Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723Ab1ESRbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:31:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:44012 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933494Ab1ESRbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:31:13 -0400
Date: Thu, 19 May 2011 17:31:01 GMT
From: tip-bot for Michal Marek <mmarek@suse.cz>
Message-ID: <tip-d6971822c288ce5547190c6f812cc978d6520777@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, mmarek@suse.cz, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, mmarek@suse.cz
In-Reply-To: <20110517133646.GP13293@sepie.suse.cz>
References: <20110517133646.GP13293@sepie.suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace/kbuild: Add recordmcount files to force full build
Git-Commit-ID: d6971822c288ce5547190c6f812cc978d6520777
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 May 2011 17:31:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6971822c288ce5547190c6f812cc978d6520777
Gitweb:     http://git.kernel.org/tip/d6971822c288ce5547190c6f812cc978d6520777
Author:     Michal Marek <mmarek@suse.cz>
AuthorDate: Tue, 17 May 2011 15:36:46 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 19 May 2011 07:58:28 -0400

ftrace/kbuild: Add recordmcount files to force full build

Modifications to recordmcount must be performed on all object
files to stay consistent with what the kernel code may expect.
Add the recordmcount files to the main dependencies to make sure
any change to them causes a full recompile.

Signed-off-by: Michal Marek <mmarek@suse.cz>
Link: http://lkml.kernel.org/r/20110517133646.GP13293@sepie.suse.cz
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/Makefile.build |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index fdca952..6165622 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -255,6 +255,8 @@ sub_cmd_record_mcount =					\
 	if [ $(@) != "scripts/mod/empty.o" ]; then	\
 		$(objtree)/scripts/recordmcount $(RECORDMCOUNT_FLAGS) "$(@)";	\
 	fi;
+recordmcount_source := $(srctree)/scripts/recordmcount.c \
+		    $(srctree)/scripts/recordmcount.h
 else
 sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
@@ -262,6 +264,7 @@ sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH
 	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
 	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
 	"$(if $(part-of-module),1,0)" "$(@)";
+recordmcount_source := $(srctree)/scripts/recordmcount.pl
 endif
 cmd_record_mcount = 						\
 	if [ "$(findstring -pg,$(_c_flags))" = "-pg" ]; then	\
@@ -282,13 +285,13 @@ define rule_cc_o_c
 endef
 
 # Built-in and composite module parts
-$(obj)/%.o: $(src)/%.c FORCE
+$(obj)/%.o: $(src)/%.c $(recordmcount_source) FORCE
 	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
 
 # Single-part modules are special since we need to mark them in $(MODVERDIR)
 
-$(single-used-m): $(obj)/%.o: $(src)/%.c FORCE
+$(single-used-m): $(obj)/%.o: $(src)/%.c $(recordmcount_source) FORCE
 	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
 	@{ echo $(@:.o=.ko); echo $@; } > $(MODVERDIR)/$(@F:.o=.mod)
