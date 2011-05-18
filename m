Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab1ERQJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:09:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37219 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349Ab1ERQJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:09:11 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=A4-K8H3-c-wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=z649lOmnFjOI60_BTCcA:9 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110518160909.641109014@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 12:08:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 14/15] ftrace/x86: mcount offset calculation
References: <20110518160809.724215604@goodmis.org>
Content-Disposition: inline; filename=0014-ftrace-x86-mcount-offset-calculation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Do the mcount offset adjustment in the recordmcount.pl/recordmcount.[ch]
at compile time and not in ftrace_call_adjust at run time.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h |    7 +++----
 scripts/recordmcount.c        |    2 ++
 scripts/recordmcount.pl       |    2 ++
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index db24c22..268c783 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -38,11 +38,10 @@ extern void mcount(void);
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
 	/*
-	 * call mcount is "e8 <4 byte offset>"
-	 * The addr points to the 4 byte offset and the caller of this
-	 * function wants the pointer to e8. Simply subtract one.
+	 * addr is the address of the mcount call instruction.
+	 * recordmcount does the necessary offset calculation.
 	 */
-	return addr - 1;
+	return addr;
 }
 
 #ifdef CONFIG_DYNAMIC_FTRACE
diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 0e18975..7648a5d 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -335,6 +335,7 @@ do_file(char const *const fname)
 		reltype = R_386_32;
 		make_nop = make_nop_x86;
 		ideal_nop = ideal_nop5_x86_32;
+		mcount_adjust_32 = -1;
 		break;
 	case EM_ARM:	 reltype = R_ARM_ABS32;
 			 altmcount = "__gnu_mcount_nc";
@@ -350,6 +351,7 @@ do_file(char const *const fname)
 		make_nop = make_nop_x86;
 		ideal_nop = ideal_nop5_x86_64;
 		reltype = R_X86_64_64;
+		mcount_adjust_64 = -1;
 		break;
 	}  /* end switch */
 
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index a871cd4..414e7f5 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -223,6 +223,7 @@ if ($arch eq "x86_64") {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
     $type = ".quad";
     $alignment = 8;
+    $mcount_adjust = -1;
 
     # force flags for this arch
     $ld .= " -m elf_x86_64";
@@ -232,6 +233,7 @@ if ($arch eq "x86_64") {
 
 } elsif ($arch eq "i386") {
     $alignment = 4;
+    $mcount_adjust = -1;
 
     # force flags for this arch
     $ld .= " -m elf_i386";
-- 
1.7.4.4


