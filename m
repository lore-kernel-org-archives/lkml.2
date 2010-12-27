Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab0L0UnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 15:43:13 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:49065 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab0L0UnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 15:43:12 -0500
Date: Mon, 27 Dec 2010 21:43:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Tejun Heo <tj@kernel.org>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, eric.dumazet@gmail.com,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH RESEND percpu#for-next] percpu: align percpu readmostly
	subsection to cacheline
Message-ID: <20101227204309.GA3878@merkur.ravnborg.org>
References: <20101227133719.GD488@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101227133719.GD488@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 02:37:19PM +0100, Tejun Heo wrote:
> Currently percpu readmostly subsection may share cachelines with other
> percpu subsections which may result in unnecessary cacheline bounce
> and performance degradation.
> 
> This patch adds @cacheline parameter to PERCPU() and PERCPU_VADDR()
> linker macros, makes each arch linker scripts specify its cacheline
> size and use it to align percpu subsections.
> 
> This is based on Shaohua's x86 only patch.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Shaohua Li <shaohua.li@intel.com>
> ---
> Shaohua, can you please verify this achieves the same result?  If no
> one objects, I'll route it through the percpu tree.
> 
> Thanks.
> 
> (arch ML address was wrong, resending with the correct one)
> 
>  arch/alpha/kernel/vmlinux.lds.S    |    2 +-
>  arch/arm/kernel/vmlinux.lds.S      |    2 +-
>  arch/blackfin/kernel/vmlinux.lds.S |    2 +-
>  arch/cris/kernel/vmlinux.lds.S     |    2 +-
>  arch/frv/kernel/vmlinux.lds.S      |    2 +-
>  arch/ia64/kernel/vmlinux.lds.S     |    2 +-
>  arch/m32r/kernel/vmlinux.lds.S     |    2 +-
>  arch/mips/kernel/vmlinux.lds.S     |    2 +-
>  arch/mn10300/kernel/vmlinux.lds.S  |    2 +-
>  arch/parisc/kernel/vmlinux.lds.S   |    2 +-
>  arch/powerpc/kernel/vmlinux.lds.S  |    2 +-
>  arch/s390/kernel/vmlinux.lds.S     |    2 +-
>  arch/sh/kernel/vmlinux.lds.S       |    2 +-
>  arch/sparc/kernel/vmlinux.lds.S    |    2 +-
>  arch/tile/kernel/vmlinux.lds.S     |    2 +-
>  arch/um/include/asm/common.lds.S   |    2 +-
>  arch/x86/kernel/vmlinux.lds.S      |    4 ++--
>  arch/xtensa/kernel/vmlinux.lds.S   |    2 +-
>  include/asm-generic/vmlinux.lds.h  |   35 ++++++++++++++++++++++-------------
>  19 files changed, 41 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
> index 003ef4c..173518f 100644
> --- a/arch/alpha/kernel/vmlinux.lds.S
> +++ b/arch/alpha/kernel/vmlinux.lds.S
> @@ -38,7 +38,7 @@ SECTIONS
>  	__init_begin = ALIGN(PAGE_SIZE);
>  	INIT_TEXT_SECTION(PAGE_SIZE)
>  	INIT_DATA_SECTION(16)
> -	PERCPU(PAGE_SIZE)
> +	PERCPU(64, PAGE_SIZE)
>  	/* Align to THREAD_SIZE rather than PAGE_SIZE here so any padding page
>  	   needed for the THREAD_SIZE aligned init_task gets freed after init */
>  	. = ALIGN(THREAD_SIZE);

It would have been better to include cache.h and then use L1_CACHE_BYTES,
as the value differs for EV4.
It will work with 64 as this is the bigger of the two.

It looks like we could do this for almost all archs.
But then I am not sure if "L1_CACHE_BYTES" is the same as
a cacheline on the different archs.

	Sam
