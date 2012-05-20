Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab2ETFrB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 01:47:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34006 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2ETFq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 01:46:58 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] spi: Add SPI master controller for OCTEON SOCs.
To: David Daney <ddaney.cavm@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-doc@vger.kernel.org, David Daney <david.daney@cavium.com>
In-Reply-To: <1336772086-17248-3-git-send-email-ddaney.cavm@gmail.com>
References: <1336772086-17248-1-git-send-email-ddaney.cavm@gmail.com> <1336772086-17248-3-git-send-email-ddaney.cavm@gmail.com>
Date: Sat, 19 May 2012 23:46:56 -0600
Message-Id: <20120520054657.091DA3E03B8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012 14:34:46 -0700, David Daney <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Add the driver, link it into the kbuild system and provide device tree
> binding documentation.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

Some comments below, but you can add my a-b:

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> +#include <asm/octeon/octeon.h>
> +#include <asm/octeon/cvmx-mpi-defs.h>
> +
> +#define DRV_VERSION "2.0" /* Version 1 was the out-of-tree driver */

As already discussed, drop this line.

> +#define DRV_DESCRIPTION "Cavium, Inc. OCTEON SPI bus driver"

Used exactly once.  Drop this line and move string to the
MODULE_DESCRIPTION().

> +static int __devinit octeon_spi_probe(struct platform_device *pdev)
> +{
> +
> +	struct resource *res_mem;
> +	struct spi_master *master;
> +	struct octeon_spi *p;
> +	int err = -ENOENT;
> +
> +	master = spi_alloc_master(&pdev->dev, sizeof(struct octeon_spi));
> +	if (!master)
> +		return -ENOMEM;
> +	p = spi_master_get_devdata(master);
> +	platform_set_drvdata(pdev, p);
> +	p->my_master = master;
> +
> +	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> +	if (res_mem == NULL) {
> +		dev_err(&pdev->dev, "found no memory resource\n");
> +		err = -ENXIO;
> +		goto fail;
> +	}
> +	if (!devm_request_mem_region(&pdev->dev, res_mem->start,
> +				     resource_size(res_mem), res_mem->name)) {
> +		dev_err(&pdev->dev, "request_mem_region failed\n");
> +		goto fail;
> +	}
> +	p->register_base = (u64)devm_ioremap(&pdev->dev, res_mem->start,
> +					     resource_size(res_mem));

Nasty cast.  p->register_base needs to be an __iomem pointer
variable.  The fact taht cvmx_read_csr accepts a uint64_t instead of
an __iomem pointer looks really wrong.  Why is it written that way?

> +
> +	/* Dynamic bus numbering */
> +	master->bus_num = -1;
> +	master->num_chipselect = 4;
> +	master->mode_bits = SPI_CPHA |
> +			    SPI_CPOL |
> +			    SPI_CS_HIGH |
> +			    SPI_LSB_FIRST |
> +			    SPI_3WIRE;
> +
> +	master->setup = octeon_spi_setup;
> +	master->cleanup = octeon_spi_cleanup;
> +	master->prepare_transfer_hardware = octeon_spi_nop_transfer_hardware;
> +	master->transfer_one_message = octeon_spi_transfer_one_message;
> +	master->unprepare_transfer_hardware = octeon_spi_nop_transfer_hardware;
> +
> +	master->dev.of_node = pdev->dev.of_node;
> +	err = spi_register_master(master);
> +	if (err) {
> +		dev_err(&pdev->dev, "register master failed: %d\n", err);
> +		goto fail;
> +	}
> +
> +	dev_info(&pdev->dev, "Version " DRV_VERSION "\n");
> +
> +	return 0;
> +fail:
> +	spi_master_put(master);
> +	return err;
> +}
> +
> +static int __devexit octeon_spi_remove(struct platform_device *pdev)
> +{
> +	struct octeon_spi *p = platform_get_drvdata(pdev);
> +	struct spi_master *master = p->my_master;
> +
> +	spi_unregister_master(master);
> +
> +	/* Clear the CSENA* and put everything in a known state. */
> +	cvmx_write_csr(p->register_base + OCTEON_SPI_CFG, 0);
> +	spi_master_put(master);
> +	return 0;
> +}
> +
> +static struct of_device_id octeon_spi_match[] = {
> +	{
> +		.compatible = "cavium,octeon-3010-spi",
> +	},
> +	{},

Nitpick:
	{ .compatible = "cavium,octeon-3010-spi", },
	{},

No need for the extra lines when it is so short.

> +};
> +MODULE_DEVICE_TABLE(of, octeon_spi_match);
> +
> +static struct platform_driver octeon_spi_driver = {
> +	.driver = {
> +		.name		= "spi-octeon",
> +		.owner		= THIS_MODULE,
> +		.of_match_table = octeon_spi_match,
> +	},
> +	.probe		= octeon_spi_probe,
> +	.remove		= __exit_p(octeon_spi_remove),

__devexit_p

> +};
> +
> +module_platform_driver(octeon_spi_driver);
> +
> +MODULE_DESCRIPTION(DRV_DESCRIPTION);
> +MODULE_VERSION(DRV_VERSION);
> +MODULE_AUTHOR("David Daney");
> +MODULE_LICENSE("GPL");
> -- 
> 1.7.2.3
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
