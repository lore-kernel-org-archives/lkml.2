Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543Ab2EXWG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:06:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:59017 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab2EXWGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:06:55 -0400
Date: Fri, 25 May 2012 00:06:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Beulich <JBeulich@suse.com>
cc: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: clear HPET configuration registers on startup
In-Reply-To: <4F79D0BB020000780007C02D@nat28.tlf.novell.com>
Message-ID: <alpine.LFD.2.02.1205242352460.3231@ionos>
References: <4F79D0BB020000780007C02D@nat28.tlf.novell.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2012, Jan Beulich wrote:

Sorry for ignoring this for so long.

> +	cfg = hpet_readl(HPET_CFG);
> +	hpet_boot_cfg = kmalloc((last + 2) * sizeof(*hpet_boot_cfg),
> +				GFP_KERNEL);
> +	if (hpet_boot_cfg)
> +		*hpet_boot_cfg = cfg;
> +	else
> +		pr_warn("HPET initial state will not be saved\n");
> +	cfg &= ~(HPET_CFG_ENABLE | HPET_CFG_LEGACY);
> +	hpet_writel(cfg, HPET_Tn_CFG(i));

This wants to be  

> +	hpet_writel(cfg, HPET_CFG);

Right ?

You would have noticed if that code would have run on an AMD SB700
based machine and i would have been != 0 :)

> +	if (cfg)
> +		pr_warn("HPET: Unrecognized bits %#x set in global cfg\n",
> +			cfg);
> +
> +	for (i = 0; i <= last; ++i) {
> +		cfg = hpet_readl(HPET_Tn_CFG(i));
> +		if (hpet_boot_cfg)
> +			hpet_boot_cfg[i + 1] = cfg;
> +		cfg &= ~(HPET_TN_ENABLE | HPET_TN_LEVEL | HPET_TN_FSB);
> +		hpet_writel(cfg, HPET_Tn_CFG(i));
> +		cfg &= ~(HPET_TN_PERIODIC | HPET_TN_PERIODIC_CAP
> +			 | HPET_TN_64BIT_CAP | HPET_TN_32BIT | HPET_TN_ROUTE
> +			 | HPET_TN_FSB | HPET_TN_FSB_CAP);
> +		if (cfg)
> +			pr_warn("HPET: Unrecognized bits %#x set in cfg#%u\n",
> +				cfg, i);
> +	}
> +	hpet_print_config();
> +
>  	if (hpet_clocksource_register())
>  		goto out_nohpet;
>  
> @@ -923,14 +952,28 @@ fs_initcall(hpet_late_init);
>  void hpet_disable(void)
>  {
>  	if (is_hpet_capable() && hpet_virt_address) {
> -		unsigned int cfg = hpet_readl(HPET_CFG);
> +		unsigned int cfg = hpet_readl(HPET_CFG), id, last;
>  
> -		if (hpet_legacy_int_enabled) {
> +		if (hpet_boot_cfg)
> +			cfg = *hpet_boot_cfg;

That restores the setting which you recorded at init time. Why do you
want to do that? There is no point to restore to an eventually borked
state. If we shut down the thing, then we better leave it in a
consistent state rather than something dubious, really.

Thanks,

	tglx
