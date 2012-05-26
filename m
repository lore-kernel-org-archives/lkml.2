Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2EZIsd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 04:48:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45810 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab2EZIsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 04:48:31 -0400
Date: Sat, 26 May 2012 09:48:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 6/6] serial: add amba-pl011-pci
Message-ID: <20120526084819.GF24149@n2100.arm.linux.org.uk>
References: <cover.1337959750.git.rubini@gnudd.com> <b166cb0fce2a67b24da5808604553b4196258f45.1337959750.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b166cb0fce2a67b24da5808604553b4196258f45.1337959750.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One other point.

On Fri, May 25, 2012 at 05:48:57PM +0200, Alessandro Rubini wrote:
> +/* This is a template, copied every time a new pci device appears */
> +static AMBA_APB_DEVICE(pl011_pci_template, "pl011-pci", 0,
> +		       0 /* base */, {0} /* irqs */, NULL /* data */);

APB device.  It's a _peripheral_, it only has a _slave_ port which can't
initiate DMA, so:

> +	if (pdev->vendor == PCI_VENDOR_ID_STMICRO) {
> +		/* Under sta2x11, DMA is there but limited to 512M */
> +		adev->dma_mask = SZ_512M - 1;
> +		adev->dev.coherent_dma_mask = SZ_512M - 1;
> +	}

This is pointless and unnecessary.  The PL011 driver itself doesn't use
_this_ struct device for anything to do with DMA at all.  That's all
handled by the DMA engine's struct device.

That's true of all APB devices.  Only AHB devices with a master port can
initiate bus transactions, and hence cause accesses to other parts of the
system.
