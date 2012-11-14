Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2KNHLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:11:40 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37248 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab2KNHLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:11:38 -0500
MIME-Version: 1.0
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C060FBEA29A@SC-VEXCH1.marvell.com>
References: <25B60CDC2F704E4E9D88FFD52780CB4C060FBEA29A@SC-VEXCH1.marvell.com>
Date: Wed, 14 Nov 2012 15:11:37 +0800
Message-ID: <CADz5_gLC=z_VYrNq8q3dU7L6im7shSz-Sn6Tzym2mRZONwpgUg@mail.gmail.com>
Subject: Re: FW: [PATCH v2] mmc: sdhci: apply voltage range check only for
 non-fixed regulators
From: Kevin Liu <keyuan.liu@gmail.com>
To: m.szyprowski@samsung.com, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, lrg@ti.com,
        Philip Rakity <prakity@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-owner@vger.kernel.org] On Behalf Of Chris Ball
> Sent: Tuesday, November 13, 2012 10:14 PM
> To: Marek Szyprowski
> Cc: linux-kernel@vger.kernel.org; linux-mmc@vger.kernel.org; Kyungmin Park; Mark Brown; Liam Girdwood; Philip Rakity
> Subject: Re: [PATCH v2] mmc: sdhci: apply voltage range check only for non-fixed regulators
>
> Hi,
>
> On Tue, Nov 13 2012, Marek Szyprowski wrote:
>>> On Tue, Nov 13 2012, Marek Szyprowski wrote:
>>> > Fixed regulators cannot change their voltage, so disable all voltage
>>> > range checking for them, otherwise the driver fails to operate with
>>> > fixed regulators. Up to now it worked only by luck, because
>>> > regulator_is_supported_voltage() function returned incorrect values.
>>> > Commit "regulator: fix voltage check in regulator_is_supported_voltage()"
>>> > fixed that function and now additional check is needed for fixed
>>> > regulators.
>>> >
>>> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>> > ---
>>> >  drivers/mmc/host/sdhci.c |    2 +-
>>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>>> >
>>> > diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>>> > index c7851c0..6f6534e 100644
>>> > --- a/drivers/mmc/host/sdhci.c
>>> > +++ b/drivers/mmc/host/sdhci.c
>>> > @@ -2923,7 +2923,7 @@ int sdhci_add_host(struct sdhci_host *host)
>>> >            regulator_enable(host->vmmc);
>>> >
>>> >  #ifdef CONFIG_REGULATOR
>>> > -  if (host->vmmc) {
>>> > +  if (host->vmmc && regulator_count_voltages(host->vmmc) > 1) {
>>> >            ret = regulator_is_supported_voltage(host->vmmc, 3300000,
>>> >                    3300000);
>>> >            if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))
>>>
>>> Thanks for the longer explanation.  I'm still missing something, though;
>>> what's wrong with running the check as it was with the new regulator code?
>>> (I haven't tried it yet.)
>>>
>>> #ifdef CONFIG_REGULATOR
>>>          if (host->vmmc) {
>>>                  ret = regulator_is_supported_voltage(host->vmmc, 3300000,
>>>                          3300000);
>>>                  if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))
>>>                          caps[0] &= ~SDHCI_CAN_VDD_330;
>>>                  ret = regulator_is_supported_voltage(host->vmmc, 3000000,
>>>                          3000000);
>>>                  if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_300)))
>>>                          caps[0] &= ~SDHCI_CAN_VDD_300;
>>>                  ret = regulator_is_supported_voltage(host->vmmc, 1800000,
>>>                          1800000);
>>>                  if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_180)))
>>>                          caps[0] &= ~SDHCI_CAN_VDD_180;
>>>          }
>>> #endif /* CONFIG_REGULATOR */
>>>
>>> The point is to remove unsupported voltages, so if someone sets up a
>>> fixed regulator at 3300000, all of the other caps are disabled.  Why
>>> wouldn't that work without this change, and how are we supposed to
>>> remove those caps on a fixed regulator after your patchset?
>>>
>>> Thanks, sorry if I'm missing something obvious,
>>
>> On our boards eMMC is connected to fixed 2.8V regulator, what results in
>> clearing all available voltages and fail. The same situation is when one
>> enable dummy regulator and try to use sdhci with it. My patch fixes this
>> and restores sdhci to working state as it was before (before fixing
>> regulator regulator_is_supported_voltage() function and earlier when
>> MMC_BROKEN_VOLATGE capability was used).
>
> I see.  Sounds like a separate bug -- Philip (or anyone else), any
> idea how we should be treating eMMCs with a fixed voltage here?
>

I think we should check the voltage range rather than the voltage
point accoring to the spec.
Otherwise some valid voltage like 2.8v will be discarded by mistake.
My below old patch aim to fix this issue.
How do you think?

-----Original Message-----
From: Kevin Liu [mailto:keyuan.liu@gmail.com]
Sent: Friday, September 28, 2012 3:56 PM
To: linux-mmc@vger.kernel.org; cjb@laptop.org; pierre@ossman.eu;
ulf.hansson@linaro.org; Zhangfei Gao
Cc: Haojian Zhuang; Chao Xie; Philip Rakity; Kevin Liu; Jialing Fu
Subject: [PATCH v5 03/13] mmc: sdhci: use regulator min/max voltage
range according to spec

From: Kevin Liu <kliu5@marvell.com>

For regulator vmmc/vmmcq, use voltage range as below
3.3v/3.0v: (2.7v, 3.6v)
1.8v: (1.7v, 1.95v)
Original code use the specific value which may fail in regulator
driver if it does NOT support the specific voltage.

Signed-off-by: Jialing Fu <jlfu@marvell.com>
Signed-off-by: Kevin Liu <kliu5@marvell.com>
---
 drivers/mmc/host/sdhci.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 3aef580..36afd47 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1628,7 +1628,7 @@ static int
sdhci_do_3_3v_signal_voltage_switch(struct sdhci_host *host,
 	sdhci_writew(host, ctrl, SDHCI_HOST_CONTROL2);

 	if (host->vqmmc) {
-		ret = regulator_set_voltage(host->vqmmc, 3300000, 3300000);
+		ret = regulator_set_voltage(host->vqmmc, 2700000, 3600000);
 		if (ret) {
 			pr_warning("%s: Switching to 3.3V signalling voltage "
 				   " failed\n", mmc_hostname(host->mmc));
@@ -1672,7 +1672,7 @@ static int
sdhci_do_1_8v_signal_voltage_switch(struct sdhci_host *host,
 		 */
 		if (host->vqmmc)
 			ret = regulator_set_voltage(host->vqmmc,
-				1800000, 1800000);
+				1700000, 1950000);
 		else
 			ret = 0;

@@ -2856,7 +2856,7 @@ int sdhci_add_host(struct sdhci_host *host)
 		pr_info("%s: no vqmmc regulator found\n", mmc_hostname(mmc));
 		host->vqmmc = NULL;
 	}
-	else if (regulator_is_supported_voltage(host->vqmmc, 1800000, 1800000))
+	else if (regulator_is_supported_voltage(host->vqmmc, 1700000, 1950000))
 		regulator_enable(host->vqmmc);
 	else
 		caps[1] &= ~(SDHCI_SUPPORT_SDR104 | SDHCI_SUPPORT_SDR50 |
@@ -2927,16 +2927,14 @@ int sdhci_add_host(struct sdhci_host *host)

 #ifdef CONFIG_REGULATOR
 	if (host->vmmc) {
-		ret = regulator_is_supported_voltage(host->vmmc, 3300000,
-			3300000);
+		ret = regulator_is_supported_voltage(host->vmmc, 2700000,
+			3600000);
 		if ((ret <= 0) && (caps[0] & SDHCI_CAN_VDD_330))
 			caps[0] &= ~SDHCI_CAN_VDD_330;
-		ret = regulator_is_supported_voltage(host->vmmc, 3000000,
-			3000000);
 		if ((ret <= 0) && (caps[0] & SDHCI_CAN_VDD_300))
 			caps[0] &= ~SDHCI_CAN_VDD_300;
-		ret = regulator_is_supported_voltage(host->vmmc, 1800000,
-			1800000);
+		ret = regulator_is_supported_voltage(host->vmmc, 1700000,
+			1950000);
 		if ((ret <= 0) && (caps[0] & SDHCI_CAN_VDD_180))
 			caps[0] &= ~SDHCI_CAN_VDD_180;
 	}
-- 
1.7.0.4
