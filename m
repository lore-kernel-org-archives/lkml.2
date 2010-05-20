Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab0ETV23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 17:28:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754546Ab0ETV22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 17:28:28 -0400
Date: Thu, 20 May 2010 14:28:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Du, Alek" <alek.du@intel.com>
Cc: David Brownell <david-b@pacbell.net>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: add Penwell gpio support
Message-Id: <20100520142821.ed6efd58.akpm@linux-foundation.org>
In-Reply-To: <20100518154025.4aaff2ee@dxy2>
References: <20100518154025.4aaff2ee@dxy2>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010 15:40:25 +0800
"Du, Alek" <alek.du@intel.com> wrote:

> >From 963f6e83843b0f94f8a5337def6e897ec5bb99bf Mon Sep 17 00:00:00 2001
> From: Alek Du <alek.du@intel.com>
> Date: Thu, 25 Feb 2010 14:32:46 +0800
> Subject: [PATCH] gpio: add Penwell gpio support
> 
> Intel Penwell chip has two 96 pins GPIO blocks, which are very similiar as
> Intel Langwell chip GPIO block, except for pin number difference. This
> patch expends the original Langwell GPIO driver to support Penwell's.
> 

Has the driver been retested on Moorestown?

> -static int lnw_gpio_get(struct gpio_chip *chip, unsigned offset)
> +static inline void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
> +			enum GPIO_REG reg_type)
>  {
>  	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
> +	unsigned nreg = chip->ngpio / 32;
>  	u8 reg = offset / 32;
> -	void __iomem *gplr;
> +	void __iomem *ptr;
> +
> +	ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg * 4);
> +	return ptr;
> +}

inlining this function was probably the wrong thing to do.  But modern
gcc's often just ignore the `inline' and do the right thing anyway.


> -static struct pci_device_id lnw_gpio_ids[] = {
> -	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f) },
> +static struct pci_device_id lnw_gpio_ids[] = {      /* pin number */
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f), .driver_data = 64 },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081f), .driver_data = 96 },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081a), .driver_data = 96 },
>  	{ 0, }

I suppose we should be using DEFINE_PCI_DEVICE_TABLE() here.


