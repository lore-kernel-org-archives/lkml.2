Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab2HXHip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:38:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47521 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755526Ab2HXHim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:38:42 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX1/o0uprFHrolkvkl4wmWpm2OIQqYzywhrvs+CT0AS
	lz0wDfUXrDcu5b
From: Marc Dietrich <marvin24@gmx.de>
To: Tejun Heo <tj@kernel.org>
Cc: Julian Andres Klode <jak@jak-linux.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH staging] nvec: use system_nrt_wq instead of custom one
Date: Fri, 24 Aug 2012 09:38:35 +0200
Message-ID: <3351764.3akYJnKF5N@fb07-iapwap2>
User-Agent: KMail/4.8.4 (Linux/3.4.9-2-desktop; KDE/4.8.4; x86_64; ; )
In-Reply-To: <20120822223238.GO19212@google.com>
References: <20120822223238.GO19212@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 22. August 2012, 15:32:38 schrieb Tejun Heo:
> There isn't much reason to use custom workqueue in nvec.  It can use
> system_nrt_wq instead and cancel the two work items on removal.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> Marc, I think I'll do this conversion in two steps.  system_nrt_wq ->
> system_wq conversion should be trivial after 3.7 merge window.

I'm fine with that. Thanks for spitting up the large patch.
I cc the staging list.

Greg, can you pick it up for 3.7?

Signed-off-by: Marc Dietrich <marvin24@gmx.de>

>  drivers/staging/nvec/nvec.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
> index 695ea35..daaef24 100644
> --- a/drivers/staging/nvec/nvec.c
> +++ b/drivers/staging/nvec/nvec.c
> @@ -264,7 +264,7 @@ int nvec_write_async(struct nvec_chip *nvec, const
> unsigned char *data, list_add_tail(&msg->node, &nvec->tx_data);
>  	spin_unlock_irqrestore(&nvec->tx_lock, flags);
> 
> -	queue_work(nvec->wq, &nvec->tx_work);
> +	queue_work(system_nrt_wq, &nvec->tx_work);
> 
>  	return 0;
>  }
> @@ -470,7 +470,7 @@ static void nvec_rx_completed(struct nvec_chip *nvec)
>  	if (!nvec_msg_is_event(nvec->rx))
>  		complete(&nvec->ec_transfer);
> 
> -	queue_work(nvec->wq, &nvec->rx_work);
> +	queue_work(system_nrt_wq, &nvec->rx_work);
>  }
> 
>  /**
> @@ -791,13 +791,11 @@ static int __devinit tegra_nvec_probe(struct
> platform_device *pdev) INIT_LIST_HEAD(&nvec->tx_data);
>  	INIT_WORK(&nvec->rx_work, nvec_dispatch);
>  	INIT_WORK(&nvec->tx_work, nvec_request_master);
> -	nvec->wq = alloc_workqueue("nvec", WQ_NON_REENTRANT, 2);
> 
>  	err = devm_gpio_request_one(&pdev->dev, nvec->gpio, GPIOF_OUT_INIT_HIGH,
>  					"nvec gpio");
>  	if (err < 0) {
>  		dev_err(nvec->dev, "couldn't request gpio\n");
> -		destroy_workqueue(nvec->wq);
>  		return -ENODEV;
>  	}
> 
> @@ -805,7 +803,6 @@ static int __devinit tegra_nvec_probe(struct
> platform_device *pdev) "nvec", nvec);
>  	if (err) {
>  		dev_err(nvec->dev, "couldn't request irq\n");
> -		destroy_workqueue(nvec->wq);
>  		return -ENODEV;
>  	}
>  	disable_irq(nvec->irq);
> @@ -859,7 +856,8 @@ static int __devexit tegra_nvec_remove(struct
> platform_device *pdev)
> 
>  	nvec_write_async(nvec, EC_DISABLE_EVENT_REPORTING, 3);
>  	mfd_remove_devices(nvec->dev);
> -	destroy_workqueue(nvec->wq);
> +	cancel_work_sync(&nvec->rx_work);
> +	cancel_work_sync(&nvec->tx_work);
> 
>  	return 0;
>  }
