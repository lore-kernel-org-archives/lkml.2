Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab0IAJEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:04:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59727 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab0IAJEk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:04:40 -0400
Subject: Re: ftrace/perf_event leak
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, kvm-devel <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4C7E11E5.1040402@redhat.com>
References: <4C7E11E5.1040402@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Sep 2010 11:04:28 +0200
Message-ID: <1283331868.2059.808.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 11:42 +0300, Avi Kivity wrote:
> I recently added perf_event support to kvm_stat, to display kvm 
> tracepoints as statistics (I'd like to fold this to tools/perf 
> eventually, but that's another story).  However I'm seeing a resource 
> leak - after I quit the tool, there are quite a few references into the 
> kvm module:
> 
>    kvm_intel              43655  0
>    kvm                   272984  269 kvm_intel
> 
> The tool is just a python script that reads 
> /sys/kernel/debug/tracing/events/kvm to find out which events are 
> available, uses perf_event_open() to create one group per cpu to which a 
> lot of events are attached.  The only special thing I can think of is 
> that we use an ioctl to attach a filter to many perf_event descriptors.
> 
> You can find the source at 
> http://git.kernel.org/?p=virt/kvm/qemu-kvm.git;a=blob_plain;f=kvm/kvm_stat;hb=5bd5f131b50cb373ff4e2a3632c6dad00a1f0b55.  
> All it needs are the kvm modules loaded; no need to actually run a 
> guest.  Run as root.
> 

Does something like the below cure that?

I seem to remember C doesn't make any promises about the order of logic
statements, hence we need to explicitly pull out that try_module_get()
so that it evaluates after the rest of the conditions.

---
 kernel/trace/trace_event_perf.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 000e6e8..35051f2 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -88,10 +88,11 @@ int perf_trace_init(struct perf_event *p_event)
 	mutex_lock(&event_mutex);
 	list_for_each_entry(tp_event, &ftrace_events, list) {
 		if (tp_event->event.type == event_id &&
-		    tp_event->class && tp_event->class->reg &&
-		    try_module_get(tp_event->mod)) {
-			ret = perf_trace_event_init(tp_event, p_event);
-			break;
+		    tp_event->class && tp_event->class->reg) {
+		    	if (try_module_get(tp_event->mod)) {
+				ret = perf_trace_event_init(tp_event, p_event);
+				break;
+			}
 		}
 	}
 	mutex_unlock(&event_mutex);
@@ -138,6 +139,7 @@ void perf_trace_destroy(struct perf_event *p_event)
 
 	free_percpu(tp_event->perf_events);
 	tp_event->perf_events = NULL;
+	module_put(tp_event->mod);
 
 	if (!--total_ref_count) {
 		for (i = 0; i < 4; i++) {

