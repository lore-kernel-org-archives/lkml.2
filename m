Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab0KVSM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 13:12:56 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61659 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863Ab0KVSMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 13:12:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Q+SJnVTLgwJkPDuxbekQn1mFyaHf6oAp9vgkWHir+t4aAXSJuJkddE5trKPF+dy/vt
         mV6cRWJJrcRvLdd/w5MApNbU5JLkj3TAEyPaze/MD8sp/Uq/BSVnxRJt1UKVmXaRS620
         2t6SALR3sCAMyue5cHV3qRB8hrcJsOoY9MZ8o=
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jreiser@BitWagon.com, Rabin Vincent <rabin@rab.in>
Subject: [PATCH] ftrace/ARM: add ARM support for C version of recordmcount
Date: Mon, 22 Nov 2010 23:43:06 +0530
Message-Id: <1290449586-1512-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on the compiler version, ARM GCC calls the mcount function
either __gnu_mcount_nc or mcount.

Also, arch/arm/kernel/ftrace.c references mcount like
kernel/tracing/ftrace.c, so change the exclusion filter to match any
ftrace.c

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/Kconfig       |    1 +
 scripts/recordmcount.c |    7 +++++--
 scripts/recordmcount.h |    5 +++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 81c71da..5fdddda 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -23,6 +23,7 @@ config ARM
 	select PERF_USE_VMALLOC
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_HW_BREAKPOINT if (PERF_EVENTS && (CPU_V6 || CPU_V7))
+	select HAVE_C_RECORDMCOUNT
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index f2f32ee..038b3d1 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -38,6 +38,7 @@ static void *ehdr_curr; /* current ElfXX_Ehdr *  for resource cleanup */
 static char gpfx;	/* prefix for global symbol name (sometimes '_') */
 static struct stat sb;	/* Remember .st_size, etc. */
 static jmp_buf jmpenv;	/* setjmp/longjmp per-file error escape */
+static const char *altmcount;	/* alternate mcount symbol name */
 
 /* setjmp() return values */
 enum {
@@ -299,7 +300,9 @@ do_file(char const *const fname)
 		fail_file();
 	} break;
 	case EM_386:	 reltype = R_386_32;                   break;
-	case EM_ARM:	 reltype = R_ARM_ABS32;                break;
+	case EM_ARM:	 reltype = R_ARM_ABS32;
+			 altmcount = "__gnu_mcount_nc";
+			 break;
 	case EM_IA_64:	 reltype = R_IA64_IMM64;   gpfx = '_'; break;
 	case EM_MIPS:	 /* reltype: e_class    */ gpfx = '_'; break;
 	case EM_PPC:	 reltype = R_PPC_ADDR32;   gpfx = '_'; break;
@@ -357,7 +360,7 @@ do_file(char const *const fname)
 int
 main(int argc, char const *argv[])
 {
-	const char ftrace[] = "kernel/trace/ftrace.o";
+	const char ftrace[] = "/ftrace.o";
 	int ftrace_size = sizeof(ftrace) - 1;
 	int n_error = 0;  /* gcc-4.3.0 false positive complaint */
 
diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index 58e933a..8087bc8 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -275,11 +275,12 @@ static uint_t *sift_rel_mcount(uint_t *mlocp,
 			Elf_Sym const *const symp =
 				&sym0[Elf_r_sym(relp)];
 			char const *symname = &str0[w(symp->st_name)];
+			char const *mcount = '_' == gpfx ? "_mcount" : "mcount";
 
 			if ('.' == symname[0])
 				++symname;  /* ppc64 hack */
-			if (0 == strcmp((('_' == gpfx) ? "_mcount" : "mcount"),
-					symname))
+			if (0 == strcmp(mcount, symname) ||
+			    (altmcount && 0 == strcmp(altmcount, symname)))
 				mcountsym = Elf_r_sym(relp);
 		}
 
-- 
1.7.2.3

