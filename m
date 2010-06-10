Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab0FJKZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 06:25:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:47199 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab0FJKZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 06:25:07 -0400
Date: Thu, 10 Jun 2010 12:25:02 +0200
From: Michal Marek <mmarek@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [kbuild regression, post-rc1] Remote installation over
 read-only NFS broken
Message-ID: <20100610102502.GA16596@sepie.suse.cz>
References: <201006071110.26245.rjw@sisk.pl>
 <alpine.LFD.2.00.1006070732170.3515@i5.linux-foundation.org>
 <20100607211630.GA3902@sepie.suse.cz>
 <20100610111135.5a24e082.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610111135.5a24e082.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 11:11:35AM +1000, Stephen Rothwell wrote:
> Hi Michal,
> 
> On Mon, 7 Jun 2010 23:16:30 +0200 Michal Marek <mmarek@suse.cz> wrote:
> >
> > I can fix both issues by the below patch, but then it reintroduces the
> > issue Eric reported to me with the original approach:
> > 
> > | And indeed it's strange - while scripts/Makefile.build doesn't fail
> > | since
> > | there seems to be a script that generates some Makefiles in between
> > | the build process, I'll get this figured out to see what is the root
> > | cause.
> > 
> > (the whole thread is at http://lkml.org/lkml/2010/1/6/16).  Eric, does
> > the above still hold, i.e. if you apply the below patch, does
> > scripts/Makefile.modbuiltin fail again? If so, is it possible to fix the
> > driver build process instead?
> > 
> > Here is the patch:
> > 
> > Subject: [PATCH] kbuild: Generate modules.builtin in make modules
> 
> This patch breaks (at least) a powerpc ppc64_defconfig build with
> separate object directory (that starts completely empty).
> 
> /bin/sh: line 1: init/modules.builtin: No such file or directory

Oops, this uncovered a bug in scripts/Makefile.modbuiltin. Following
patch should fix that, I'll run a few randconfigs before pushing it
though.

Michal

Subject: [PATCH] kbuild: Create output directory in Makefile.modbuiltin

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/scripts/Makefile.modbuiltin b/scripts/Makefile.modbuiltin
index 102a276..1adb974 100644
--- a/scripts/Makefile.modbuiltin
+++ b/scripts/Makefile.modbuiltin
@@ -14,6 +14,11 @@ __modbuiltin:
 
 include scripts/Kbuild.include
 
+ifneq ($(KBUILD_SRC),)
+# Create output directory if not already present
+_dummy := $(shell [ -d $(obj) ] || mkdir -p $(obj))
+endif
+
 # The filename Kbuild has precedence over Makefile
 kbuild-dir := $(if $(filter /%,$(src)),$(src),$(srctree)/$(src))
 kbuild-file := $(if $(wildcard $(kbuild-dir)/Kbuild),$(kbuild-dir)/Kbuild,$(kbuild-dir)/Makefile)
