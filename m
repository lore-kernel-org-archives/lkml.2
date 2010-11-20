Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab0KTNTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 08:19:19 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:43531 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab0KTNTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 08:19:18 -0500
Date: Sat, 20 Nov 2010 14:19:14 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Guan <guanxuetao@mprc.pku.edu.cn>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Generic support for asm-generic headers [Was: a new UniCore32
	arch-dependent patch for linux-2.6.37-rc1]
Message-ID: <20101120131914.GA2396@merkur.ravnborg.org>
References: <00a701cb8883$649d39f0$2dd7add0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00a701cb8883$649d39f0$2dd7add0$@mprc.pku.edu.cn>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > > +#####
> > > +# Auto Generate the files that only include the corresponding
> asm-generic
> > file
> > > +#   6 files in 27-uc: errno.h fcntl.h ioctl.h poll.h resource.h
> siginfo.h
> > > +
> > > +define cmd_asmgeneric
> > > +	(set -e; \
> > > +	 echo '#include <asm-generic/$(notdir $@)>' )	> $@
> > > +endef
> > 
> > Nice trick. I'd love to have something like this in the common code so
> > we can do the same for all architectures.

Just a quick proof-of-concept hack.

	Sam

diff --git a/Makefile b/Makefile
index ab5359d..e878120 100644
--- a/Makefile
+++ b/Makefile
@@ -344,7 +344,9 @@ CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
 
 # Use LINUXINCLUDE when you must reference the include/ directory.
 # Needed to be compatible with the O= option
-LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include -Iinclude \
+LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include \
+                   $(if $(KBUILD_SRC), -Iarch/$(hdr-arch)/include) \
+                   -Iinclude \
                    $(if $(KBUILD_SRC), -I$(srctree)/include) \
                    -include include/generated/autoconf.h
 
@@ -950,7 +952,13 @@ prepare1: prepare2 include/linux/version.h include/generated/utsrelease.h \
 
 archprepare: prepare1 scripts_basic
 
-prepare0: archprepare FORCE
+archheaders: $(addprefix arch/$(SRCARCH)/include/asm/, $(ARCH_GENERIC_HEADERS))
+
+$(addprefix arch/$(SRCARCH)/include/asm/, $(ARCH_GENERIC_HEADERS)): arch/$(SRCARCH)/Makefile
+	$(Q)mkdir -p $(dir $@)
+	$(Q)echo '#include <asm-generic/$(notdir $@)>' > $@
+
+prepare0: archprepare archheaders FORCE
 	$(Q)$(MAKE) $(build)=.
 	$(Q)$(MAKE) $(build)=. missing-syscalls
 
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index b02e509..fd23d01 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -12,6 +12,8 @@ endif
 # e.g.: obj-y += foo_$(BITS).o
 export BITS
 
+ARCH_GENERIC_HEADERS := termios.h
+
 ifeq ($(CONFIG_X86_32),y)
         BITS := 32
         UTS_MACHINE := i386
diff --git a/arch/x86/include/asm/termios.h b/arch/x86/include/asm/termios.h
deleted file mode 100644
index 280d78a..0000000
--- a/arch/x86/include/asm/termios.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/termios.h>
