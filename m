Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab0KEMli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 08:41:38 -0400
Received: from vostochny.stro.at ([78.47.22.85]:44442 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab0KEMlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 08:41:35 -0400
Date: Fri, 5 Nov 2010 12:41:32 +0000
From: maximilian attems <max@stro.at>
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild, deb-pkg: select userland architectire based on
	UTS_MACHINE
Message-ID: <20101105124129.GO15146@vostochny.stro.at>
References: <4CD2A8BC.3010500@suse.cz> <1288960361-6407-1-git-send-email-asbjorn@asbjorn.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288960361-6407-1-git-send-email-asbjorn@asbjorn.biz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 12:32:41PM +0000, Asbjoern Sloth Toennesen wrote:
> Instead of creating the debian package for the compiling userland,
> create it for a userland matching the kernel thats being compiled.
> 
> This patch supports all Lenny release architectures,
> and Linux-based architecture candidates for Squeeze.
> 
> If it can't find a proper Debian userspace it displays a warning,
> and fallback to let deb-gencontrol use the host's userspace arch.
> 
> Eg. with this patch the following make command:
> 
> 	make ARCH=i386 deb-pkg
> 
> will output an i386 Debian package instead of an amd64 one,
> when run on an amd64 machine.
> 
> Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>

thank you, indeed very cool.

Acked-by: maximilian attems <max@stro.at>
> ---
>  scripts/package/builddeb |   33 ++++++++++++++++++++++++++++++++-
>  1 files changed, 32 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index 5f1e2fc..1df1cc0 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -25,8 +25,39 @@ create_package() {
>  	chown -R root:root "$pdir"
>  	chmod -R go-w "$pdir"
>  
> +	# Attempt to find the correct Debian architecture
> +	local forcearch="" debarch=""
> +	case "$UTS_MACHINE" in
> +	i386|ia64|alpha|hppa)
> +		debarch="$UTS_MACHINE" ;;

small nitpick parisc* != hppa


> +	x86_64)
> +		debarch=amd64 ;;
> +	sparc*)
> +		debarch=sparc ;;
> +	s390*)
> +		debarch=s390 ;;
> +	ppc*)
> +		debarch=powerpc ;;
> +	mips*)
> +		debarch=mips$(grep -q CPU_LITTLE_ENDIAN=y .config && echo el) ;;
> +	arm*)
> +		debarch=arm$(grep -q CONFIG_AEABI=y .config && echo el) ;;
> +	*)
> +		echo "" >&2
> +		echo "** ** **  WARNING  ** ** **" >&2
> +		echo "" >&2
> +		echo "Your architecture doesn't have it's equivalent" >&2
> +		echo "Debian userspace architecture defined!" >&2
> +		echo "Falling back to using your current userspace instead!" >&2
> +		echo "Please add support for $UTS_MACHINE to ${0} ..." >&2
> +		echo "" >&2
> +	esac
> +	if [ -n "$debarch" ] ; then
> +		forcearch="-DArchitecture=$debarch"
> +	fi
> +
>  	# Create the package
> -	dpkg-gencontrol -isp -p$pname -P"$pdir"
> +	dpkg-gencontrol -isp $forcearch -p$pname -P"$pdir"
>  	dpkg --build "$pdir" ..
>  }
>  
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
