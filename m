Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab2AWQRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:17:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab2AWQRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:17:22 -0500
Message-ID: <4F1D8810.1040501@suse.cz>
Date: Mon, 23 Jan 2012 17:17:20 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        maximilian attems <max@stro.at>
Subject: Re: [PATCH] kbuild: Fix link to headers in 'make deb-pkg'
References: <1327318828-12984-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1327318828-12984-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding max to CC)

On 23.1.2012 12:40, Joerg Roedel wrote:
> The Link to the kernel header files in the debian packages
> point to the original build directory. This is a bad choice
> if the packages were installed on a different machine. Fix
> this in by manually re-creating the link in the builddeb
> script.
> With this patch applied the lib/modules/$version dir always
> exists, so move the "$ARCH = um" check out of the modules
> check too.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  scripts/package/builddeb |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index f6cbc3d..46f63dc 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -91,6 +91,7 @@ fi
>  rm -rf "$tmpdir" "$fwdir" "$kernel_headers_dir" "$libc_headers_dir"
>  mkdir -m 755 -p "$tmpdir/DEBIAN"
>  mkdir -p  "$tmpdir/lib" "$tmpdir/boot" "$tmpdir/usr/share/doc/$packagename"
> +mkdir -p  "$tmpdir/lib/modules/$version"
>  mkdir -m 755 -p "$fwdir/DEBIAN"
>  mkdir -p "$fwdir/lib" "$fwdir/usr/share/doc/$fwpackagename"
>  mkdir -m 755 -p "$libc_headers_dir/DEBIAN"
> @@ -121,10 +122,14 @@ fi
>  
>  if grep -q '^CONFIG_MODULES=y' .config ; then
>  	INSTALL_MOD_PATH="$tmpdir" make KBUILD_SRC= modules_install
> -	if [ "$ARCH" = "um" ] ; then
> -		mv "$tmpdir/lib/modules/$version"/* "$tmpdir/usr/lib/uml/modules/$version/"
> -		rmdir "$tmpdir/lib/modules/$version"
> -	fi
> +fi
> +
> +# Make sure link to the headers is correct
> +ln -snf "/usr/src/$kernel_headers_packagename" "$tmpdir/lib/modules/$version/build"
> +
> +if [ "$ARCH" = "um" ] ; then
> +	mv "$tmpdir/lib/modules/$version"/* "$tmpdir/usr/lib/uml/modules/$version/"
> +	rmdir "$tmpdir/lib/modules/$version"
>  fi
>  
>  make headers_check

