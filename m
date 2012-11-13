Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab2KMNqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:46:06 -0500
Received: from void.printf.net ([89.145.121.20]:60850 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab2KMNqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:46:04 -0500
From: Chris Ball <cjb@laptop.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v2] mmc: sdhci: apply voltage range check only for non-fixed regulators
References: <87fw4dn030.fsf@octavius.laptop.org>
	<1352813534-6795-1-git-send-email-m.szyprowski@samsung.com>
Date: Tue, 13 Nov 2012 08:45:57 -0500
In-Reply-To: <1352813534-6795-1-git-send-email-m.szyprowski@samsung.com>
	(Marek Szyprowski's message of "Tue, 13 Nov 2012 14:32:14 +0100")
Message-ID: <87bof1mx9m.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Tue, Nov 13 2012, Marek Szyprowski wrote:
> Fixed regulators cannot change their voltage, so disable all voltage
> range checking for them, otherwise the driver fails to operate with
> fixed regulators. Up to now it worked only by luck, because
> regulator_is_supported_voltage() function returned incorrect values.
> Commit "regulator: fix voltage check in regulator_is_supported_voltage()"
> fixed that function and now additional check is needed for fixed
> regulators.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/mmc/host/sdhci.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index c7851c0..6f6534e 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2923,7 +2923,7 @@ int sdhci_add_host(struct sdhci_host *host)
>  		regulator_enable(host->vmmc);
>  
>  #ifdef CONFIG_REGULATOR
> -	if (host->vmmc) {
> +	if (host->vmmc && regulator_count_voltages(host->vmmc) > 1) {
>  		ret = regulator_is_supported_voltage(host->vmmc, 3300000,
>  			3300000);
>  		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))

Thanks for the longer explanation.  I'm still missing something, though;
what's wrong with running the check as it was with the new regulator code?
(I haven't tried it yet.)

#ifdef CONFIG_REGULATOR
        if (host->vmmc) {
                ret = regulator_is_supported_voltage(host->vmmc, 3300000,
                        3300000);
                if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))
                        caps[0] &= ~SDHCI_CAN_VDD_330;
                ret = regulator_is_supported_voltage(host->vmmc, 3000000,
                        3000000);
                if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_300)))
                        caps[0] &= ~SDHCI_CAN_VDD_300;
                ret = regulator_is_supported_voltage(host->vmmc, 1800000,
                        1800000);
                if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_180)))
                        caps[0] &= ~SDHCI_CAN_VDD_180;
        }
#endif /* CONFIG_REGULATOR */

The point is to remove unsupported voltages, so if someone sets up a
fixed regulator at 3300000, all of the other caps are disabled.  Why
wouldn't that work without this change, and how are we supposed to
remove those caps on a fixed regulator after your patchset?

Thanks, sorry if I'm missing something obvious,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
