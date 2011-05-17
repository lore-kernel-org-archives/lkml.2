Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1EQNgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:36:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab1EQNgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:36:49 -0400
Date: Tue, 17 May 2011 15:36:46 +0200
From: Michal Marek <mmarek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/2] ftrace/kbuild: Add recordmcount files to force
 full build
Message-ID: <20110517133646.GP13293@sepie.suse.cz>
References: <20110517021027.390391519@goodmis.org>
 <20110517021423.661004726@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517021423.661004726@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 10:10:29PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Modifications to recordmcount must be performed on all object
> files to stay consistent with what the kernel code may expect.
> Add the recordmcount files to the force-deps to make sure
> any change to them causes a full recompile.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  scripts/Makefile.build |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 0ff5a58..057d6e9 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -252,6 +252,7 @@ sub_cmd_record_mcount =					\
>  	if [ $(@) != "scripts/mod/empty.o" ]; then	\
>  		$(objtree)/scripts/recordmcount "$(@)";	\
>  	fi;
> +force-deps += $(srctree)/scripts/recordmcount.c $(srctree)/scripts/recordmcount.h
>  else
>  sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
>  	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
> @@ -259,6 +260,7 @@ sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH
>  	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
>  	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
>  	"$(if $(part-of-module),1,0)" "$(@)";
> +force-deps += $(srctree)/scripts/recordmcount.pl
>  endif
>  cmd_record_mcount = 						\
>  	if [ "$(findstring -pg,$(_c_flags))" = "-pg" ]; then	\

We could add recordmcount.c as a dependency in scripts/Makefile.build
directly, without playing with fixdep, like this (untested):

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index f133641..bc2c8d3 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -268,6 +268,7 @@ sub_cmd_record_mcount =					\
 	if [ $(@) != "scripts/mod/empty.o" ]; then	\
 		$(objtree)/scripts/recordmcount "$(@)";	\
 	fi;
+recordmcount_source := $(srctree)/scripts/recordmcount.c
 else
 sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
@@ -275,6 +276,7 @@ sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH
 	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
 	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
 	"$(if $(part-of-module),1,0)" "$(@)";
+recordmcount_source := $(srctree)/scripts/recordmcount.pl
 endif
 cmd_record_mcount = 						\
 	if [ "$(findstring -pg,$(_c_flags))" = "-pg" ]; then	\
@@ -295,13 +297,13 @@ define rule_cc_o_c
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

Michal
