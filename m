Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305Ab0JHOvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:51:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:54743 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757342Ab0JHOvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:51:44 -0400
Date: Fri, 8 Oct 2010 16:51:41 +0200
From: Michal Marek <mmarek@suse.cz>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: linux-next: build warnings after merge of the kbuild-current
 tree
Message-ID: <20101008145141.GA13688@sepie.suse.cz>
References: <20101006114433.4fbe86ef.sfr@canb.auug.org.au>
 <4CAC59D4.5010505@suse.cz>
 <1286365363.4281.5.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286365363.4281.5.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 12:42:43PM +0100, Catalin Marinas wrote:
> On Wed, 2010-10-06 at 12:13 +0100, Michal Marek wrote:
> > On 6.10.2010 02:44, Stephen Rothwell wrote:
> > > After merging the kbuild-current tree, today's (and yesterday's)
> > > linux-next build (x86_64 allmodconfig and other builds as well) produced
> > > these warnings:
> > >
> > > warning: [...] selects I2C_ALGOBIT which has unmet direct dependencies (I2C && !I2C_HELPER_AUTO)
> > > [...]
> > > warning: [...] selects VIDEO_TVAUDIO which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C)
> > >
> > > After reverting commit ff5ff6060bf880aac233e68dd666cbe9e39ec620
> > > ("kconfig: delay symbol direct dependency initialization") it produces no
> > > such warnings.
> > 
> > I'm aware of them. I'm talking with Jean Delvare about fixing the I2C
> > warnings, see http://lkml.org/lkml/2010/10/5/83. The drivers/media/video
> > warnings will need the same care. I don't know if we manage to fix these
> > in time, so maybe the kconfig fix will have to way for 2.6.36.1.
> 
> The kconfig commit ff5ff6060 fixes a bug with commit 246cf9c26 which was
> using some structures after they were freed. Because of the bug, it just
> happened that it wasn't showing these kconfig warnings. A worst thing is
> kbuild segfaulting or getting into an infinite loop (as reported/fixed
> by Arnaud).
> 
> I think the above commit is still needed before 2.6.36 and maybe push a
> drivers/media/video warnings in 2.6.36.1.

So my approach would be to disable the kconfig warnings *temporarily*
for 2.6.36-final. The warnings have done a good job already during the
2.6.36-rc phase and will serve us after 2.6.36 again, just the new load
of warnings that every user is going to see is not really desirable at
this point in time :-|.

Opinions?

Michal

>From ca22d6b4c7c26a8ff9092036a9524bc5ba817277 Mon Sep 17 00:00:00 2001
From: Michal Marek <mmarek@suse.cz>
Date: Fri, 8 Oct 2010 16:40:27 +0200
Subject: [PATCH] kconfig: Temporarily disable dependency warnings

After fixing a use-after-free bug in kconfig, a 'make defconfig' or
'make allmodconfig' fills the screen with warnings that were not
detected before. Given that we are close to the release now, disable the
warnings temporarily and deal with them after 2.6.36.

Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 943712c..d3cfa49 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -350,7 +350,7 @@ void sym_calc_value(struct symbol *sym)
 				}
 			}
 		calc_newval:
-			if (sym->dir_dep.tri == no && sym->rev_dep.tri != no) {
+			if (0 && sym->dir_dep.tri == no && sym->rev_dep.tri != no) {
 				fprintf(stderr, "warning: (");
 				expr_fprint(sym->rev_dep.expr, stderr);
 				fprintf(stderr, ") selects %s which has unmet direct dependencies (",
