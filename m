Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2BDOew (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 09:34:52 -0500
Received: from vostochny.stro.at ([78.47.22.85]:46157 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab2BDOeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 09:34:50 -0500
Date: Sat, 4 Feb 2012 15:34:49 +0100
From: maximilian attems <max@stro.at>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Michal Marek <mmarek@suse.cz>, Joerg Roedel <joerg.roedel@amd.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild: Fix link to headers in 'make deb-pkg'
Message-ID: <20120204143449.GA28068@stro.at>
Mail-Followup-To: Ben Hutchings <ben@decadent.org.uk>,
	Michal Marek <mmarek@suse.cz>, Joerg Roedel <joerg.roedel@amd.com>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	debian-kernel@lists.debian.org
References: <1327318828-12984-1-git-send-email-joerg.roedel@amd.com>
 <4F1D8810.1040501@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1D8810.1040501@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adding bwh + debian-kernel

On Mon, 23 Jan 2012, Michal Marek wrote:

> (adding max to CC)
> 
> On 23.1.2012 12:40, Joerg Roedel wrote:
> > The Link to the kernel header files in the debian packages
> > point to the original build directory. This is a bad choice
> > if the packages were installed on a different machine. Fix
> > this in by manually re-creating the link in the builddeb
> > script.
> > With this patch applied the lib/modules/$version dir always
> > exists, so move the "$ARCH = um" check out of the modules
> > check too.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  scripts/package/builddeb |   13 +++++++++----
> >  1 files changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> > index f6cbc3d..46f63dc 100644
> > --- a/scripts/package/builddeb
> > +++ b/scripts/package/builddeb
> > @@ -91,6 +91,7 @@ fi
> >  rm -rf "$tmpdir" "$fwdir" "$kernel_headers_dir" "$libc_headers_dir"
> >  mkdir -m 755 -p "$tmpdir/DEBIAN"
> >  mkdir -p  "$tmpdir/lib" "$tmpdir/boot" "$tmpdir/usr/share/doc/$packagename"
> > +mkdir -p  "$tmpdir/lib/modules/$version"
> >  mkdir -m 755 -p "$fwdir/DEBIAN"
> >  mkdir -p "$fwdir/lib" "$fwdir/usr/share/doc/$fwpackagename"
> >  mkdir -m 755 -p "$libc_headers_dir/DEBIAN"
> > @@ -121,10 +122,14 @@ fi
> >  
> >  if grep -q '^CONFIG_MODULES=y' .config ; then
> >  	INSTALL_MOD_PATH="$tmpdir" make KBUILD_SRC= modules_install
> > -	if [ "$ARCH" = "um" ] ; then
> > -		mv "$tmpdir/lib/modules/$version"/* "$tmpdir/usr/lib/uml/modules/$version/"
> > -		rmdir "$tmpdir/lib/modules/$version"
> > -	fi
> > +fi
> > +
> > +# Make sure link to the headers is correct
> > +ln -snf "/usr/src/$kernel_headers_packagename" "$tmpdir/lib/modules/$version/build"
> > +
> > +if [ "$ARCH" = "um" ] ; then
> > +	mv "$tmpdir/lib/modules/$version"/* "$tmpdir/usr/lib/uml/modules/$version/"
> > +	rmdir "$tmpdir/lib/modules/$version"
> >  fi
> >  
> >  make headers_check

I'm a bit sceptical that it is correct, but passing on to Ben Hutchings,
as I never used external modules. He did quite some cleanup in this
confusing area, lately for the upcoming debian release.

-- 
maks
