Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935625Ab1JFANy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 20:13:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46719 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935580Ab1JFANw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 20:13:52 -0400
MIME-Version: 1.0
In-Reply-To: <1757717892.66886.1317828833207.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
References: <1317825945-1918-1-git-send-email-linkinjeon@gmail.com>
	<1757717892.66886.1317828833207.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Date: Thu, 6 Oct 2011 09:13:50 +0900
Message-ID: <CAKYAXd9wqjK90pn6YHNGKi+gDEqwDV4x14CrY-Nc7JHQ_Ed7xw@mail.gmail.com>
Subject: Re: [PATCH v11] mmc : general purpose partition support.
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/6 Andrei Warkentin <awarkentin@vmware.com>:
> Hi,
>
> ----- Original Message -----
>> From: "Namjae Jeon" <linkinjeon@gmail.com>
>> To: cjb@laptop.org, linux-mmc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org, awarkentin@vmware.com, "adrian hunter" <adrian.hunter@intel.com>, "linus walleij"
>> <linus.walleij@linaro.org>, "james p freyensee" <james_p_freyensee@linux.intel.com>, sebras@gmail.com, "Ulf Hansson"
>> <Ulf.Hansson@stericsson.com>, "stefan xk nilsson" <stefan.xk.nilsson@stericsson.com>, "per forlin"
>> <per.forlin@stericsson.com>, "johan rudholm" <johan.rudholm@stericsson.com>, "Namjae Jeon" <linkinjeon@gmail.com>
>> Sent: Wednesday, October 5, 2011 10:45:45 AM
>> Subject: [PATCH v11] mmc : general purpose partition support.
>>
>> It allows gerneral purpose partitions in MMC Device.
>> And I try to simpliy make mmc_blk_alloc_parts using mmc_part
>> structure suggested by Andrei Warkentin.
>> After patching, we can see general purpose partitions like this.
>> > cat /proc/partitions
>>           179 0 847872 mmcblk0
>>           179 192 4096 mmcblk0gp3
>>           179 160 4096 mmcblk0gp2
>>           179 128 4096 mmcblk0gp1
>>           179 96  1052672 mmcblk0gp0
>>           179 64  1024 mmcblk0boot1
>>           179 32  1024 mmcblk0boot0
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> ---
>>  drivers/mmc/card/block.c |   41 +++++++++++++++++++++++------------
>>  drivers/mmc/core/mmc.c   |   52
>>  ++++++++++++++++++++++++++++++++++++++++++---
>>  include/linux/mmc/card.h |   34 +++++++++++++++++++++++++++++-
>>  include/linux/mmc/mmc.h  |    5 +++-
>>  4 files changed, 112 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
>> +     for (idx = 0; idx < card->nr_parts; idx++) {
>> +             if (mmc_is_boot_partition(&card->part[idx]) &&
>> +                     !mmc_boot_partition_access(card->host))
>> +                     continue;
>> +             if (card->part[idx].size) {
>> +                     ret = mmc_blk_alloc_part(card, md,
>> +                             card->part[idx].part_cfg,
>> +                             card->part[idx].size >> 9,
>> +                             card->part[idx].force_ro,
>> +                             card->part[idx].name);
>> +                     if (ret)
>> +                             return ret;
>> +             }
>>       }
>
> Is there any reason for putting the mmc_boot_partition_access() logic here? If
> boot partitions are not allowed by host, then just don't add the mmc_parts to
> the parts array, no? Such minutae should belong in core mmc code, not block driver, IMHO.

Hi.

How about changing patch like this ?

if (ext_csd[EXT_CSD_BOOT_MULT] && mmc_boot_partition_access(card->host)) {
                        for (idx = 0; idx < MMC_NUM_BOOT_PARTITION; idx++) {
                                part_size = ext_csd[EXT_CSD_BOOT_MULT] << 17;
                                mmc_part_add(card, part_size,
                                        EXT_CSD_PART_CONFIG_ACC_BOOT0 + idx,
                                        "boot%d", idx, true);
                        }
                }

I want to hear the opinion from andrei and
adrian(mmc_boot_partition_access patch's author)
Thanks.
>
> A
>
