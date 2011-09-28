Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab1I1BNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 21:13:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38098 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab1I1BNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 21:13:39 -0400
MIME-Version: 1.0
In-Reply-To: <4E80BE05.40401@linux.intel.com>
References: <1316840820-2014-1-git-send-email-linkinjeon@gmail.com>
	<4E80BE05.40401@linux.intel.com>
Date: Wed, 28 Sep 2011 10:13:38 +0900
Message-ID: <CAKYAXd-LFpxy6rU+bn67Nv0Onxu=qkEXuQ_O3y22e7L9VTk9Mw@mail.gmail.com>
Subject: Re: [PATCH v2] mmc : general purpose partition support.
From: NamJae Jeon <linkinjeon@gmail.com>
To: J Freyensee <james_p_freyensee@linux.intel.com>, cjb@laptop.org,
        linux-mmc@vger.kernel.org, Andrei Warkentin <awarkentin@vmware.com>,
        adrian.hunter@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8S1Dnq9028138

2011/9/27 J Freyensee <james_p_freyensee@linux.intel.com>:
> On 09/23/2011 10:07 PM, Namjae Jeon wrote:
>>
>> It allows gerneral purpose partitions in MMC Device.
>> And I try to simpliy make mmc_blk_alloc_parts using mmc_part structure
>> suggested by Andrei Warkentin.
>> After patching, we can see general purpose partitions like this.
>>>
>>> cat /proc/partitions
>>
>>           179 0 847872 mmcblk0
>>           179 192 4096 mmcblk0gp4
>>           179 160 4096 mmcblk0gp3
>>           179 128 4096 mmcblk0gp2
>>           179 96  1052672 mmcblk0gp1
>>           179 64  1024 mmcblk0boot1
>>           179 32  1024 mmcblk0boot0
>
> Looks reasonable to me.
Thanks for your review.
I want to know how the opinion of others.

>
>
>>
>> Signed-off-by: Namjae Jeon<linkinjeon@gmail.com>
>> ---
>>  drivers/mmc/card/block.c |   30 ++++++++++++++++--------------
>>  drivers/mmc/core/mmc.c   |   46
>> +++++++++++++++++++++++++++++++++++++++++++++-
>>  include/linux/mmc/card.h |   19 ++++++++++++++++++-
>>  include/linux/mmc/mmc.h  |    2 --
>>  4 files changed, 79 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
>> index 1ff5486..8ec7cfd 100644
>> --- a/drivers/mmc/card/block.c
>> +++ b/drivers/mmc/card/block.c
>> @@ -1377,26 +1377,28 @@ static int mmc_blk_alloc_part(struct mmc_card
>> *card,
>>        return 0;
>>  }
>>
>> +/* MMC Physical partition consist of two boot partitons and
>> + * four general purpose partitions.
>> + * if the register of respective partitions is set in ext_csd,
>> + * it allocate block device to be accessed.
>> + */
>> +
>>  static int mmc_blk_alloc_parts(struct mmc_card *card, struct mmc_blk_data
>> *md)
>>  {
>> -       int ret = 0;
>> +       int i, ret = 0;
>>
>>        if (!mmc_card_mmc(card))
>>                return 0;
>>
>> -       if (card->ext_csd.boot_size) {
>> -               ret = mmc_blk_alloc_part(card, md,
>> EXT_CSD_PART_CONFIG_ACC_BOOT0,
>> -                                        card->ext_csd.boot_size>>  9,
>> -                                        true,
>> -                                        "boot0");
>> -               if (ret)
>> -                       return ret;
>> -               ret = mmc_blk_alloc_part(card, md,
>> EXT_CSD_PART_CONFIG_ACC_BOOT1,
>> -                                        card->ext_csd.boot_size>>  9,
>> -                                        true,
>> -                                        "boot1");
>> -               if (ret)
>> -                       return ret;
>> +       for (i = 0; i<  MMC_MAX_NUM_PHY_PARTITION; i++) {
>> +               if (card->part[i].size) {
>> +                       ret = mmc_blk_alloc_part(card, md,
>> card->part[i].cookie,
>> +                               card->part[i].size>>  9,
>> +                               card->part[i].force_ro,
>> +                               card->part[i].name);
>> +                       if (ret)
>> +                               return ret;
>> +               }
>>        }
>>
>>        return ret;
>> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
>> index 5700b1c..56c4b9e 100644
>> --- a/drivers/mmc/core/mmc.c
>> +++ b/drivers/mmc/core/mmc.c
>> @@ -340,7 +340,18 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8
>> *ext_csd)
>>                 * There are two boot regions of equal size, defined in
>>                 * multiples of 128K.
>>                 */
>> -               card->ext_csd.boot_size = ext_csd[EXT_CSD_BOOT_MULT]<<
>>  17;
>> +               int i, boot_part_config;
>> +               if (ext_csd[EXT_CSD_BOOT_MULT]) {
>> +                       for (i = 0, boot_part_config = 0x1;
>> +                               i<  MMC_NUM_BOOT_PARTITION;
>> +                               i++, boot_part_config++) {
>> +                               card->part[i].size =
>> +                                       ext_csd[EXT_CSD_BOOT_MULT]<<  17;
>> +                               card->part[i].cookie = boot_part_config;
>> +                               sprintf(card->part[i].name, "boot%d", i);
>> +                               card->part[i].force_ro = true;
>> +                       }
>> +               }
>>        }
>>
>>        card->ext_csd.raw_hc_erase_gap_size =
>> @@ -392,6 +403,39 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8
>> *ext_csd)
>>                        card->ext_csd.enhanced_area_offset = -EINVAL;
>>                        card->ext_csd.enhanced_area_size = -EINVAL;
>>                }
>> +
>> +               if (ext_csd[EXT_CSD_PARTITION_SUPPORT]&  0x1) {
>> +                       u8 hc_erase_grp_sz =
>> +                               ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
>> +                       u8 hc_wp_grp_sz =
>> +                               ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
>> +
>> +                       card->ext_csd.enhanced_area_en = 1;
>> +
>> +                       int i, gp_num, gp_part_config, gp_size_mult;
>> +                       for (i = 2, gp_num = 1, gp_part_config = 0x4,
>> +                               gp_size_mult = 143;
>> +                               i<  MMC_MAX_NUM_PHY_PARTITION;
>> +                               i++, gp_num++, gp_part_config++,
>> +                               gp_size_mult += 3) {
>> +                                       if (!ext_csd[gp_size_mult]&&
>> +                                               !ext_csd[gp_size_mult +
>> 1]&&
>> +                                               !ext_csd[gp_size_mult +
>> 2])
>> +                                               continue;
>> +                               card->part[i].size =
>> +                                       (ext_csd[gp_size_mult + 2]<<  16)
>> +
>> +                                       (ext_csd[gp_size_mult + 1]<<  8) +
>> +                                       ext_csd[gp_size_mult];
>> +                               card->part[i].size *=
>> +                                       (size_t)(hc_erase_grp_sz *
>> +                                       hc_wp_grp_sz);
>> +                               card->part[i].size<<= 19;
>> +                               card->part[i].cookie = gp_part_config;
>> +                               sprintf(card->part[i].name,
>> +                                       "gp%d", gp_num);
>> +                               card->part[i].force_ro = false;
>> +                       }
>> +               }
>>                card->ext_csd.sec_trim_mult =
>>                        ext_csd[EXT_CSD_SEC_TRIM_MULT];
>>                card->ext_csd.sec_erase_mult =
>> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
>> index b460fc2..842f702 100644
>> --- a/include/linux/mmc/card.h
>> +++ b/include/linux/mmc/card.h
>> @@ -12,6 +12,7 @@
>>
>>  #include<linux/mmc/core.h>
>>  #include<linux/mod_devicetable.h>
>> +#include<linux/genhd.h>
>>
>>  struct mmc_cid {
>>        unsigned int            manfid;
>> @@ -63,7 +64,6 @@ struct mmc_ext_csd {
>>        bool                    enhanced_area_en;       /* enable bit */
>>        unsigned long long      enhanced_area_offset;   /* Units: Byte */
>>        unsigned int            enhanced_area_size;     /* Units: KB */
>> -       unsigned int            boot_size;              /* in bytes */
>>        u8                      raw_partition_support;  /* 160 */
>>        u8                      raw_erased_mem_count;   /* 181 */
>>        u8                      raw_ext_csd_structure;  /* 194 */
>> @@ -157,6 +157,22 @@ struct sdio_func_tuple;
>>
>>  #define SDIO_MAX_FUNCS                7
>>
>> +/* The number of MMC physical partitions
>> + * It consist of boot partitions(2), general purpose partitions(4) in MMC
>> v4.4
>> + */
>> +#define MMC_NUM_BOOT_PARTITION 2
>> +#define MMC_MAX_NUM_PHY_PARTITION      6
>> +
>> +/*
>> + * MMC Physical partitions
>> + */
>> +struct mmc_part {
>> +       unsigned int    size;   /* partition size (in bytes) */
>> +       unsigned int    cookie; /* it used to part_type */
>> +       char    name[DISK_NAME_LEN];
>> +       bool    force_ro;       /* to make boot parts RO by default */
>> +};
>> +
>>  /*
>>   * MMC device
>>   */
>> @@ -216,6 +232,7 @@ struct mmc_card {
>>        unsigned int            sd_bus_speed;   /* Bus Speed Mode set for
>> the card */
>>
>>        struct dentry           *debugfs_root;
>> +       struct  mmc_part part[MMC_MAX_NUM_PHY_PARTITION];       /* mmc
>> physical partitions */
>>  };
>>
>>  /*
>> diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
>> index 5a794cb..33eae3d 100644
>> --- a/include/linux/mmc/mmc.h
>> +++ b/include/linux/mmc/mmc.h
>> @@ -301,8 +301,6 @@ struct _mmc_csd {
>>  #define EXT_CSD_WR_REL_PARAM_EN               (1<<2)
>>
>>  #define EXT_CSD_PART_CONFIG_ACC_MASK  (0x7)
>> -#define EXT_CSD_PART_CONFIG_ACC_BOOT0  (0x1)
>> -#define EXT_CSD_PART_CONFIG_ACC_BOOT1  (0x2)
>>
>>  #define EXT_CSD_CMD_SET_NORMAL                (1<<0)
>>  #define EXT_CSD_CMD_SET_SECURE                (1<<1)
>
>
> --
> J (James/Jay) Freyensee
> Storage Technology Group
> Intel Corporation
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
