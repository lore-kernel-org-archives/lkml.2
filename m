Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab2IGTU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:20:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56425 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2IGTUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:20:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 07/31] arm64: Process management
Date: Fri, 7 Sep 2012 19:20:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-8-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-8-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071920.17355.arnd@arndb.de>
X-Provags-ID: V02:K0:eGwCt88xoBpnl3/o9igPmV2AdZdqoc9RJU7ozqnYckQ
 ITsV8ESp1i2+2UyljrD+CIXx96arSrQjY1GDd9jj0H5DigfQTE
 wZLmIwbSLjEMFe/ZgsgTxhq+nKWYotxDFWRX6vJnVx5buMATeM
 WJ+xTJdzgUbBG66TCJ7KCu6/IomJWyNJGFhAaUfCBg6MqfBSPc
 Nf4rFh3geFvBME9PCvxK2N4nszr7rsfULtIFaIb6Vt/JefZ7fo
 LNhNNPZSn9c8CwOvGlrYcB9I57NLvVfxZO8u+FDveuMTqE3Vt1
 trLUKzTEuHtlgGs2Od6LJ/cf5dsLUqIUrAHS7222Dpal0yyhAH
 Mu2eO9QiXd14e+HWxL4Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> The patch adds support for thread creation and context switching. The
> context switching CPU specific code is introduced with the CPU support
> patch (part of the arch/arm64/mm/proc.S file). AArch64 supports
> ASID-tagged TLBs and the ASID can be either 8 or 16-bit wide (detectable
> via the ID_AA64AFR0_EL1 register).
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>


But please fix a few small issues in process.c:

> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> new file mode 100644
> index 0000000..6dfd96f
> --- /dev/null
> +++ b/arch/arm64/kernel/process.c

> +
> +extern void setup_mm_for_reboot(void);

No extern declarations in .c files, put it in a header file instead.


> +
> +/*
> + * Function pointers to optional machine specific functions
> + */
> +void (*pm_power_off)(void);
> +EXPORT_SYMBOL(pm_power_off);
> +
> +void (*pm_restart)(const char *cmd);
> +EXPORT_SYMBOL_GPL(pm_restart);
> +
>
> +void (*pm_idle)(void) = default_idle;
> +EXPORT_SYMBOL(pm_idle);

I'd make them all EXPORT_SYMBOL_GPL. External modules have no business overriding them.

> +	/*
> +	 * Whoops - the architecture was unable to reboot.
> +	 * Tell the user!
> +	 */
> +	mdelay(1000);
> +	printk("Reboot failed -- System halted\n");
> +	while (1);

This delay seems pointless.


	Arnd
