Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963Ab1JGNTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 09:19:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38729 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1JGNTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 09:19:41 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Fri,  7 Oct 2011 15:19:21 +0200
Message-Id: <1317993561-16242-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.6.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] kbuild: let object files depend on recordmcount instead of its sources
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the upside that distributions only have to ship the recordmcount
binary to allow building modules instead of recordmcount and it's sources.

Make still notices that the object files need to be rebuilt when
recordmcount's sources change.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 scripts/Makefile.build |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index a0fd502..bc83e94 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -271,8 +271,7 @@ sub_cmd_record_mcount =					\
 	if [ $(@) != "scripts/mod/empty.o" ]; then	\
 		$(objtree)/scripts/recordmcount $(RECORDMCOUNT_FLAGS) "$(@)";	\
 	fi;
-recordmcount_source := $(srctree)/scripts/recordmcount.c \
-		    $(srctree)/scripts/recordmcount.h
+recordmcount_exec := $(objtree)/scripts/recordmcount
 else
 sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
@@ -280,7 +279,7 @@ sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH
 	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
 	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
 	"$(if $(part-of-module),1,0)" "$(@)";
-recordmcount_source := $(srctree)/scripts/recordmcount.pl
+recordmcount_exec := $(srctree)/scripts/recordmcount.pl
 endif
 cmd_record_mcount = 						\
 	if [ "$(findstring -pg,$(_c_flags))" = "-pg" ]; then	\
@@ -301,13 +300,13 @@ define rule_cc_o_c
 endef
 
 # Built-in and composite module parts
-$(obj)/%.o: $(src)/%.c $(recordmcount_source) FORCE
+$(obj)/%.o: $(src)/%.c $(recordmcount_exec) FORCE
 	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
 
 # Single-part modules are special since we need to mark them in $(MODVERDIR)
 
-$(single-used-m): $(obj)/%.o: $(src)/%.c $(recordmcount_source) FORCE
+$(single-used-m): $(obj)/%.o: $(src)/%.c $(recordmcount_exec) FORCE
 	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
 	@{ echo $(@:.o=.ko); echo $@; } > $(MODVERDIR)/$(@F:.o=.mod)
-- 
1.7.6.3

