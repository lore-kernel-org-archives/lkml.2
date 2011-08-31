Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab1HaEXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 00:23:53 -0400
Received: from ozlabs.org ([203.10.76.45]:58069 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab1HaEXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 00:23:51 -0400
Date: Wed, 31 Aug 2011 14:23:48 +1000
From: Anton Blanchard <anton@samba.org>
To: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Milton Miller <miltonm@bga.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC PATCH 05/10] fadump: Convert firmware-assisted cpu state
 dump data into elf notes.
Message-ID: <20110831142348.7ef28a18@kryten>
In-Reply-To: <20110713180722.6210.20251.stgit@mars.in.ibm.com>
References: <20110713180252.6210.34810.stgit@mars.in.ibm.com>
	<20110713180722.6210.20251.stgit@mars.in.ibm.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> diff --git a/kernel/panic.c b/kernel/panic.c
> index 6923167..1965b50 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -49,6 +49,15 @@ static long no_blink(int state)
>  long (*panic_blink)(int state);
>  EXPORT_SYMBOL(panic_blink);
>  
> +#ifdef CONFIG_FA_DUMP
> +/*
> + * provide an empty default implementation here -- architecture
> + * code may override this
> + */
> +void __attribute__ ((weak)) crash_fadump(struct pt_regs *regs, const char *str)
> +{}
> +#endif
> +
>  /**
>   *	panic - halt the system
>   *	@fmt: The text string to print
> @@ -81,6 +90,13 @@ NORET_TYPE void panic(const char * fmt, ...)
>  	dump_stack();
>  #endif
>  
> +#ifdef CONFIG_FA_DUMP
> +	/*
> +	 * If firmware-assisted dump has been registered then trigger
> +	 * firmware-assisted dump and let firmware handle everything else.
> +	 */
> +	crash_fadump(NULL, buf);
> +#endif
>  	/*
>  	 * If we have crashed and we have a crash kernel loaded let it handle
>  	 * everything else.

Firmware assisted dump is an IBM POWER Systems specific feature and it
shouldn't leak into a common file like this. Isn't there an existing
hook we can catch like the panic notifier?

Anton
