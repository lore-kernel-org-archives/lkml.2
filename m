Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab2ARN3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:29:03 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:27763 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab2ARN3B convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 18 Jan 2012 08:29:01 -0500
Message-Id: <4F16D728020000780006D732@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 18 Jan 2012 13:28:56 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <acme@ghostprotocols.net>,
        <paulus@samba.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] perf/x86-64: also allow measuring alternative
 memcpy implementations
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intended to be able to support the current selection of the preferred
memcpy() implementation, this patch adds the ability to also measure
the two alternative implementations, again by way of using some
pre-processsor replacement.

While on my Westmere system this proves that the movsb based variant is
worse than the movsq based one (since the ERMS feature isn't there), it
also shows that here for the default as well as small sizes the
unrolled variant outperforms the movsq one.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

--- a/tools/perf/bench/mem-memcpy-x86-64-asm-def.h
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm-def.h
@@ -2,3 +2,11 @@
 MEMCPY_FN(__memcpy,
 	"x86-64-unrolled",
 	"unrolled memcpy() in arch/x86/lib/memcpy_64.S")
+
+MEMCPY_FN(memcpy_c,
+	"x86-64-movsq",
+	"movsq-based memcpy() in arch/x86/lib/memcpy_64.S")
+
+MEMCPY_FN(memcpy_c_e,
+	"x86-64-movsb",
+	"movsb-based memcpy() in arch/x86/lib/memcpy_64.S")
--- a/tools/perf/bench/mem-memcpy-x86-64-asm.S
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm.S
@@ -1,2 +1,6 @@
 #define memcpy MEMCPY /* don't hide glibc's memcpy() */
+#define altinstr_replacement text
+#define globl p2align 4; .globl
+#define Lmemcpy_c globl memcpy_c; memcpy_c
+#define Lmemcpy_c_e globl memcpy_c_e; memcpy_c_e
 #include "../../../arch/x86/lib/memcpy_64.S"



