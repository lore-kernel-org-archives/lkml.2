Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882Ab0J0KkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:40:15 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34961 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760838Ab0J0KkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:40:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cmT+mWGFAu+VpKX3H6xlLWpSUrmRALBSW84LUMQ1CMDQwS8PeJ49lI/chjz/RqgaaO
         6rEq83d8CiOYKGF/S4XcVjagNuvSqTCPmNeOeqj/hvaaNQ1U26wruR+ECFMdZiMp0doG
         PuC/MAtvAlDqqdkgiq8if757IeVX0e/CiO8Po=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, John Reiser <jreiser@bitwagon.com>,
        Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH] ftrace: Speed up recordmcount
Date: Wed, 27 Oct 2010 18:39:56 +0800
Message-Id: <f603e1dc44524b81ebc423dd226eb44d837a37be.1288175801.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

cmd_record_mcount is only needed for the targets who are compiled with
-pg, so, only define it when CONFIG_FTRACE_MCOUNT_RECORD is defined and
only use it for the targets who are compiled with -pg.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 Makefile               |   11 ++++++++---
 scripts/Makefile.build |   26 ++++++++++++++++----------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/Makefile b/Makefile
index 3e43805..60d7a87 100644
--- a/Makefile
+++ b/Makefile
@@ -576,9 +576,14 @@ endif
 ifdef CONFIG_FUNCTION_TRACER
 KBUILD_CFLAGS	+= -pg
 ifdef CONFIG_DYNAMIC_FTRACE
-	ifdef CONFIG_HAVE_C_RECORDMCOUNT
-		BUILD_C_RECORDMCOUNT := y
-		export BUILD_C_RECORDMCOUNT
+	ifdef CONFIG_FTRACE_MCOUNT_RECORD
+		DEFINE_CMD_RECORD_MCOUNT := y
+		export DEFINE_CMD_RECORD_MCOUNT
+
+		ifdef CONFIG_HAVE_C_RECORDMCOUNT
+			BUILD_C_RECORDMCOUNT := y
+			export BUILD_C_RECORDMCOUNT
+		endif
 	endif
 endif
 endif
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 5ad25e1..ceb5175 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -208,22 +208,28 @@ cmd_modversions =								\
 	fi;
 endif
 
-ifdef CONFIG_FTRACE_MCOUNT_RECORD
+ifdef DEFINE_CMD_RECORD_MCOUNT
 ifdef BUILD_C_RECORDMCOUNT
 # Due to recursion, we must skip empty.o.
 # The empty.o file is created in the make process in order to determine
 #  the target endianness and word size. It is made before all other C
 #  files, including recordmcount.
-cmd_record_mcount = if [ $(@) != "scripts/mod/empty.o" ]; then			\
-			$(objtree)/scripts/recordmcount "$(@)";			\
-		    fi;
+cmd_record_mcount =							\
+	if [ "$(findstring -pg,$(KBUILD_CFLAGS))" == "-pg" ]; then	\
+		if [ $(@) != "scripts/mod/empty.o" ]; then		\
+			$(objtree)/scripts/recordmcount "$(@)";		\
+		fi;							\
+	fi;
 else
-cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
-	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
-	"$(if $(CONFIG_64BIT),64,32)" \
-	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
-	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
-	"$(if $(part-of-module),1,0)" "$(@)";
+cmd_record_mcount = 							\
+	if [ "$(findstring -pg,$(KBUILD_CFLAGS))" == "-pg" ]; then	\
+		set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
+		"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" 		\
+		"$(if $(CONFIG_64BIT),64,32)" 				\
+		"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" 	\
+		"$(LD)" "$(NM)" "$(RM)" "$(MV)" 			\
+		"$(if $(part-of-module),1,0)" "$(@)";			\
+	fi;
 endif
 endif
 
-- 
1.7.1

