Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab2EBDIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:08:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52010 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177Ab2EBDIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:08:06 -0400
X-AuditID: cbfee61b-b7ce2ae00000583e-63-4fa0a514d527
Message-id: <4FA0A50F.4020400@samsung.com>
Date: Wed, 02 May 2012 12:07:59 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412
 Thunderbird/11.0.1
MIME-version: 1.0
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        cjb@laptop.org, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        will.newton@gmail.com, jh80.chung@samsung.com, tgih.jun@samsung.com,
        dianders@google.com
Subject: Re: [PATCH] mmc: dw_mmc: make multiple instances of
 dw_mci_card_workqueue
References: <1335909456-14020-1-git-send-email-thomas.abraham@linaro.org>
In-reply-to: <1335909456-14020-1-git-send-email-thomas.abraham@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

On 05/02/2012 06:57 AM, Thomas Abraham wrote:

> The variable 'dw_mci_card_workqueue' is a global variable shared between
> multiple instances of the dw_mmc host controller. Due to this, data
> corruption has been noticed when multiple instances of dw_mmc controllers
> are actively reading/writing the media. Fix this by adding a instance
> of 'struct workqueue_struct' for each host instance and removing the
> global 'dw_mci_card_workqueue' instance.
> 
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  drivers/mmc/host/dw_mmc.c  |   14 ++++++--------
>  include/linux/mmc/dw_mmc.h |    1 +
>  2 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index ab3fc46..1532357 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -100,8 +100,6 @@ struct dw_mci_slot {
>  	int			last_detect_state;
>  };
>  
> -static struct workqueue_struct *dw_mci_card_workqueue;
> -
>  #if defined(CONFIG_DEBUG_FS)
>  static int dw_mci_req_show(struct seq_file *s, void *v)
>  {
> @@ -1605,7 +1603,7 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>  
>  		if (pending & SDMMC_INT_CD) {
>  			mci_writel(host, RINTSTS, SDMMC_INT_CD);
> -			queue_work(dw_mci_card_workqueue, &host->card_work);
> +			queue_work(host->card_workqueue, &host->card_work);
>  		}
>  
>  		/* Handle SDIO Interrupts */
> @@ -1844,7 +1842,7 @@ static int __init dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  	 * Card may have been plugged in prior to boot so we
>  	 * need to run the detect tasklet
>  	 */
> -	queue_work(dw_mci_card_workqueue, &host->card_work);
> +	queue_work(host->card_workqueue, &host->card_work);
>  
>  	return 0;
>  }
> @@ -2021,9 +2019,9 @@ int dw_mci_probe(struct dw_mci *host)
>  	mci_writel(host, CLKSRC, 0);
>  
>  	tasklet_init(&host->tasklet, dw_mci_tasklet_func, (unsigned long)host);
> -	dw_mci_card_workqueue = alloc_workqueue("dw-mci-card",
> +	host->card_workqueue = alloc_workqueue("dw-mci-card",
>  			WQ_MEM_RECLAIM | WQ_NON_REENTRANT, 1);
> -	if (!dw_mci_card_workqueue)
> +	if (!host->card_workqueue)
>  		goto err_dmaunmap;
>  	INIT_WORK(&host->card_work, dw_mci_work_routine_card);
>  	ret = request_irq(host->irq, dw_mci_interrupt, host->irq_flags, "dw-mci", host);
> @@ -2085,7 +2083,7 @@ err_init_slot:
>  	free_irq(host->irq, host);
>  
>  err_workqueue:
> -	destroy_workqueue(dw_mci_card_workqueue);
> +	destroy_workqueue(host->card_workqueue);
>  
>  err_dmaunmap:
>  	if (host->use_dma && host->dma_ops->exit)
> @@ -2119,7 +2117,7 @@ void dw_mci_remove(struct dw_mci *host)
>  	mci_writel(host, CLKSRC, 0);
>  
>  	free_irq(host->irq, host);
> -	destroy_workqueue(dw_mci_card_workqueue);
> +	destroy_workqueue(host->card_workqueue);
>  	dma_free_coherent(&host->dev, PAGE_SIZE, host->sg_cpu, host->sg_dma);
>  
>  	if (host->use_dma && host->dma_ops->exit)
> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
> index 8f66e28..7a7ebd3 100644
> --- a/include/linux/mmc/dw_mmc.h
> +++ b/include/linux/mmc/dw_mmc.h
> @@ -125,6 +125,7 @@ struct dw_mci {
>  	struct mmc_request	*mrq;
>  	struct mmc_command	*cmd;
>  	struct mmc_data		*data;
> +	struct workqueue_struct	*card_workqueue;
>  
>  	/* DMA interface members*/
>  	int			use_dma;


