Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab1I3Bc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:32:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63076 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1I3BcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:32:25 -0400
MIME-Version: 1.0
In-Reply-To: <1522108758.811204.1317316828352.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
References: <1317309431-1898-1-git-send-email-linkinjeon@gmail.com>
	<1522108758.811204.1317316828352.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Date: Fri, 30 Sep 2011 10:32:23 +0900
Message-ID: <CAKYAXd_1jY23C8NTvP7NizZEseb7G2bbtJYq7RvF1vaJaZgh_Q@mail.gmail.com>
Subject: Re: [PATCH v3] mmc : general purpose partition support.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Andrei Warkentin <awarkentin@vmware.com>
Cc: linux-kernel@vger.kernel.org, adrian hunter <adrian.hunter@intel.com>,
        linus walleij <linus.walleij@linaro.org>,
        james p freyensee <james_p_freyensee@linux.intel.com>,
        sebras@gmail.com, Ulf Hansson <Ulf.Hansson@stericsson.com>,
        stefan xk nilsson <stefan.xk.nilsson@stericsson.com>,
        per forlin <per.forlin@stericsson.com>,
        johan rudholm <johan.rudholm@stericsson.com>, cjb@laptop.org,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8U1WtI6009950

2011/9/30 Andrei Warkentin <awarkentin@vmware.com>:
> Namjae,
>
> ----- Original Message -----
>> From: "Namjae Jeon" <linkinjeon@gmail.com>
>> To: cjb@laptop.org, linux-mmc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org, awarkentin@vmware.com, "adrian hunter" <adrian.hunter@intel.com>, "linus walleij"
>> <linus.walleij@linaro.org>, "james p freyensee" <james_p_freyensee@linux.intel.com>, sebras@gmail.com, "Ulf Hansson"
>> <Ulf.Hansson@stericsson.com>, "stefan xk nilsson" <stefan.xk.nilsson@stericsson.com>, "per forlin"
>> <per.forlin@stericsson.com>, "johan rudholm" <johan.rudholm@stericsson.com>, "Namjae Jeon" <linkinjeon@gmail.com>
>> Sent: Thursday, September 29, 2011 11:17:11 AM
>> Subject: [PATCH v3] mmc : general purpose partition support.
>>
>> It allows gerneral purpose partitions in MMC Device.
>> And I try to simpliy make mmc_blk_alloc_parts using mmc_part
>> structure suggested by Andrei Warkentin.
>> After patching, we can see general purpose partitions like this.
>> > cat /proc/partitions
>>               179 0 847872 mmcblk0
>>               179 192 4096 mmcblk0gp3
>>               179 160 4096 mmcblk0gp2
>>               179 128 4096 mmcblk0gp1
>>               179 96  1052672 mmcblk0gp0
>>               179 64  1024 mmcblk0boot1
>>               179 32  1024 mmcblk0boot0
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>
>> +      for (idx = 0; idx < MMC_NUM_BOOT_PARTITION; idx++) {
>> +             if (card->boot_part[idx].size) {
>> +                     ret = mmc_blk_alloc_part(card, md,
>> +                             card->boot_part[idx].cookie,
>> +                             card->boot_part[idx].size >> 9,
>> +                             card->boot_part[idx].force_ro,
>> +                             card->boot_part[idx].name);
>> +                     if (ret)
>> +                             return ret;
>> +             }
>> +     }
>> +
>> +     for (idx = 0; idx < MMC_NUM_GP_PARTITION; idx++) {
>> +             if (card->gp_part[idx].size) {
>> +                     ret = mmc_blk_alloc_part(card, md,
>> +                             card->gp_part[idx].cookie,
>> +                             card->gp_part[idx].size >> 9,
>> +                             card->gp_part[idx].force_ro,
>> +                             card->gp_part[idx].name);
>> +                     if (ret)
>> +                             return ret;
>
> You were on a better track before. Why does the block drivre need to know about the partition types?
> You should parse one array.
>
>> -             card->ext_csd.boot_size = ext_csd[EXT_CSD_BOOT_MULT] << 17;
>> +             if (ext_csd[EXT_CSD_BOOT_MULT]) {
>> +                     part_cfg = EXT_CSD_PART_CONFIG_ACC_BOOT0;
>> +                     for (idx = 0; idx < MMC_NUM_BOOT_PARTITION; idx++) {
>> +                             card->boot_part[idx].size =
>> +                                     ext_csd[EXT_CSD_BOOT_MULT] << 17;
>> +                             card->boot_part[idx].cookie = part_cfg++;
>> +                             sprintf(card->boot_part[idx].name, "boot%d",
>> +                                     idx);
>> +                             card->boot_part[idx].force_ro = true;
>> +                     }
>> +             }
>>       }
>>
>
> My earlier comment still stands - make your code look something like -
>
> if (ext_csd[EXT_CSD_BOOT_MULT]) {
>        part_cfg = EXT_CSD_PART_CONFIG_ACC_BOOT0;
>        for (idx = 0; idx < MMC_NUM_BOOT_PARTITION; idx++) {
>                mmc_part_add(card, size, part_cfg++, "boot%d", part_cfg++,
>                                "boot%d", idx, true)
> }
>
>> +     struct mmc_part boot_part[MMC_NUM_BOOT_PARTITION];      /* mmc boot
>> partitions */
>> +     struct mmc_part gp_part[MMC_NUM_GP_PARTITION];  /* mmc general
>> purpose partitions */
>
> struct mmc_part parts[MMC_NUM_BOOT_PARTITION + MMC_NUM_GP_PARTITION];
> unsigned nr_parts;
>

Your review will always inspire me.
I will post again.
plz review after..
Thanks.
> A
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
