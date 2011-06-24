Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab1FXNhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:37:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756995Ab1FXNhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:37:42 -0400
Message-ID: <4E049324.2000406@suse.cz>
Date: Fri, 24 Jun 2011 15:37:40 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86, kconfig: Pick up the .config arch version in
 'make oldconfig'
References: <1306707270.2029.377.camel@i7.infradead.org>	 <20110530072300.GA9802@elte.hu>	 <1306745835.2029.389.camel@i7.infradead.org>	 <20110530091536.GA2827@elte.hu> <1306750170.2029.416.camel@i7.infradead.org>
In-Reply-To: <1306750170.2029.416.camel@i7.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.5.2011 12:09, David Woodhouse wrote:
> I wasted a bunch of time today because I'd taken a .config from my
> test machine and tried to build it, and the existing setting of
> CONFIG_X86_32 got changed to the host system's bitness which was
> 64-bit.
>
> This patch fixes that. Last time I tried to fix this bug, I had
> introduced a regression that broke:
>
>     make ARCH=x86_64 randconfig
>     make ARCH=i386 randconfig
>
> type of filtered-randconfig behavior which restricted randconfigs to
> 64-bit and 32-bit configs, respectively.
>
> This version fixes that so prior randconfig behavior is maintained,
> although if a "filtered randconfig" is desired it seems like it would be
> better to actually implement that properly, rather than relying on a
> hack which preserves the obsolete 'ARCH=i386' and 'ARCH=x86_64' legacy
> just to influence *one* of the many config options that might need to be
> hard-coded if you actually want a 'randconfig' that produces a useful
> end-result.
>
> Signed-off-by: David Woodhouse<David.Woodhouse@intel.com>
> Link: http://lkml.kernel.org/r/1306707270.2029.377.camel@i7.infradead.org
>
> ---
> v2: Explicitly turn off CONFIG_64BIT in i386_defconfig. The default for
> CONFIG_64BIT has *changed* (from n to y) for ARCH=x86, so it needs to be
> explicitly turned off or 'make i386_defconfig' will give you 64-bit :)
>
> diff --git a/Makefile b/Makefile
> index 123d858..7b3b7c5 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -165,7 +165,8 @@ export srctree objtree VPATH
>   # then ARCH is assigned, getting whatever value it gets normally, and
>   # SUBARCH is subsequently ignored.
>
> -SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
> +SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
> +				  -e s/sun4u/sparc64/ \
>   				  -e s/arm.*/arm/ -e s/sa110/arm/ \
>   				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
>   				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index cc6c53a..1f206b0 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1,7 +1,7 @@
>   # Select 32 or 64 bit
>   config 64BIT
>   	bool "64-bit kernel" if ARCH = "x86"
> -	default ARCH = "x86_64"
> +	default ARCH != "i386"

This breaks all{mod,yes}config on 32bit and allnoconfig on 64bit (and 
randconfig sometimes :)). The user expectation is that make 
defconfig/allmodconfig/allyesconfig builds a kernel for their 
architecture. You only handle defconfig below.

Michal
