Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab0JGUIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:08:51 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:44821 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab0JGUIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:08:50 -0400
Date: Thu, 7 Oct 2010 13:09:04 -0700
From: Andres Salomon <dilinger@queued.net>
To: Daniel Drake <dsd@laptop.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OLPC: Add XO-1 poweroff support
Message-ID: <20101007130904.29350df2@debxo>
In-Reply-To: <20101007185952.A36859D401B@zog.reactivated.net>
References: <20101007185952.A36859D401B@zog.reactivated.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Oct 2010 19:59:52 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> Add a pm_power_off handler for the OLPC XO-1 laptop.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  arch/x86/Kconfig           |    6 ++
>  arch/x86/kernel/Makefile   |    1 +
>  arch/x86/kernel/olpc-xo1.c |  112
> ++++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 119
> insertions(+), 0 deletions(-) create mode 100644
> arch/x86/kernel/olpc-xo1.c
> 
> The new olpc-xo1.c file will also be used for further functionality
> (suspend/resume, lid switch device, etc); patches to be submitted
> shortly after the review/merge of this one.
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index cea0cd9..19e6439 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2065,6 +2065,12 @@ config OLPC
>  	  Add support for detecting the unique features of the OLPC
>  	  XO hardware.
>  
> +config OLPC_XO1
> +	bool "OLPC XO-1 support"

Any particular reason why this can't be modular?

[...]
> +
> +	pm_power_off = xo1_power_off;
> +

If this were to be modular, I'm not sure what the best option is for
pm_power_off.  If the old value was saved upon module load, and
restored upon module unload, I could imagine races like the following:

module A load:
  saved_ppo = pm_power_off; /* NULL */
  pm_power_off = frob;
module B load:
  old_ppo = pm_power_off; /* frob */
  pm_power_off = foo;
module A unload:
  pm_power_off = saved_ppo; /* NULL */


So I guess just clobbering whatever's in pm_power_off and setting back
to NULL upon unload, with the assumption that driver's only really
going to clobber it in the case of actual OLPC hardware, and the
callbacks being clobbered wouldn't really have done the correct thing
anyways?



> +	printk(KERN_INFO "OLPC XO-1 support registered\n");
> +	return 0;
> +}
> +device_initcall(olpc_xo1_init);
> +
