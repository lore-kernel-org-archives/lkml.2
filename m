Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0FCWHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 18:07:21 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39274 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0FCWHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 18:07:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZT+DNG+flOQym6Gpju/j26CSajP/Dz56RS+iz/zwR3G748wYXFwqoXJVLNyfXwag5d
         PaDkid5eGJOiUvlKGZLMQXx6NpCsua0GXW1lDywrzqf2m52uwaWQh57pmlmwMMjNumkG
         yO8gIvA4M01OGZwE4/KylkYWDtabyDo9gjr/o=
MIME-Version: 1.0
In-Reply-To: <4C081AF1.4070103@nokia.com>
References: <4C081AF1.4070103@nokia.com>
Date: Fri, 4 Jun 2010 07:07:18 +0900
X-Google-Sender-Auth: qFkUoF4VrFCri2S3jFMbD8nuPEw
Message-ID: <AANLkTinI6ScNcFSRbWL_Oi2E7WUzfHOmSgzdde7xezm7@mail.gmail.com>
Subject: Re: [PATCH 2/4] mmc: Add erase, secure erase, trim and secure trim 
	operations
From: Kyungmin Park <kmpark@infradead.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi adrian,

First thank you for your works. we have to implement it but you did.

Before the code review, can you provide the results of trim effect?
I wonder how much we can gain performance from trim command.

So please give any benchmark result based on vfat or btrfs. since it's
already implemented the discard request.

Thank you,
Kyungmin Park

On Fri, Jun 4, 2010 at 6:13 AM, Adrian Hunter <adrian.hunter@nokia.com> wrote:
> From 8f9a8227c528c3853ee9eef2209cefcf1616ebb3 Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@nokia.com>
> Date: Tue, 1 Jun 2010 13:20:22 +0300
> Subject: [PATCH 2/4] mmc: Add erase, secure erase, trim and secure trim
> operations
>
> As SD and MMC cards have a NAND core, they can support an erase
> operation that is typically 10x to 100x faster than writing.
>
> In addition, eMMCv4.4 also offers:
>       o Secure Erase
>       o Trim
>       o Secure Trim
>
> The "secure" variants also ensure that any copies of the data
> (for example remnants of garbage collection) are also erased.
>
> "Trim" is the same as "erase" except that individual sectors
> can be erased instead of whole Erase Groups.
>
> The erase operation and its variants are not supported by
> default and drivers must set MMC_CAP_ERASE.  This is because
> the operation can take a long time and drivers that rely on
> polling the status may perform very badly.  Also drivers
> may need changes to support the very long erase timeouts.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
> ---
> drivers/mmc/core/core.c   |  330
> +++++++++++++++++++++++++++++++++++++++++++++
> drivers/mmc/core/core.h   |    2 +
> drivers/mmc/core/mmc.c    |   44 ++++++-
> drivers/mmc/core/sd.c     |   81 +++++++++++
> drivers/mmc/core/sd_ops.c |   48 +++++++
> drivers/mmc/core/sd_ops.h |    1 +
> include/linux/mmc/card.h  |   19 +++
> include/linux/mmc/core.h  |   19 +++
> include/linux/mmc/host.h  |    1 +
> include/linux/mmc/mmc.h   |   24 +++-
> include/linux/mmc/sd.h    |    5 +
> 11 files changed, 567 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 569e94d..2627147 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1050,6 +1050,336 @@ void mmc_detect_change(struct mmc_host *host,
> unsigned long delay)
>
> EXPORT_SYMBOL(mmc_detect_change);
>
> +void mmc_init_erase(struct mmc_card *card)
> +{
> +       unsigned int sz;
> +
> +       if (is_power_of_2(card->erase_size))
> +               card->erase_shift = ffs(card->erase_size) - 1;
> +       else
> +               card->erase_shift = 0;
> +
> +       /*
> +        * It is possible to erase an arbitrarily large area of an SD or MMC
> +        * card.  That is not desirable because it can take a long time
> +        * (minutes) potentially delaying more important I/O, and also the
> +        * timeout calculations become increasingly hugely over-estimated.
> +        * Consequently, 'max_erase' is defined as a guide to upper layers
> +        * (i.e. the MMC Block driver) to limit erases to that size and
> +        * alignment.
> +        *
> +        * For SD cards that define Allocation Unit size, limit erases to
> one
> +        * Allocation Unit at a time.  For MMC cards that define High
> Capacity
> +        * Erase Size, whether it is switched on or not, limit to that size.
> +        * Otherwise just have a stab at a good value.  For modern cards it
> +        * will end up being 4MiB.  Note that if the value is too small, it
> +        * can end up taking longer to erase.
> +        */
> +       if (mmc_card_sd(card) && card->ssr.au) {
> +               card->max_erase = card->ssr.au;
> +               card->erase_shift = ffs(card->ssr.au) - 1;
> +       } else if (card->ext_csd.hc_erase_size) {
> +               card->max_erase = card->ext_csd.hc_erase_size;
> +       } else {
> +               sz = (card->csd.capacity << (card->csd.read_blkbits - 9)) >>
> 11;
> +               if (sz < 128)
> +                       card->max_erase = 512 * 1024 / 512;
> +               else if (sz < 512)
> +                       card->max_erase = 1024 * 1024 / 512;
> +               else if (sz < 1024)
> +                       card->max_erase = 2 * 1024 * 1024 / 512;
> +               else
> +                       card->max_erase = 4 * 1024 * 1024 / 512;
> +               if (card->max_erase < card->erase_size)
> +                       card->max_erase = card->erase_size;
> +               else {
> +                       sz = card->max_erase % card->erase_size;
> +                       if (sz)
> +                               card->max_erase += card->erase_size - sz;
> +               }
> +       }
> +}
> +
> +static void mmc_set_mmc_erase_timeout(struct mmc_card *card,
> +                                     struct mmc_command *cmd,
> +                                     unsigned int arg, unsigned int qty)
> +{
> +       unsigned int erase_timeout;
> +
> +       if (card->ext_csd.erase_group_def & 1) {
> +               /* High Capacity Erase Group Size uses HC timeouts */
> +               if (arg == MMC_TRIM_ARG)
> +                       erase_timeout = card->ext_csd.trim_timeout;
> +               else
> +                       erase_timeout = card->ext_csd.hc_erase_timeout;
> +       } else {
> +               /* CSD Erase Group Size uses write timeout */
> +               unsigned int mult = (10 << card->csd.r2w_factor);
> +               unsigned int timeout_clks = card->csd.tacc_clks * mult;
> +               unsigned int timeout_us;
> +
> +               /* Avoid overflow: e.g. tacc_ns=80000000 mult=1280 */
> +               if (card->csd.tacc_ns < 1000000)
> +                       timeout_us = (card->csd.tacc_ns * mult) / 1000;
> +               else
> +                       timeout_us = (card->csd.tacc_ns / 1000) * mult;
> +
> +               /*
> +                * ios.clock is only a target.  The real clock rate might be
> +                * less but not that much less, so fudge it by multiplying
> by 2.
> +                */
> +               timeout_clks <<= 1;
> +               timeout_us += (timeout_clks * 1000) /
> +                             (card->host->ios.clock / 1000);
> +
> +               erase_timeout = timeout_us / 1000;
> +
> +               /*
> +                * Theoretically, the calculation could underflow so round
> up
> +                * to 1ms in that case.
> +                */
> +               if (!erase_timeout)
> +                       erase_timeout = 1;
> +       }
> +
> +       /* Multiplier for secure operations */
> +       if (arg & MMC_SECURE_ARGS) {
> +               if (arg == MMC_SECURE_ERASE_ARG)
> +                       erase_timeout *= card->ext_csd.sec_erase_mult;
> +               else
> +                       erase_timeout *= card->ext_csd.sec_trim_mult;
> +       }
> +
> +       erase_timeout *= qty;
> +
> +       /*
> +        * Ensure at least a 1 second timeout for SPI as per
> +        * 'mmc_set_data_timeout()'
> +        */
> +       if (mmc_host_is_spi(card->host) && erase_timeout < 1000)
> +               erase_timeout = 1000;
> +
> +       cmd->erase_timeout = erase_timeout;
> +}
> +
> +static void mmc_set_sd_erase_timeout(struct mmc_card *card,
> +                                    struct mmc_command *cmd, unsigned int
> arg,
> +                                    unsigned int qty)
> +{
> +       if (card->ssr.erase_timeout) {
> +               /* Erase timeout specified in SD Status Register (SSR) */
> +               cmd->erase_timeout = card->ssr.erase_timeout * qty +
> +                                    card->ssr.erase_offset;
> +       } else {
> +               /*
> +                * Erase timeout not specified in SD Status Register (SSR)
> so
> +                * use 250ms per write block.
> +                */
> +               cmd->erase_timeout = 250 * qty;
> +       }
> +
> +       /* Must not be less than 1 second */
> +       if (cmd->erase_timeout < 1000)
> +               cmd->erase_timeout = 1000;
> +}
> +
> +static void mmc_set_erase_timeout(struct mmc_card *card,
> +                                 struct mmc_command *cmd, unsigned int arg,
> +                                 unsigned int qty)
> +{
> +       if (mmc_card_sd(card))
> +               mmc_set_sd_erase_timeout(card, cmd, arg, qty);
> +       else
> +               mmc_set_mmc_erase_timeout(card, cmd, arg, qty);
> +}
> +
> +static int mmc_do_erase(struct mmc_card *card, unsigned int from,
> +                       unsigned int to, unsigned int arg)
> +{
> +       struct mmc_command cmd;
> +       unsigned int qty = 0;
> +       int err;
> +
> +       /*
> +        * qty is used to calculate the erase timeout which depends on how
> many
> +        * erase groups (or allocation units in SD terminology) are
> affected.
> +        * We count erasing part of an erase group as one erase group.
> +        * For SD, the allocation units are always a power of 2.  For MMC,
> the
> +        * erase group size is almost certainly also power of 2, but it does
> not
> +        * seem to insist on that in the JEDEC standard, so we fall back to
> +        * division in that case.  SD may not specify an allocation unit
> size,
> +        * in which case the timeout is based on the number of write blocks.
> +        *
> +        * Note that the timeout for secure trim 2 will only be correct if
> the
> +        * number of erase groups specified is the same as the total of all
> +        * preceding secure trim 1 commands.  Since the power may have been
> +        * lost since the secure trim 1 commands occurred, it is generally
> +        * impossible to calculate the secure trim 2 timeout correctly.
> +        */
> +       if (card->erase_shift)
> +               qty += ((to >> card->erase_shift) -
> +                       (from >> card->erase_shift)) + 1;
> +       else if (mmc_card_sd(card))
> +               qty += to - from + 1;
> +       else
> +               qty += ((to / card->erase_size) -
> +                       (from / card->erase_size)) + 1;
> +
> +       if (!mmc_card_blockaddr(card)) {
> +               from <<= 9;
> +               to <<= 9;
> +       }
> +
> +       memset(&cmd, 0, sizeof(struct mmc_command));
> +       if (mmc_card_sd(card))
> +               cmd.opcode = SD_ERASE_WR_BLK_START;
> +       else
> +               cmd.opcode = MMC_ERASE_GROUP_START;
> +       cmd.arg = from;
> +       cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_AC;
> +       err = mmc_wait_for_cmd(card->host, &cmd, 0);
> +       if (err) {
> +               printk(KERN_ERR "mmc_erase: group start error %d, "
> +                      "status %#x\n", err, cmd.resp[0]);
> +               err = -EINVAL;
> +               goto out;
> +       }
> +
> +       memset(&cmd, 0, sizeof(struct mmc_command));
> +       if (mmc_card_sd(card))
> +               cmd.opcode = SD_ERASE_WR_BLK_END;
> +       else
> +               cmd.opcode = MMC_ERASE_GROUP_END;
> +       cmd.arg = to;
> +       cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_AC;
> +       err = mmc_wait_for_cmd(card->host, &cmd, 0);
> +       if (err) {
> +               printk(KERN_ERR "mmc_erase: group end error %d, status
> %#x\n",
> +                      err, cmd.resp[0]);
> +               err = -EINVAL;
> +               goto out;
> +       }
> +
> +       memset(&cmd, 0, sizeof(struct mmc_command));
> +       cmd.opcode = MMC_ERASE;
> +       cmd.arg = arg;
> +       cmd.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
> +       mmc_set_erase_timeout(card, &cmd, arg, qty);
> +       err = mmc_wait_for_cmd(card->host, &cmd, 0);
> +       if (err) {
> +               printk(KERN_ERR "mmc_erase: erase error %d, status %#x\n",
> +                      err, cmd.resp[0]);
> +               err = -EIO;
> +               goto out;
> +       }
> +
> +       if (mmc_host_is_spi(card->host))
> +               goto out;
> +
> +       do {
> +               memset(&cmd, 0, sizeof(struct mmc_command));
> +               cmd.opcode = MMC_SEND_STATUS;
> +               cmd.arg = card->rca << 16;
> +               cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
> +               /* Do not retry else we can't see errors */
> +               err = mmc_wait_for_cmd(card->host, &cmd, 0);
> +               if (err || (cmd.resp[0] & 0xFDF92000)) {
> +                       printk(KERN_ERR "error %d requesting status %#x\n",
> +                               err, cmd.resp[0]);
> +                       err = -EIO;
> +                       goto out;
> +               }
> +       } while (!(cmd.resp[0] & R1_READY_FOR_DATA) ||
> +                R1_CURRENT_STATE(cmd.resp[0]) == 7);
> +out:
> +       return err;
> +}
> +
> +/**
> + * mmc_erase - erase sectors.
> + * @card: card to erase
> + * @from: first sector to erase
> + * @nr: number of sectors to erase
> + * @arg: erase command argument (SD supports only %MMC_ERASE_ARG)
> + *
> + * Caller must claim host before calling this function.
> + */
> +int mmc_erase(struct mmc_card *card, unsigned int from, unsigned int nr,
> +             unsigned int arg)
> +{
> +       unsigned int to = from + nr;
> +
> +       if (!(card->host->caps & MMC_CAP_ERASE) ||
> +           !(card->csd.cmdclass & CCC_ERASE))
> +               return -EOPNOTSUPP;
> +
> +       if (!card->erase_size)
> +               return -EOPNOTSUPP;
> +
> +       if (mmc_card_sd(card) && arg != MMC_ERASE_ARG)
> +               return -EOPNOTSUPP;
> +
> +       if ((arg & MMC_SECURE_ARGS) &&
> +           !(card->ext_csd.sec_feature_support & EXT_CSD_SEC_ER_EN))
> +               return -EOPNOTSUPP;
> +
> +       if ((arg & MMC_TRIM_ARGS) &&
> +           !(card->ext_csd.sec_feature_support & EXT_CSD_SEC_GB_CL_EN))
> +               return -EOPNOTSUPP;
> +
> +       if (arg == MMC_ERASE_ARG || arg == MMC_SECURE_ERASE_ARG) {
> +               if (from % card->erase_size || nr % card->erase_size)
> +                       return -EINVAL;
> +       }
> +
> +       if (nr == 0)
> +               return 0;
> +
> +       if (to <= from)
> +               return -EINVAL;
> +
> +       /* 'from' and 'to' are inclusive */
> +       to -= 1;
> +
> +       return mmc_do_erase(card, from, to, arg);
> +}
> +EXPORT_SYMBOL(mmc_erase);
> +
> +int mmc_can_erase(struct mmc_card *card)
> +{
> +       if ((card->host->caps & MMC_CAP_ERASE) &&
> +           (card->csd.cmdclass & CCC_ERASE) && card->erase_size)
> +               return 1;
> +       return 0;
> +}
> +EXPORT_SYMBOL(mmc_can_erase);
> +
> +int mmc_can_trim(struct mmc_card *card)
> +{
> +       if (card->ext_csd.sec_feature_support & EXT_CSD_SEC_GB_CL_EN)
> +               return 1;
> +       return 0;
> +}
> +EXPORT_SYMBOL(mmc_can_trim);
> +
> +int mmc_can_secure_erase_trim(struct mmc_card *card)
> +{
> +       if (card->ext_csd.sec_feature_support & EXT_CSD_SEC_ER_EN)
> +               return 1;
> +       return 0;
> +}
> +EXPORT_SYMBOL(mmc_can_secure_erase_trim);
> +
> +int mmc_erase_group_aligned(struct mmc_card *card, unsigned int from,
> +                           unsigned int nr)
> +{
> +       if (!card->erase_size)
> +               return 0;
> +       if (from % card->erase_size || nr % card->erase_size)
> +               return 0;
> +       return 1;
> +}
> +EXPORT_SYMBOL(mmc_erase_group_aligned);
>
> void mmc_rescan(struct work_struct *work)
> {
> diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
> index a811c52..9d9eef5 100644
> --- a/drivers/mmc/core/core.h
> +++ b/drivers/mmc/core/core.h
> @@ -29,6 +29,8 @@ struct mmc_bus_ops {
> void mmc_attach_bus(struct mmc_host *host, const struct mmc_bus_ops *ops);
> void mmc_detach_bus(struct mmc_host *host);
>
> +void mmc_init_erase(struct mmc_card *card);
> +
> void mmc_set_chip_select(struct mmc_host *host, int mode);
> void mmc_set_clock(struct mmc_host *host, unsigned int hz);
> void mmc_set_bus_mode(struct mmc_host *host, unsigned int mode);
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 89f7a25..9603720 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -108,13 +108,23 @@ static int mmc_decode_cid(struct mmc_card *card)
>        return 0;
> }
>
> +static void mmc_set_erase_size(struct mmc_card *card)
> +{
> +       if (card->ext_csd.erase_group_def & 1)
> +               card->erase_size = card->ext_csd.hc_erase_size;
> +       else
> +               card->erase_size = card->csd.erase_size;
> +
> +       mmc_init_erase(card);
> +}
> +
> /*
>  * Given a 128-bit response, decode to our card CSD structure.
>  */
> static int mmc_decode_csd(struct mmc_card *card)
> {
>        struct mmc_csd *csd = &card->csd;
> -       unsigned int e, m, csd_struct;
> +       unsigned int e, m, a, b, csd_struct;
>        u32 *resp = card->raw_csd;
>
>        /*
> @@ -151,6 +161,12 @@ static int mmc_decode_csd(struct mmc_card *card)
>        csd->write_blkbits = UNSTUFF_BITS(resp, 22, 4);
>        csd->write_partial = UNSTUFF_BITS(resp, 21, 1);
>
> +       a = UNSTUFF_BITS(resp, 42, 5);
> +       b = UNSTUFF_BITS(resp, 37, 5);
> +       csd->erase_size = (a + 1) * (b + 1);
> +       csd->erase_size <<= csd->write_blkbits;
> +       csd->erase_size >>= 9;
> +
>        return 0;
> }
>
> @@ -247,8 +263,30 @@ static int mmc_read_ext_csd(struct mmc_card *card)
>                if (sa_shift > 0 && sa_shift <= 0x17)
>                        card->ext_csd.sa_timeout =
>                                        1 << ext_csd[EXT_CSD_S_A_TIMEOUT];
> +               card->ext_csd.erase_group_def =
> +                       ext_csd[EXT_CSD_ERASE_GROUP_DEF];
> +               card->ext_csd.hc_erase_timeout = 300 *
> +                       ext_csd[EXT_CSD_ERASE_TIMEOUT_MULT];
> +               card->ext_csd.hc_erase_size =
> +                       ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE] << 19;
> +       }
> +
> +       if (card->ext_csd.rev >= 4) {
> +               card->ext_csd.sec_trim_mult =
> +                       ext_csd[EXT_CSD_SEC_TRIM_MULT];
> +               card->ext_csd.sec_erase_mult =
> +                       ext_csd[EXT_CSD_SEC_ERASE_MULT];
> +               card->ext_csd.sec_feature_support =
> +                       ext_csd[EXT_CSD_SEC_FEATURE_SUPPORT];
> +               card->ext_csd.trim_timeout = 300 *
> +                       ext_csd[EXT_CSD_TRIM_MULT];
>        }
>
> +       if (ext_csd[EXT_CSD_ERASED_MEM_CONT])
> +               card->erased_byte = 0xFF;
> +       else
> +               card->erased_byte = 0x0;
> +
> out:
>        kfree(ext_csd);
>
> @@ -260,6 +298,7 @@ MMC_DEV_ATTR(cid, "%08x%08x%08x%08x\n",
> card->raw_cid[0], card->raw_cid[1],
> MMC_DEV_ATTR(csd, "%08x%08x%08x%08x\n", card->raw_csd[0], card->raw_csd[1],
>        card->raw_csd[2], card->raw_csd[3]);
> MMC_DEV_ATTR(date, "%02d/%04d\n", card->cid.month, card->cid.year);
> +MMC_DEV_ATTR(erase_size, "%u\n", card->erase_size);
> MMC_DEV_ATTR(fwrev, "0x%x\n", card->cid.fwrev);
> MMC_DEV_ATTR(hwrev, "0x%x\n", card->cid.hwrev);
> MMC_DEV_ATTR(manfid, "0x%06x\n", card->cid.manfid);
> @@ -271,6 +310,7 @@ static struct attribute *mmc_std_attrs[] = {
>        &dev_attr_cid.attr,
>        &dev_attr_csd.attr,
>        &dev_attr_date.attr,
> +       &dev_attr_erase_size.attr,
>        &dev_attr_fwrev.attr,
>        &dev_attr_hwrev.attr,
>        &dev_attr_manfid.attr,
> @@ -407,6 +447,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>                err = mmc_read_ext_csd(card);
>                if (err)
>                        goto free_card;
> +               /* Erase size depends on CSD and Extended CSD */
> +               mmc_set_erase_size(card);
>        }
>
>        /*
> diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
> index 5eac21d..fe6bc74 100644
> --- a/drivers/mmc/core/sd.c
> +++ b/drivers/mmc/core/sd.c
> @@ -119,6 +119,14 @@ static int mmc_decode_csd(struct mmc_card *card)
>                csd->r2w_factor = UNSTUFF_BITS(resp, 26, 3);
>                csd->write_blkbits = UNSTUFF_BITS(resp, 22, 4);
>                csd->write_partial = UNSTUFF_BITS(resp, 21, 1);
> +
> +               if (UNSTUFF_BITS(resp, 46, 1))
> +                       csd->erase_size = 1;
> +               else {
> +                       csd->erase_size = UNSTUFF_BITS(resp, 39, 7) + 1;
> +                       csd->erase_size <<= csd->write_blkbits;
> +                       csd->erase_size >>= 9;
> +               }
>                break;
>        case 1:
>                /*
> @@ -147,6 +155,7 @@ static int mmc_decode_csd(struct mmc_card *card)
>                csd->r2w_factor = 4; /* Unused */
>                csd->write_blkbits = 9;
>                csd->write_partial = 0;
> +               csd->erase_size = 1;
>                break;
>        default:
>                printk(KERN_ERR "%s: unrecognised CSD structure version
> %d\n",
> @@ -154,6 +163,8 @@ static int mmc_decode_csd(struct mmc_card *card)
>                return -EINVAL;
>        }
>
> +       card->erase_size = csd->erase_size;
> +
>        return 0;
> }
>
> @@ -179,10 +190,68 @@ static int mmc_decode_scr(struct mmc_card *card)
>        scr->sda_vsn = UNSTUFF_BITS(resp, 56, 4);
>        scr->bus_widths = UNSTUFF_BITS(resp, 48, 4);
>
> +       if (UNSTUFF_BITS(resp, 55, 1))
> +               card->erased_byte = 0xFF;
> +       else
> +               card->erased_byte = 0x0;
> +
>        return 0;
> }
>
> /*
> + * Fetch and process SD Status register.
> + */
> +static int mmc_read_ssr(struct mmc_card *card)
> +{
> +       unsigned int au, es, et, eo;
> +       int err, i;
> +       u32 *ssr;
> +
> +       if (!(card->csd.cmdclass & CCC_APP_SPEC)) {
> +               printk(KERN_WARNING "%s: card lacks mandatory SD Status "
> +                       "function.\n", mmc_hostname(card->host));
> +               return 0;
> +       }
> +
> +       ssr = kmalloc(64, GFP_KERNEL);
> +       if (!ssr)
> +               return -ENOMEM;
> +
> +       err = mmc_app_sd_status(card, ssr);
> +       if (err) {
> +               printk(KERN_WARNING "%s: problem reading SD Status "
> +                       "register.\n", mmc_hostname(card->host));
> +               err = 0;
> +               goto out;
> +       }
> +
> +       for (i = 0; i < 16; i++)
> +               ssr[i] = be32_to_cpu(ssr[i]);
> +
> +       /*
> +        * UNSTUFF_BITS only works with four u32s so we have to offset the
> +        * bitfield positions accordingly.
> +        */
> +       au = UNSTUFF_BITS(ssr, 428 - 384, 4);
> +       if (au > 0 || au <= 9) {
> +               card->ssr.au = 1 << (au + 4);
> +               es = UNSTUFF_BITS(ssr, 408 - 384, 16);
> +               et = UNSTUFF_BITS(ssr, 402 - 384, 6);
> +               eo = UNSTUFF_BITS(ssr, 400 - 384, 2);
> +               if (es && et) {
> +                       card->ssr.erase_timeout = (et * 1000) / es;
> +                       card->ssr.erase_offset = eo * 1000;
> +               }
> +       } else {
> +               printk(KERN_WARNING "%s: SD Status: Invalid Allocation Unit
> "
> +                       "size.\n", mmc_hostname(card->host));
> +       }
> +out:
> +       kfree(ssr);
> +       return err;
> +}
> +
> +/*
>  * Fetches and decodes switch information
>  */
> static int mmc_read_switch(struct mmc_card *card)
> @@ -289,6 +358,7 @@ MMC_DEV_ATTR(csd, "%08x%08x%08x%08x\n",
> card->raw_csd[0], card->raw_csd[1],
>        card->raw_csd[2], card->raw_csd[3]);
> MMC_DEV_ATTR(scr, "%08x%08x\n", card->raw_scr[0], card->raw_scr[1]);
> MMC_DEV_ATTR(date, "%02d/%04d\n", card->cid.month, card->cid.year);
> +MMC_DEV_ATTR(erase_size, "%u\n", card->erase_size);
> MMC_DEV_ATTR(fwrev, "0x%x\n", card->cid.fwrev);
> MMC_DEV_ATTR(hwrev, "0x%x\n", card->cid.hwrev);
> MMC_DEV_ATTR(manfid, "0x%06x\n", card->cid.manfid);
> @@ -302,6 +372,7 @@ static struct attribute *sd_std_attrs[] = {
>        &dev_attr_csd.attr,
>        &dev_attr_scr.attr,
>        &dev_attr_date.attr,
> +       &dev_attr_erase_size.attr,
>        &dev_attr_fwrev.attr,
>        &dev_attr_hwrev.attr,
>        &dev_attr_manfid.attr,
> @@ -442,6 +513,16 @@ static int mmc_sd_init_card(struct mmc_host *host, u32
> ocr,
>                        goto free_card;
>
>                /*
> +                * Fetch and process SD Status register.
> +                */
> +               err = mmc_read_ssr(card);
> +               if (err)
> +                       goto free_card;
> +
> +               /* Erase init depends on CSD and SSR */
> +               mmc_init_erase(card);
> +
> +               /*
>                 * Fetch switch information from card.
>                 */
>                err = mmc_read_switch(card);
> diff --git a/drivers/mmc/core/sd_ops.c b/drivers/mmc/core/sd_ops.c
> index 63772e7..797cdb5 100644
> --- a/drivers/mmc/core/sd_ops.c
> +++ b/drivers/mmc/core/sd_ops.c
> @@ -346,3 +346,51 @@ int mmc_sd_switch(struct mmc_card *card, int mode, int
> group,
>        return 0;
> }
>
> +int mmc_app_sd_status(struct mmc_card *card, void *ssr)
> +{
> +       int err;
> +       struct mmc_request mrq;
> +       struct mmc_command cmd;
> +       struct mmc_data data;
> +       struct scatterlist sg;
> +
> +       BUG_ON(!card);
> +       BUG_ON(!card->host);
> +       BUG_ON(!ssr);
> +
> +       /* NOTE: caller guarantees ssr is heap-allocated */
> +
> +       err = mmc_app_cmd(card->host, card);
> +       if (err)
> +               return err;
> +
> +       memset(&mrq, 0, sizeof(struct mmc_request));
> +       memset(&cmd, 0, sizeof(struct mmc_command));
> +       memset(&data, 0, sizeof(struct mmc_data));
> +
> +       mrq.cmd = &cmd;
> +       mrq.data = &data;
> +
> +       cmd.opcode = SD_APP_SD_STATUS;
> +       cmd.arg = 0;
> +       cmd.flags = MMC_RSP_SPI_R2 | MMC_RSP_R1 | MMC_CMD_ADTC;
> +
> +       data.blksz = 64;
> +       data.blocks = 1;
> +       data.flags = MMC_DATA_READ;
> +       data.sg = &sg;
> +       data.sg_len = 1;
> +
> +       sg_init_one(&sg, ssr, 64);
> +
> +       mmc_set_data_timeout(&data, card);
> +
> +       mmc_wait_for_req(card->host, &mrq);
> +
> +       if (cmd.error)
> +               return cmd.error;
> +       if (data.error)
> +               return data.error;
> +
> +       return 0;
> +}
> diff --git a/drivers/mmc/core/sd_ops.h b/drivers/mmc/core/sd_ops.h
> index 9742d8a..ffc2305 100644
> --- a/drivers/mmc/core/sd_ops.h
> +++ b/drivers/mmc/core/sd_ops.h
> @@ -19,6 +19,7 @@ int mmc_send_relative_addr(struct mmc_host *host, unsigned
> int *rca);
> int mmc_app_send_scr(struct mmc_card *card, u32 *scr);
> int mmc_sd_switch(struct mmc_card *card, int mode, int group,
>        u8 value, u8 *resp);
> +int mmc_app_sd_status(struct mmc_card *card, void *ssr);
>
> #endif
>
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index d02d2c6..eff7a08 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -30,6 +30,7 @@ struct mmc_csd {
>        unsigned int            tacc_ns;
>        unsigned int            r2w_factor;
>        unsigned int            max_dtr;
> +       unsigned int            erase_size;             /* In sectors */
>        unsigned int            read_blkbits;
>        unsigned int            write_blkbits;
>        unsigned int            capacity;
> @@ -41,9 +42,16 @@ struct mmc_csd {
>
> struct mmc_ext_csd {
>        u8                      rev;
> +       u8                      erase_group_def;
> +       u8                      sec_feature_support;
>        unsigned int            sa_timeout;             /* Units: 100ns */
>        unsigned int            hs_max_dtr;
>        unsigned int            sectors;
> +       unsigned int            hc_erase_size;          /* In sectors */
> +       unsigned int            hc_erase_timeout;       /* In milliseconds
> */
> +       unsigned int            sec_trim_mult;  /* Secure trim multiplier
>  */
> +       unsigned int            sec_erase_mult; /* Secure erase multiplier
> */
> +       unsigned int            trim_timeout;           /* In milliseconds
> */
> };
>
> struct sd_scr {
> @@ -53,6 +61,12 @@ struct sd_scr {
> #define SD_SCR_BUS_WIDTH_4      (1<<2)
> };
>
> +struct sd_ssr {
> +       unsigned int            au;                     /* In sectors */
> +       unsigned int            erase_timeout;          /* In milliseconds
> */
> +       unsigned int            erase_offset;           /* In milliseconds
> */
> +};
> +
> struct sd_switch_caps {
>        unsigned int            hs_max_dtr;
> };
> @@ -101,6 +115,10 @@ struct mmc_card {
> #define MMC_QUIRK_LENIENT_FN0   (1<<0)          /* allow SDIO FN0 writes
> outside of the VS CCCR range */
> #define MMC_QUIRK_BLKSZ_FOR_BYTE_MODE (1<<1)    /* use func->cur_blksize */
>                                                /* for byte mode */
> +       unsigned int            erase_size;     /* erase size in sectors */
> +       unsigned int            erase_shift;    /* if erase unit is power 2
> */
> +       unsigned int            max_erase;      /* in sectors */
> +       u8                      erased_byte;    /* value of erased bytes */
>
>        u32                     raw_cid[4];     /* raw card CID */
>        u32                     raw_csd[4];     /* raw card CSD */
> @@ -109,6 +127,7 @@ struct mmc_card {
>        struct mmc_csd          csd;            /* card specific */
>        struct mmc_ext_csd      ext_csd;        /* mmc v4 extended card
> specific */
>        struct sd_scr           scr;            /* extra SD information */
> +       struct sd_ssr           ssr;            /* yet more SD information
> */
>        struct sd_switch_caps   sw_caps;        /* switch (CMD6) caps */
>
>        unsigned int            sdio_funcs;     /* number of SDIO functions
> */
> diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
> index e4898e9..7429033 100644
> --- a/include/linux/mmc/core.h
> +++ b/include/linux/mmc/core.h
> @@ -92,6 +92,8 @@ struct mmc_command {
>  *              actively failing requests
>  */
>
> +       unsigned int            erase_timeout;  /* in milliseconds */
> +
>        struct mmc_data         *data;          /* data segment associated
> with cmd */
>        struct mmc_request      *mrq;           /* associated request */
> };
> @@ -134,6 +136,23 @@ extern int mmc_wait_for_cmd(struct mmc_host *, struct
> mmc_command *, int);
> extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
>        struct mmc_command *, int);
>
> +#define MMC_ERASE_ARG          0x00000000
> +#define MMC_SECURE_ERASE_ARG   0x80000000
> +#define MMC_TRIM_ARG           0x00000001
> +#define MMC_SECURE_TRIM1_ARG   0x80000001
> +#define MMC_SECURE_TRIM2_ARG   0x80008000
> +
> +#define MMC_SECURE_ARGS                0x80000000
> +#define MMC_TRIM_ARGS          0x00008001
> +
> +extern int mmc_erase(struct mmc_card *card, unsigned int from, unsigned int
> nr,
> +                    unsigned int arg);
> +extern int mmc_can_erase(struct mmc_card *card);
> +extern int mmc_can_trim(struct mmc_card *card);
> +extern int mmc_can_secure_erase_trim(struct mmc_card *card);
> +extern int mmc_erase_group_aligned(struct mmc_card *card, unsigned int
> from,
> +                                  unsigned int nr);
> +
> extern void mmc_set_data_timeout(struct mmc_data *, const struct mmc_card
> *);
> extern unsigned int mmc_align_data_size(struct mmc_card *, unsigned int);
>
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index f65913c..3beb29d 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -155,6 +155,7 @@ struct mmc_host {
> #define MMC_CAP_DISABLE         (1 << 7)        /* Can the host be disabled
> */
> #define MMC_CAP_NONREMOVABLE    (1 << 8)        /* Nonremovable e.g. eMMC */
> #define MMC_CAP_WAIT_WHILE_BUSY (1 << 9)        /* Waits while card is busy
> */
> +#define MMC_CAP_ERASE          (1 << 10)       /* Allow erase/trim commands
> */
>
>        mmc_pm_flag_t           pm_caps;        /* supported pm features */
>
> diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
> index 8a49cbf..82cdf8b 100644
> --- a/include/linux/mmc/mmc.h
> +++ b/include/linux/mmc/mmc.h
> @@ -251,12 +251,20 @@ struct _mmc_csd {
>  * EXT_CSD fields
>  */
>
> -#define EXT_CSD_BUS_WIDTH      183     /* R/W */
> -#define EXT_CSD_HS_TIMING      185     /* R/W */
> -#define EXT_CSD_CARD_TYPE      196     /* RO */
> -#define EXT_CSD_REV            192     /* RO */
> -#define EXT_CSD_SEC_CNT                212     /* RO, 4 bytes */
> -#define EXT_CSD_S_A_TIMEOUT    217
> +#define EXT_CSD_ERASE_GROUP_DEF                175     /* R/W */
> +#define EXT_CSD_ERASED_MEM_CONT                181     /* RO */
> +#define EXT_CSD_BUS_WIDTH              183     /* R/W */
> +#define EXT_CSD_HS_TIMING              185     /* R/W */
> +#define EXT_CSD_CARD_TYPE              196     /* RO */
> +#define EXT_CSD_REV                    192     /* RO */
> +#define EXT_CSD_SEC_CNT                        212     /* RO, 4 bytes */
> +#define EXT_CSD_S_A_TIMEOUT            217     /* RO */
> +#define EXT_CSD_ERASE_TIMEOUT_MULT     223     /* RO */
> +#define EXT_CSD_HC_ERASE_GRP_SIZE      224     /* RO */
> +#define EXT_CSD_SEC_TRIM_MULT          229     /* RO */
> +#define EXT_CSD_SEC_ERASE_MULT         230     /* RO */
> +#define EXT_CSD_SEC_FEATURE_SUPPORT    231     /* RO */
> +#define EXT_CSD_TRIM_MULT              232     /* RO */
>
> /*
>  * EXT_CSD field definitions
> @@ -274,6 +282,10 @@ struct _mmc_csd {
> #define EXT_CSD_BUS_WIDTH_4     1       /* Card is in 4 bit mode */
> #define EXT_CSD_BUS_WIDTH_8     2       /* Card is in 8 bit mode */
>
> +#define EXT_CSD_SEC_ER_EN      BIT(0)
> +#define EXT_CSD_SEC_BD_BLK_EN  BIT(2)
> +#define EXT_CSD_SEC_GB_CL_EN   BIT(4)
> +
> /*
>  * MMC_SWITCH access modes
>  */
> diff --git a/include/linux/mmc/sd.h b/include/linux/mmc/sd.h
> index f310062..3fd85e0 100644
> --- a/include/linux/mmc/sd.h
> +++ b/include/linux/mmc/sd.h
> @@ -21,8 +21,13 @@
>  /* class 10 */
> #define SD_SWITCH                 6   /* adtc [31:0] See below   R1  */
>
> +  /* class 5 */
> +#define SD_ERASE_WR_BLK_START    32   /* ac   [31:0] data addr   R1  */
> +#define SD_ERASE_WR_BLK_END      33   /* ac   [31:0] data addr   R1  */
> +
>  /* Application commands */
> #define SD_APP_SET_BUS_WIDTH      6   /* ac   [1:0] bus width    R1  */
> +#define SD_APP_SD_STATUS         13   /* adtc                    R1  */
> #define SD_APP_SEND_NUM_WR_BLKS  22   /* adtc                    R1  */
> #define SD_APP_OP_COND           41   /* bcr  [31:0] OCR         R3  */
> #define SD_APP_SEND_SCR          51   /* adtc                    R1  */
> --
> 1.6.3.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
