Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab0CaAQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:16:01 -0400
Received: from kroah.org ([198.145.64.141]:51815 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756767Ab0C3XRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:38 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:11 2010
Message-Id: <20100330225611.216298662@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:54:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [021/116] tracing: Do not record user stack trace from NMI context
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit b6345879ccbd9b92864fbd7eb8ac48acdb4d6b15 upstream.

A bug was found with Li Zefan's ftrace_stress_test that caused applications
to segfault during the test.

Placing a tracing_off() in the segfault code, and examining several
traces, I found that the following was always the case. The lock tracer
was enabled (lockdep being required) and userstack was enabled. Testing
this out, I just enabled the two, but that was not good enough. I needed
to run something else that could trigger it. Running a load like hackbench
did not work, but executing a new program would. The following would
trigger the segfault within seconds:

  # echo 1 > /debug/tracing/options/userstacktrace
  # echo 1 > /debug/tracing/events/lock/enable
  # while :; do ls > /dev/null ; done

Enabling the function graph tracer and looking at what was happening
I finally noticed that all cashes happened just after an NMI.

 1)               |    copy_user_handle_tail() {
 1)               |      bad_area_nosemaphore() {
 1)               |        __bad_area_nosemaphore() {
 1)               |          no_context() {
 1)               |            fixup_exception() {
 1)   0.319 us    |              search_exception_tables();
 1)   0.873 us    |            }
[...]
 1)   0.314 us    |  __rcu_read_unlock();
 1)   0.325 us    |    native_apic_mem_write();
 1)   0.943 us    |  }
 1)   0.304 us    |  rcu_nmi_exit();
[...]
 1)   0.479 us    |  find_vma();
 1)               |  bad_area() {
 1)               |    __bad_area() {

After capturing several traces of failures, all of them happened
after an NMI. Curious about this, I added a trace_printk() to the NMI
handler to read the regs->ip to see where the NMI happened. In which I
found out it was here:

ffffffff8135b660 <page_fault>:
ffffffff8135b660:       48 83 ec 78             sub    $0x78,%rsp
ffffffff8135b664:       e8 97 01 00 00          callq  ffffffff8135b800 <error_entry>

What was happening is that the NMI would happen at the place that a page
fault occurred. It would call rcu_read_lock() which was traced by
the lock events, and the user_stack_trace would run. This would trigger
a page fault inside the NMI. I do not see where the CR2 register is
saved or restored in NMI handling. This means that it would corrupt
the page fault handling that the NMI interrupted.

The reason the while loop of ls helped trigger the bug, was that
each execution of ls would cause lots of pages to be faulted in, and
increase the chances of the race happening.

The simple solution is to not allow user stack traces in NMI context.
After this patch, I ran the above "ls" test for a couple of hours
without any issues. Without this patch, the bug would trigger in less
than a minute.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/trace.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1171,6 +1171,13 @@ ftrace_trace_userstack(struct ring_buffe
 	if (!(trace_flags & TRACE_ITER_USERSTACKTRACE))
 		return;
 
+	/*
+	 * NMIs can not handle page faults, even with fix ups.
+	 * The save user stack can (and often does) fault.
+	 */
+	if (unlikely(in_nmi()))
+		return;
+
 	event = trace_buffer_lock_reserve(buffer, TRACE_USER_STACK,
 					  sizeof(*entry), flags, pc);
 	if (!event)


