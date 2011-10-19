Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab1JSWda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:33:30 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:47355 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab1JSWd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:33:29 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mips: fix the build with C=1
Date: Thu, 20 Oct 2011 01:33:27 +0300
Message-Id: <1319063607-11316-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to compile the 3.1-rc10 kernel for my MIPS board with C=1
(sparse checking), the build fails early with the error:

	  CHK     include/linux/version.h
	  UPD     include/linux/version.h
	  CHK     include/generated/utsrelease.h
	  UPD     include/generated/utsrelease.h
	  Checking missing-syscalls for N32
	  CALL    scripts/checksyscalls.sh
	  Checking missing-syscalls for O32
	  CALL    scripts/checksyscalls.sh
	  CC      kernel/bounds.s
	  GEN     include/generated/bounds.h
	  CC      arch/mips/kernel/asm-offsets.s
	  GEN     include/generated/asm-offsets.h
	  CALL    scripts/checksyscalls.sh
	  HOSTCC  scripts/genksyms/genksyms.o
	  SHIPPED scripts/genksyms/lex.lex.c
	  SHIPPED scripts/genksyms/keywords.hash.c
	  SHIPPED scripts/genksyms/parse.tab.h
	  HOSTCC  scripts/genksyms/lex.lex.o
	  SHIPPED scripts/genksyms/parse.tab.c
	  HOSTCC  scripts/genksyms/parse.tab.o
	  HOSTLD  scripts/genksyms/genksyms
	/bin/sh: Syntax error: "(" unexpected
	make[3]: *** [scripts/mod/empty.o] Error 2
	make[2]: *** [scripts/mod] Error 2
	make[1]: *** [scripts] Error 2

It seems the shell chokes because sparse is called with command line
arguments such as:

	-D__INT8_C(c)='c'

Converting these to form:

	-D'__INT8_C(c)'='c'

seems to fix the problem.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/mips/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 53e3514..30346b0 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -226,7 +226,7 @@ LDFLAGS			+= -m $(ld-emul)
 ifdef CONFIG_MIPS
 CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -xc /dev/null | \
 	egrep -vw '__GNUC_(|MINOR_|PATCHLEVEL_)_' | \
-	sed -e 's/^\#define /-D/' -e "s/ /='/" -e "s/$$/'/")
+	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/")
 ifdef CONFIG_64BIT
 CHECKFLAGS		+= -m64
 endif
-- 
1.7.2.5

