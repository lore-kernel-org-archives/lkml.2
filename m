Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab0LIMLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 07:11:11 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44912 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab0LIMLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 07:11:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x2U76klcQOlmZib52b9cDtUc/rnQlXjm7oaoo/IP8xD+ulgOqDjD+9/CMNMz4Tbd+A
         Mu+zXOtpCYXa2Ptjy54/EA0QtOIh9gakwWsunCHbMtQmnrJw9iIDmYF+T1eAUYghTp7u
         j7aeEjV5Km6Oro1BgGCGigHwgUmf3GYp7Y0vQ=
MIME-Version: 1.0
In-Reply-To: <20101209064751.GA21128@void.printf.net>
References: <AANLkTi=0RtvsGX+Q3goL3mdG6oKeNidYtiudTZ8ZTpRP@mail.gmail.com>
	<20101208115510.GD10998@console-pimps.org>
	<AANLkTi=KqOa-MRQiptCtZGvoafRCgULfE3QFs=hmGpdi@mail.gmail.com>
	<AANLkTi=PpTi1_JO9Q=ph7w9Jim8iXMf9LbCfmEkWuo-h@mail.gmail.com>
	<20101209064751.GA21128@void.printf.net>
Date: Thu, 9 Dec 2010 12:11:06 +0000
Message-ID: <AANLkTimMgrawcndvUTYYjq9BGFqs-sbRsZkwVQ0Uvhvb@mail.gmail.com>
Subject: Re: [PATCH] dw_mmc: Add Synopsys DesignWare mmc host driver.
From: Will Newton <will.newton@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 6:47 AM, Chris Ball <cjb@laptop.org> wrote:
> Hi Will,
>
> Thanks for the submission (and thanks for the review, Matt!).
>
> Some more comments below, mainly stylistic, and at the bottom I've
> attached an indentation and cleanup patch.  It's okay if there are
> some changes in it that you'd rather not make.
>
> On Wed, Dec 08, 2010 at 02:21:05PM +0000, Will Newton wrote:
>> +config MMC_DW_IDMAC
>> +     depends on MMC_DW
>> +     bool "Internal DMAC interface"
>> +     help
>> +       This selects support for the internal DMAC block within the Synopsys
>> +       Designware Mobile Storage IP block. This disables the external DMA
>> +       interface.
>> +
>
> Is there something we could depend on that would stop this driver being
> presented to everyone, without being far too specific?  At the moment
> we'd be making x86 desktop users say whether they have this IP, which
> isn't good.  Are the architectures that use this IP already upstream?
> Are they all ARM architectures, for instance?

I don't know of any architectures upstream that use this IP block. There is an
SoC from NXP that uses this it but it is not upstream:

http://ics.nxp.com/support/software/lpc313x.bsp.linux/

The architecture we tested and debugged this driver on is not upstream either
unfortunately. :-/

>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -0,0 +1,1806 @@
>> +/*
>> + * Synopsys DesignWare Multimedia Card Interface driver
>> + *  (Based on NXP driver for lpc 31xx)
>> + *
>
> Is the NXP driver publicly available?  If not, we can remove this line.
> The driver looks like it's based on our atmel-mci.c to me.

Yes, that too. ;-)

The driver is available at the link above, I can add the URL to the comment
if that would be helpful.

> It'd be nice if you kerneldoc'd your data structures in the same style as
> atmel-mci does, and many of the locking comments in there apply directly
> to this driver.

Ok, I'll look into that.

>> + * Copyright (C) 2009 NXP Semiconductors
>> + * Copyright (C) 2009, 2010 Imagination Technologies Ltd.
>
> Hm, what's the relationship between NXP and Imagination here?  If
> you're submitting a driver with NXP copyright, I think we should have
> a Signed-off-by line from whomever owns the copyright/wrote that code.
> If that's you, that's fine, but it's unclear to me.

We both have SoCs with this IP block in it, other than that I don't think
there has been any communication between NXP and Imagination about this driver.
Hence the lack of SOB from the original authors.

The driver is available publically under the GPL, so it was my
understanding that
no SOB was required as long as we keep appropriate copyright credit in the code.

>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>
> My patch snips from here until the end of this comment, to align with the
> rest of MMC.  One reason not to include the FSF address in every source
> file is that it becomes wrong occasionally, like the address below.  :)

Good idea.

>> +#if defined(CONFIG_DEBUG_FS)
>> +/*
>> + * The debugfs stuff below is mostly optimized away when
>> + * CONFIG_DEBUG_FS is not set.
>> + */
>
> Don't think this comment needs to be here.

Agreed.

>> +static u32 dw_mci_prepare_command(struct mmc_host *mmc,
>> +                               struct mmc_command *cmd)
>> +{
>> +     struct mmc_data *data;
>> +     u32 cmdr;
>> +     cmd->error = -EINPROGRESS;
>> +
>> +     cmdr = cmd->opcode;
>> +
>> +     if (cmdr == MMC_STOP_TRANSMISSION)
>> +             cmdr |= SDMMC_CMD_STOP;
>> +     else
>> +             cmdr |= SDMMC_CMD_PRV_DAT_WAIT;
>> +
>> +     if (cmd->flags & MMC_RSP_PRESENT) {
>> +             cmdr |= SDMMC_CMD_RESP_EXP;
>> +             /* expect the respond, need to set this bit */
>
> I think the comment's referring to the line above, so it should be
> before it.  Also, s/respond/response/, and maybe it could be reworded.

Ok.

>> +             if (cmd->flags & MMC_RSP_136)
>> +                     cmdr |= SDMMC_CMD_RESP_LONG; /* expect long respond */
>> +     }
>> +
>> +     if (cmd->flags & MMC_RSP_CRC)
>> +             cmdr |= SDMMC_CMD_RESP_CRC;
>> +
>> +     data = cmd->data;
>> +     if (data) {
>> +             cmdr |= SDMMC_CMD_DAT_EXP;
>> +             if (data->flags & MMC_DATA_STREAM)
>> +                     cmdr |= SDMMC_CMD_STRM_MODE; /*  set stream mode */
>
> I think both of these comments can be removed as obvious.

Ok.

>> +             if (data->flags & MMC_DATA_WRITE)
>> +                     cmdr |= SDMMC_CMD_DAT_WR;
>> +     }
>> +
>> +     return cmdr;
>> +}
>> +
>> +static void dw_mci_start_command(struct dw_mci *host,
>> +                              struct mmc_command *cmd, u32 cmd_flags)
>> +{
>> +     host->cmd = cmd;
>> +     dev_vdbg(&host->pdev->dev,
>> +                     "start command: ARGR=0x%08x CMDR=0x%08x\n",
>> +                     cmd->arg, cmd_flags);
>> +
>> +     /* write to CMDARG register */
>> +     mci_writel(host, CMDARG, cmd->arg);
>> +     wmb();
>> +
>> +     /* write to CMD register */
>> +     mci_writel(host, CMD, cmd_flags | SDMMC_CMD_START);
>
> Again, these comments aren't very useful.  I do approve of comments in
> general, honest, but they're supposed to say something that isn't
> apparent by just looking at the code.

Yes, these should go.

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
>
> Don't understand this comment.

Maybe a typo, "no" for "now"? I'll remove the comment.

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
>
> I think you mean:
>        /* If this is the first command, send the initialization clock /*

Done.

>> +     if (test_and_clear_bit(DW_MMC_CARD_NEED_INIT, &slot->flags))
>> +             cmdflags |= SDMMC_CMD_INIT;
>> +
>> +     /* we may need to move this code to mci_start_command */
>
> Has this question been resolved yet?

I've removed the comment, it doesn't appear to make logical sense to me.

>> +static int dw_mci_get_ro(struct mmc_host *mmc)
>> +{
>> +     int read_only;
>> +     struct dw_mci_slot *slot = mmc_priv(mmc);
>> +     struct dw_mci_board *brd = slot->host->pdata;
>> +
>> +     if (brd->get_ro != NULL) {
>
> != NULL isn't necessary here.

Ok.

>> +             read_only = brd->get_ro(slot->id);
>> +     } else {
>> +             /* Try on board write protect */
>> +             read_only =
>> +                     mci_readl(slot->host, WRTPRT) & (1 << slot->id) ? 1 : 0;
>> +     }
>> +
>> +     dev_dbg(&mmc->class_dev, "card is %s\n",
>> +                             read_only ? "read-only" : "read-write");
>> +
>> +     return read_only;
>> +}
>> +
>> +static int dw_mci_get_cd(struct mmc_host *mmc)
>> +{
>> +     int present;
>> +     struct dw_mci_slot *slot = mmc_priv(mmc);
>> +     struct dw_mci_board *brd = slot->host->pdata;
>> +
>> +     if (brd->get_cd != NULL)
>
> (Same.)

Ok.

>> +             present = !brd->get_cd(slot->id);
>> +     else    /* try onboard card detect */
>> +             present = (mci_readl(slot->host, CDETECT) & (1 << slot->id))
>> +                             == 0 ? 1 : 0;
>> +
>> +     dev_dbg(&mmc->class_dev, "card is %spresent\n", present ? "" : "not ");
>
> I expanded this, since being able to grep for "not present" has some value.

Ok.

>> +
>> +     return present;
>> +}
>> +
>> +static const struct mmc_host_ops dw_mci_ops = {
>> +     .request        = dw_mci_request,
>> +     .set_ios        = dw_mci_set_ios,
>> +     .get_ro         = dw_mci_get_ro,
>> +     .get_cd         = dw_mci_get_cd,
>> +};
>> +
>> +static void dw_mci_request_end(struct dw_mci *host, struct mmc_request *mrq)
>> +     __releases(&host->lock)
>> +     __acquires(&host->lock)
>> +{
>> +     struct dw_mci_slot *slot;
>> +     struct mmc_host *prev_mmc = host->cur_slot->mmc;
>> +
>> +     WARN_ON(host->cmd || host->data);
>> +
>> +     host->cur_slot->mrq = NULL;
>> +     host->mrq = NULL;
>> +     if (!list_empty(&host->queue)) {
>> +             slot = list_entry(host->queue.next,
>> +                             struct dw_mci_slot, queue_node);
>> +             list_del(&slot->queue_node);
>> +             dev_vdbg(&host->pdev->dev, "list not empty: %s is next\n",
>> +                             mmc_hostname(slot->mmc));
>> +             host->state = STATE_SENDING_CMD;
>> +             dw_mci_start_request(host, slot);
>> +     } else {
>> +             dev_vdbg(&host->pdev->dev, "list empty\n");
>> +             host->state = STATE_IDLE;
>> +     }
>> +
>> +     spin_unlock(&host->lock);
>> +     mmc_request_done(prev_mmc, mrq);
>> +
>> +     spin_lock(&host->lock);
>> +}
>> +
>> +static void dw_mci_command_complete(struct dw_mci *host,
>> +                                 struct mmc_command *cmd)
>> +{
>> +     u32 status = host->cmd_status;
>> +
>> +     host->cmd_status = 0;
>> +
>> +     /* Read the response from the card (up to 16 bytes) */
>> +     if (cmd->flags & MMC_RSP_PRESENT) {
>> +             if (cmd->flags & MMC_RSP_136) {
>> +                     cmd->resp[3] = mci_readl(host, RESP0);
>> +                     cmd->resp[2] = mci_readl(host, RESP1);
>> +                     cmd->resp[1] = mci_readl(host, RESP2);
>> +                     cmd->resp[0] = mci_readl(host, RESP3);
>
> It'd be nice to have a comment explaining why this is in reverse
> order, yet if RSP_136 is set we use RESP0 instead of RESP3.
>
>> +             } else {
>> +                     cmd->resp[0] = mci_readl(host, RESP0);
>> +                     cmd->resp[1] = 0;
>> +                     cmd->resp[2] = 0;
>> +                     cmd->resp[3] = 0;
>> +             }
>> +     }
>> +
>> +     if (status & SDMMC_INT_RTO)
>> +             cmd->error = -ETIMEDOUT;
>> +     else if ((cmd->flags & MMC_RSP_CRC) && (status & SDMMC_INT_RCRC))
>> +             cmd->error = -EILSEQ;
>> +     else if (status & SDMMC_INT_RESP_ERR)
>> +             cmd->error = -EIO;
>> +     else
>> +             cmd->error = 0;
>> +
>> +     if (cmd->error) {
>> +             /* newer ip versions need a delay between retries */
>> +             if (host->quirks & DW_MCI_QUIRK_RETRY_DELAY)
>> +                     mdelay(20);
>> +
>> +             if (cmd->data) {
>> +                     host->data = NULL;
>> +                     dw_mci_stop_dma(host);
>> +             }
>> +     }
>> +}
>> +
>> +static void dw_mci_tasklet_func(unsigned long priv)
>> +{
>> +     struct dw_mci *host = (struct dw_mci *)priv;
>> +     struct mmc_data *data;
>> +     struct mmc_command *cmd;
>> +     enum dw_mci_state state;
>> +     enum dw_mci_state prev_state;
>> +     u32 status;
>> +
>> +     spin_lock(&host->lock);
>> +
>> +     state = host->state;
>> +     data = host->data;
>> +
>> +     do {
>> +             prev_state = state;
>> +
>> +             switch (state) {
>> +             case STATE_IDLE:
>> +                     break;
>> +
>> +             case STATE_SENDING_CMD:
>> +                     if (!test_and_clear_bit(EVENT_CMD_COMPLETE,
>> +                                             &host->pending_events))
>> +                             break;
>> +
>> +                     cmd = host->cmd;
>> +                     host->cmd = NULL;
>> +                     set_bit(EVENT_CMD_COMPLETE, &host->completed_events);
>> +                     dw_mci_command_complete(host, host->mrq->cmd);
>> +                     if (!host->mrq->data || cmd->error) {
>> +                             dw_mci_request_end(host, host->mrq);
>> +                             goto unlock;
>> +                     }
>> +
>> +                     prev_state = state = STATE_SENDING_DATA;
>> +                     /* fall through */
>> +
>> +             case STATE_SENDING_DATA:
>> +                     if (test_and_clear_bit(EVENT_DATA_ERROR,
>> +                                            &host->pending_events)) {
>> +                             dw_mci_stop_dma(host);
>> +                             if (data->stop)
>> +                                     send_stop_cmd(host, data);
>> +                             state = STATE_DATA_ERROR;
>> +                             break;
>> +                     }
>> +
>> +                     if (!test_and_clear_bit(EVENT_XFER_COMPLETE,
>> +                                             &host->pending_events))
>> +                             break;
>> +
>> +                     set_bit(EVENT_XFER_COMPLETE, &host->completed_events);
>> +                     prev_state = state = STATE_DATA_BUSY;
>> +                     /* fall through */
>> +
>> +             case STATE_DATA_BUSY:
>> +                     if (!test_and_clear_bit(EVENT_DATA_COMPLETE,
>> +                                             &host->pending_events))
>> +                             break;
>> +
>> +                     host->data = NULL;
>> +                     set_bit(EVENT_DATA_COMPLETE, &host->completed_events);
>> +                     status = host->data_status;
>> +
>> +                     if (unlikely(status & DW_MCI_DATA_ERROR_FLAGS)) {
>> +                             if (status & SDMMC_INT_DTO) {
>> +                                     dev_err(&host->pdev->dev,
>> +                                                     "data timeout error\n");
>> +                                     data->error = -ETIMEDOUT;
>> +                             } else if (status & SDMMC_INT_DCRC) {
>> +                                     dev_err(&host->pdev->dev,
>> +                                                     "data CRC error\n");
>> +                                     data->error = -EILSEQ;
>> +                             } else {
>> +                                     dev_err(&host->pdev->dev,
>> +                                             "data FIFO error "
>> +                                             "(status=%08x)\n",
>> +                                             status);
>> +                                     data->error = -EIO;
>> +                             }
>> +                     } else {
>> +                             data->bytes_xfered = data->blocks * data->blksz;
>> +                             data->error = 0;
>> +                     }
>> +
>> +                     if (!data->stop) {
>> +                             dw_mci_request_end(host, host->mrq);
>> +                             goto unlock;
>> +                     }
>> +
>> +                     prev_state = state = STATE_SENDING_STOP;
>> +                     if (!data->error)
>> +                             send_stop_cmd(host, data);
>> +                     /* fall through */
>> +
>> +             case STATE_SENDING_STOP:
>> +                     if (!test_and_clear_bit(EVENT_CMD_COMPLETE,
>> +                                             &host->pending_events))
>> +                             break;
>> +
>> +                     host->cmd = NULL;
>> +                     dw_mci_command_complete(host, host->mrq->stop);
>> +                     dw_mci_request_end(host, host->mrq);
>> +                     goto unlock;
>> +
>> +             case STATE_DATA_ERROR:
>> +                     if (!test_and_clear_bit(EVENT_XFER_COMPLETE,
>> +                                             &host->pending_events))
>> +                             break;
>> +
>> +                     state = STATE_DATA_BUSY;
>> +                     break;
>> +             }
>> +     } while (state != prev_state);
>> +
>> +     host->state = state;
>> +unlock:
>> +     spin_unlock(&host->lock);
>> +
>> +}
>> +
>> +static void dw_mci_push_data16(struct dw_mci *host, void *buf, int cnt)
>> +{
>> +     u16 *pData = (u16 *)buf;
>
> Changed to pdata.

Ok.

>> +static void dw_mci_read_data_pio(struct dw_mci *host)
>> +{
>> +     struct scatterlist *sg = host->sg;
>> +     void *buf = sg_virt(sg);
>> +     unsigned int offset = host->pio_offset;
>> +     struct mmc_data *data = host->data;
>> +     int shift = host->data_shift;
>> +     u32 status;
>> +     unsigned int nbytes = 0, len, old_len, count = 0;
>> +
>> +     do {
>> +             len = SDMMC_GET_FCNT(mci_readl(host, STATUS)) << shift;
>> +             if (count == 0)
>> +                     old_len = len;
>> +
>> +             if (likely(offset + len <= sg->length)) {
>
> I agree with Matt, the unlikely/likely aren't necessary.

Removed.

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
>
> The "lets" were ungrammatical and didn't add much, so I removed them.

Ok.

>> +     if (host->pdata->blk_settings) {
>> +             mmc->max_segs = host->pdata->blk_settings->max_segs;
>> +             mmc->max_blk_size = host->pdata->blk_settings->max_blk_size;
>> +             mmc->max_blk_count = host->pdata->blk_settings->max_blk_count;
>> +             mmc->max_req_size = host->pdata->blk_settings->max_req_size;
>> +             mmc->max_seg_size = host->pdata->blk_settings->max_seg_size;
>> +     } else {
>> +             /*useful defaults*/
>> +             mmc->max_segs = 64;
>> +             mmc->max_blk_size = 65536; /* BLKSIZ is 16 bits */
>> +             mmc->max_blk_count = 512;
>> +             mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
>> +             mmc->max_seg_size = mmc->max_req_size;
>> +     }
>> +#endif /* CONFIG_MMC_DW_IDMAC */
>> +
>> +     /* Assume card is present initially */
>> +     if (dw_mci_get_cd(mmc))
>> +             set_bit(DW_MMC_CARD_PRESENT, &slot->flags);
>> +     else
>> +             clear_bit(DW_MMC_CARD_PRESENT, &slot->flags);
>
> Hm, does the code actually make that assumption?  Won't dw_mci_get_cd()
> return an appropriate value, and have the present bit cleared if so?

Yes, comment removed.

>> +     host->pdev = pdev;
>> +     host->pdata = pdata = pdev->dev.platform_data;
>> +     if (!pdata) {
>> +             dev_err(&pdev->dev, "Platform data missing\n");
>> +             ret = -ENODEV;
>> +             goto err_freehost;
>> +     }
>> +
>> +     if (((pdata->num_slots > 1) && !(pdata->select_slot))
>> +                     || !(pdata->init)) {
>> +             dev_err(&pdev->dev, "Platform data wrong\n");
>> +             ret = -ENODEV;
>> +             goto err_freehost;
>> +     }
>
> "Platform data wrong" is pretty unhelpful -- perhaps you could have the
> first test be (!pdata || !pdata->init), and then the second test can
> explain that num_slots is > 1 without a slot selected.

Yes, that would be clearer.

>> +     ret = request_irq(irq, dw_mci_interrupt, 0, "dw-mci", host);
>> +     if (ret)
>> +             goto err_dmaunmap;
>> +
>> +     platform_set_drvdata(pdev, host);
>> +
>> +     if (host->pdata->num_slots)
>> +             host->num_slots = host->pdata->num_slots;
>> +     else
>> +             host->num_slots = ((mci_readl(host, HCON) >> 1) & 0x1F) + 1;
>> +
>> +     /* We need at least one slot to succeed ####pd####*/
>
> What does ####pd#### mean?

I expect pd is one of the original authors - I've removed that part of
the comment.

>
> Cleanup patch:

Thanks for the patch, I've applied it and done a couple more minor
changes. I'll send a v3 when it's tested.
