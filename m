Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2GGVkj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 17:40:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab2GGVki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 17:40:38 -0400
Date: Sat, 7 Jul 2012 23:40:33 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Arnaud Lacombe <lacombar@gmail.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Jan Beulich <jbeulich@novell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "Inconsistent kallsyms data" error
Message-ID: <20120707214033.GA5303@pobox.suse.cz>
References: <CA+55aFyr+gexQW9Gmg=_V145SUeKOcfSNUx5h4p7bgjMp=07Og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyr+gexQW9Gmg=_V145SUeKOcfSNUx5h4p7bgjMp=07Og@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 02:18:18PM -0700, Linus Torvalds wrote:
> So for some unknown reason I'm hitting this on just one particular
> machine, and it's *very* annoying.
> 
> It's annoying for three reasons:
> 
>  - it's breaking the build (duh)
> 
>  - the error is printed out to stderr, so you don't even *see* it as
> an error if you redirect the normal messages somewhere else (like any
> sane person, ie me, does)

I'm committing the attached patch to kbuild.git#kbuild.


>  - when the error happens, it doesn't show *what* went wrong, and in
> fact it explicitly cleans up all the files that could show what
> happened.

Right, the files need to be preserved somehow. At the same
time, we can't leave the final files there, to not mark the link as
successful. I will have a look.

No idea about the actual kallsyms bug yet, sorry.

Michal


>From 5369f55021feb27a1481267e7afefe14128d669f Mon Sep 17 00:00:00 2001
From: Michal Marek <mmarek@suse.cz>
Date: Sat, 7 Jul 2012 23:04:40 +0200
Subject: [PATCH] kbuild: Print errors to stderr

... at least in the top-level Makefile and scripts/link-vmlinux.sh.
There are some more instances of the 'echo <error>; exit 1' pattern in
some arch Makefiles and kconfig.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile                |   24 ++++++++++++------------
 scripts/link-vmlinux.sh |    4 ++--
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/Makefile b/Makefile
index 0d718ed..d7d7949 100644
--- a/Makefile
+++ b/Makefile
@@ -535,11 +535,11 @@ PHONY += include/config/auto.conf
 
 include/config/auto.conf:
 	$(Q)test -e include/generated/autoconf.h -a -e $@ || (		\
-	echo;								\
-	echo "  ERROR: Kernel configuration is invalid.";		\
-	echo "         include/generated/autoconf.h or $@ are missing.";\
-	echo "         Run 'make oldconfig && make prepare' on kernel src to fix it.";	\
-	echo;								\
+	echo >&2;							\
+	echo >&2 "  ERROR: Kernel configuration is invalid.";		\
+	echo >&2 "         include/generated/autoconf.h or $@ are missing.";\
+	echo >&2 "         Run 'make oldconfig && make prepare' on kernel src to fix it.";	\
+	echo >&2 ;							\
 	/bin/false)
 
 endif # KBUILD_EXTMOD
@@ -796,8 +796,8 @@ prepare3: include/config/kernel.release
 ifneq ($(KBUILD_SRC),)
 	@$(kecho) '  Using $(srctree) as source for kernel'
 	$(Q)if [ -f $(srctree)/.config -o -d $(srctree)/include/config ]; then \
-		echo "  $(srctree) is not clean, please run 'make mrproper'"; \
-		echo "  in the '$(srctree)' directory.";\
+		echo >&2 "  $(srctree) is not clean, please run 'make mrproper'"; \
+		echo >&2 "  in the '$(srctree)' directory.";\
 		/bin/false; \
 	fi;
 endif
@@ -971,11 +971,11 @@ else # CONFIG_MODULES
 # ---------------------------------------------------------------------------
 
 modules modules_install: FORCE
-	@echo
-	@echo "The present kernel configuration has modules disabled."
-	@echo "Type 'make config' and enable loadable module support."
-	@echo "Then build a kernel with module support enabled."
-	@echo
+	@echo >&2
+	@echo >&2 "The present kernel configuration has modules disabled."
+	@echo >&2 "Type 'make config' and enable loadable module support."
+	@echo >&2 "Then build a kernel with module support enabled."
+	@echo >&2
 	@exit 1
 
 endif # CONFIG_MODULES
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index cd9c6c6..4629038 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -210,8 +210,8 @@ if [ -n "${CONFIG_KALLSYMS}" ]; then
 	mksysmap ${kallsyms_vmlinux} .tmp_System.map
 
 	if ! cmp -s System.map .tmp_System.map; then
-		echo Inconsistent kallsyms data
-		echo echo Try "make KALLSYMS_EXTRA_PASS=1" as a workaround
+		echo >&2 Inconsistent kallsyms data
+		echo >&2 echo Try "make KALLSYMS_EXTRA_PASS=1" as a workaround
 		cleanup
 		exit 1
 	fi
