Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab1FHWdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 18:33:35 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33963 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab1FHWde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 18:33:34 -0400
Date: Wed, 8 Jun 2011 16:33:31 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH/RESEND v4 1/2] spi_topcliff_pch: support new device
 ML7213 IOH
Message-ID: <20110608223331.GD17138@ponder.secretlab.ca>
References: <1307425811-5030-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307425811-5030-1-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 02:50:10PM +0900, Tomoya MORINAGA wrote:
> ***Modify Grant's comments.
>    - Delete unrelated whitespace
>    - Prevent device driver from accessing platform data
>    - Add __devinit and __devexit
>    - Save pdev->dev to pd_dev->dev.parent
>    - Have own suspend/resume processing in platform_driver.
>    - Care returned value in pch_spi_init
>    - Change unregister order
> 
> Support ML7213 device of OKI SEMICONDUCTOR.
> ML7213 is companion chip of Intel Atom E6xx series for IVI(In-Vehicle Infotainment).
> ML7213 is compatible for Intel EG20T PCH.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---

Hi Tomoya,

comment below...

> -static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +static int __devinit pch_spi_pd_probe(struct platform_device *plat_dev)
>  {
> -
> +	int ret;
>  	struct spi_master *master;
> +	struct pch_spi_board_data *board_dat = dev_get_platdata(&plat_dev->dev);
> +	struct pch_spi_data *data;
>  
> -	struct pch_spi_board_data *board_dat;
> -	int retval;
> -
> -	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
> -
> -	/* allocate memory for private data */
> -	board_dat = kzalloc(sizeof(struct pch_spi_board_data), GFP_KERNEL);
> -	if (board_dat == NULL) {
> -		dev_err(&pdev->dev,
> -			" %s memory allocation for private data failed\n",
> -			__func__);
> -		retval = -ENOMEM;
> -		goto err_kmalloc;
> -	}
> -
> -	dev_dbg(&pdev->dev,
> -		"%s memory allocation for private data success\n", __func__);
> -
> -	/* enable PCI device */
> -	retval = pci_enable_device(pdev);
> -	if (retval != 0) {
> -		dev_err(&pdev->dev, "%s pci_enable_device FAILED\n", __func__);
> -
> -		goto err_pci_en_device;
> +	master = spi_alloc_master(&board_dat->pdev->dev,
> +				  sizeof(struct pch_spi_data));
> +	if (!master) {
> +		dev_err(&plat_dev->dev, "spi_alloc_master[%d] failed.\n",
> +			plat_dev->id);
> +		return -ENOMEM;
>  	}
>  
> -	dev_dbg(&pdev->dev, "%s pci_enable_device returned=%d\n",
> -		__func__, retval);
> +	data = spi_master_get_devdata(master);
> +	data->master = master;
>  
> -	board_dat->pdev = pdev;
> +	platform_set_drvdata(plat_dev, data);
>  
> -	/* alllocate memory for SPI master */
> -	master = spi_alloc_master(&pdev->dev, sizeof(struct pch_spi_data));
> -	if (master == NULL) {
> -		retval = -ENOMEM;
> -		dev_err(&pdev->dev, "%s Fail.\n", __func__);
> -		goto err_spi_alloc_master;
> +	/* baseaddress + 0x20(offset) */
> +	data->io_remap_addr = pci_iomap(board_dat->pdev, 1, 0) +
> +						   0x20 * plat_dev->id;
> +	if (!data->io_remap_addr) {
> +		dev_err(&plat_dev->dev, "%s pci_iomap failed\n", __func__);
> +		ret = -ENOMEM;
> +		goto err_pci_iomap;
>  	}
>  
> -	dev_dbg(&pdev->dev,
> -		"%s spi_alloc_master returned non NULL\n", __func__);
> +	dev_dbg(&plat_dev->dev, "[ch%d] remap_addr=%p\n",
> +		plat_dev->id, data->io_remap_addr);
>  
>  	/* initialize members of SPI master */
> -	master->bus_num = -1;
> +	master->bus_num = plat_dev->id;

This shouldn't be here.  The bus id should be dynamically allocated,
and using the plat_dev->id assumes that there are no other spi busses
in the system, which is a bad assumption.

I picked up the patch (it's about time I guess, I've left this out
alone for too long), but I've dropped this hunk.

You can post a followup patch if it broke anything.

g.

