Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab0EXF1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 01:27:42 -0400
Received: from ozlabs.org ([203.10.76.45]:56563 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab0EXF1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 01:27:41 -0400
Date: Mon, 24 May 2010 15:27:35 +1000
From: Paul Mackerras <paulus@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tracing, powerpc: Add data parameter to powerpc-specific
 tracepoints
Message-ID: <20100524052735.GB10628@drongo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 38516ab5 ("tracing: Let tracepoints have data passed to
tracepoint callbacks") added a void *data parameter to tracing
callbacks and to the {un,}register_trace_* functions, requiring all
tracepoint callback functions to have the extra void * parameter.

This adds the void *data parameter to the tracepoints in the pSeries
hypervisor call code.  Without this, hvCall_inst.c fails to compile
with tracing enabled.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/platforms/pseries/hvCall_inst.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hvCall_inst.c b/arch/powerpc/platforms/pseries/hvCall_inst.c
index 1fefae7..9d03ef5 100644
--- a/arch/powerpc/platforms/pseries/hvCall_inst.c
+++ b/arch/powerpc/platforms/pseries/hvCall_inst.c
@@ -102,7 +102,8 @@ static const struct file_operations hcall_inst_seq_fops = {
 #define CPU_NAME_BUF_SIZE	32
 
 
-static void probe_hcall_entry(unsigned long opcode, unsigned long *args)
+static void probe_hcall_entry(void *data, unsigned long opcode,
+			      unsigned long *args)
 {
 	struct hcall_stats *h;
 
@@ -114,8 +115,8 @@ static void probe_hcall_entry(unsigned long opcode, unsigned long *args)
 	h->purr_start = mfspr(SPRN_PURR);
 }
 
-static void probe_hcall_exit(unsigned long opcode, unsigned long retval,
-			     unsigned long *retbuf)
+static void probe_hcall_exit(void *data, unsigned long opcode,
+			     unsigned long retval, unsigned long *retbuf)
 {
 	struct hcall_stats *h;
 
@@ -140,11 +141,11 @@ static int __init hcall_inst_init(void)
 	if (!firmware_has_feature(FW_FEATURE_LPAR))
 		return 0;
 
-	if (register_trace_hcall_entry(probe_hcall_entry))
+	if (register_trace_hcall_entry(probe_hcall_entry, NULL))
 		return -EINVAL;
 
-	if (register_trace_hcall_exit(probe_hcall_exit)) {
-		unregister_trace_hcall_entry(probe_hcall_entry);
+	if (register_trace_hcall_exit(probe_hcall_exit, NULL)) {
+		unregister_trace_hcall_entry(probe_hcall_entry, NULL);
 		return -EINVAL;
 	}
 
