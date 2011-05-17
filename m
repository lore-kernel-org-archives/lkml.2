Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab1EQUN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 16:13:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:52286 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217Ab1EQUNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 16:13:55 -0400
Message-ID: <4DD2D703.4030908@suse.cz>
Date: Tue, 17 May 2011 22:13:55 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Arun Sharma <asharma@fb.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] kbuild: Append RPM release to $KERNELRELEASE
References: <1305653779-3445-1-git-send-email-asharma@fb.com> <1305653779-3445-5-git-send-email-asharma@fb.com>
In-Reply-To: <1305653779-3445-5-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.5.2011 19:36, Arun Sharma wrote:
> Provide the same consistency as distributor kernels.
> uname -r matches RPM name (includes the release)
> 
> Glossary:
> 
> KERNELRELEASE = what users see
> ___KERNELRELEASE = KERNELRELEASE without RPM release
> __KERNELRELEASE = ___KERNELRELEASE with s/-/_/g
> 
> Signed-off-by: Arun Sharma <asharma@fb.com>
> ---
>  Makefile                 |    9 ++++++---
>  scripts/package/Makefile |    2 +-
>  scripts/package/mkspec   |    2 +-
>  3 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 28820f7..90d45f4 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -367,11 +367,14 @@ KBUILD_AFLAGS_MODULE  := -DMODULE
>  KBUILD_CFLAGS_MODULE  := -DMODULE
>  KBUILD_LDFLAGS_MODULE := -T $(srctree)/scripts/module-common.lds
>  
> -# Read KERNELRELEASE from include/config/kernel.release (if it exists)
> -KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
> +# Read ___KERNELRELEASE from include/config/kernel.release (if it exists)
> +___KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
> +# Append the release version only once. 
> +# Note: .version could change during the build.
> +KERNELRELEASE ?= $(___KERNELRELEASE)-$(shell /bin/sh scripts/mkversion)

Please stop decorating the kernel release string for the sake of make
rpm, thanks. If you really want the kernel release string match rpm's
%{version}-%{release}, how about this: Let the user set
CONFIG_LOCALVERSION=-<number> and check in make rpm if $KERNELRELEASE
ends with -<number>. If so, use <number> in the Release: field and the
rest in Version:, otherwise use the same scheme as before. That way, you
won't force a new kernel release numbering scheme on anyone.

Michal
