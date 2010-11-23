Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0KWOP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:15:27 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64446 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab0KWOPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:15:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=vi/1s7HpMeEduCecx4EFmYjgIL8FMQTJPaRuhZjHJiKbnzJfllAyNezdX8UrWsCjm5
         yJd3S+8pqGlyZ3BOL6/2YycRiRwN36rqRfIVL10jeXfPLUgRQCDt2rJnYeEHKqbd4jeQ
         mbTs+JRz9rlUtaMPmrL/cg0ftlDaEm0AmdhG8=
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jreiser@BitWagon.com, Rabin Vincent <rabin@rab.in>
Subject: [PATCHv2 2/2] ftrace/ARM: add ARM support for C version of recordmcount
Date: Tue, 23 Nov 2010 19:44:51 +0530
Message-Id: <1290521691-5101-2-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290454387.30543.304.camel@gandalf.stny.rr.com>
References: <1290454387.30543.304.camel@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on the compiler version, ARM GCC calls the mcount function
either __gnu_mcount_nc or mcount.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/Kconfig       |    1 +
 scripts/recordmcount.c |    5 ++++-
 scripts/recordmcount.h |    5 +++--
 3 files changed, 8 insertions(+), 3 deletions(-)

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
index ac6e51c..038b3d1 100644
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

