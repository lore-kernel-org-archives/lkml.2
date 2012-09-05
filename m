Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946Ab2IEQkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:40:15 -0400
Received: from local.xorcom.com ([81.218.177.19]:48925 "EHLO local.xorcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758839Ab2IEQkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:40:11 -0400
Date: Wed, 5 Sep 2012 19:40:09 +0300
From: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
To: maximilian attems <max@stro.at>
Cc: Michal Marek <mmarek@suse.cz>, Linux Kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] builddeb: remove unneeded explicit Architecture
Message-ID: <20120905164009.GM18204@xorcom.com>
References: <1344941092-31312-1-git-send-email-tzafrir.cohen@xorcom.com>
 <5040C112.70501@suse.cz>
 <20120905130528.GI18204@xorcom.com>
 <50475310.6000508@suse.cz>
 <20120905151422.GD12713@stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905151422.GD12713@stro.at>
X-Forced-Service: Sadly Using Gmail [tm]
Organization: Xorcom*
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 05:14:22PM +0200, maximilian attems wrote:
> On Wed, 05 Sep 2012, Michal Marek wrote:
> 
> > On 5.9.2012 15:05, Tzafrir Cohen wrote:
> > > Hi,
> > > 
> > > Thanks for your reply,
> > > 
> > > On Fri, Aug 31, 2012 at 03:50:10PM +0200, Michal Marek wrote:
> > >> Adding Max to CC.
> > >>
> > >> On 14.8.2012 12:44, Tzafrir Cohen wrote:
> > >>> Architecture was set explicitly in debian/control for one of the three
> > >>> packages (linux-libc-dev) but not for the other two. When cross-building
> > >>> it gives me an error:
> > >>>
> > >>>   dpkg-gencontrol: error: current host architecture 'armhf' does not
> > >>>   appear in package's architecture list (amd64)
> > >>>
> > >>> Also note that if used, dpkg --print-architecture should have been
> > >>> replaced with dpkg-architecture.
> > >>>
> > >>> Signed-off-by: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
> > >>> ---
> > >>>  scripts/package/builddeb |    3 +--
> > >>>  1 file changed, 1 insertion(+), 2 deletions(-)
> > >>>
> > >>> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> > >>> index acb8650..d9c71a6 100644
> > >>> --- a/scripts/package/builddeb
> > >>> +++ b/scripts/package/builddeb
> > >>> @@ -252,13 +252,12 @@ mkdir -p "$destdir"
> > >>>  (cd $objtree; tar -c -f - -T "$objtree/debian/hdrobjfiles") | (cd $destdir; tar -xf -)
> > >>>  ln -sf "/usr/src/linux-headers-$version" "$kernel_headers_dir/lib/modules/$version/build"
> > >>>  rm -f "$objtree/debian/hdrsrcfiles" "$objtree/debian/hdrobjfiles"
> > >>> -arch=$(dpkg --print-architecture)
> > >>>  
> > >>>  cat <<EOF >> debian/control
> > >>>  
> > >>>  Package: $kernel_headers_packagename
> > >>>  Provides: linux-headers, linux-headers-2.6
> > >>> -Architecture: $arch
> > >>> +Architecture: any
> > >>>  Description: Linux kernel headers for $KERNELRELEASE on $arch
> > >>>   This package provides kernel header files for $KERNELRELEASE on $arch
> > >>>   .
> > >>
> > >> As the package contains files from arch/$SRCARCH/include, I doubt that
> > >> this is a valid change.
> > > 
> > > But you optionally force the Architecture later on in build_package.
> > > "Arhcitecture: any" in the source package states that the binary package
> > > will be the one stated by the build system.
> > 
> > Ah, OK. I don't know much about Debian packaging in fact. Max, could you
> > have a look? The original thread is here:
> > http://lkml.org/lkml/2012/8/14/133. I meant to add you to CC before,
> > but apparently I forgot.
>
> yes indeed it is an invalid change.
> Cross building shouldn't need it, what did you exactly try?

$ grep CROSS_COMPILE .config
CONFIG_CROSS_COMPILE="arm-linux-gnueabihf-"

Command:

  KBUILD_DEBARCH=armhf make ARCH=arm KBUILD_IMAGE=uImage deb-pkg

Error I get:

  dpkg-gencontrol: error: current host architecture 'armhf' does not
  appear in package's architecture list (amd64)

It seems I have to use KBUILD_DEBARCH, as the kernel build system can't
really tell if I want armel or armhf (If I built the same kernel for a
Squeeze system I would have been forced to use armel).

After I apply the patch, I can build the packages with no problem. The
generated linux-libc-dev file has "Architecture: armhf".


Below is debian/control at the time the error message was generated:

Source: linux-upstream
Section: kernel
Priority: optional
Maintainer: Tzafrir Cohen <tzafrir@debian.org>
Standards-Version: 3.8.4
Homepage: http://www.kernel.org/

Package: linux-image-3.6.0-rc4-cm-t3730+
Provides: linux-image, linux-image-2.6, linux-modules-3.6.0-rc4-cm-t3730+
Suggests: linux-firmware-image
Architecture: any
Description: Linux kernel, version 3.6.0-rc4-cm-t3730+
 This package contains the Linux kernel, modules and corresponding other
 files, version: 3.6.0-rc4-cm-t3730+.

Package: linux-headers-3.6.0-rc4-cm-t3730+
Provides: linux-headers, linux-headers-2.6
Architecture: amd64
Description: Linux kernel headers for 3.6.0-rc4-cm-t3730+ on amd64
 This package provides kernel header files for 3.6.0-rc4-cm-t3730+ on amd64
 .
 This is useful for people who need to build external modules

Package: linux-libc-dev
Section: devel
Provides: linux-kernel-headers
Architecture: any
Description: Linux support headers for userspace development
 This package provides userspaces headers from the Linux kernel.  These headers
 are used by the installed headers for GNU glibc and other system libraries.

-- 
               Tzafrir Cohen
icq#16849755              jabber:tzafrir.cohen@xorcom.com
+972-50-7952406           mailto:tzafrir.cohen@xorcom.com
http://www.xorcom.com  iax:guest@local.xorcom.com/tzafrir
