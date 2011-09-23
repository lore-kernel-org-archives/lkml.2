Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab1IWSfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 14:35:07 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:56502 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086Ab1IWSfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 14:35:06 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Koyamangalath\, Abhilash" <abhilash.kv@ti.com>
Cc: "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony\@atomide.com" <tony@atomide.com>,
        "linux\@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "sameo\@linux.intel.com" <sameo@linux.intel.com>,
        "Shilimkar\, Santosh" <santosh.shilimkar@ti.com>,
        "Premi\, Sanjeev" <premi@ti.com>,
        "david.woodhouse\@intel.com" <david.woodhouse@intel.com>,
        "christian.gmeiner\@gmail.com" <christian.gmeiner@gmail.com>
Subject: Re: [PATCH v3 1/3] AM35x: voltage: Basic initialization
Organization: Texas Instruments, Inc.
References: <1316698155-954-1-git-send-email-abhilash.kv@ti.com>
	<1316698155-954-2-git-send-email-abhilash.kv@ti.com>
	<877h50p5w0.fsf@ti.com>
	<FCCFB4CDC6E5564B9182F639FC356087037AF843EC@dbde02.ent.ti.com>
Date: Fri, 23 Sep 2011 11:33:33 -0700
In-Reply-To: <FCCFB4CDC6E5564B9182F639FC356087037AF843EC@dbde02.ent.ti.com>
	(Abhilash Koyamangalath's message of "Fri, 23 Sep 2011 18:03:02
	+0530")
Message-ID: <877h4zglc2.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhilash,

"Koyamangalath, Abhilash" <abhilash.kv@ti.com> writes:

> On Fri, Sep 23, 2011 at 4:00 AM, Hilman, Kevin wrote:
>> Hi Abhilash, Abhilash K V <abhilash.kv@ti.com> writes:
>>> This patch adds the basic initialization of voltage layer for
>>> AM35x. Since AM35x doesn't support voltage scaling,
>> I must admit to still being confused by this series.  This patch
>> says AM35x doesn't support voltage scaling, and the next patch adds
>> PMIC support, and registers it with the voltage layer.  However,
>> with each voltdm->scalable flag set to false, none of the PMIC
>> values will ever be used (by the current voltage layer.)  Do you
>> have more patches on top of this that extend the voltage layer to
>> directly use the PMIC instead of using VC or VP?  I'm assuming we
>> have some more assumptions in our current voltage layer about the
>> presence of VC/VP that are wrong and need to be fixed.  Now that the
>> big voltage layer cleanup is done, I am *very* interested in getting
>> rid of any more assumptions we have in that code about how devices
>> are hooked up with PMICs.  Can you summarize how these devices are
>> using (or want to use) the voltage layer?
> [Abhilash K V] Your concerns are grave and am trying to address most,
> however these are the only points I can make outright:
>
> - AM35x has just one voltage domain, so I tried having only one entry
> in voltagedomains_omap3[ ] ( and calling it "mpu_core", maybe or "mpu"
> or "core" ?).  

Based the TRM, it's called core.

> Either ways, some power-domain, say mpu_pwrdm would try
> looking for the "mpu_iva" volt-domain and return error, this happens
> for most powerdomains as their constituent volt-domains are hard-coded
> (and so unavailable on am35xx). Changing the code (which will be
> massive) there going against our initial premise that am35xx is still
> a "type of" omap3 SoC.

While the AM35x is similar to the OMAP3 in many ways, in terms of power,
there are some significant differences that we need to model properly.

The problem with the current approach is it's trying to trick the core
code into thinking an AM35x is like an OMAP34xx by creating voltage
domains that don't exist in hardware.  

The point of these voltage/power/clock domain data files is to represent
*exactly* what is in hardware.

Looking closer at SPRUGR0B, I don't think you should be directly using
the 34xx powerdomains as a starting point.  There are a few reasons:

- not all 34xx powerdomains exist on AM35x (at least cam, iva2, USB host
  are missing)
- AM35x powerdomains are in different voltage domains
- AM35x powerdomains do not support retention or off (only on and inactive
  according to SPRUGR0B)

> - TPS65023 PMIC code was originally included as a starting point to
> support a omap34xx (with SR disabled maybe) with power supplied by a
> TPS65023. Yes,I agree that since this looks more of like hypothetical
> scenario right now and so we can do without the addition of file
> pmic_tps65023.c for now as it doesn't provide any support for scaling.

I see now.

Adding support for that PMIC to the kernel is fine, I just don't think
it makes sense in context of this series for this device, since it does
not support voltage scaling, and AFAICT, this PMIC is for DVS uses.

Kevin

