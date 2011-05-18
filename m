Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab1ERQJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:09:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41494 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342Ab1ERQJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:09:11 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=3ejn9FAqq70A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=3tnRlbvgU3YgXBmIiRsA:9 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110518160909.877357918@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 12:08:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 15/15] ftrace/s390: mcount offset calculation
References: <20110518160809.724215604@goodmis.org>
Content-Disposition: inline; filename=0015-ftrace-s390-mcount-offset-calculation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Do the mcount offset adjustment in the recordmcount.pl/recordmcount.[ch]
at compile time and not in ftrace_call_adjust at run time.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/s390/include/asm/ftrace.h |    4 +---
 scripts/recordmcount.c         |    8 ++++++--
 scripts/recordmcount.pl        |    2 ++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/ftrace.h b/arch/s390/include/asm/ftrace.h
index 3c29be4..b7931fa 100644
--- a/arch/s390/include/asm/ftrace.h
+++ b/arch/s390/include/asm/ftrace.h
@@ -11,15 +11,13 @@ struct dyn_arch_ftrace { };
 
 #ifdef CONFIG_64BIT
 #define MCOUNT_INSN_SIZE  12
-#define MCOUNT_OFFSET	   8
 #else
 #define MCOUNT_INSN_SIZE  20
-#define MCOUNT_OFFSET	   4
 #endif
 
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
-	return addr - MCOUNT_OFFSET;
+	return addr;
 }
 
 #endif /* __ASSEMBLY__ */
diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 7648a5d..ee52cb8 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -368,8 +368,10 @@ do_file(char const *const fname)
 				"unrecognized ET_REL file: %s\n", fname);
 			fail_file();
 		}
-		if (w2(ehdr->e_machine) == EM_S390)
+		if (w2(ehdr->e_machine) == EM_S390) {
 			reltype = R_390_32;
+			mcount_adjust_32 = -4;
+		}
 		if (w2(ehdr->e_machine) == EM_MIPS) {
 			reltype = R_MIPS_32;
 			is_fake_mcount32 = MIPS32_is_fake_mcount;
@@ -384,8 +386,10 @@ do_file(char const *const fname)
 				"unrecognized ET_REL file: %s\n", fname);
 			fail_file();
 		}
-		if (w2(ghdr->e_machine) == EM_S390)
+		if (w2(ghdr->e_machine) == EM_S390) {
 			reltype = R_390_64;
+			mcount_adjust_64 = -8;
+		}
 		if (w2(ghdr->e_machine) == EM_MIPS) {
 			reltype = R_MIPS_64;
 			Elf64_r_sym = MIPS64_r_sym;
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 414e7f5..858966a 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -243,12 +243,14 @@ if ($arch eq "x86_64") {
 
 } elsif ($arch eq "s390" && $bits == 32) {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_32\\s+_mcount\$";
+    $mcount_adjust = -4;
     $alignment = 4;
     $ld .= " -m elf_s390";
     $cc .= " -m31";
 
 } elsif ($arch eq "s390" && $bits == 64) {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_(PC|PLT)32DBL\\s+_mcount\\+0x2\$";
+    $mcount_adjust = -8;
     $alignment = 8;
     $type = ".quad";
     $ld .= " -m elf64_s390";
-- 
1.7.4.4


