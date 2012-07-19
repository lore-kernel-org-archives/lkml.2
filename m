Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab2GSNKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 09:10:05 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:39859 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab2GSNKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 09:10:03 -0400
X-Greylist: delayed 681 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2012 09:10:03 EDT
From: Oliver Neukum <oliver@neukum.org>
To: wei_wang@realsil.com.cn
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] drivers/misc: Add realtek pci card reader driver
Date: Thu, 19 Jul 2012 14:57:55 +0200
Message-ID: <1416801.Uc45iJreQi@linux-lqwf.site>
User-Agent: KMail/4.8.4 (Linux/3.5.0-rc6-117-g918227b-1-vanilla; KDE/4.8.4; x86_64; ; )
In-Reply-To: <1342691710-23164-1-git-send-email-wei_wang@realsil.com.cn>
References: <1342691710-23164-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2012 17:55:10 wei_wang@realsil.com.cn wrote:

> +static int rtsx_pci_transfer_sglist_adma(struct rtsx_pdev *pdev,
> +		struct scatterlist *sg, int num_sg, int read, int timeout)
> +{
> +	struct completion trans_done;
> +	u8 dir;
> +	int buf_cnt, i;
> +	int err = 0;
> +	long timeleft;
> +	unsigned long flags;
> +	struct scatterlist *sg_ptr;
> +	enum dma_data_direction dma_dir;
> +
> +	if ((sg == NULL) || (num_sg <= 0))
> +		return -EINVAL;
> +
> +	if (read) {
> +		dir = DEVICE_TO_HOST;
> +		dma_dir = DMA_FROM_DEVICE;
> +	} else {
> +		dir = HOST_TO_DEVICE;
> +		dma_dir = DMA_TO_DEVICE;
> +	}
> +
> +	spin_lock_irqsave(&pdev->lock, flags);
> +
> +	/* set up data structures for the wakeup system */
> +	pdev->done = &trans_done;
> +	pdev->trans_state = STATE_TRANS_SG;
> +	pdev->trans_result = TRANS_NOT_READY;
> +
> +	spin_unlock_irqrestore(&pdev->lock, flags);
> +
> +	buf_cnt = dma_map_sg(&(pdev->pci->dev), sg, num_sg, dma_dir);
> +
> +	sg_ptr = sg;
> +	for (i = 0; i <= buf_cnt / (HOST_SG_TBL_BUF_LEN / 8); i++) {
> +		u32 val = TRIG_DMA;
> +		int sg_cnt, j;
> +
> +		if (i == buf_cnt / (HOST_SG_TBL_BUF_LEN / 8))
> +			sg_cnt = buf_cnt % (HOST_SG_TBL_BUF_LEN / 8);
> +		else
> +			sg_cnt = (HOST_SG_TBL_BUF_LEN / 8);
> +
> +		pdev->sgi = 0;
> +		for (j = 0; j < sg_cnt; j++) {
> +			dma_addr_t addr = sg_dma_address(sg_ptr);
> +			unsigned int len = sg_dma_len(sg_ptr);
> +			u8 option;
> +
> +			pr_debug("DMA addr: 0x%x, Len: 0x%x\n",
> +					(unsigned int)addr, len);
> +
> +			if (j == (sg_cnt - 1))
> +				option = SG_VALID | SG_END | SG_TRANS_DATA;
> +			else
> +				option = SG_VALID | SG_TRANS_DATA;
> +
> +			rtsx_pci_add_sg_tbl(pdev, (u32)addr, (u32)len, option);
> +			sg_ptr = sg_next(sg_ptr);
> +		}
> +
> +		pr_debug("SG table count = %d\n", pdev->sgi);
> +
> +		val |= (u32)(dir & 0x01) << 29;
> +		val |= ADMA_MODE;
> +
> +		spin_lock_irqsave(&pdev->lock, flags);
> +
> +		init_completion(&trans_done);
> +
> +		rtsx_pci_writel(pdev, RTSX_HDBAR, pdev->host_sg_tbl_addr);
> +		rtsx_pci_writel(pdev, RTSX_HDBCTLR, val);
> +
> +		spin_unlock_irqrestore(&pdev->lock, flags);
> +
> +		timeleft = wait_for_completion_interruptible_timeout(
> +				&trans_done, msecs_to_jiffies(timeout));
> +		if (timeleft <= 0) {
> +			pr_debug("Timeout (%s %d)\n", __func__, __LINE__);
> +			pr_debug("pdev->int_reg = 0x%x\n", pdev->int_reg);
> +			err = -ETIMEDOUT;
> +			goto out;
> +		}
> +
> +		spin_lock_irqsave(&pdev->lock, flags);
> +		if (pdev->trans_result == TRANS_RESULT_FAIL) {
> +			err = -EINVAL;
> +			spin_unlock_irqrestore(&pdev->lock, flags);
> +			goto out;
> +		} else if (pdev->trans_result == TRANS_NO_DEVICE) {
> +			err = -ENODEV;
> +			spin_unlock_irqrestore(&pdev->lock, flags);
> +			goto out;
> +		}
> +		spin_unlock_irqrestore(&pdev->lock, flags);
> +
> +		sg_ptr += sg_cnt;
> +	}
> +
> +	/* Wait for TRANS_OK_INT */
> +	spin_lock_irqsave(&pdev->lock, flags);
> +	if (pdev->trans_result == TRANS_NOT_READY) {
> +		init_completion(&trans_done);
> +		spin_unlock_irqrestore(&pdev->lock, flags);
> +		timeleft = wait_for_completion_interruptible_timeout(
> +				&trans_done, msecs_to_jiffies(timeout));
> +		if (timeleft <= 0) {
> +			pr_debug("Timeout (%s %d)\n", __func__, __LINE__);
> +			pr_debug("pdev->int_reg = 0x%x\n", pdev->int_reg);
> +			err = -ETIMEDOUT;
> +			goto out;
> +		}
> +	} else {
> +		spin_unlock_irqrestore(&pdev->lock, flags);
> +	}
> +
> +	spin_lock_irqsave(&pdev->lock, flags);

So why drop the lock?

> +	if (pdev->trans_result == TRANS_RESULT_FAIL)
> +		err = -EINVAL;
> +	else if (pdev->trans_result == TRANS_RESULT_OK)
> +		err = 0;
> +	else if (pdev->trans_result == TRANS_NO_DEVICE)
> +		err = -ENODEV;
> +	spin_unlock_irqrestore(&pdev->lock, flags);
> +
> +out:
> +	spin_lock_irqsave(&pdev->lock, flags);
> +	pdev->done = NULL;
> +	pdev->trans_state = STATE_TRANS_NONE;
> +	spin_unlock_irqrestore(&pdev->lock, flags);
> +
> +	dma_unmap_sg(&(pdev->pci->dev), sg, num_sg, dma_dir);

You must not unmap before you stop the hardware

> +	if ((err < 0) && (err != -ENODEV))
> +		rtsx_pci_stop_cmd(pdev);
> +
> +	if (pdev->finish_me)
> +		complete(pdev->finish_me);
> +
> +	return err;
> +}
> +
> +/**
> + * rtsx_pci_transfer_buf - transfer data in linear buffer.
> + * @pdev: Realtek's card reader pdev
> + * @card: this command is relevant to card or not
> + * @buf: data buffer
> + * @len: buffer length
> + * @dma_dir: transfer direction (DMA_FROM_DEVICE or DMA_TO_DEVICE)
> + * @timeout: time out in millisecond

	Regards
		Oliver

