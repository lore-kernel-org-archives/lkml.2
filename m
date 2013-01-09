Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab3AIQJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:09:28 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:41750 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab3AIQJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:09:26 -0500
Date: Wed, 9 Jan 2013 11:09:23 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] Proposed removal of IS_ERR_OR_NULL() (was: Re: [PATCH
 1/4] gpiolib: introduce descriptor-based GPIO interface)
In-Reply-To: <20130109155154.GN3931@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1301091058070.6300@xanadu.home>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <201301081259.29839.arnd@arndb.de> <CAAVeFu+4VbCbj9TaeMm+NMDJ9_M4-j4O0ONF7Yh_un63wS38+Q@mail.gmail.com> <201301091035.23206.arnd@arndb.de> <20130109104414.GF3931@n2100.arm.linux.org.uk>
 <20130109111055.GG3931@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1301090932400.6300@xanadu.home> <20130109150427.GL3931@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1301091020580.6300@xanadu.home> <20130109155154.GN3931@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2013, Russell King - ARM Linux wrote:

> On Wed, Jan 09, 2013 at 10:27:53AM -0500, Nicolas Pitre wrote:
> > Anyone with good coccinelle skills around to deal with the users?
> 
> I'm not sure that's a solution.

Well, I was thinking that coccinelle could handle the majority of the 
354 users when the "fix" is obvious enough to be automated.

That said, if we want people to fix their code, it is probably necessary 
to merge your patch right away so the warnings are actually being seen, 
and revert it right before the final v3.8 release if the remaining 
warnings are still too numerous.  Repeat with next cycle.

> For example:
> 
>         err = gpio_request(en_vdd_1v05, "EN_VDD_1V05");
>         if (err) {
>                 pr_err("%s: gpio_request failed: %d\n", __func__, err);   
>                 return err;   
>         }
> ...
>         regulator = regulator_get(NULL, "vdd_ldo0,vddio_pex_clk");
>         if (IS_ERR_OR_NULL(regulator)) {
>                 pr_err("%s: regulator_get failed: %d\n", __func__,
>                        (int)PTR_ERR(regulator));
>                 goto err_reg;
>         }
> 
>         regulator_enable(regulator);
> 
>         err = tegra_pcie_init(true, true);
> ...
> err_reg:
>         gpio_free(en_vdd_1v05);
>                 
>         return err;
> }
> 
> Now, regulator_get() returns error-pointers for real errors when it's
> configured in.  When regulator support is not configured, it returns
> NULL.
> 
> So, one solution here would be:
> 
> 	if (IS_ERR(regulator)) {
> 		err = PTR_ERR(regulator);
> 		pr_err("%s: regulator_get failed: %d\n", __func__, err);
> 		goto err_reg;
> 	}
> 
> but leaves us with the question: is it safe to call tegra_pcie_init()
> without regulator support?

The best approach is to assume it is not, but unlike the current code, 
this should be fixed by returning an appropriate error code instead of 0.


Nicolas
