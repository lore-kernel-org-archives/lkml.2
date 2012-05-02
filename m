Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab2EBTd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:33:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23093 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab2EBTck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:32:40 -0400
X-Authority-Analysis: v=2.0 cv=fvFelSEf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=irIKgB6La5wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=2mpfi5TdF5UcT3aGsd0A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120502193238.132016127@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 May 2012 15:24:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 9/9][RFC] ftrace: Remove selecting FRAME_POINTER with FUNCTION_TRACER
References: <20120502192418.024103772@goodmis.org>
Content-Disposition: inline; filename=0009-ftrace-Remove-selecting-FRAME_POINTER-with-FUNCTION_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The function tracer will enable the -pg option with gcc, which requires
that frame pointers. When FRAME_POINTER is defined in the kernel config
it adds the gcc option -fno-omit-frame-pointer which causes some problems
on some architectures. For those architectures, the FRAME_POINTER select
was not set.

When FUNCTION_TRACER was selected on these architectures that can not have
-fno-omit-frame-pointer, the -pg option is still set. But when
FRAME_POINTER is not selected, the kernel config would add the gcc option
-fomit-frame-pointer. Adding this option is incompatible with -pg
even on archs that do not need frame pointers with -pg.

The answer to this was to just not add either -fno-omit-frame-pointer
or -fomit-frame-pointer on these archs that want function tracing
but do not set FRAME_POINTER.

As it turns out, for archs that require frame pointers for function
tracing, the same can be used. If gcc requires frame pointers with
-pg, it will simply add it. The best thing to do is not select FRAME_POINTER
when function tracing is selected, and let gcc add it if needed.

Only add the -fno-omit-frame-pointer when something else selects
FRAME_POINTER, but do not add -fomit-frame-pointer if function tracing
is selected.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index a1d2849..d81a1a5 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -141,7 +141,6 @@ if FTRACE
 config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
 	depends on HAVE_FUNCTION_TRACER
-	select FRAME_POINTER if !ARM_UNWIND && !PPC && !S390 && !MICROBLAZE
 	select KALLSYMS
 	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
-- 
1.7.9.5


