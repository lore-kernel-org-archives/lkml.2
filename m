Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab2IFQVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:21:48 -0400
Received: from local.xorcom.com ([81.218.177.19]:59445 "EHLO local.xorcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915Ab2IFQVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:21:46 -0400
Date: Thu, 6 Sep 2012 19:21:43 +0300
From: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
To: maximilian attems <max@stro.at>
Cc: Michal Marek <mmarek@suse.cz>, Linux Kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] builddeb: remove unneeded explicit Architecture
Message-ID: <20120906162143.GN18204@xorcom.com>
References: <1344941092-31312-1-git-send-email-tzafrir.cohen@xorcom.com>
 <5040C112.70501@suse.cz>
 <20120905130528.GI18204@xorcom.com>
 <50475310.6000508@suse.cz>
 <20120905151422.GD12713@stro.at>
 <20120905164009.GM18204@xorcom.com>
 <20120905202604.GF28778@vostochny.stro.at>
 <20120906140004.GL19848@vostochny.stro.at>
 <20120906140416.GG28778@vostochny.stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906140416.GG28778@vostochny.stro.at>
X-Forced-Service: Sadly Using Gmail [tm]
Organization: Xorcom*
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 02:04:16PM +0000, maximilian attems wrote:
> On Thu, Sep 06, 2012 at 02:00:04PM +0000, maximilian attems wrote:
> > On Wed, Sep 05, 2012 at 08:26:05PM +0000, maximilian attems wrote:
> > > On Wed, Sep 05, 2012 at 07:40:09PM +0300, Tzafrir Cohen wrote:
> > > > 
> > > > $ grep CROSS_COMPILE .config
> > > > CONFIG_CROSS_COMPILE="arm-linux-gnueabihf-"
> > > > 
> > > > Command:
> > > > 
> > > >   KBUILD_DEBARCH=armhf make ARCH=arm KBUILD_IMAGE=uImage deb-pkg
> > > > 
> > > > Error I get:
> > > > 
> > > >   dpkg-gencontrol: error: current host architecture 'armhf' does not
> > > >   appear in package's architecture list (amd64)
> > > > 
> > > > It seems I have to use KBUILD_DEBARCH, as the kernel build system can't
> > > > really tell if I want armel or armhf (If I built the same kernel for a
> > > > Squeeze system I would have been forced to use armel).
> > > 
> > > well, obviously the dpkg call in
> > >  -arch=$(dpkg --print-architecture)
> > > is wrong please fix that.
> > > 
> > 
> > care to test belows:
> > 
> 
> without a useless snippet about the lost forcearch v2:
> 
> >From f78afbe0b7fa7c49656f4ed1cf404e915f3c325b Mon Sep 17 00:00:00 2001
> From: maximilian attems <max@stro.at>
> Date: Thu, 6 Sep 2012 15:22:02 +0200
> Subject: [PATCH v2] deb-pkg: Simplify architecture matching for cross building
> 
> No point in invoking dpkg to get the archticture of the host
> we build on. Instead directly use the logic implemented
> in create_package(). No need anymore to override arch.

Works for the case I presented. I still have one bad case:

Now I remove the explicit setting of KBUILD_DEBRCH:

  $ rm -rf debian
  $ make ARCH=arm KBUILD_IMAGE=uImage deb-pkg

  ...

  dpkg-gencontrol: error: current host architecture 'armhf' does not
  appear in package's architecture list (armel)

My host architecture is amd64. This is actually the build architecture.
dpkg-gencontrol uses Dpkg::Arch::get_host_arch().

  $ perl -MDpkg::Arch -e 'print Dpkg::Arch::get_host_arch()."\n"'
  amd64

  $ CC=/usr/bin/arm-linux-gnueabi-gcc  perl -MDpkg::Arch -e 'print Dpkg::Arch::get_host_arch()."\n"'
  armel
  
  $ CC=/usr/bin/arm-linux-gnueabihf-gcc  perl -MDpkg::Arch -e 'print Dpkg::Arch::get_host_arch()."\n"'
  armhf

  $ DEB_HOST_ARCH=whatever perl -MDpkg::Arch -e 'print Dpkg::Arch::get_host_arch()."\n"'
  whatever

Is it OK to use that perl one-liner as the default instead of the
architecture guessing case?

-- 
               Tzafrir Cohen
icq#16849755              jabber:tzafrir.cohen@xorcom.com
+972-50-7952406           mailto:tzafrir.cohen@xorcom.com
http://www.xorcom.com  iax:guest@local.xorcom.com/tzafrir
