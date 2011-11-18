Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab1KRVZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:25:04 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36936 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1KRVZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:25:01 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740D74F48@HQMAIL01.nvidia.com>
References: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
	<1321546766-26770-4-git-send-email-pdeschrijver@nvidia.com>
	<20111118190649.GB31678@quad.lixom.net>
	<74CDBE0F657A3D45AFBB94109FB122FF1740D74F48@HQMAIL01.nvidia.com>
Date: Fri, 18 Nov 2011 13:25:01 -0800
Message-ID: <CAOesGMix=CG5s8Ux_fiLKmSqdoVJgm5skm2MBrHg3YrNCyHaUg@mail.gmail.com>
Subject: Re: [PATCH 03/10] arm/tegra: prepare clock code for multiple tegra variants
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 12:18 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Olof Johansson wrote at Friday, November 18, 2011 12:07 PM:
>> On Thu, Nov 17, 2011 at 06:19:17PM +0200, Peter De Schrijver wrote:
>> > Rework the tegra20 clock code to support multiple tegra variants :
>> >
>> >  * remove tegra2_periph_reset_assert/tegra2_periph_reset_deassert. This
>> >    functionality should be in clock.c.
>> >  * compile tegra_sdmmc_tap_delay only on tegra20 as this feature will not
>> >    be available in future variants.
>> >  * don't export clk_measure_input_freq as its functionality is also available
>> >    using clk_get_rate().
> ...
>> > @@ -403,10 +405,11 @@ void __init tegra_init_clock(void)
>> >  }
>> >
>> >  /*
>> > - * The SDMMC controllers have extra bits in the clock source register that
>> > - * adjust the delay between the clock and data to compenstate for delays
>> > - * on the PCB.
>> > + * The SDMMC controllers on tegra20 have extra bits in the clock source
>> > + * register that adjust the delay between the clock and data to compenstate
>> > + * for delays on the PCB.
>> >   */
>> > +#ifdef CONFIG_ARCH_TEGRA_2x_SOC
>> >  void tegra_sdmmc_tap_delay(struct clk *c, int delay)
>> >  {
>> >     unsigned long flags;
>> > @@ -415,6 +418,7 @@ void tegra_sdmmc_tap_delay(struct clk *c, int delay)
>> >     tegra2_sdmmc_tap_delay(c, delay);
>> >     spin_unlock_irqrestore(&c->spinlock, flags);
>> >  }
>> > +#endif
>>
>> Ifdeffing this out doesn't quite make sense. Better to do a #ifdef in the
>> include file with an #else case that fills in an empty function. This
>> needs to be abstracted differently for the two platforms anyway but
>> that can be done separately from this. Does tegra3 have tap delay setup
>> as well? (I don't have the TRM handy right now).
>
> I vote just rip this function out altogether.
>
> It isn't used in mainline, chromeos-2.6.38, chromeos-3.0, nor our internal
> 2.6.36 or 2.6.39 kernels.
>
> Equally, I can't find any documentation of the register bits this code
> touches in either Tegra20 or Tegra30 TRMs.

Actually, it used on some of the chromeos platforms, in particular for
the sdio wifi interface (see board-seaboard.c on the chromeos tree).
Without it we don't have stable operation. I'll get the use side
patches posted for it for 3.3.

And yeah. I was unable to find documentation too, it required getting
questions answered from FAEs.


-Olof
