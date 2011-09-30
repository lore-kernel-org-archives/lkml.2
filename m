Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1I3X1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 19:27:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49960 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814Ab1I3X1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 19:27:21 -0400
MIME-Version: 1.0
In-Reply-To: <CANz0V+474_SvriQmUWx9VJwAk-iggu-h+A1WH-zGPBJgLzJDAg@mail.gmail.com>
References: <1317397619-7091-1-git-send-email-linkinjeon@gmail.com>
	<CANz0V+474_SvriQmUWx9VJwAk-iggu-h+A1WH-zGPBJgLzJDAg@mail.gmail.com>
Date: Sat, 1 Oct 2011 08:27:19 +0900
Message-ID: <CAKYAXd8cH5r8meTbTiEWNQAv5pmEwaL=T4=ZQOd+Bd99zLUusQ@mail.gmail.com>
Subject: Re: [PATCH v4] mmc : general purpose partition support.
From: NamJae Jeon <linkinjeon@gmail.com>
To: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        awarkentin@vmware.com, adrian.hunter@intel.com,
        linus.walleij@linaro.org, james_p_freyensee@linux.intel.com,
        sebras@gmail.com, Ulf.Hansson@stericsson.com,
        stefan.xk.nilsson@stericsson.com, per.forlin@stericsson.com,
        johan.rudholm@stericsson.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8UNRtxx015687

2011/10/1 Andrei E. Warkentin <andrey.warkentin@gmail.com>:
> Hi Namjae,
>
> Why don't you update card->nr_parts inside mmc_part_add? You're making
> this too complicated. There
> is also no need for the part_cfg array.
>
> 2011/9/30 Namjae Jeon <linkinjeon@gmail.com>:
>> It allows gerneral purpose partitions in MMC Device.
>> And I try to simpliy make mmc_blk_alloc_parts using mmc_part structure suggested by Andrei Warkentin.
>> After patching, we can see general purpose partitions like this.
>>> cat /proc/partitions
>>          179 0 847872 mmcblk0
>>          179 192 4096 mmcblk0gp3
>>          179 160 4096 mmcblk0gp2
>>          179 128 4096 mmcblk0gp1
>>          179 96  1052672 mmcblk0gp0
>>          179 64  1024 mmcblk0boot1
>>          179 32  1024 mmcblk0boot0
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> ---
>
>>
>> +/* partition configuration array */
>> +static const unsigned int part_cfg[] = {
>> +       0x1,    0x2,    0x4,    0x5,    0x6,    7,
>> +};
>> +
>
> No need. Plus this is obscure.
>
>> -               card->ext_csd.boot_size = ext_csd[EXT_CSD_BOOT_MULT] << 17;
>> +               if (ext_csd[EXT_CSD_BOOT_MULT]) {
>> +                       card->nr_parts = MMC_NUM_BOOT_PARTITION;
>> +                       for (idx = 0, part_num = 0;
>> +                               idx < MMC_NUM_BOOT_PARTITION; idx++,
>> +                               part_num++) {
>> +                               part_size = ext_csd[EXT_CSD_BOOT_MULT] << 17;
>> +                               mmc_part_add(card, part_size, part_cfg[idx],
>> +                                       "boot%d", idx, part_num, true);
>> +                       }
>> +               }
>>        }
>
> There is no need for part_num (you have idx for that). And there is no
> need for passing the actual array
> index either - that's why you have mmc_part_add: it will do
> card->parts[card->nr_parts++] = new_part.
>
>               if (ext_csd[EXT_CSD_BOOT_MULT]) {
>                       for (idx = 0, part_num = 0;
>                               idx < MMC_NUM_BOOT_PARTITION; idx++) {
>                               part_size = ext_csd[EXT_CSD_BOOT_MULT] << 17;
>                               mmc_part_add(card, part_size,
> EXT_CSD_PART_CONFIG_ACC_BOOT0 + idx,
>                                       "boot%d", idx, true);
>                       }
>               }
>
>
>> +               if (ext_csd[EXT_CSD_PARTITION_SUPPORT] & 0x1) {
>> +                       u8 hc_erase_grp_sz =
>> +                               ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
>> +                       u8 hc_wp_grp_sz =
>> +                               ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
>> +
>> +                       card->ext_csd.enhanced_area_en = 1;
>> +
>> +                       card->nr_parts += MMC_NUM_GP_PARTITION;
>> +                       for (part_num = 0, gp_size_mult = 143;
>> +                               idx < card->nr_parts;
>> +                               idx++, part_num++, gp_size_mult += 3) {
>> +                               if (!ext_csd[gp_size_mult] &&
>> +                                       !ext_csd[gp_size_mult + 1] &&
>> +                                       !ext_csd[gp_size_mult + 2])
>> +                                       continue;
>> +                               part_size = (ext_csd[gp_size_mult + 2] << 16) +
>> +                                       (ext_csd[gp_size_mult + 1] << 8) +
>> +                                       ext_csd[gp_size_mult];
>> +                               part_size *= (size_t)(hc_erase_grp_sz *
>> +                                       hc_wp_grp_sz);
>> +                               part_size <<= 19;
>> +                               mmc_part_add(card, part_size, part_cfg[idx],
>> +                                       "gp%d", idx, part_num, false);
>> +                       }
>> +               }
>
> Same story: get rid of part_num, don't touch card->nr_parts, and get
> rid of part_cfg array access.
>
>                       card->ext_csd.enhanced_area_en = 1;
>                       for (idx = 0, gp_size_mult = 143;
>                               idx < MMC_NUM_GP_PARTITION;
>                               idx++, gp_size_mult += 3) {
>                               if (!ext_csd[gp_size_mult] &&
>                                       !ext_csd[gp_size_mult + 1] &&
>                                       !ext_csd[gp_size_mult + 2])
>                                       continue;
>                               part_size = (ext_csd[gp_size_mult + 2] << 16) +
>                                       (ext_csd[gp_size_mult + 1] << 8) +
>                                       ext_csd[gp_size_mult];
>                               part_size *= (size_t)(hc_erase_grp_sz *
>                                       hc_wp_grp_sz);
>                               part_size <<= 19;
>                               mmc_part_add(card, part_size, idx +
> EXT_CSD_PART_CONFIG_ACC_GP0,
>                                       "gp%d", idx, false);
>                       }
>               }
>
>
>>  /*
>> + * This function fill contents in mmc_part.
>> + */
>> +static inline void mmc_part_add(struct mmc_card *card, unsigned int size,
>> +       unsigned int part_cfg, char *name, int idx, int part_num, bool ro)
>> +{
>> +       card->part[idx].size = size;
>> +       card->part[idx].cookie = part_cfg;
>> +       sprintf(card->part[idx].name, name, part_num);
>> +       card->part[idx].force_ro = ro;
>> +}
>
> static inline void mmc_part_add(struct mmc_card *card, unsigned int size,
>       unsigned int part_cfg, char *name, int idx, bool ro)
> {
>       card->part[card->nr_parts].size = size;
>       card->part[card->nr_parts].cookie = part_cfg;
>       sprintf(card->part[card->nr_parts].name, name, idx);
>       card->part[card->nr_parts].force_ro = ro;
>       card->nr_parts++;
> }
>
>>  #define EXT_CSD_PART_CONFIG_ACC_MASK   (0x7)
>> -#define EXT_CSD_PART_CONFIG_ACC_BOOT0  (0x1)
>> -#define EXT_CSD_PART_CONFIG_ACC_BOOT1  (0x2)
>>
>
> I'd also keep the MMC_NUM_BOOT_PARTITION and MMC_NUM_GP_PARTITION defs
> at the same location.
Why should this def move to mmc.h ?
this area where there are ext csd fields.
>
> /* The number of MMC physical partitions
>  * It consist of boot partitions(2), general purpose partitions(4) in MMC v4.4
>  */
> #define MMC_NUM_BOOT_PARTITION 2
> #define MMC_NUM_GP_PARTITION   4
>
> #define EXT_CSD_PART_CONFIG_ACC_BOOT0  (0x1)
> #define EXT_CSD_PART_CONFIG_ACC_GP0       (0x4)
>
> A
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
