Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab0LVNQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:16:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:55713 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab0LVNQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:16:08 -0500
Date: Wed, 22 Dec 2010 13:15:46 GMT
From: tip-bot for Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        wuzhangjin@gmail.com, rostedt@goodmis.org, mmarek@suse.cz,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mmarek@suse.cz
In-Reply-To: <3dc8cddf022eb7024f9f2cf857529a15bee8999a.1288196498.git.wuzhangjin@gmail.com>
References: <3dc8cddf022eb7024f9f2cf857529a15bee8999a.1288196498.git.wuzhangjin@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace: Speed up recordmcount
Message-ID: <tip-45677454dd6d128608117abe7dcd2bdfdd7cdf72@git.kernel.org>
Git-Commit-ID: 45677454dd6d128608117abe7dcd2bdfdd7cdf72
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 13:15:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45677454dd6d128608117abe7dcd2bdfdd7cdf72
Gitweb:     http://git.kernel.org/tip/45677454dd6d128608117abe7dcd2bdfdd7cdf72
Author:     Wu Zhangjin <wuzhangjin@gmail.com>
AuthorDate: Thu, 28 Oct 2010 00:24:34 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 18 Nov 2010 17:16:05 -0500

ftrace: Speed up recordmcount

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
