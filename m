Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab2FLNFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:05:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15623 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2FLNFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:05:42 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-54-4fd73ea44e4c
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'S, Venkatraman'" <svenkatr@ti.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Chris Ball'" <cjb@laptop.org>, "'Maya Erez'" <merez@codeaurora.org>,
        "'Subhash Jadavani'" <subhashj@codeaurora.org>
References: <000601cd47ab$8ad77c50$a08674f0$%jun@samsung.com>
 <CANfBPZ9dwwAOBbXPqGV64k-sB-MzRtTO8x7tXnZBjtYN+V88XQ@mail.gmail.com>
In-reply-to: <CANfBPZ9dwwAOBbXPqGV64k-sB-MzRtTO8x7tXnZBjtYN+V88XQ@mail.gmail.com>
Subject: RE: [PATCH v7 1/3] mmc: core: Add packed command feature of eMMC4.5
Date: Tue, 12 Jun 2012 22:05:40 +0900
Message-id: <000001cd489c$115f03b0$341d0b10$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1IUtymiENcPPJFR3CfD1Xs6EGq1gANQRHg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd0ldtf9DfoPW1hc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKezJ3HWPDWrWLp6gvMDYx9Fl2MnBwSAiYSi7/PZ4Ww
	xSQu3FvP1sXIxSEksIhRYtXt1VDOH0aJL383sYFUsQloSfx984YZxBYR0JDYOWUFWJxZYAOj
	xN8tmhANLYwSZw6+AyviFAiW2LRjHTuILSzgI3Fj8xMWEJtFQFViVfdcsDivgK3EsbutzBC2
	oMSPyfdYIIbqSXz8c5sRwtaWePLuAtCpHECnqks8+qsLcYORxPrONqgSEYl9L94xTmAUmoVk
	0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFB/Ux6B+OqBotDjAIc
	jEo8vAssrvsLsSaWFVfmHmKU4GBWEuGtZgAK8aYkVlalFuXHF5XmpBYfYpTmYFES522yvuAv
	JJCeWJKanZpakFoEk2Xi4JRqYKy4vsrbYmXGHPEJd/8dnHeGt3S766QpgXZZz6VaW34mFKhu
	+ew42+K6LWtUkU1WhhzfWxYZSfNk3b82Xe/LJd53f0yLe7TSxHpidPF+GXeBK9w/s89OVPQR
	r3cRu/mPhddqoYue/Afmuae6dKoyOqrWuFcZ6D7Z+2bu78+SBuqPdPULDs9TV2Ipzkg01GIu
	Kk4EAAT7Ig9mAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S, Venkatraman <svenkatr@ti.com> wrote:
> On Mon, Jun 11, 2012 at 1:53 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > This patch adds packed command feature of eMMC4.5.
> > The maximum number for packing read(or write) is offered
> > and exception event relevant to packed command which is
> > used for error handling is enabled. If host wants to use
> > this feature, MMC_CAP2_PACKED_CMD should be set.
> >
> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> 
> Can you please post some clear performance benchmarks with your patchset ?
> Given that #merez claims to see a significant performance drop for
> reads, it will be
> good to compare notes.
> If it's not too much trouble, both CFQ and deadline scheduler figures
> would be useful, on a
> set of read only, write only and parallel read write usecases.
> 
> I can also try to replicate your results if you can publish the exact
> configuration you used
> for testing (example: iozone parameters)
I'm checking the merez's result.
Currently packed command is effective on write.
When running packed write with iozone, there is 25% performance gains.
(ex: iozone -az -i0 -I -s 10m -f /target/test -e)

> 
> > ---
> >  drivers/mmc/core/mmc.c   |   24 ++++++++++++++++++++++++
> >  include/linux/mmc/card.h |    3 +++
> >  include/linux/mmc/host.h |    4 ++++
> >  include/linux/mmc/mmc.h  |   15 +++++++++++++++
> >  4 files changed, 46 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> > index 258b203..f9d54b0 100644
> > --- a/drivers/mmc/core/mmc.c
> > +++ b/drivers/mmc/core/mmc.c
> > @@ -516,6 +516,11 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
> >                } else {
> >                        card->ext_csd.data_tag_unit_size = 0;
> >                }
> > +
> > +               card->ext_csd.max_packed_writes =
> > +                       ext_csd[EXT_CSD_MAX_PACKED_WRITES];
> > +               card->ext_csd.max_packed_reads =
> > +                       ext_csd[EXT_CSD_MAX_PACKED_READS];
> >        } else {
> >                card->ext_csd.data_sector_size = 512;
> >        }
> > @@ -1246,6 +1251,25 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
> >                }
> >        }
> >
> > +       if ((host->caps2 & MMC_CAP2_PACKED_CMD) &&
> > +                       ((card->ext_csd.max_packed_writes > 0) ||
> > +                       (card->ext_csd.max_packed_reads > 0))) {
> > +               err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> > +                               EXT_CSD_EXP_EVENTS_CTRL,
> > +                               EXT_CSD_PACKED_EVENT_EN,
> > +                               card->ext_csd.generic_cmd6_time);
> > +               if (err && err != -EBADMSG)
> > +                       goto free_card;
> > +               if (err) {
> > +                       pr_warning("%s: Enabling packed event failed\n",
> > +                                       mmc_hostname(card->host));
> > +                       card->ext_csd.packed_event_en = 0;
> > +                       err = 0;
> > +               } else {
> > +                       card->ext_csd.packed_event_en = 1;
> > +               }
> > +       }
> > +
> >        if (!oldcard)
> >                host->card = card;
> >
> > diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> > index d76513b..4aeb4e9 100644
> > --- a/include/linux/mmc/card.h
> > +++ b/include/linux/mmc/card.h
> > @@ -53,6 +53,9 @@ struct mmc_ext_csd {
> >        u8                      part_config;
> >        u8                      cache_ctrl;
> >        u8                      rst_n_function;
> > +       u8                      max_packed_writes;
> > +       u8                      max_packed_reads;
> > +       u8                      packed_event_en;
> >        unsigned int            part_time;              /* Units: ms */
> >        unsigned int            sa_timeout;             /* Units: 100ns */
> >        unsigned int            generic_cmd6_time;      /* Units: 10ms */
> > diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> > index 0707d22..9d0d946 100644
> > --- a/include/linux/mmc/host.h
> > +++ b/include/linux/mmc/host.h
> > @@ -238,6 +238,10 @@ struct mmc_host {
> >  #define MMC_CAP2_BROKEN_VOLTAGE        (1 << 7)        /* Use the broken voltage */
> >  #define MMC_CAP2_DETECT_ON_ERR (1 << 8)        /* On I/O err check card removal */
> >  #define MMC_CAP2_HC_ERASE_SZ   (1 << 9)        /* High-capacity erase size */
> > +#define MMC_CAP2_PACKED_RD     (1 << 10)       /* Allow packed read */
> > +#define MMC_CAP2_PACKED_WR     (1 << 11)       /* Allow packed write */
> > +#define MMC_CAP2_PACKED_CMD    (MMC_CAP2_PACKED_RD | \
> > +                                MMC_CAP2_PACKED_WR) /* Allow packed commands */
> >
> >        mmc_pm_flag_t           pm_caps;        /* supported pm features */
> >        unsigned int        power_notify_type;
> > diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
> > index d425cab..254901a 100644
> > --- a/include/linux/mmc/mmc.h
> > +++ b/include/linux/mmc/mmc.h
> > @@ -139,6 +139,7 @@ static inline bool mmc_op_multi(u32 opcode)
> >  #define R1_CURRENT_STATE(x)    ((x & 0x00001E00) >> 9) /* sx, b (4 bits) */
> >  #define R1_READY_FOR_DATA      (1 << 8)        /* sx, a */
> >  #define R1_SWITCH_ERROR                (1 << 7)        /* sx, c */
> > +#define R1_EXP_EVENT           (1 << 6)        /* sr, a */
> >  #define R1_APP_CMD             (1 << 5)        /* sr, c */
> >
> >  #define R1_STATE_IDLE  0
> > @@ -274,6 +275,10 @@ struct _mmc_csd {
> >  #define EXT_CSD_FLUSH_CACHE            32      /* W */
> >  #define EXT_CSD_CACHE_CTRL             33      /* R/W */
> >  #define EXT_CSD_POWER_OFF_NOTIFICATION 34      /* R/W */
> > +#define EXT_CSD_PACKED_FAILURE_INDEX   35      /* RO */
> > +#define EXT_CSD_PACKED_CMD_STATUS      36      /* RO */
> > +#define EXT_CSD_EXP_EVENTS_STATUS      54      /* RO, 2 bytes */
> > +#define EXT_CSD_EXP_EVENTS_CTRL        56      /* R/W, 2 bytes */
> >  #define EXT_CSD_DATA_SECTOR_SIZE       61      /* R */
> >  #define EXT_CSD_GP_SIZE_MULT           143     /* R/W */
> >  #define EXT_CSD_PARTITION_ATTRIBUTE    156     /* R/W */
> > @@ -318,6 +323,8 @@ struct _mmc_csd {
> >  #define EXT_CSD_CACHE_SIZE             249     /* RO, 4 bytes */
> >  #define EXT_CSD_TAG_UNIT_SIZE          498     /* RO */
> >  #define EXT_CSD_DATA_TAG_SUPPORT       499     /* RO */
> > +#define EXT_CSD_MAX_PACKED_WRITES      500     /* RO */
> > +#define EXT_CSD_MAX_PACKED_READS       501     /* RO */
> >  #define EXT_CSD_HPI_FEATURES           503     /* RO */
> >
> >  /*
> > @@ -377,6 +384,14 @@ struct _mmc_csd {
> >  #define EXT_CSD_PWR_CL_4BIT_MASK       0x0F    /* 8 bit PWR CLS */
> >  #define EXT_CSD_PWR_CL_8BIT_SHIFT      4
> >  #define EXT_CSD_PWR_CL_4BIT_SHIFT      0
> > +
> > +#define EXT_CSD_PACKED_EVENT_EN        (1 << 3)
> > +
> > +#define EXT_CSD_PACKED_FAILURE (1 << 3)
> > +
> > +#define EXT_CSD_PACKED_GENERIC_ERROR   (1 << 0)
> > +#define EXT_CSD_PACKED_INDEXED_ERROR   (1 << 1)
> > +
> >  /*
> >  * MMC_SWITCH access modes
> >  */
> > --
> > 1.7.0.4
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

