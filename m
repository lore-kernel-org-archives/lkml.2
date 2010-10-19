Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab0JSVbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:31:17 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:41791 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab0JSVbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:31:15 -0400
Date: Tue, 19 Oct 2010 23:31:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier.adi@gmail.com>, Michal Marek <mmarek@suse.cz>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>, mmarek@suse.cz,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH] initramfs: Fix build break on symbol-prefixed archs
Message-ID: <20101019213112.GA11432@merkur.ravnborg.org>
References: <20100831082307.064687027@linux.vnet.ibm.com> <20100831083844.043619334@linux.vnet.ibm.com> <AANLkTikCLHh5Uz-DRq9ws78We+SwCAqdurA6HfuJh-8Y@mail.gmail.com> <20101018103729.GA4122@linux.vnet.ibm.com> <AANLkTikKJ25L=6b2resz+0SAg7ZYL5j=rHG7Lg4kFbwd@mail.gmail.com> <20101019110801.GA4128@linux.vnet.ibm.com> <AANLkTimLi8BYy_u8NhD15s=+iiODzuG1H_CgZ-cd7jep@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimLi8BYy_u8NhD15s=+iiODzuG1H_CgZ-cd7jep@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 04:11:53PM -0400, Mike Frysinger wrote:
> On Tue, Oct 19, 2010 at 07:08, Hendrik Brueckner wrote:
> > --- a/usr/Makefile
> > +++ b/usr/Makefile
> > @@ -19,6 +19,9 @@ suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZ
> >  suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZO)   = .lzo
> >
> >  AFLAGS_initramfs_data.o += -DINITRAMFS_IMAGE="usr/initramfs_data.cpio$(suffix_y)"
> > +ifdef CONFIG_SYMBOL_PREFIX
> > +AFLAGS_initramfs_data.o += -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
> > +endif
> >
> >  # Generate builtin.o based on initramfs_data.o
> >  obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data.o
> 
> i dont think we want to go this route.  keep it in one place:
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -120,7 +120,9 @@ _c_flags += $(if $(patsubst n%,, \
>  endif
> 
>  ifdef CONFIG_SYMBOL_PREFIX
> -_cpp_flags += -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
> +_sym_flags = -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
> +_cpp_flags += $(_sym_flags)
> +_a_flags += $(_sym_flags)
>  endif

The right fix would be to fix some unfortunate breakage in kbuild.
The value of _cpp_flags is only used for preprocessing linker scripts,
but should be used for as and gcc too.

A small analysis:
Today we have different ways to set preprocessor flags.

KBUILD_CPPFLAGS - set in top-level Makefile + arch MAkefile
                  used by all of cpp, as, gcc

EXTRA_CPPFLAGS  - not used at all and can be deleted

cppflags-y      - set in Kbuild files
                - only used when preprocessing linker scripts

CPPFLAGS_<target> - used for linker scripts in many places

It looks like the following untested patch should fix it.
With this patch we have SYMBOL_PREFIX defined when
building assembler files too.

The patch fix it so flags used for preprocessing is also applied
to as and gcc.

@Michal - do you follow my rationale and do you agree?


Another way to fix this would be to fix asm-generic/vmlinx.lds.h
to check for CONFIG_SYMBOL_PREFIX direct.
I cannot see why we require the SYMBOL_PREFIX definition.

See patch number two below for my take on it.
This is my preferred way to deal with this.
The cppflags fix can wait a little.

	Sam

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 54fd1b7..1b8f15d 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -109,10 +109,10 @@ else
 debug_flags =
 endif
 
-orig_c_flags   = $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(KBUILD_SUBDIR_CCFLAGS) \
+orig_c_flags   = $(KBUILD_CFLAGS) $(KBUILD_SUBDIR_CCFLAGS) \
                  $(ccflags-y) $(CFLAGS_$(basetarget).o)
 _c_flags       = $(filter-out $(CFLAGS_REMOVE_$(basetarget).o), $(orig_c_flags))
-_a_flags       = $(KBUILD_CPPFLAGS) $(KBUILD_AFLAGS) $(KBUILD_SUBDIR_ASFLAGS) \
+_a_flags       = $(KBUILD_AFLAGS) $(KBUILD_SUBDIR_ASFLAGS) \
                  $(asflags-y) $(AFLAGS_$(basetarget).o)
 _cpp_flags     = $(KBUILD_CPPFLAGS) $(cppflags-y) $(CPPFLAGS_$(@F))
 
@@ -150,16 +150,14 @@ __a_flags	=                          $(call flags,_a_flags)
 __cpp_flags     =                          $(call flags,_cpp_flags)
 endif
 
-c_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
-		 $(__c_flags) $(modkern_cflags)                           \
+cpp_flags      = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
+		 $(__cpp_flags)
+
+c_flags        = $(cpp_flags) $(__c_flags) $(modkern_cflags)              \
 		 -D"KBUILD_STR(s)=\#s" $(basename_flags) $(modname_flags) \
 		  $(debug_flags)
 
-a_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
-		 $(__a_flags) $(modkern_aflags)
-
-cpp_flags      = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
-		 $(__cpp_flags)
+a_flags        = $(cpp_flags) $(__a_flags) $(modkern_aflags)
 
 ld_flags       = $(LDFLAGS) $(ldflags-y)
 





diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 8a92a17..520e4ac 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -52,12 +52,12 @@
 #define LOAD_OFFSET 0
 #endif
 
-#ifndef SYMBOL_PREFIX
+#ifndef CONFIG_SYMBOL_PREFIX
 #define VMLINUX_SYMBOL(sym) sym
 #else
 #define PASTE2(x,y) x##y
 #define PASTE(x,y) PASTE2(x,y)
-#define VMLINUX_SYMBOL(sym) PASTE(SYMBOL_PREFIX, sym)
+#define VMLINUX_SYMBOL(sym) PASTE(CONFIG_SYMBOL_PREFIX, sym)
 #endif
 
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 54fd1b7..08e13b1 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -127,10 +127,6 @@ _c_flags += $(if $(patsubst n%,, \
 		$(CFLAGS_GCOV))
 endif
 
-ifdef CONFIG_SYMBOL_PREFIX
-_cpp_flags += -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
-endif
-
 
 # If building the kernel in a separate objtree expand all occurrences
 # of -Idir to -I$(srctree)/dir except for absolute paths (starting with '/').
