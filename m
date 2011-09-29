Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab1I2RUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 13:20:31 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:31822 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292Ab1I2RU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 13:20:29 -0400
Date: Thu, 29 Sep 2011 10:20:28 -0700 (PDT)
From: Andrei Warkentin <awarkentin@vmware.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org, adrian hunter <adrian.hunter@intel.com>,
        linus walleij <linus.walleij@linaro.org>,
        james p freyensee <james_p_freyensee@linux.intel.com>,
        sebras@gmail.com, Ulf Hansson <Ulf.Hansson@stericsson.com>,
        stefan xk nilsson <stefan.xk.nilsson@stericsson.com>,
        per forlin <per.forlin@stericsson.com>,
        johan rudholm <johan.rudholm@stericsson.com>, cjb@laptop.org,
        linux-mmc@vger.kernel.org
Message-ID: <1522108758.811204.1317316828352.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <1317309431-1898-1-git-send-email-linkinjeon@gmail.com>
Subject: Re: [PATCH v3] mmc : general purpose partition support.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.61.163]
X-Mailer: Zimbra 7.1.1_GA_3225 (ZimbraWebClient - FF3.0 (Linux)/7.1.1_GA_3225)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae,

----- Original Message -----
> From: "Namjae Jeon" <linkinjeon@gmail.com>
> To: cjb@laptop.org, linux-mmc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org, awarkentin@vmware.com, "adrian hunter" <adrian.hunter@intel.com>, "linus walleij"
> <linus.walleij@linaro.org>, "james p freyensee" <james_p_freyensee@linux.intel.com>, sebras@gmail.com, "Ulf Hansson"
> <Ulf.Hansson@stericsson.com>, "stefan xk nilsson" <stefan.xk.nilsson@stericsson.com>, "per forlin"
> <per.forlin@stericsson.com>, "johan rudholm" <johan.rudholm@stericsson.com>, "Namjae Jeon" <linkinjeon@gmail.com>
> Sent: Thursday, September 29, 2011 11:17:11 AM
> Subject: [PATCH v3] mmc : general purpose partition support.
> 
> It allows gerneral purpose partitions in MMC Device.
> And I try to simpliy make mmc_blk_alloc_parts using mmc_part
> structure suggested by Andrei Warkentin.
> After patching, we can see general purpose partitions like this.
> > cat /proc/partitions
>               179 0 847872 mmcblk0
>               179 192 4096 mmcblk0gp3
>               179 160 4096 mmcblk0gp2
>               179 128 4096 mmcblk0gp1
>               179 96  1052672 mmcblk0gp0
>               179 64  1024 mmcblk0boot1
>               179 32  1024 mmcblk0boot0
> 
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>

> +	 for (idx = 0; idx < MMC_NUM_BOOT_PARTITION; idx++) {
> +		if (card->boot_part[idx].size) {
> +			ret = mmc_blk_alloc_part(card, md,
> +				card->boot_part[idx].cookie,
> +				card->boot_part[idx].size >> 9,
> +				card->boot_part[idx].force_ro,
> +				card->boot_part[idx].name);
> +			if (ret)
> +				return ret;
> +		}
> +	}
> +
> +	for (idx = 0; idx < MMC_NUM_GP_PARTITION; idx++) {
> +		if (card->gp_part[idx].size) {
> +			ret = mmc_blk_alloc_part(card, md,
> +				card->gp_part[idx].cookie,
> +				card->gp_part[idx].size >> 9,
> +				card->gp_part[idx].force_ro,
> +				card->gp_part[idx].name);
> +			if (ret)
> +				return ret;

You were on a better track before. Why does the block drivre need to know about the partition types?
You should parse one array.

> -		card->ext_csd.boot_size = ext_csd[EXT_CSD_BOOT_MULT] << 17;
> +		if (ext_csd[EXT_CSD_BOOT_MULT])	{
> +			part_cfg = EXT_CSD_PART_CONFIG_ACC_BOOT0;
> +			for (idx = 0; idx < MMC_NUM_BOOT_PARTITION; idx++) {
> +				card->boot_part[idx].size =
> +					ext_csd[EXT_CSD_BOOT_MULT] << 17;
> +				card->boot_part[idx].cookie = part_cfg++;
> +				sprintf(card->boot_part[idx].name, "boot%d",
> +					idx);
> +				card->boot_part[idx].force_ro = true;
> +			}
> +		}
>  	}
>  

My earlier comment still stands - make your code look something like -

if (ext_csd[EXT_CSD_BOOT_MULT])	{
	part_cfg = EXT_CSD_PART_CONFIG_ACC_BOOT0;
	for (idx = 0; idx < MMC_NUM_BOOT_PARTITION; idx++) {
		mmc_part_add(card, size, part_cfg++, "boot%d", part_cfg++,
				"boot%d", idx, true)
}

> +	struct mmc_part	boot_part[MMC_NUM_BOOT_PARTITION];	/* mmc boot
> partitions */
> +	struct mmc_part	gp_part[MMC_NUM_GP_PARTITION];	/* mmc general
> purpose partitions */

struct mmc_part parts[MMC_NUM_BOOT_PARTITION + MMC_NUM_GP_PARTITION];
unsigned nr_parts;

A
