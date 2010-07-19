Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966786Ab0GSVB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:01:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:51939 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966763Ab0GSVB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:01:56 -0400
Message-ID: <4C44BD42.3030904@kernel.org>
Date: Mon, 19 Jul 2010 23:01:54 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Mark Knecht <markknecht@gmail.com>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Drives missing at boot
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>	<4C2F5ECB.1040505@kernel.org>	<AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>	<4C2F61AB.9030806@kernel.org>	<AANLkTilYOT45q8OUJ-_V61_fnYy9HIk6GAv5ZPiomCaT@mail.gmail.com>	<4C317C04.20500@kernel.org>	<AANLkTilupyieml9yaWO9BUNPmQQ0g2w1HLWj6R9MwDZf@mail.gmail.com>	<4C32CE50.6010501@kernel.org>	<AANLkTikehTO1j6Gd7Y_g32_P6Yg9KB8Z8qwbNJh10aOU@mail.gmail.com>	<4C341598.6040004@kernel.org>	<AANLkTik4zkcIyVxwtX8GA1BsQSZaAeODpPlY3mRVBc-4@mail.gmail.com>	<4C34A1D5.1090202@kernel.org>	<AANLkTilgQSu3qi7qoTtjnV22r-8Sh1hbDAB_nlPImWNt@mail.gmail.com>	<4C34B8BE.5080504@kernel.org> <AANLkTilDbrA6lLPSOAtA8_4mLNkUZibHweTliqU5jd03@mail.gmail.com>
In-Reply-To: <AANLkTilDbrA6lLPSOAtA8_4mLNkUZibHweTliqU5jd03@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: multipart/mixed;
 boundary="------------090206080000010303060208"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 19 Jul 2010 21:01:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090206080000010303060208
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

On 07/19/2010 09:31 PM, Mark Knecht wrote:
>    With about 10-12 day of testing, 1-2 boots/day, I've not had a
> single boot failure since adding the patch. Only twice has it said
> tries=2. Every other time it's tries=1. The machine seems to work fine
> either way.

Hmmm... can you please test the attached patch instead?  It seems
likely that the root cause is not flakiness of SIDPR but incorrect
locking in libata EH code.

Thanks.

-- 
tejun

--------------090206080000010303060208
Content-Type: text/x-patch;
 name="ata_piix-sidpr-lock.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ata_piix-sidpr-lock.patch"

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 7409f98..3971bc0 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -158,6 +158,7 @@ struct piix_map_db {
 struct piix_host_priv {
 	const int *map;
 	u32 saved_iocfg;
+	spinlock_t sidpr_lock;	/* FIXME: remove once locking in EH is fixed */
 	void __iomem *sidpr;
 };
 
@@ -951,12 +952,15 @@ static int piix_sidpr_scr_read(struct ata_link *link,
 			       unsigned int reg, u32 *val)
 {
 	struct piix_host_priv *hpriv = link->ap->host->private_data;
+	unsigned long flags;
 
 	if (reg >= ARRAY_SIZE(piix_sidx_map))
 		return -EINVAL;
 
+	spin_lock_irqsave(&hpriv->sidpr_lock, flags);
 	piix_sidpr_sel(link, reg);
 	*val = ioread32(hpriv->sidpr + PIIX_SIDPR_DATA);
+	spin_unlock_irqrestore(&hpriv->sidpr_lock, flags);
 	return 0;
 }
 
@@ -964,12 +968,15 @@ static int piix_sidpr_scr_write(struct ata_link *link,
 				unsigned int reg, u32 val)
 {
 	struct piix_host_priv *hpriv = link->ap->host->private_data;
+	unsigned long flags;
 
 	if (reg >= ARRAY_SIZE(piix_sidx_map))
 		return -EINVAL;
 
+	spin_lock_irqsave(&hpriv->sidpr_lock, flags);
 	piix_sidpr_sel(link, reg);
 	iowrite32(val, hpriv->sidpr + PIIX_SIDPR_DATA);
+	spin_unlock_irqrestore(&hpriv->sidpr_lock, flags);
 	return 0;
 }
 
@@ -1566,6 +1573,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
 	if (!hpriv)
 		return -ENOMEM;
+	spin_lock_init(&hpriv->sidpr_lock);
 
 	/* Save IOCFG, this will be used for cable detection, quirk
 	 * detection and restoration on detach.  This is necessary

--------------090206080000010303060208--
