Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab1ERQJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:09:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41494 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146Ab1ERQJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:09:07 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=y9eGrYNM-zYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=xdbRATVirv9vrkJ0QZYA:9 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110518160906.110902054@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 12:08:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michal Marek <mmarek@suse.cz>
Subject: [PATCH 01/15] ftrace/kbuild: Add recordmcount files to force full build
References: <20110518160809.724215604@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-kbuild-Add-recordmcount-files-to-force-full-b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Marek <mmarek@suse.cz>

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
index d5f925a..7d3f903 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -252,6 +252,8 @@ sub_cmd_record_mcount =					\
 	if [ $(@) != "scripts/mod/empty.o" ]; then	\
 		$(objtree)/scripts/recordmcount "$(@)";	\
 	fi;
+recordmcount_source := $(srctree)/scripts/recordmcount.c \
+		    $(srctree)/scripts/recordmcount.h
 else
 sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
@@ -259,6 +261,7 @@ sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH
 	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
 	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
 	"$(if $(part-of-module),1,0)" "$(@)";
+recordmcount_source := $(srctree)/scripts/recordmcount.pl
 endif
 cmd_record_mcount = 						\
 	if [ "$(findstring -pg,$(_c_flags))" = "-pg" ]; then	\
@@ -279,13 +282,13 @@ define rule_cc_o_c
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
-- 
1.7.4.4


