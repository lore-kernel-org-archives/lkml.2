Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab0KJW20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:28:26 -0500
Received: from www.tglx.de ([62.245.132.106]:44162 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757118Ab0KJW2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:28:25 -0500
Date: Wed, 10 Nov 2010 23:28:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@mit.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improve clocksource unstable warning
In-Reply-To: <80b5a10ac1a6ef51afca3c113b624bf1b5049452.1289427381.git.luto@mit.edu>
Message-ID: <alpine.LFD.2.00.1011102327050.2900@localhost6.localdomain6>
References: <80b5a10ac1a6ef51afca3c113b624bf1b5049452.1289427381.git.luto@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010, Andy Lutomirski wrote:

> When the system goes out to lunch for a long time, the clocksource
> watchdog might get false positives.  Clarify the warning so that
> people stop blaming their system freezes on the timing code.
> 
> This change was Thomas Gleixner's suggestion.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> ---
> I've only compile-tested on 2.6.36, but it applies cleanly to Linus' tree
> and it's rather trivial.
> 
>  kernel/time/clocksource.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index c18d7ef..5b30aa2 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -215,8 +215,10 @@ static void __clocksource_unstable(struct clocksource *cs)
>  
>  static void clocksource_unstable(struct clocksource *cs, int64_t delta)
>  {
> -	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
> -	       cs->name, delta);
> +	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)%s\n",
> +	       cs->name, delta,
> +	       delta < -5000000000LL ?

I'm ok with that change, but we should not hard code the
delta. Instead we should look at the wrap around time of the
clocksource which we use for reference.

> +		 " or your system lagged for other reasons" : "");
>  	__clocksource_unstable(cs);
>  }

Thanks,

	tglx
