Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab2IILyt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 07:54:49 -0400
Received: from local.xorcom.com ([81.218.177.19]:31366 "EHLO local.xorcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab2IILyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 07:54:47 -0400
Date: Sun, 9 Sep 2012 14:54:44 +0300
From: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
To: maximilian attems <max@stro.at>
Cc: Michal Marek <mmarek@suse.cz>, Linux Kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] builddeb: remove unneeded explicit Architecture
Message-ID: <20120909115444.GP18204@xorcom.com>
References: <5040C112.70501@suse.cz>
 <20120905130528.GI18204@xorcom.com>
 <50475310.6000508@suse.cz>
 <20120905151422.GD12713@stro.at>
 <20120905164009.GM18204@xorcom.com>
 <20120905202604.GF28778@vostochny.stro.at>
 <20120906140004.GL19848@vostochny.stro.at>
 <20120906140416.GG28778@vostochny.stro.at>
 <20120906162143.GN18204@xorcom.com>
 <20120907000209.GA5993@stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907000209.GA5993@stro.at>
X-Forced-Service: Sadly Using Gmail [tm]
Organization: Xorcom*
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 02:02:09AM +0200, maximilian attems wrote:
> On Thu, 06 Sep 2012, Tzafrir Cohen wrote:
> >
> > Works for the case I presented.
> 
> Michal please care to queue previous v2 patch with
> Tested-by: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
> to kope with that cross building regression since
> the linux headers got added to deb-pkg target.
> 
> > Now I remove the explicit setting of KBUILD_DEBRCH:
> 
> and here lies the error.
>  
> >   $ rm -rf debian
> >   $ make ARCH=arm KBUILD_IMAGE=uImage deb-pkg
> > 
> >   ...
> > 
> >   dpkg-gencontrol: error: current host architecture 'armhf' does not
> >   appear in package's architecture list (armel)
> > 
> > My host architecture is amd64. This is actually the build architecture.
> > dpkg-gencontrol uses Dpkg::Arch::get_host_arch().
> > 
> >   $ perl -MDpkg::Arch -e 'print Dpkg::Arch::get_host_arch()."\n"'
> >   amd64
> > 
> >   $ CC=/usr/bi/narm-linux-gnueabi-gcc  perl -MDpkg::Arch -e 'print Dpkg::Arch::get_host_arch()."\n"'
> >   armel
> >   
> >   $ CC=/usr/bin/arm-linux-gnueabihf-gcc  perl -MDpkg::Arch -e 'print Dpkg::Arch::get_host_arch()."\n"'
> >   armhf
> > 
> >   $ DEB_HOST_ARCH=whatever perl -MDpkg::Arch -e 'print Dpkg::Arch::get_host_arch()."\n"'
> >   whatever
> > 
> > Is it OK to use that perl one-liner as the default instead of the
> > architecture guessing case?
> 
> In any case that would be a follow up, but I'm not fond of that perl/dpkg
> magic plus supporting DEB_ variables. 

This magic is lifted from current dpkg-gencontrol. Is there any better
way to get it?

> I think for linux it is preferable
> to have it based on UTS_MACHINE. Thus I think your testcases aren't valid,

Well, my current build script is:

  #!/bin/sh
  # YOu need to have one of the following unremmed to avoid a
  # dpkg-gencontrol error:
  export KBUILD_DEBARCH=armhf # Unrem this for armhf
  #export DEB_HOST_ARCH=armel # Or this for armel
  exec make ARCH=arm KBUILD_IMAGE=uImage deb-pkg "$@"

Clearly on my build toolchain I must set DEB_HOST_ARCH in some cases. So
DEB_ variables are already in there. Without it it will give me an error
for trying to build 

> and also you neglected the following one:
> make KBUILD_DEBARCH=i386 deb-pkg # i386 userland with amd64 linux

I'm not sure I follow. If the packagees are to be installed on a i386
system, they are all to be considered i386, right? The linux-image
package as well. The same as
http://packages.debian.org/sid/linux-image-amd64 (the i386 variant).

Setting KBUILD_DEBARCH does not change the building of the files in any
way. It only changes the package's metadata.

Maybe set DEB_HOST_ARCH from KBUILD_DEBARCH if the latter was set?

-- 
               Tzafrir Cohen
icq#16849755              jabber:tzafrir.cohen@xorcom.com
+972-50-7952406           mailto:tzafrir.cohen@xorcom.com
http://www.xorcom.com  iax:guest@local.xorcom.com/tzafrir
