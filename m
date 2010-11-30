Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab0K3PhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:37:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab0K3PhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:37:03 -0500
Date: Tue, 30 Nov 2010 16:36:59 +0100
From: Michal Marek <mmarek@suse.cz>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com
Subject: Re: [PATCH] initramfs: Fix build break on symbol-prefixed archs
Message-ID: <20101130153659.GE9418@sepie.suse.cz>
References: <20101019213112.GA11432@merkur.ravnborg.org>
 <AANLkTike6UQVWKSz-Njs5Rps690EHeResH3V+aSM+qdO@mail.gmail.com>
 <AANLkTimn8R-qde8FH_cNa4JPcR2F=mkUAQhPVT-hOBhn@mail.gmail.com>
 <4CC8ABC7.5030003@suse.cz>
 <20101028203542.GA30879@merkur.ravnborg.org>
 <4CC9E8C7.60306@suse.cz>
 <AANLkTinfsjy9GzDg1eHx+mFc4VabCZ2jk85JodFqRnEE@mail.gmail.com>
 <AANLkTimDUnaQ+Nax5Xz_TFmzPpj-20w7LOknL_WCKDdt@mail.gmail.com>
 <20101129143850.dbc533da.akpm@linux-foundation.org>
 <AANLkTi=3JQGZERNS7Uvbrs==dm0pJE_rGrcD_CkW2RDq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=3JQGZERNS7Uvbrs==dm0pJE_rGrcD_CkW2RDq@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 06:29:37PM -0500, Mike Frysinger wrote:
> On Mon, Nov 29, 2010 at 17:38, Andrew Morton wrote:
> > On Wed, 24 Nov 2010 03:40:51 -0500 Mike Frysinger wrote:
> >> On Sat, Nov 13, 2010 at 18:17, Mike Frysinger wrote:
> >> > On Thu, Oct 28, 2010 at 17:19, Michal Marek wrote:
> >> >> On 28.10.2010 22:35, Sam Ravnborg wrote:
> >> >>> On Thu, Oct 28, 2010 at 12:46:31AM +0200, Michal Marek wrote:
> >> >>>> On 27.10.2010 20:23, Mike Frysinger wrote:
> >> >>>>> can we get this change dropped from linux-next until someone gets a
> >> >>>>> chance to fix it ?
> >> >>>>
> >> >>>> Sorry I missed this thread. So your last patch
> >> >>>> (http://lkml.org/lkml/2010/10/19/488) did fix the Blackfin build
> >> >>>> failure? Can you submit it with a proper Signed-off-by and changelog?
> >> >>>
> >> >>> Did you see the patch I posted in: http://lkml.org/lkml/2010/10/19/534
> >> >>>
> >> >>> The one that fix up the cppflags usage.
> >> >>>
> >> >>> I think this will solve the issue with blackfin nicely - and
> >> >>> make use of cppflags more as expected.
> >> >>
> >> >> As Mike noted - your patch does not strip the double quotes. And Mike's
> >> >> patch is really minimal, it just adds the SYMBOL_PREFIX definition to
> >> >> _a_flags. I'll look at your patch after this merge window.
> >> >
> >> > why am i seeing __initramfs_size failures in mainline now ?
> >>
> >> ping ... it looks like no one merged the VMLINUX_SYMBOL() changes in
> >> usr/initramfs_data.S proposed by Hendrik

Argh, yes. I only merged your patch to use -DSYMBOL_PREFIX when preprocessing
.S files ("initramfs: Fix build break on symbol-prefixed archs") as d63f6d1,
but did not realize that the main part of Hendrik's patch is missing :-/.

> >
> > Well I found and forward-ported the below, from October.

I deleted the Makefile change, which is now obsoleted by d63f6d1, the
result would look like below. Mike, does mainline with this patch build
on Blackfin now?

Michal

From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: [PATCH] initramfs: Really fix build break on symbol-prefixed archs

Define the __initramfs_size variable using VMLINUX_SYMBOL() to take care
of symbol-prefixed architectures, for example, blackfin.

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[mmarek: leave out Makefile change, since d63f6d1 already takes care of the
 SYMBOL_PREFIX define]
Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/usr/initramfs_data.S b/usr/initramfs_data.S
index 792a750..c14322d 100644
--- a/usr/initramfs_data.S
+++ b/usr/initramfs_data.S
@@ -22,14 +22,15 @@
 */
 
 #include <linux/stringify.h>
+#include <asm-generic/vmlinux.lds.h>
 
 .section .init.ramfs,"a"
 __irf_start:
 .incbin __stringify(INITRAMFS_IMAGE)
 __irf_end:
 .section .init.ramfs.info,"a"
-.globl __initramfs_size
-__initramfs_size:
+.globl VMLINUX_SYMBOL(__initramfs_size)
+VMLINUX_SYMBOL(__initramfs_size):
 #ifdef CONFIG_64BIT
 	.quad __irf_end - __irf_start
 #else
