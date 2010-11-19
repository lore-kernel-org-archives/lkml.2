Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab0KSWL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:11:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63407 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab0KSWLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:11:51 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=7c-JFGxozsUA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=2rs2RijT8D-jbCgwNtgA:9 a=QYSxkNT07ikeMSyrh1cA:7 a=ejenB99CELfE48ECfLhhg6XBvjUA:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101119221148.271352565@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 19 Nov 2010 17:11:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH 1/2] ftrace: Speed up recordmcount
References: <20101119221122.946280474@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Speed-up-recordmcount.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

cmd_record_mcount is used to locate the _mcount symbols in the object
files, only the files compiled with -pg has the _mcount symbol, so, it
is only needed for such files, but the current cmd_record_mcount is used
for all of the object files, so, we need to fix it and speed it up.

Since -pg may be removed by the method used in kernel/trace/Makefile:

ORIG_CFLAGS := $(KBUILD_CFLAGS)
KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))

Or may be removed by the method used in arch/x86/kernel/Makefile:

CFLAGS_REMOVE_file.o = -pg

So, we must check the last variable stores the compiling flags, that is
c_flags(Please refer to cmd_cc_o_c and rule_cc_o_c defined in
scripts/Makefile.build) and since the CFLAGS_REMOVE_file.o is already
filtered in _c_flags(Please refer to scripts/Makefile.lib) and _c_flags
has less symbols, therefore, we only need to check _c_flags.

---------------
Changes from v1:

  o Don't touch Makefile for CONFIG_FTRACE_MCOUNT_RECORD is enough
  o Use _c_flags intead of KBUILD_CFLAGS to cover CONFIG_REMOVE_file.o = -pg
  (feedback from Steven Rostedt <rostedt@goodmis.org>)

Acked-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
LKML-Reference: <3dc8cddf022eb7024f9f2cf857529a15bee8999a.1288196498.git.wuzhangjin@gmail.com>

[ changed if [ .. == .. ] to if [ .. = .. ] to handle dash environments ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/Makefile.build |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 5ad25e1..4eb99ab 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -214,17 +214,22 @@ ifdef BUILD_C_RECORDMCOUNT
 # The empty.o file is created in the make process in order to determine
 #  the target endianness and word size. It is made before all other C
 #  files, including recordmcount.
-cmd_record_mcount = if [ $(@) != "scripts/mod/empty.o" ]; then			\
-			$(objtree)/scripts/recordmcount "$(@)";			\
-		    fi;
+sub_cmd_record_mcount =					\
+	if [ $(@) != "scripts/mod/empty.o" ]; then	\
+		$(objtree)/scripts/recordmcount "$(@)";	\
+	fi;
 else
-cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
+sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
 	"$(if $(CONFIG_64BIT),64,32)" \
 	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
 	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
 	"$(if $(part-of-module),1,0)" "$(@)";
 endif
+cmd_record_mcount = 						\
+	if [ "$(findstring -pg,$(_c_flags))" = "-pg" ]; then	\
+		$(sub_cmd_record_mcount)			\
+	fi;
 endif
 
 define rule_cc_o_c
-- 
1.7.1


