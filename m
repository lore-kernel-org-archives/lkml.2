Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab2KMOJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:09:41 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54220 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2KMOJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:09:40 -0500
Message-id: <50A254A0.8000403@samsung.com>
Date: Tue, 13 Nov 2012 15:09:36 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026
 Thunderbird/16.0.2
MIME-version: 1.0
To: Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v2] mmc: sdhci: apply voltage range check only for
 non-fixed regulators
References: <87fw4dn030.fsf@octavius.laptop.org>
 <1352813534-6795-1-git-send-email-m.szyprowski@samsung.com>
 <87bof1mx9m.fsf@octavius.laptop.org>
In-reply-to: <87bof1mx9m.fsf@octavius.laptop.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/13/2012 2:45 PM, Chris Ball wrote:
> Hi Marek,
>
> On Tue, Nov 13 2012, Marek Szyprowski wrote:
> > Fixed regulators cannot change their voltage, so disable all voltage
> > range checking for them, otherwise the driver fails to operate with
> > fixed regulators. Up to now it worked only by luck, because
> > regulator_is_supported_voltage() function returned incorrect values.
> > Commit "regulator: fix voltage check in regulator_is_supported_voltage()"
> > fixed that function and now additional check is needed for fixed
> > regulators.
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  drivers/mmc/host/sdhci.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> > index c7851c0..6f6534e 100644
> > --- a/drivers/mmc/host/sdhci.c
> > +++ b/drivers/mmc/host/sdhci.c
> > @@ -2923,7 +2923,7 @@ int sdhci_add_host(struct sdhci_host *host)
> >  		regulator_enable(host->vmmc);
> >
> >  #ifdef CONFIG_REGULATOR
> > -	if (host->vmmc) {
> > +	if (host->vmmc && regulator_count_voltages(host->vmmc) > 1) {
> >  		ret = regulator_is_supported_voltage(host->vmmc, 3300000,
> >  			3300000);
> >  		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))
>
> Thanks for the longer explanation.  I'm still missing something, though;
> what's wrong with running the check as it was with the new regulator code?
> (I haven't tried it yet.)
>
> #ifdef CONFIG_REGULATOR
>          if (host->vmmc) {
>                  ret = regulator_is_supported_voltage(host->vmmc, 3300000,
>                          3300000);
>                  if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))
>                          caps[0] &= ~SDHCI_CAN_VDD_330;
>                  ret = regulator_is_supported_voltage(host->vmmc, 3000000,
>                          3000000);
>                  if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_300)))
>                          caps[0] &= ~SDHCI_CAN_VDD_300;
>                  ret = regulator_is_supported_voltage(host->vmmc, 1800000,
>                          1800000);
>                  if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_180)))
>                          caps[0] &= ~SDHCI_CAN_VDD_180;
>          }
> #endif /* CONFIG_REGULATOR */
>
> The point is to remove unsupported voltages, so if someone sets up a
> fixed regulator at 3300000, all of the other caps are disabled.  Why
> wouldn't that work without this change, and how are we supposed to
> remove those caps on a fixed regulator after your patchset?
>
> Thanks, sorry if I'm missing something obvious,

On our boards eMMC is connected to fixed 2.8V regulator, what results in
clearing all available voltages and fail. The same situation is when one
enable dummy regulator and try to use sdhci with it. My patch fixes this
and restores sdhci to working state as it was before (before fixing
regulator regulator_is_supported_voltage() function and earlier when
MMC_BROKEN_VOLATGE capability was used).

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


