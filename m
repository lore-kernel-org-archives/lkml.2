Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab0JOQON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 12:14:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44151 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab0JOQOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:14:10 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=ad5hsr9vf7MA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=SyI_GHdlAAAA:8 a=meVymXHHAAAA:8 a=n3LdQAqYse_Y-hFgDxMA:9 a=L6vnP2lrd3kWSMAb_tMA:7 a=p7td2IlV2MAk_3AhkFbole4G0OMA:4 a=jEp0ucaQiEUA:10 a=UQxMgyrMzRwA:10 a=jeBq3FmKZ4MA:10 a=QXhR5TPjOZk691r-:21 a=JzadWNcq-ks-54Q4:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101015161408.997523259@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 15 Oct 2010 12:13:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Reiser <jreiser@bitwagon.com>
Subject: [PATCH 1/2] ftrace: Do not process kernel/trace/ftrace.o with C recordmcount program
References: <20101015161334.766423984@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Do-not-process-kernel-trace-ftrace.o-with-C-r.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The file kernel/trace/ftrace.c references the mcount() call to
convert the mcount() callers to nops. But because it references
mcount(), the mcount() address is placed in the relocation table.

The C version of recordmcount reads the relocation table of all
object files, and it will add all references to mcount to the
__mcount_loc table that is used to find the places that call mcount()
and change the call to a nop. When recordmcount finds the mcount reference
in kernel/trace/ftrace.o, it saves that location even though the code
is not a call, but references mcount as data.

On boot up, when all calls are converted to nops, the code has a safety
check to determine what op code it is actually replacing before it
replaces it. If that op code at the address does not match, then
a warning is printed and the function tracer is disabled.

The reference to mcount in ftrace.c, causes this warning to trigger,
since the reference is not a call to mcount(). The ftrace.c file is
not compiled with the -pg flag, so no calls to mcount() should be
expected.

This patch simply makes recordmcount.c skip the kernel/trace/ftrace.c
file. This was the same solution used by the perl version of
recordmcount.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: John Reiser <jreiser@bitwagon.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 7f7f718..26e1271 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -313,12 +313,30 @@ do_file(char const *const fname)
 int
 main(int argc, char const *argv[])
 {
+	const char ftrace[] = "kernel/trace/ftrace.o";
+	int ftrace_size = sizeof(ftrace) - 1;
 	int n_error = 0;  /* gcc-4.3.0 false positive complaint */
-	if (argc <= 1)
+
+	if (argc <= 1) {
 		fprintf(stderr, "usage: recordmcount file.o...\n");
-	else  /* Process each file in turn, allowing deep failure. */
+		return 0;
+	}
+
+	/* Process each file in turn, allowing deep failure. */
 	for (--argc, ++argv; 0 < argc; --argc, ++argv) {
 		int const sjval = setjmp(jmpenv);
+		int len;
+
+		/*
+		 * The file kernel/trace/ftrace.o references the mcount
+		 * function but does not call it. Since ftrace.o should
+		 * not be traced anyway, we just skip it.
+		 */
+		len = strlen(argv[0]);
+		if (len >= ftrace_size &&
+		    strcmp(argv[0] + (len - ftrace_size), ftrace) == 0)
+			continue;
+
 		switch (sjval) {
 		default: {
 			fprintf(stderr, "internal error: %s\n", argv[0]);
-- 
1.7.1


