Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab1IVXP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 19:15:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49841 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab1IVXPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 19:15:53 -0400
MIME-Version: 1.0
In-Reply-To: <4E7BB1D3.6020208@linux.intel.com>
References: <1316705680-1940-1-git-send-email-linkinjeon@gmail.com>
	<4E7BB1D3.6020208@linux.intel.com>
Date: Fri, 23 Sep 2011 08:15:51 +0900
Message-ID: <CAKYAXd-ABNyB53r01f=J4jNxxqVLfKi1nFbBPifZMPXNYnFZ-w@mail.gmail.com>
Subject: Re: [PATCH] mmc : general purpose partition support.
From: NamJae Jeon <linkinjeon@gmail.com>
To: J Freyensee <james_p_freyensee@linux.intel.com>
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8MNGB4i001528

2011/9/23 J Freyensee <james_p_freyensee@linux.intel.com>:
> On 09/22/2011 08:34 AM, Namjae Jeon wrote:
>>
>> It allows general purpose parition in MMC Device. If it is enable, it will
>> make mmcblk0gp1,gp2,gp3,gp4 partition like this.
>>
>>> cat /proc/paritition
>>
>>       179 0 847872 mmcblk0
>>       179 192 4096 mmcblk0gp4
>>       179 160 4096 mmcblk0gp3
>>       179 128 4096 mmcblk0gp2
>>       179 96  1052672 mmcblk0gp1
>>       179 64  1024 mmcblk0boot1
>>       179 32  1024 mmcblk0boot0
>>
>> Signed-off-by: Namjae Jeon<linkinjeon@gmail.com>
>> ---
>>  drivers/mmc/card/block.c |   36 ++++++++++++++++++++++++++++++++++++
>>  drivers/mmc/core/mmc.c   |   42
>> ++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/mmc/card.h |    4 ++++
>>  include/linux/mmc/mmc.h  |    4 ++++
>>  4 files changed, 86 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
>> index 9b90726..074ec55 100644
>> --- a/drivers/mmc/card/block.c
>> +++ b/drivers/mmc/card/block.c
>> @@ -1402,6 +1402,42 @@ static int mmc_blk_alloc_parts(struct mmc_card
>> *card, struct mmc_blk_data *md)
>>                        return ret;
>>        }
>>
>> +       if (card->ext_csd.gp1_size) {
>> +               ret = mmc_blk_alloc_part(card, md,
>> EXT_CSD_PART_CONFIG_ACC_GP1,
>> +                                       card->ext_csd.gp1_size>>  9,
>> +                                       false,
>> +                                       "gp1");
>> +               if (ret)
>> +                       return ret;
>> +       }
>> +
>
> if mmc_blk_alloc_part() fails for 'if (card->ext_csd.pt1_size)', why would
> you want to give this code the opportunity to call mmc_blk_alloc_part()
> again with the next if() below?  If mmc_blk_alloc_part() fails, is it a big
> problem, like kzalloc() failing?  If so, I would think you would want to
> immediately quit this function and report an error (either use errno value
> or pass the value of ret).
-> if card->ext_csd.gp1_size is no zero, it means general purpose
partition is enable.
and it can set up to 4 partition in specification. so we should check
it by next if().

>
>> +       if (card->ext_csd.gp2_size) {
>> +               ret = mmc_blk_alloc_part(card, md,
>> EXT_CSD_PART_CONFIG_ACC_GP2,
>> +                                       card->ext_csd.gp2_size>>  9,
>> +                                       false,
>> +                                       "gp2");
>> +               if (ret)
>> +                       return ret;
>> +       }
>> +
>> +       if (card->ext_csd.gp3_size) {
>> +               ret = mmc_blk_alloc_part(card, md,
>> EXT_CSD_PART_CONFIG_ACC_GP3,
>> +                                       card->ext_csd.gp3_size>>  9,
>> +                                       false,
>> +                                       "gp3");
>> +               if (ret)
>> +                       return ret;
>> +       }
>> +
>> +       if (card->ext_csd.gp4_size) {
>> +               ret = mmc_blk_alloc_part(card, md,
>> EXT_CSD_PART_CONFIG_ACC_GP4,
>> +                                       card->ext_csd.gp4_size>>  9,
>> +                                       false,
>> +                                       "gp4");
>> +               if (ret)
>> +                       return ret;
>> +       }
>> +
>>        return ret;
>>  }
>>
>> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
>> index 10f5a19..cc31511 100644
>> --- a/drivers/mmc/core/mmc.c
>> +++ b/drivers/mmc/core/mmc.c
>> @@ -393,6 +393,48 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8
>> *ext_csd)
>>                        card->ext_csd.enhanced_area_offset = -EINVAL;
>>                        card->ext_csd.enhanced_area_size = -EINVAL;
>>                }
>> +
>> +               /*
>> +                * General purpose partition Support
>> +                */
>> +
>> +               if (ext_csd[EXT_CSD_PARTITION_SUPPORT]&  0x1) {
>> +
>> +                       u8 hc_erase_grp_sz =
>> +                               ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
>> +                       u8 hc_wp_grp_sz =
>> +                               ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
>> +
>> +                       card->ext_csd.enhanced_area_en = 1;
>> +
>> +                       card->ext_csd.gp1_size =
>> +                               (ext_csd[145]<<  16) + (ext_csd[144]<<  8)
>> +
>> +                               ext_csd[143];
>> +                       card->ext_csd.gp1_size *=
>> +                               (size_t)(hc_erase_grp_sz * hc_wp_grp_sz);
>> +                       card->ext_csd.gp1_size<<= 19;
>> +
>> +                       card->ext_csd.gp2_size =
>> +                               (ext_csd[148]<<  16) + (ext_csd[147]<<  8)
>> +
>> +                               ext_csd[146];
>> +                       card->ext_csd.gp2_size *=
>> +                               (size_t)(hc_erase_grp_sz * hc_wp_grp_sz);
>> +                               card->ext_csd.gp2_size<<= 19;
>> +
>> +                       card->ext_csd.gp3_size =
>> +                               (ext_csd[151]<<  16) + (ext_csd[150]<<  8)
>> +
>> +                               ext_csd[149];
>> +                       card->ext_csd.gp3_size *=
>> +                               (size_t)(hc_erase_grp_sz * hc_wp_grp_sz);
>> +                       card->ext_csd.gp3_size<<= 19;
>> +
>> +                       card->ext_csd.gp4_size =
>> +                               (ext_csd[154]<<  16) + (ext_csd[153]<<  8)
>> +
>> +                               ext_csd[152];
>> +                       card->ext_csd.gp4_size *=
>> +                               (size_t)(hc_erase_grp_sz * hc_wp_grp_sz);
>> +                       card->ext_csd.gp4_size<<= 19;
>> +               }
>>                card->ext_csd.sec_trim_mult =
>>                        ext_csd[EXT_CSD_SEC_TRIM_MULT];
>>                card->ext_csd.sec_erase_mult =
>> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
>> index b460fc2..96a98a7 100644
>> --- a/include/linux/mmc/card.h
>> +++ b/include/linux/mmc/card.h
>> @@ -64,6 +64,10 @@ struct mmc_ext_csd {
>>        unsigned long long      enhanced_area_offset;   /* Units: Byte */
>>        unsigned int            enhanced_area_size;     /* Units: KB */
>>        unsigned int            boot_size;              /* in bytes */
>> +       unsigned int            gp1_size;               /* in bytes */
>> +       unsigned int            gp2_size;               /* in bytes */
>> +       unsigned int            gp3_size;               /* in bytes */
>> +       unsigned int            gp4_size;               /* in bytes */
>>        u8                      raw_partition_support;  /* 160 */
>>        u8                      raw_erased_mem_count;   /* 181 */
>>        u8                      raw_ext_csd_structure;  /* 194 */
>> diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
>> index 5a794cb..380720a 100644
>> --- a/include/linux/mmc/mmc.h
>> +++ b/include/linux/mmc/mmc.h
>> @@ -303,6 +303,10 @@ struct _mmc_csd {
>>  #define EXT_CSD_PART_CONFIG_ACC_MASK  (0x7)
>>  #define EXT_CSD_PART_CONFIG_ACC_BOOT0 (0x1)
>>  #define EXT_CSD_PART_CONFIG_ACC_BOOT1 (0x2)
>> +#define EXT_CSD_PART_CONFIG_ACC_GP1    (0x4)
>> +#define EXT_CSD_PART_CONFIG_ACC_GP2    (0x5)
>> +#define EXT_CSD_PART_CONFIG_ACC_GP3    (0x6)
>> +#define EXT_CSD_PART_CONFIG_ACC_GP4    (0x7)
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
