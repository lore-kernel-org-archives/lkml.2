Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab2FVOZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:25:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65456 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab2FVOZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:25:05 -0400
Date: Fri, 22 Jun 2012 16:24:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        joe@perches.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cleanups] x86/early_printk: Replace obsolete
 simple_strtoul() usage with kstrtoint()
Message-ID: <20120622142456.GA24850@gmail.com>
References: <1338424803.3569.5.camel@lorien2>
 <tip-fbd24153c48b8425b09c161a020483cd77da870e@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-fbd24153c48b8425b09c161a020483cd77da870e@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Shuah Khan <shuahkhan@gmail.com> wrote:

> Commit-ID:  fbd24153c48b8425b09c161a020483cd77da870e
> Gitweb:     http://git.kernel.org/tip/fbd24153c48b8425b09c161a020483cd77da870e
> Author:     Shuah Khan <shuahkhan@gmail.com>
> AuthorDate: Wed, 30 May 2012 18:40:03 -0600
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 6 Jun 2012 11:44:22 +0200
> 
> x86/early_printk: Replace obsolete simple_strtoul() usage with kstrtoint()
> 
> Change early_serial_init() to call kstrtoul() instead of calling
> obsoleted simple_strtoul().
> 
> Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
> Cc: Joe Perches <joe@perches.com>
> Link: http://lkml.kernel.org/r/1338424803.3569.5.camel@lorien2
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kernel/early_printk.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
> index 9b9f18b..5e47712 100644
> --- a/arch/x86/kernel/early_printk.c
> +++ b/arch/x86/kernel/early_printk.c
> @@ -119,7 +119,7 @@ static __init void early_serial_init(char *s)
>  	unsigned char c;
>  	unsigned divisor;
>  	unsigned baud = DEFAULT_BAUD;
> -	char *e;
> +	ssize_t ret;
>  
>  	if (*s == ',')
>  		++s;
> @@ -127,14 +127,14 @@ static __init void early_serial_init(char *s)
>  	if (*s) {
>  		unsigned port;
>  		if (!strncmp(s, "0x", 2)) {
> -			early_serial_base = simple_strtoul(s, &e, 16);
> +			ret = kstrtoint(s, 16, &early_serial_base);
>  		} else {
>  			static const int __initconst bases[] = { 0x3f8, 0x2f8 };
>  
>  			if (!strncmp(s, "ttyS", 4))
>  				s += 4;
> -			port = simple_strtoul(s, &e, 10);
> -			if (port > 1 || s == e)
> +			ret = kstrtouint(s, 10, &port);
> +			if (ret || port > 1)
>  				port = 0;
>  			early_serial_base = bases[port];
>  		}
> @@ -149,8 +149,8 @@ static __init void early_serial_init(char *s)
>  	outb(0x3, early_serial_base + MCR);	/* DTR + RTS */
>  
>  	if (*s) {
> -		baud = simple_strtoul(s, &e, 0);
> -		if (baud == 0 || s == e)
> +		ret = kstrtouint(s, 0, &baud);
> +		if (ret || baud == 0)
>  			baud = DEFAULT_BAUD;
>  	}

This commit is quite buggy: kstrto*int() can return an error but 
it's not checked in every path above. simple_strtoul() on the 
other hand could not fail, so this patch subtly intruduces new 
failure modes.

I'm dropping this patch.

Thanks,

	Ingo
