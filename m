Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab2JQVMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 17:12:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34826 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757853Ab2JQVMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 17:12:05 -0400
Message-ID: <507F1F21.8040206@ti.com>
Date: Wed, 17 Oct 2012 16:12:01 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>,
        Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: discrepancy while save and restore of debounce registers
References: <1BAFE6F6C881BF42822005164F1491C33EAA9A7C@DBDE01.ent.ti.com>
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EAA9A7C@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.112.54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gururaja,

On 10/17/2012 01:13 AM, Hebbar, Gururaja wrote:
> Hi,
> 
> I came across a peculiar issue while updating GPIO debounce registers on
> OMAP platform.
> 
> According to mainline commit ae547354a8ed59f19b57f7e1de9c7816edfc3537
> 
> gpio/omap: save and restore debounce registers
> 
> GPIO debounce registers need to be saved and restored for proper functioning
> of driver.
> 
> ...
> @@ -1363,6 +1369,12 @@ static void omap_gpio_restore_context(struct gpio_bank *bank)
>         __raw_writel(bank->context.fallingdetect,
>                                 bank->base + bank->regs->fallingdetect);
>         __raw_writel(bank->context.dataout, bank->base + bank->regs->dataout);
> +       if (bank->dbck_enable_mask) {
> +               __raw_writel(bank->context.debounce, bank->base +
> +                                       bank->regs->debounce);
> +               __raw_writel(bank->context.debounce_en,
> +                                       bank->base + bank->regs->debounce_en);
> +       }
>  }
> 
> 
> Due to copy/paste of this commit into my local tree, I missed the check for 
> bank->dbck_enable_mask, and directly restored the saved value from context.
> 
> After this, I saw random crashes when accessing different registers (sometimes
> its OE register and sometime its DATAOUT register). 
> 
> These crashes were seen across 2nd and subsequent suspend/resume.
> 
> My doubt/questions are
> 1. Why should debounce registers be updated only when it's accessed previously?

If debounce is not being used by any of the gpios, then there is no need
to restore them as there are no bits set. So this makes sense and saves
a couple register writes.

> 2. What is the relation between updating debounce registers and crash seen on
> others registers? 

This I am not sure about. I gave this a quick try on my omap3430 beagle
board, but I did not see any side-effects from doing this. However, if
you are always restoring the debounce context regardless of whether
debounce is being used, then you could be writing bad values to the
debounce registers as the context variables bank->context.debouce and
bank->context.debouce_en may not initialised. So that is bad. However,
that said I am still not sure how this could cause a crash.

Can you share more details on ...
1. The OMAP platform you are using?
2. What linux distro/environment you are using?
3. If there are any specific steps to reproduce this 100% of the time?

Cheers
Jon
