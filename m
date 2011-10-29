Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab1J2XtX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:49:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38546 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab1J2XtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:49:15 -0400
Date: Sat, 29 Oct 2011 14:03:19 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Steve Wilkins <steve.wilkins@raymarine.com>
Subject: Re: [PATCH 1/3] OMAP: SPI: Use a workqueue per omap2_mcspi controller
Message-ID: <20111029120319.GD22592@ponder.secretlab.ca>
References: <1319802259-16565-1-git-send-email-shubhrajyoti@ti.com>
 <1319802259-16565-2-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319802259-16565-2-git-send-email-shubhrajyoti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 05:14:17PM +0530, Shubhrajyoti D wrote:
> Currently all the spi controllers share the work queue.
> This patch allocates a work queue per controller.
> 
> Signed-off-by: Steve Wilkins <steve.wilkins@raymarine.com>
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>

Applied for v3.3, thanks.

g.

> ---
>  drivers/spi/spi-omap2-mcspi.c |   19 +++++++++++--------
>  1 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> index a8b614b..471b0f3 100644
> --- a/drivers/spi/spi-omap2-mcspi.c
> +++ b/drivers/spi/spi-omap2-mcspi.c
> @@ -121,6 +121,7 @@ struct omap2_mcspi {
>  	/* SPI1 has 4 channels, while SPI2 has 2 */
>  	struct omap2_mcspi_dma	*dma_channels;
>  	struct  device		*dev;
> +	struct workqueue_struct *wq;
>  };
>  
>  struct omap2_mcspi_cs {
> @@ -143,8 +144,6 @@ struct omap2_mcspi_regs {
>  
>  static struct omap2_mcspi_regs omap2_mcspi_ctx[OMAP2_MCSPI_MAX_CTRL];
>  
> -static struct workqueue_struct *omap2_mcspi_wq;
> -
>  #define MOD_REG_BIT(val, mask, set) do { \
>  	if (set) \
>  		val |= mask; \
> @@ -1043,7 +1042,7 @@ static int omap2_mcspi_transfer(struct spi_device *spi, struct spi_message *m)
>  
>  	spin_lock_irqsave(&mcspi->lock, flags);
>  	list_add_tail(&m->queue, &mcspi->msg_queue);
> -	queue_work(omap2_mcspi_wq, &mcspi->work);
> +	queue_work(mcspi->wq, &mcspi->work);
>  	spin_unlock_irqrestore(&mcspi->lock, flags);
>  
>  	return 0;
> @@ -1088,6 +1087,7 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
>  	struct omap2_mcspi	*mcspi;
>  	struct resource		*r;
>  	int			status = 0, i;
> +	char			wq_name[20];
>  
>  	master = spi_alloc_master(&pdev->dev, sizeof *mcspi);
>  	if (master == NULL) {
> @@ -1111,6 +1111,13 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
>  	mcspi = spi_master_get_devdata(master);
>  	mcspi->master = master;
>  
> +	sprintf(wq_name, "omap2_mcspi/%d", master->bus_num);
> +	mcspi->wq = alloc_workqueue(wq_name, WQ_MEM_RECLAIM, 1);
> +	if (mcspi->wq == NULL) {
> +		status = -ENOMEM;
> +		goto err1;
> +	}
> +
>  	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (r == NULL) {
>  		status = -ENODEV;
> @@ -1216,6 +1223,7 @@ static int __exit omap2_mcspi_remove(struct platform_device *pdev)
>  	spi_unregister_master(master);
>  	iounmap(base);
>  	kfree(dma_channels);
> +	destroy_workqueue(mcspi->wq);
>  
>  	return 0;
>  }
> @@ -1274,10 +1282,6 @@ static struct platform_driver omap2_mcspi_driver = {
>  
>  static int __init omap2_mcspi_init(void)
>  {
> -	omap2_mcspi_wq = create_singlethread_workqueue(
> -				omap2_mcspi_driver.driver.name);
> -	if (omap2_mcspi_wq == NULL)
> -		return -1;
>  	return platform_driver_probe(&omap2_mcspi_driver, omap2_mcspi_probe);
>  }
>  subsys_initcall(omap2_mcspi_init);
> @@ -1286,7 +1290,6 @@ static void __exit omap2_mcspi_exit(void)
>  {
>  	platform_driver_unregister(&omap2_mcspi_driver);
>  
> -	destroy_workqueue(omap2_mcspi_wq);
>  }
>  module_exit(omap2_mcspi_exit);
>  
> -- 
> 1.7.1
> 
> 
> ------------------------------------------------------------------------------
> The demand for IT networking professionals continues to grow, and the
> demand for specialized networking skills is growing even more rapidly.
> Take a complimentary Learning@Cisco Self-Assessment and learn 
> about Cisco certifications, training, and career opportunities. 
> http://p.sf.net/sfu/cisco-dev2dev
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general
