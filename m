Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab0LHNOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 08:14:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41751 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab0LHNON convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 08:14:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R1wd3Xbxr5I+MX/Zv4fRLGh8Pz6MDkC1gLkwBlL85AsMpCAKzw0cJti7hAnESDYDHj
         2G1KaCwJfCNirI2UJhr1EDU8HNBj+21UEo9vFasEuZAMZnqdAoT4hGlMnTI4wPhvy9q2
         YbFG+UupYuR7W6374cEFh785I962XHgELA6GQ=
MIME-Version: 1.0
In-Reply-To: <20101208115510.GD10998@console-pimps.org>
References: <AANLkTi=0RtvsGX+Q3goL3mdG6oKeNidYtiudTZ8ZTpRP@mail.gmail.com>
	<20101208115510.GD10998@console-pimps.org>
Date: Wed, 8 Dec 2010 13:14:11 +0000
Message-ID: <AANLkTi=KqOa-MRQiptCtZGvoafRCgULfE3QFs=hmGpdi@mail.gmail.com>
Subject: Re: [RESEND PATCH] dw_mmc: Add Synopsys DesignWare mmc host driver.
From: Will Newton <will.newton@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 11:55 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Mon, Dec 06, 2010 at 03:53:10PM +0000, Will Newton wrote:
>> This adds the mmc host driver for the Synopsys DesignWare mmc
>> host controller, found in a number of embedded SoC designs.
>>
>> Signed-off-by: Will Newton <will.newton@imgtec.com>
>
> Comments below..

Thanks for the review!

>> +static void dw_mci_init_debugfs(struct dw_mci_slot *slot)
>> +{
>> +     struct mmc_host *mmc = slot->mmc;
>> +     struct dw_mci *host = slot->host;
>> +     struct dentry *root;
>> +     struct dentry *node;
>> +
>> +     root = mmc->debugfs_root;
>> +     if (!root)
>> +             return;
>> +
>> +     node = debugfs_create_file("regs", S_IRUSR, root, host,
>> +                     &dw_mci_regs_fops);
>> +     if (IS_ERR(node))
>> +             return;
>
> Should this be a goto err instead of return? I'm guessing this is
> meant to catch -ENODEV being returned when debugfs is not enabled in
> the kernel, but if we've compiled this code with CONFIG_DEBUG_FS then
> we probably want to know when this call fails.

I've removed that check, I don't think debugfs_create_file will return an error
other than NULL with CONFIG_DEBUG_FS enabled.

>> +static void dw_mci_set_timeout(struct dw_mci *host)
>> +{
>> +     mci_writel(host, TMOUT, 0xffffffff); /* timeout (maximum) */
>> +}
>> +
>
> Could do with an explicit 'inline'? Especially as it only has one
> callsite.

gcc is always going to inline it so I'd rather leave out the explicit
inline. That way if the code gets changed in future the inline hint
isn't going to become out of date.

>> +static void dw_mci_start_request(struct dw_mci *host,
>> +                              struct dw_mci_slot *slot)
>> +{
>> +     struct mmc_request *mrq;
>> +     struct mmc_command *cmd;
>> +     struct mmc_data *data;
>> +     u32 cmdflags;
>> +
>> +     mrq = slot->mrq;
>> +     /* no select the proper slot */
>> +     if (host->pdata->select_slot)
>> +             host->pdata->select_slot(slot->id);
>> +
>> +     /* Slot specific timing and width adjustment */
>> +     dw_mci_setup_bus(slot);
>> +
>> +     host->cur_slot = slot;
>> +     host->mrq = mrq;
>> +
>> +     host->pending_events = 0;
>> +     host->completed_events = 0;
>> +     host->data_status = 0;
>> +
>> +     data = mrq->data;
>> +     if (data) {
>> +             dw_mci_set_timeout(host);
>> +             mci_writel(host, BYTCNT, data->blksz*data->blocks);
>> +             mci_writel(host, BLKSIZ, data->blksz);
>> +     }
>> +
>> +     cmd = mrq->cmd;
>> +     cmdflags = dw_mci_prepare_command(slot->mmc, cmd);
>> +
>> +     /* this is the first command, lets send the initialization clock */
>> +     if (unlikely(
>> +             test_and_clear_bit(DW_MMC_CARD_NEED_INIT, &slot->flags))) {
>> +             cmdflags |= SDMMC_CMD_INIT;
>> +     }
>
> This unlikely seems a bit over the top and forces an unfortunate break
> in the line to keep within 80 cols. Maybe delete it?

Removed.

>> +static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>> +{
>> +     struct dw_mci *host = dev_id;
>> +     u32 status,  pending;
>> +     unsigned int pass_count = 0;
>> +
>> +     do {
>> +             status = mci_readl(host, RINTSTS);
>> +             pending = mci_readl(host, MINTSTS);/* read only mask reg */
>> +
>> +             /*
>> +              * DTO fix - version 2.10a and below, and only if internal DMA
>> +              * is configured.
>> +              */
>> +             if (host->quirks & DW_MCI_QUIRK_IDMAC_DTO) {
>> +                     if (!pending &&
>> +                         ((mci_readl(host, STATUS) >> 17) & 0x1fff))
>> +                             pending |= SDMMC_INT_DATA_OVER;
>> +             }
>> +
>> +             if (!pending)
>> +                     break;
>> +
>> +             if (pending & DW_MCI_CMD_ERROR_FLAGS) {
>> +                     mci_writel(host, RINTSTS, DW_MCI_CMD_ERROR_FLAGS);
>> +                     host->cmd_status = status;
>> +                     smp_wmb();
>> +                     set_bit(EVENT_CMD_COMPLETE, &host->pending_events);
>> +                     tasklet_schedule(&host->tasklet);
>> +             }
>> +
>> +             if (pending & DW_MCI_DATA_ERROR_FLAGS) {
>> +                     /* if there is an error, lets report DATA_ERROR */
>> +                     mci_writel(host, RINTSTS, DW_MCI_DATA_ERROR_FLAGS);
>> +                     host->data_status = status;
>> +                     smp_wmb();
>> +                     set_bit(EVENT_DATA_ERROR, &host->pending_events);
>> +                     tasklet_schedule(&host->tasklet);
>> +             }
>> +
>> +
>> +             if (pending & SDMMC_INT_DATA_OVER) {
>> +                     mci_writel(host, RINTSTS, SDMMC_INT_DATA_OVER);
>> +                     if (!host->data_status)
>> +                             host->data_status = status;
>> +                     smp_wmb();
>> +                     if (host->dir_status == DW_MCI_RECV_STATUS) {
>> +                             if (host->sg != NULL)
>> +                                     dw_mci_read_data_pio(host);
>> +                     }
>> +                     set_bit(EVENT_DATA_COMPLETE, &host->pending_events);
>> +                     tasklet_schedule(&host->tasklet);
>> +             }
>> +
>> +             if (pending & SDMMC_INT_RXDR) {
>> +                     mci_writel(host, RINTSTS, SDMMC_INT_RXDR);
>> +                     if (host->sg)
>> +                             dw_mci_read_data_pio(host);
>> +             }
>> +
>> +             if (pending & SDMMC_INT_TXDR) {
>> +                     mci_writel(host, RINTSTS, SDMMC_INT_TXDR);
>> +                     if (host->sg)
>> +                             dw_mci_write_data_pio(host);
>> +             }
>> +
>> +             if (pending & SDMMC_INT_CMD_DONE) {
>> +                     mci_writel(host, RINTSTS, SDMMC_INT_CMD_DONE);
>> +                     dw_mci_cmd_interrupt(host, status);
>> +             }
>> +
>> +             if (pending & SDMMC_INT_CD) {
>> +                     mci_writel(host, RINTSTS, SDMMC_INT_CD);
>> +                     tasklet_schedule(&host->card_tasklet);
>> +             }
>> +
>> +     } while (pass_count++ < 5);
>
> This could do with a comment, explaining why it's necessary to loop 5
> times.

I'm not sure where that number comes from so I can't really add much
unfortunately. :-/

>> +static int __init dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>> +{
>> +     struct mmc_host *mmc;
>> +     struct dw_mci_slot *slot;
>> +
>> +     mmc = mmc_alloc_host(sizeof(struct dw_mci_slot), &host->pdev->dev);
>> +     if (!mmc)
>> +             return -ENOMEM;
>> +
>> +     slot = mmc_priv(mmc);
>> +     slot->id = id;
>> +     slot->mmc = mmc;
>> +     slot->host = host;
>> +
>> +     mmc->ops = &dw_mci_ops;
>> +     mmc->f_min = DIV_ROUND_UP(host->bus_hz, 510);
>
> Is that really supposed to be 510, and not 512?

The maximum divider is 255*2 so 510 is the correct number. Strange but true.

>> +#ifndef _DW_MMC_H_
>> +#define _DW_MMC_H_
>> +
>> +#define MCI_SLOT             0
>
> This appears to be unused.

Yep, removed.

I'll respin the patch and post a v2.
