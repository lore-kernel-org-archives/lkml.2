Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab0GNPXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:23:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab0GNPW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:22:59 -0400
Message-ID: <4C3DD64B.10109@suse.cz>
Date: Wed, 14 Jul 2010 17:22:51 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        ak@linux.intel.com
Subject: Re: [PATCH] Kbuild: Add option to set -femit-struct-debug-baseonly
References: <20100714134352.GA10341@basil.fritz.box>
In-Reply-To: <20100714134352.GA10341@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 03:43 PM, Andi Kleen wrote:
> Kbuild: Add option to set -femit-struct-debug-baseonly 
> 
> Newer gcc has a -femit-struct-debug-baseonly option that dramatically
> reduces the size of object files with debug info. What it does
> is to only emit type information for structures when the structures
> are defined in the same file or in a header file.
> 
> This means the type information for most headers are not included.
> This is not good when the type information is actually
> needed (e.g. with kgdb or systemtap) 
> 
> But often kernel hackers only care about line numbers and don't
> need all the type information anyways. In this case setting
> the option can be a big win:
> 
> A build dir for a specific x86-64 configuration with gcc 4.5
> shrunk from 2.3G to 1.2G. The compilation was also nearly a minute
> faster.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  Makefile          |    4 ++++
>  lib/Kconfig.debug |   12 ++++++++++++
>  2 files changed, 16 insertions(+)
> 
> Index: linux-2.6.34-ak/Makefile
> ===================================================================
> --- linux-2.6.34-ak.orig/Makefile
> +++ linux-2.6.34-ak/Makefile
> @@ -554,6 +554,10 @@ KBUILD_CFLAGS	+= -g
>  KBUILD_AFLAGS	+= -gdwarf-2
>  endif
>  
> +ifdef CONFIG_DEBUG_INFO_REDUCED
> +KBUILD_CFLAGS 	+= $(call cc-option, -femit-struct-debug-baseonly)
> +endif
> +
>  ifdef CONFIG_FUNCTION_TRACER
>  KBUILD_CFLAGS	+= -pg
>  endif
> Index: linux-2.6.34-ak/lib/Kconfig.debug
> ===================================================================
> --- linux-2.6.34-ak.orig/lib/Kconfig.debug
> +++ linux-2.6.34-ak/lib/Kconfig.debug
> @@ -616,6 +616,18 @@ config DEBUG_INFO
>  
>  	  If unsure, say N.
>  
> +config DEBUG_INFO_REDUCED
> +	bool "Reduce debugging information"
> +	depends on DEBUG_INFO
> +	help
> +	  If you say Y here gcc is instructed to generate less debugging information
> +          for structure types. This means that tools that need full debugging information
> +          (like kgdb or systemtap) won't be happy. But if you merely need debugging
> +          information to resolve line numbers there is no loss.
> +          Advantage is that build directory object sizes shrink dramatically over
> +          a full DEBUG_INFO build and compile times are reduced too.
> +          Only works with newer gcc versions.
> +

I reformatted this help text to not wrap in a 80-column terminal and
applied the patch to the kbuild tree.

thanks,
Michal
