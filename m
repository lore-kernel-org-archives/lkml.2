Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279Ab0LYLU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 06:20:28 -0500
Received: from vostochny.stro.at ([78.47.22.85]:34847 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab0LYLU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 06:20:27 -0500
Date: Sat, 25 Dec 2010 11:20:26 +0000
From: maximilian attems <max@stro.at>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: create linux-headers package in deb-pkg
Message-ID: <20101225112026.GF20262@vostochny.stro.at>
References: <1293201730-1583-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293201730-1583-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 09:42:10AM -0500, Theodore Ts'o wrote:
> Create a linux-headers-$KVER.deb package which can be used to build
> external modules without having the source tree around.

thanks that's great.


fjp had back a year ago asked for a bindeb-pkg once we add more things
to deb-pkg. I had submitted linux-libc-dev built out of deb-pkg
http://marc.info/?l=linux-kbuild&m=125737390700914&w=2

It's an orthogonal issue, but just to clear it up.

-- 
maks

> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  scripts/package/builddeb |   28 +++++++++++++++++++++++++++-
>  1 files changed, 27 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index 49b74e1..cb5b29d 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -40,15 +40,17 @@ else
>  fi
>  tmpdir="$objtree/debian/tmp"
>  fwdir="$objtree/debian/fwtmp"
> +hdrdir="$objtree/debian/hdrtmp"
>  packagename=linux-image-$version
>  fwpackagename=linux-firmware-image
> +hdrpackagename=linux-headers-$version
>  
>  if [ "$ARCH" = "um" ] ; then
>  	packagename=user-mode-linux-$version
>  fi
>  
>  # Setup the directory structure
> -rm -rf "$tmpdir" "$fwdir"
> +rm -rf "$tmpdir" "$fwdir" "$hdrdir"
>  mkdir -p "$tmpdir/DEBIAN" "$tmpdir/lib" "$tmpdir/boot" "$tmpdir/usr/share/doc/$packagename"
>  mkdir -p "$fwdir/DEBIAN" "$fwdir/lib" "$fwdir/usr/share/doc/$fwpackagename"
>  if [ "$ARCH" = "um" ] ; then
> @@ -188,6 +190,30 @@ EOF
>  
>  fi
>  
> +# Build header package
> +find . -name Makefile -o -name Kconfig\* -o -name \*.pl > /tmp/files$$
> +find arch/x86/include include scripts -type f >> /tmp/files$$
x86 centric?
> +(cd $objtree; find .config Module.symvers include scripts -type f >> /tmp/objfiles$$)
> +destdir=$hdrdir/usr/src/linux-headers-$version
> +mkdir -p "$destdir" "$hdrdir/DEBIAN" "$hdrdir/usr/share/doc/$hdrpackagename"
could move up to the other mkdir calls.
> +tar -c -f - -T /tmp/files$$ | (cd $destdir; tar -xf -)
> +(cd $objtree; tar -c -f - -T /tmp/objfiles$$) | (cd $destdir; tar -xf -)
> +rm -f /tmp/files$$ /tmp/objfiles$$
> +arch=$(dpkg --print-architecture)
> +
> +cat <<EOF >> debian/control
> +
> +Package: $hdrpackagename
> +Provides: linux-headers, linux-headers-2.6
> +Architecture: $arch
not sure if that will interfere with the new crosscompile feature
of deb-pkg in linux-next.
> +Description: Linux kernel headers for $KERNELRELEASE on $arch
> + This package provides kernel header files for $KERNELRELEASE on $arch
> + .
> + This is useful for people who need to build external modules
> +EOF
> +
> +create_package "$hdrpackagename" "$hdrdir"
> +
>  # Do we have firmware? Move it out of the way and build it into a package.
>  if [ -e "$tmpdir/lib/firmware" ]; then
>  	mv "$tmpdir/lib/firmware" "$fwdir/lib/"
