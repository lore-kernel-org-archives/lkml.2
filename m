Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab1FFSQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:16:16 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64030 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab1FFSQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:16:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vr32j/46m3XeE/wMBoiZAO5TF01weGmfumzgXgMXojoqOKtKwtg2iialR/SFRxhEWg
         nC+OLtHARZtYFqyfE5KQZY8fk37G1HURLeTVQL0dp/mzL21zMvnDtaTBHLsYE5O7pzW1
         DVb3FJkjTtM8LhSUw3hGGJmgoCGDCcQTyhSjA=
Date: Mon, 6 Jun 2011 20:16:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to
 unhide debug options
Message-ID: <20110606181606.GB7862@somewhere>
References: <20110605210223.GA7595@leaf>
 <20110606151832.GI30348@elte.hu>
 <20110606165130.GA1844@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606165130.GA1844@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 09:51:30AM -0700, Josh Triplett wrote:
> Several debugging options currently default to y, such as
> CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_RODATA.  Embedded users might
> want to turn those options off to save space; however, turning them off
> requires turning on CONFIG_DEBUG_KERNEL to unhide them.  Since
> CONFIG_DEBUG_KERNEL exists specifically to unhide debugging options, and
> CONFIG_EXPERT exists specifically to unhide options potentially needed
> by experts and/or embedded users, make CONFIG_EXPERT automatically imply
> CONFIG_DEBUG_KERNEL.
> 
> Change various debugging options to only reference DEBUG_KERNEL, not
> EXPERT.

Ok, so ideally this should have been done in two patches. They are both
different logical changes that don't imply the same.

v2 was fine, and should be an independent change.

But some comment on what was added in this v3 below:

> 
> Note that DEBUG_MEMORY_INIT defaulted to !EXPERT, which seemed wrong,
> since EXPERT should not directly affect anything except the availability
> of other options.  (And EXPERT definitely shouldn't mean "implicitly
> turn off default safety features".)  Change it to default to y, which
> means that turning on EXPERT does not automatically disable it, but will
> provide the option to disable it.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
> 
> v3: Changed other debugging options to stop referencing EXPERT.
> 
>  arch/tile/Kconfig.debug |    2 +-
>  init/Kconfig            |    2 ++
>  lib/Kconfig.debug       |    6 +++---
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/tile/Kconfig.debug b/arch/tile/Kconfig.debug
> index ddbfc33..afc9cf3 100644
> --- a/arch/tile/Kconfig.debug
> +++ b/arch/tile/Kconfig.debug
> @@ -3,7 +3,7 @@ menu "Kernel hacking"
>  source "lib/Kconfig.debug"
>  
>  config EARLY_PRINTK
> -	bool "Early printk" if EXPERT && DEBUG_KERNEL
> +	bool "Early printk" if DEBUG_KERNEL
>  	default y

I don't understand why early_printk is default y. But that's debatable,
we may want to have any user able to run a raw vga console for debugging
requests.

Either:

- if we consider it's very important and mandatory, let's keep it "if EXPERT"
and default y.

- if we consider it's only used by kernel developers, it should be off by
default and depend on DEBUG_KERNEL only.

>  	help
>  	  Write kernel log output directly via the hypervisor console.
> diff --git a/init/Kconfig b/init/Kconfig
> index ebafac4..14370d3 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -909,6 +909,8 @@ config ANON_INODES
>  
>  menuconfig EXPERT
>  	bool "Configure standard kernel features (expert users)"
> +	# Unhide debug options, to make the on-by-default options visible
> +	select DEBUG_KERNEL
>  	help
>  	  This option allows certain base kernel options and settings
>            to be disabled or tweaked. This is for specialized
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index dd373c8..b121413 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -694,7 +694,7 @@ config DEBUG_HIGHMEM
>  	  Disable for production systems.
>  
>  config DEBUG_BUGVERBOSE
> -	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
> +	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL

I believe this should not be changed, let keep it how it is, or change to
"if EXPERT" because EXPERT selects DEBUG_KERNEL anyway.

There are no good reason to disable this option, except for some embedded
system perhaps, so EXPERT still make sense here. 

Thanks.
