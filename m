Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab0FGVQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:16:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:55792 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab0FGVQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:16:32 -0400
Date: Mon, 7 Jun 2010 23:16:30 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [kbuild regression, post-rc1] Remote installation over
 read-only NFS broken
Message-ID: <20100607211630.GA3902@sepie.suse.cz>
References: <201006071110.26245.rjw@sisk.pl>
 <alpine.LFD.2.00.1006070732170.3515@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006070732170.3515@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 07:41:42AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 7 Jun 2010, Rafael J. Wysocki wrote:
> > 
> > Namely, I build kernels on a central machine and export the build directory
> > along with the kernel sources over read-only NFS to test boxes.  Then, on the
> > test boxes I run "make modules_install", copy the kernel to /boot, run mkinitrd
> > and so on.  Now, after your commit above the "make modules_install" command on
> > the test boxes doesn't work any more, because it tries to write to the build
> > directory, which is mounted read-only.
> > 
> > Please fix or revert.
> 
> Ahh. It's broken for another reason too. Even if it's a writable 
> filesystem, it means that there's a lot of files that get written by root 
> (since you have to be root to do the install). Which is very 
> uncomfortable, and we've tried very hard to avoid that.

I can fix both issues by the below patch, but then it reintroduces the
issue Eric reported to me with the original approach:

| And indeed it's strange - while scripts/Makefile.build doesn't fail
| since
| there seems to be a script that generates some Makefiles in between
| the build process, I'll get this figured out to see what is the root
| cause.

(the whole thread is at http://lkml.org/lkml/2010/1/6/16).  Eric, does
the above still hold, i.e. if you apply the below patch, does
scripts/Makefile.modbuiltin fail again? If so, is it possible to fix the
driver build process instead?

Here is the patch:

Subject: [PATCH] kbuild: Generate modules.builtin in make modules

Generating the file in make modules_install was broken as well, because
it didn't work in a readonly filesystem and otherwise it generated a
root-owned file which is not wanted.

Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/Makefile b/Makefile
index efdc3d0..2735465 100644
--- a/Makefile
+++ b/Makefile
@@ -1095,7 +1095,7 @@ all: modules
 #	using awk while concatenating to the final file.
 
 PHONY += modules
-modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux)
+modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux) modules.builtin
 	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
 	@$(kecho) '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
@@ -1117,7 +1117,7 @@ PHONY += modules_install
 modules_install: _modinst_ _modinst_post
 
 PHONY += _modinst_
-_modinst_: modules.builtin
+_modinst_:
 	@if [ -z "`$(DEPMOD) -V 2>/dev/null | grep module-init-tools`" ]; then \
 		echo "Warning: you may need to install module-init-tools"; \
 		echo "See http://www.codemonkey.org.uk/docs/post-halloween-2.6.txt";\
