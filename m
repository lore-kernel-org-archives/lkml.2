Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab2HUTtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:49:35 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64230 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab2HUTtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:49:32 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 21 Aug 2012 12:49:36 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: David Daney <ddaney.cavm@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linux-doc@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [2/2] spi: Add SPI master controller for OCTEON SOCs.
Message-ID: <20120821194936.GA7145@roeck-us.net>
References: <1336772086-17248-3-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336772086-17248-3-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 08:34:46PM -0000, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Add the driver, link it into the kbuild system and provide device tree
> binding documentation.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
[ ... ]

> +
> +static int __devexit octeon_spi_remove(struct platform_device *pdev)
> +{
> +	struct octeon_spi *p = platform_get_drvdata(pdev);
> +	struct spi_master *master = p->my_master;
> +
> +	spi_unregister_master(master);
> +

I know it is a bit late, but ...

The call to spi_unregister_master() frees the memory associated with master,
ie 'p', and the spi_master_put() below without matching spi_master_get() is
unnecessary/wrong. One possible fix would be to use 

	struct spi_master *master = spi_master_get(p->my_master);

above. That protects master and p while it is still being used, and makes use
of the call to spi_master_put() below. Another option might be to move
cvmx_write_csr() ahead of the call to spi_unregister_master() and drop the
call to spi_master_put().

Guenter

> +	/* Clear the CSENA* and put everything in a known state. */
> +	cvmx_write_csr(p->register_base + OCTEON_SPI_CFG, 0);
> +	spi_master_put(master);
> +	return 0;
> +}
> +
