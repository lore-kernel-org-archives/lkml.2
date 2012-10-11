Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259Ab2JKULR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:11:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28141 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab2JKULN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:11:13 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=SDt48C6ByX4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=l7_9tSXZjzcA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=AS1RrZ5PnTC0n6Uu3PkA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=zB3R35yRSVL3cNGO:21 a=1vT9WK16aYhReYGp:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349986271.24256.67.camel@gandalf.local.home>
Subject: [PATCH][3.7] ring-buffer: Check for uninitialized cpu buffer before
 resizing
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Thu, 11 Oct 2012 16:11:11 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 8e49f418c9632790bf456634742d34d97120a784


Vaibhav Nagarnaik (1):
      ring-buffer: Check for uninitialized cpu buffer before resizing

----
 kernel/trace/ring_buffer.c |    4 ++++
 1 file changed, 4 insertions(+)
---------------------------
commit 8e49f418c9632790bf456634742d34d97120a784
Author: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date:   Wed Oct 10 16:40:27 2012 -0700

    ring-buffer: Check for uninitialized cpu buffer before resizing
    
    With a system where, num_present_cpus < num_possible_cpus, even if all
    CPUs are online, non-present CPUs don't have per_cpu buffers allocated.
    If per_cpu/<cpu>/buffer_size_kb is modified for such a CPU, it can cause
    a panic due to NULL dereference in ring_buffer_resize().
    
    To fix this, resize operation is allowed only if the per-cpu buffer has
    been initialized.
    
    Link: http://lkml.kernel.org/r/1349912427-6486-1-git-send-email-vnagarnaik@google.com
    
    Cc: stable@vger.kernel.org # 3.5+
    Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b32ed0e..b979426 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1567,6 +1567,10 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 
 		put_online_cpus();
 	} else {
+		/* Make sure this CPU has been intitialized */
+		if (!cpumask_test_cpu(cpu_id, buffer->cpumask))
+			goto out;
+
 		cpu_buffer = buffer->buffers[cpu_id];
 
 		if (nr_pages == cpu_buffer->nr_pages)


