Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab0GLS0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 14:26:25 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:42928 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab0GLS0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 14:26:24 -0400
Date: Mon, 12 Jul 2010 20:26:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Denys Vlasenko <vda.linux@googlemail.com>, Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Modpost error after changing CONFIG_SOUND from m to y
Message-ID: <20100712182622.GA17551@merkur.ravnborg.org>
References: <201007120554.16459.vda.linux@googlemail.com> <20100712100301.db1d3980.randy.dunlap@oracle.com> <AANLkTin88f83UV4HcqKtaXS7F2hMTe8YVJPpE-XLmo5J@mail.gmail.com> <20100712172847.GA17423@merkur.ravnborg.org> <AANLkTimTdQRCoWzCYZ7yBLYsKr4P812n8UR678hktJbO@mail.gmail.com> <20100712174114.GA17431@merkur.ravnborg.org> <AANLkTik8WV6kRwDK2N5M_hg7Opi0agLdIERK06GwhU0o@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik8WV6kRwDK2N5M_hg7Opi0agLdIERK06GwhU0o@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 07:42:25PM +0200, Denys Vlasenko wrote:
> On Mon, Jul 12, 2010 at 7:41 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> >> >
> >> > What is the intial reason why you assign CFLAGS_KERNEL and CFLAGS_MODULE?
> >>
> >> I want to add some flags to every compiler invocation.
> >
> >    make KCFLAGS=-DMYSTUFF
> >
> > is what you want to use then.
> 
> What to do if I want different options for kernel and for modules?

Use CFLAGS_KERNEL, CFLAGS_MODULE :-)
But you then need to add "-DMODULE" to CLFAGS_MODULE because that
is lost when you override these variables.

Maybe we should fix this...
Relying on the user to add "-DMODULE" to CFLAGS_MODULE is just broken.

Following patch fixes it so we free up CFLAGS_MODULE to
be used by the user.
It drops the potentially user visible "MODFLAGS".
But alas I do not know of it being used...

Comments?

	Sam

diff --git a/Makefile b/Makefile
index f9835c8..c7c6fdd 100644
--- a/Makefile
+++ b/Makefile
@@ -332,9 +332,8 @@ CHECK		= sparse
 
 CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
 		  -Wbitwise -Wno-return-void $(CF)
-MODFLAGS	= -DMODULE
-CFLAGS_MODULE   = $(MODFLAGS)
-AFLAGS_MODULE   = $(MODFLAGS)
+CFLAGS_MODULE   =
+AFLAGS_MODULE   =
 LDFLAGS_MODULE  = -T $(srctree)/scripts/module-common.lds
 CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
@@ -355,6 +354,7 @@ KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -Wno-format-security \
 		   -fno-delete-null-pointer-checks
 KBUILD_AFLAGS   := -D__ASSEMBLY__
+KBUILD_MODFLAGS := -DMODULE
 
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)
 KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
@@ -368,7 +368,7 @@ export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
 export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV
-export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
+export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE KBUILD_MODFLAGS
 
 # When compiling out-of-tree modules, put MODVERDIR in the module
 # tree rather than in the kernel tree. The kernel tree might
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 0b9c01a..2d77a2d 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -93,7 +93,7 @@ all-$(CONFIG_SYS_SUPPORTS_ZBOOT)+= vmlinuz
 cflags-y			+= -G 0 -mno-abicalls -fno-pic -pipe
 cflags-y			+= -msoft-float
 LDFLAGS_vmlinux			+= -G 0 -static -n -nostdlib
-MODFLAGS			+= -mlong-calls
+KBUILD_MODFLAGS			+= -mlong-calls
 
 cflags-y += -ffreestanding
 
@@ -185,7 +185,7 @@ cflags-$(CONFIG_CPU_DADDI_WORKAROUNDS)	+= $(call cc-option,-mno-daddi,)
 
 ifdef CONFIG_CPU_SB1
 ifdef CONFIG_SB1_PASS_1_WORKAROUNDS
-MODFLAGS	+= -msb1-pass1-workarounds
+KBUILD_MODFLAGS	+= -msb1-pass1-workarounds
 endif
 endif
 
diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 30c5f01..16a3ef9 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -24,7 +24,7 @@ CHECKFLAGS	+= -D__s390__ -msize-long
 else
 LD_BFD		:= elf64-s390
 LDFLAGS		:= -m elf64_s390
-MODFLAGS	+= -fpic -D__PIC__
+KBUILD_MODFLAGS	+= -fpic -D__PIC__
 KBUILD_CFLAGS	+= -m64
 KBUILD_AFLAGS	+= -m64
 UTS_MACHINE	:= s390x
diff --git a/arch/score/Makefile b/arch/score/Makefile
index 68e0cd0..c667f1d 100644
--- a/arch/score/Makefile
+++ b/arch/score/Makefile
@@ -20,7 +20,7 @@ cflags-y += -G0 -pipe -mel -mnhwloop -D__SCOREEL__ \
 #
 KBUILD_AFLAGS += $(cflags-y)
 KBUILD_CFLAGS += $(cflags-y)
-MODFLAGS += -mlong-calls
+KBUILD_MODFLAGS += -mlong-calls
 LDFLAGS += --oformat elf32-littlescore
 LDFLAGS_vmlinux	+= -G0 -static -nostdlib
 
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index e4deb73..c538f81 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -115,7 +115,10 @@ endif
 # ---------------------------------------------------------------------------
 
 # Default is built-in, unless we know otherwise
-modkern_cflags = $(if $(part-of-module), $(CFLAGS_MODULE), $(CFLAGS_KERNEL))
+modkern_cflags =                                     \
+	$(if $(part-of-module),                      \
+		$(KBUILD_MODFLAGS) $(CFLAGS_MODULE), \
+		$(CFLAGS_KERNEL))
 quiet_modtag := $(empty)   $(empty)
 
 $(real-objs-m)        : part-of-module := y
@@ -250,8 +253,8 @@ $(obj)/%.lst: $(src)/%.c FORCE
 
 modkern_aflags := $(AFLAGS_KERNEL)
 
-$(real-objs-m)      : modkern_aflags := $(AFLAGS_MODULE)
-$(real-objs-m:.o=.s): modkern_aflags := $(AFLAGS_MODULE)
+$(real-objs-m)      : modkern_aflags := $(KBUILD_MODFLAGS) $(AFLAGS_MODULE)
+$(real-objs-m:.o=.s): modkern_aflags := $(KBUILD_MODFLAGS) $(AFLAGS_MODULE)
 
 quiet_cmd_as_s_S = CPP $(quiet_modtag) $@
 cmd_as_s_S       = $(CPP) $(a_flags)   -o $@ $< 


