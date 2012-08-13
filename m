Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab2HMVbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 17:31:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19735 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2HMVbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 17:31:34 -0400
Date: Mon, 13 Aug 2012 17:21:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thai Bui <blquythai@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] boot: Put initcall_debug into its own Kconfig option
 DEBUG_INITCALL
Message-ID: <20120813212151.GA15429@phenom.dumpdata.com>
References: <n>
 <1344891431-30869-1-git-send-email-blquythai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344891431-30869-1-git-send-email-blquythai@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 01:57:11PM -0700, Thai Bui wrote:
> Putting DEBUG_INITCALL config option to compile out the command-line option
> "initcall_debug".

Can you explain the benfits of this please?
> 
> Signed-off-by: Thai Bui <blquythai@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  Documentation/kernel-parameters.txt |    3 ++-
>  include/linux/init.h                |    4 ++++
>  init/main.c                         |    2 ++
>  lib/Kconfig.debug                   |    9 +++++++++
>  4 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index d99fd9c..3dbaf15 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1026,7 +1026,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  	initcall_debug	[KNL] Trace initcalls as they are executed.  Useful
>  			for working out where the kernel is dying during
> -			startup.
> +			startup. DEBUG_INITCALL needs to be enabled in order
> +			for this option to work.
>  
>  	initrd=		[BOOT] Specify the location of the initial ramdisk
>  
> diff --git a/include/linux/init.h b/include/linux/init.h
> index 6b95109..d2f31f1 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -157,7 +157,11 @@ void prepare_namespace(void);
>  
>  extern void (*late_time_init)(void);
>  
> +#ifdef CONFIG_DEBUG_INITCALL
>  extern bool initcall_debug;
> +#else
> +static const bool initcall_debug = false;
> +#endif /* CONFIG_DEBUG_INITCALL */
>  
>  #endif
>    
> diff --git a/init/main.c b/init/main.c
> index ff49a6d..65837f7 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -648,8 +648,10 @@ static void __init do_ctors(void)
>  #endif
>  }
>  
> +#ifdef CONFIG_DEBUG_INITCALL
>  bool initcall_debug;
>  core_param(initcall_debug, initcall_debug, bool, 0644);
> +#endif /* CONFIG_DEBUG_INITCALL */
>  
>  static char msgbuf[64];
>  
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 8745ac7..424ac93 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -769,6 +769,15 @@ config DEBUG_WRITECOUNT
>  
>  	  If unsure, say N.
>  
> +config DEBUG_INITCALL
> +	bool "Debug initcalls as they are executed"
> +	depends on DEBUG_KERNEL
> +	help
> +	  Enable this for tracing initcalls during startup. Useful for working
> +	  out where the kernel is dying during startup.
> +
> +	  If unsure, say N
> +
>  config DEBUG_MEMORY_INIT
>  	bool "Debug memory initialisation" if EXPERT
>  	default !EXPERT
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
