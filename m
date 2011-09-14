Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750858Ab1INEYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 00:24:25 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44508 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1INEYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 00:24:23 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH] Kbuild: allow code re-use across different directories
Date: Wed, 14 Sep 2011 00:24:14 -0400
Message-Id: <1315974254-17345-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify Kbuild to allow direct code re-use in multiple directory without having
to go through a copy. Technically, Kbuild would use by default the VPATH feature
of GNU make and provides accessors for Makefile to change it indirectly.

Considering:

arch/foo/lib:
fancy.c

We want to be able to build it with -DPANTS=32 in the kernel, but with
-DPANTS_SIZE=30 in the bootloader.

Currently we would do:

arch/foo/lib/Makefile
LDFLAGS_fancy.o := -DPANTS=32
obj-y += fancy.o

and, either:

arch/foo/boot/Makefile:
LDFLAGS_fancy.o := -DPANTS=30
obj-y += fancy.o
$(obj)/fancy.c: $(srctree)/arch/foo/lib/fancy.c
	$(call cmd,shipped)

or

arch/foo/boot/Makefile:
LDFLAGS_fancy.o := -DPANTS=30
obj-y += fancy.o
$(obj)/fancy.o: $(srctree)/arch/foo/lib/fancy.c
	$(call cmd,cc_c_o)

The former implies an extra copy of the source file, the latter expose Kbuild
internal function.

Now, we just would do:

arch/foo/boot/Makefile:
LDFLAGS_fancy.o := -DPANTS=30
obj-y += fancy.o
vpath-y += $(srctree)/arch/foo/lib

and let GNU make do the job.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 Makefile               |    5 +++--
 scripts/Makefile.build |   24 +++++++++++++++---------
 scripts/Makefile.lib   |   17 ++++++++++++-----
 3 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/Makefile b/Makefile
index c3e90c5..663429b 100644
--- a/Makefile
+++ b/Makefile
@@ -154,9 +154,10 @@ objtree		:= $(CURDIR)
 src		:= $(srctree)
 obj		:= $(objtree)
 
-VPATH		:= $(srctree)$(if $(KBUILD_EXTMOD),:$(KBUILD_EXTMOD))
+KBUILD_VPATH	:= $(srctree)$(if $(KBUILD_EXTMOD),:$(KBUILD_EXTMOD))
+VPATH		:= $(KBUILD_VPATH)
 
-export srctree objtree VPATH
+export srctree objtree KBUILD_VPATH
 
 
 # SUBARCH tells the usermode build what the underlying arch is.  That is set
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index a0fd502..ac539d7 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -18,6 +18,8 @@ always :=
 targets :=
 subdir-y :=
 subdir-m :=
+vpath-y :=
+vpath-m :=
 EXTRA_AFLAGS   :=
 EXTRA_CFLAGS   :=
 EXTRA_CPPFLAGS :=
@@ -37,6 +39,7 @@ include scripts/Kbuild.include
 
 # For backward compatibility check that these variables do not change
 save-cflags := $(CFLAGS)
+save-vpath := $(VPATH)
 
 # The filename Kbuild has precedence over Makefile
 kbuild-dir := $(if $(filter /%,$(src)),$(src),$(srctree)/$(src))
@@ -48,6 +51,9 @@ ifeq ($(KBUILD_NOPEDANTIC),)
         ifneq ("$(save-cflags)","$(CFLAGS)")
                 $(error CFLAGS was changed in "$(kbuild-file)". Fix it to use EXTRA_CFLAGS)
         endif
+        ifneq ("$(save-vpath)","$(VPATH)")
+                $(error VPATH was changed in "$(kbuild-file)". Please uses vpath-y)
+        endif
 endif
 
 #
@@ -198,13 +204,13 @@ $(multi-objs-y:.o=.lst) : modname = $(modname-multi)
 quiet_cmd_cc_s_c = CC $(quiet_modtag)  $@
 cmd_cc_s_c       = $(CC) $(c_flags) -fverbose-asm -S -o $@ $<
 
-$(obj)/%.s: $(src)/%.c FORCE
+$(obj)/%.s: %.c FORCE
 	$(call if_changed_dep,cc_s_c)
 
 quiet_cmd_cc_i_c = CPP $(quiet_modtag) $@
 cmd_cc_i_c       = $(CPP) $(c_flags)   -o $@ $<
 
-$(obj)/%.i: $(src)/%.c FORCE
+$(obj)/%.i: %.c FORCE
 	$(call if_changed_dep,cc_i_c)
 
 cmd_gensymtypes =                                                           \
@@ -219,7 +225,7 @@ cmd_cc_symtypes_c =                                                         \
     $(call cmd_gensymtypes,true,$@) >/dev/null;                             \
     test -s $@ || rm -f $@
 
-$(obj)/%.symtypes : $(src)/%.c FORCE
+$(obj)/%.symtypes : %.c FORCE
 	$(call cmd,cc_symtypes_c)
 
 # C (.c) files
@@ -301,13 +307,13 @@ define rule_cc_o_c
 endef
 
 # Built-in and composite module parts
-$(obj)/%.o: $(src)/%.c $(recordmcount_source) FORCE
+$(obj)/%.o: %.c $(recordmcount_source) FORCE
 	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
 
 # Single-part modules are special since we need to mark them in $(MODVERDIR)
 
-$(single-used-m): $(obj)/%.o: $(src)/%.c $(recordmcount_source) FORCE
+$(single-used-m): %.o: %.c $(recordmcount_source) FORCE
 	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
 	@{ echo $(@:.o=.ko); echo $@; } > $(MODVERDIR)/$(@F:.o=.mod)
@@ -317,7 +323,7 @@ quiet_cmd_cc_lst_c = MKLST   $@
 		     $(CONFIG_SHELL) $(srctree)/scripts/makelst $*.o \
 				     System.map $(OBJDUMP) > $@
 
-$(obj)/%.lst: $(src)/%.c FORCE
+$(obj)/%.lst: %.c FORCE
 	$(call if_changed_dep,cc_lst_c)
 
 # Compile assembler sources (.S)
@@ -331,13 +337,13 @@ $(real-objs-m:.o=.s): modkern_aflags := $(KBUILD_AFLAGS_MODULE) $(AFLAGS_MODULE)
 quiet_cmd_as_s_S = CPP $(quiet_modtag) $@
 cmd_as_s_S       = $(CPP) $(a_flags)   -o $@ $< 
 
-$(obj)/%.s: $(src)/%.S FORCE
+$(obj)/%.s: %.S FORCE
 	$(call if_changed_dep,as_s_S)
 
 quiet_cmd_as_o_S = AS $(quiet_modtag)  $@
 cmd_as_o_S       = $(CC) $(a_flags) -c -o $@ $<
 
-$(obj)/%.o: $(src)/%.S FORCE
+$(obj)/%.o: %.S FORCE
 	$(call if_changed_dep,as_o_S)
 
 targets += $(real-objs-y) $(real-objs-m) $(lib-y)
@@ -349,7 +355,7 @@ quiet_cmd_cpp_lds_S = LDS     $@
       cmd_cpp_lds_S = $(CPP) $(cpp_flags) -P -C -U$(ARCH) \
 	                     -D__ASSEMBLY__ -DLINKER_SCRIPT -o $@ $<
 
-$(obj)/%.lds: $(src)/%.lds.S FORCE
+$(obj)/%.lds: %.lds.S FORCE
 	$(call if_changed_dep,cpp_lds_S)
 
 # Build the compiled-in targets
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index aeea84a..b57b621 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -46,6 +46,13 @@ obj-m		:= $(filter-out %/, $(obj-m))
 
 subdir-ym	:= $(sort $(subdir-y) $(subdir-m))
 
+#
+vpath-ym	:= $(vpath-y) $(vpath-m)
+VPATH		:= $(KBUILD_VPATH)
+VPATH		+= $(srctree)/$(src)
+VPATH		+= $(obj)
+VPATH		+= $(vpath-ym)
+
 # if $(foo-objs) exists, foo.o is a composite object 
 multi-used-y := $(sort $(foreach m,$(obj-y), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y))), $(m))))
 multi-used-m := $(sort $(foreach m,$(obj-m), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y))), $(m))))
@@ -167,7 +174,7 @@ ifdef REGENERATE_PARSERS
 quiet_cmd_gperf = GPERF $@
       cmd_gperf = gperf -t --output-file $@ -a -C -E -g -k 1,3,$$ -p -t $<
 
-$(src)/%.hash.c_shipped: $(src)/%.gperf
+$(src)/%.hash.c_shipped: %.gperf
 	$(call cmd,gperf)
 
 # LEX
@@ -177,7 +184,7 @@ LEX_PREFIX = $(if $(LEX_PREFIX_${baseprereq}),$(LEX_PREFIX_${baseprereq}),yy)
 quiet_cmd_flex = LEX     $@
       cmd_flex = flex -o$@ -L -P $(LEX_PREFIX) $<
 
-$(src)/%.lex.c_shipped: $(src)/%.l
+$(src)/%.lex.c_shipped: %.l
 	$(call cmd,flex)
 
 # YACC
@@ -187,13 +194,13 @@ YACC_PREFIX = $(if $(YACC_PREFIX_${baseprereq}),$(YACC_PREFIX_${baseprereq}),yy)
 quiet_cmd_bison = YACC    $@
       cmd_bison = bison -o$@ -t -l -p $(YACC_PREFIX) $<
 
-$(src)/%.tab.c_shipped: $(src)/%.y
+$(src)/%.tab.c_shipped: %.y
 	$(call cmd,bison)
 
 quiet_cmd_bison_h = YACC    $@
       cmd_bison_h = bison -o/dev/null --defines=$@ -t -l -p $(YACC_PREFIX) $<
 
-$(src)/%.tab.h_shipped: $(src)/%.y
+$(src)/%.tab.h_shipped: %.y
 	$(call cmd,bison_h)
 
 endif
@@ -204,7 +211,7 @@ endif
 quiet_cmd_shipped = SHIPPED $@
 cmd_shipped = cat $< > $@
 
-$(obj)/%: $(src)/%_shipped
+$(obj)/%: %_shipped
 	$(call cmd,shipped)
 
 # Commands useful for building a boot image
-- 
1.7.6.153.g78432

