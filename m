Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab1AZWtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 17:49:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753608Ab1AZWt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 17:49:29 -0500
Date: Wed, 26 Jan 2011 14:49:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, olofj@chromium.org
Subject: Re: [PATCH] printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
Message-Id: <20110126144910.ce0646ec.akpm@linux-foundation.org>
In-Reply-To: <20110125235700.GR8008@google.com>
References: <20110125235700.GR8008@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 15:57:00 -0800
Mandeep Singh Baines <msb@chromium.org> wrote:

> We've been burned by regressions/bugs which we later realized could
> have been triaged quicker if only we'd paid closer attention to
> dmesg. To make it easier to audit dmesg, we'd like to make
> DEFAULT_MESSAGE_LEVEL Kconfig-settable. That way we can set it to
> KERN_NOTICE and audit any messages <= KERN_WARNING.
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> ---
>  kernel/printk.c   |    2 +-
>  lib/Kconfig.debug |   12 ++++++++++++
>  2 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 5ddd291..f91a7fd 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -59,7 +59,7 @@ void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
>  #define __LOG_BUF_LEN	(1 << CONFIG_LOG_BUF_SHIFT)
>  
>  /* printk's without a loglevel use this.. */
> -#define DEFAULT_MESSAGE_LOGLEVEL 4 /* KERN_WARNING */
> +#define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
>  
>  /* We show everything that is MORE important than this.. */
>  #define MINIMUM_CONSOLE_LOGLEVEL 1 /* Minimum loglevel we let people use */
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 28b42b9..67b42fa 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -9,6 +9,18 @@ config PRINTK_TIME
>  	  operations.  This is useful for identifying long delays
>  	  in kernel startup.
>  
> +config DEFAULT_MESSAGE_LOGLEVEL
> +	int "Default message log level (1-7)"
> +	range 1 7
> +	depends on PRINTK
> +	default "4"
> +	help
> +	  Default log level for printk statements with no specified priority.
> +
> +	  This was hard-coded to KERN_WARNING since at least 2.6.10 but folks
> +	  that are auditing their logs closely may want to set it to a lower
> +	  priority.
> +
>  config ENABLE_WARN_DEPRECATED
>  	bool "Enable __deprecated logic"
>  	default y

I'm a bit surprised that this wasn't already tunable at boot-time
and/or at runtime.

I think it's generally superior to be able to tune this sort of thing
via kernel boot parameters and/or /proc knobs, rather than requiring a
recompile.  That might be a problem in this specific case, if we have
printks which are occurring before __setup() parsing has completed.


Poeple often complain that they want things settable in Kconfig because
for some reason it's all too hard to set the kernel boot command line. 
Next time someone says this I'll suggest that they fix the problem
permanently by implementing a CONFIG_CMDLINE string, which gets
inserted into the kernel boot command line at compile time ;)

