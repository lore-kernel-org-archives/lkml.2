Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab1ESMsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:48:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36406 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab1ESMse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:48:34 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=w4lYD6xOu-MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=W75vOVEBfmnzJBHoJzIA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [GIT PULL] (missing patch) ftrace/kbuild: Add recordmcount files
 to force full build
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 19 May 2011 08:48:32 -0400
Message-ID: <1305809312.11267.29.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is the missing patch that was suppose to be in tip/perf/core-2 but
was missing due to git mirror lag.

I waited till the git mirrors updated this time.

Please pull the latest tip/perf/core-3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core-3


Michal Marek (1):
      ftrace/kbuild: Add recordmcount files to force full build

----
 scripts/Makefile.build |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)
---------------------------
commit d6971822c288ce5547190c6f812cc978d6520777
Author: Michal Marek <mmarek@suse.cz>
Date:   Tue May 17 15:36:46 2011 +0200

    ftrace/kbuild: Add recordmcount files to force full build
    
    Modifications to recordmcount must be performed on all object
    files to stay consistent with what the kernel code may expect.
    Add the recordmcount files to the main dependencies to make sure
    any change to them causes a full recompile.
    
    Signed-off-by: Michal Marek <mmarek@suse.cz>
    Link: http://lkml.kernel.org/r/20110517133646.GP13293@sepie.suse.cz
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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


