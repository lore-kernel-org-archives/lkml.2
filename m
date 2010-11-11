Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab0KKVmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:42:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62305 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab0KKVmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:42:00 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=QHqalcCKOTcA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=omOdbC7AAAAA:8 a=Tty9oNO6AAAA:8 a=meVymXHHAAAA:8 a=N56VC1Z3b-zy9rtOjdYA:9 a=UzhZ_sH7CmyWa5jKpMMA:7 a=Moqt5YQ9x8SQcoAnbRLGidgU4bwA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=AjVVRxw9dd0-IgkE:21 a=uLEDjVwJ7mJyNyoX:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101111214158.271364095@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 11 Nov 2010 16:41:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/2] tracing: Fix module use of trace_bprintk()
References: <20101111214111.675303594@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Fix-module-use-of-trace_bprintk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

On use of trace_printk() there's a macro that determines if the format
is static or a variable. If it is static, it defaults to __trace_bprintk()
otherwise it uses __trace_printk().

A while ago, Lai Jiangshan added __trace_bprintk(). In that patch, we
discussed a way to allow modules to use it. The difference between
__trace_bprintk() and __trace_printk() is that for faster processing,
just the format and args are stored in the trace instead of running
it through a sprintf function. In order to do this, the format used
by the __trace_bprintk() had to be persistent.

See commit 1ba28e02a18cbdbea123836f6c98efb09cbf59ec

The problem comes with trace_bprintk() where the module is unloaded.
The pointer left in the buffer is still pointing to the format.

To solve this issue, the formats in the module were copied into kernel
core. If the same format was used, they would use the same copy (to prevent
memory leak). This all worked well until we tried to merge everything.

At the time this was written, Lai Jiangshan, Frederic Weisbecker,
Ingo Molnar and myself were all touching the same code. When this was
merged, we lost the part of it that was in module.c. This kept out the
copying of the formats and unloading the module could cause bad pointers
left in the ring buffer.

This patch adds back (with updates required for current kernel) the
module code that sets up the necessary pointers.

Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/module.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 437a74a..d190664 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2326,6 +2326,18 @@ static void find_module_sections(struct module *mod, struct load_info *info)
 	kmemleak_scan_area(mod->trace_events, sizeof(*mod->trace_events) *
 			   mod->num_trace_events, GFP_KERNEL);
 #endif
+#ifdef CONFIG_TRACING
+	mod->trace_bprintk_fmt_start = section_objs(info, "__trace_printk_fmt",
+					 sizeof(*mod->trace_bprintk_fmt_start),
+					 &mod->num_trace_bprintk_fmt);
+	/*
+	 * This section contains pointers to allocated objects in the trace
+	 * code and not scanning it leads to false positives.
+	 */
+	kmemleak_scan_area(mod->trace_bprintk_fmt_start,
+			   sizeof(*mod->trace_bprintk_fmt_start) *
+			   mod->num_trace_bprintk_fmt, GFP_KERNEL);
+#endif
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 	/* sechdrs[0].sh_size is always zero */
 	mod->ftrace_callsites = section_objs(info, "__mcount_loc",
-- 
1.7.1


