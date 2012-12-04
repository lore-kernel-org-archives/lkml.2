Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab2LDOuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:50:08 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:45522 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2LDOuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:50:05 -0500
MIME-Version: 1.0
In-Reply-To: <1354629663-29091-4-git-send-email-m.szyprowski@samsung.com>
References: <1354629663-29091-1-git-send-email-m.szyprowski@samsung.com>
	<1354629663-29091-4-git-send-email-m.szyprowski@samsung.com>
Date: Tue, 4 Dec 2012 22:50:03 +0800
Message-ID: <CADz5_gLAWyD-3nYEV5HJad11wxEmxO867LkWOXDBn1_XmcOA_w@mail.gmail.com>
Subject: Re: [PATCH 3/3] mmc: sdhci: check voltage range only on regulators
 aware of voltage value
From: Kevin Liu <keyuan.liu@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/4 Marek Szyprowski <m.szyprowski@samsung.com>:
> Some regulators don't report any voltage values, so checking supported
> voltage range results in disabling all SDHCI_CAN_VDD_* flags and
> registration failure. This patch finally provides a correct fix for the
> registration of SDHCI driver with all possible voltage regulators:
> dummy, fixed and regulated without using regulator_count_voltages()
> hacks.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/mmc/host/sdhci.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index a9ad2cd..d244dc0 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2930,7 +2930,11 @@ int sdhci_add_host(struct sdhci_host *host)
>         }
>
>  #ifdef CONFIG_REGULATOR
> -       if (host->vmmc && regulator_count_voltages(host->vmmc) > 1) {
> +       /*
> +        * Voltage range check makes sense only if regulator reports
> +        * any voltage value.
> +        */
> +       if (host->vmmc && regulator_get_voltage(host->vmmc) > 0) {
>                 ret = regulator_is_supported_voltage(host->vmmc, 2700000,
>                         3600000);
>                 if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))

Good idea. But how about the regulator is disabled at this point? So I
suggest to change to
     if (host->vmmc && regulator_get_voltage(host->vmmc) >= 0)

Thanks
Kevin
