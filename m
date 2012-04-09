Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab2DIN7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 09:59:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56885 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2DIN7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 09:59:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH 3/3] arch/tile: tilegx PCI root complex support
Date: Mon, 9 Apr 2012 13:59:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Myron Stowe <myron.stowe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Joe Perches <joe@perches.com>, David Howells <dhowells@redhat.com>
References: <201204072316.q37NGv8d019280@farm-0023.internal.tilera.com> <201204072319.q37NJlNp019384@farm-0023.internal.tilera.com>
In-Reply-To: <201204072319.q37NJlNp019384@farm-0023.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204091359.13059.arnd@arndb.de>
X-Provags-ID: V02:K0:mx0BizWxi3Cz7/0X4+YAK5pV22zHeAZVKoZYLx0GFF1
 raaU3bRQzktOCEz3HZxoVtFwmiog3HJiHTR1vccJWIdhJHPNM/
 enbWQkeWhnXGI7glMbsXxED69buy+Cb57pn/4vVF+SCnakhOu7
 2tYwUhslB+0Z+tPSOuBUdgln3iBl22FJKiNAOymX9n86PFBE3o
 itJ+gcVwvBfc6xMxCBqBO9bMY2sZSHwfmpEXvOApvAwBMqkIxv
 azgOqSW7FAwhmTEzzAwh+irtIYNNyCYvc3eaMy6Aj1Fj8x5Twd
 4VCUdz39Kzhx/ajbJn9RJr5vv9/2nkt5ppxgqX3uYfTwe3fwnV
 Dhxc5RVRTf7NilyqNSOk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 April 2012, Chris Metcalf wrote:
> This change implements PCIe root complex support for tilegx using
> the kernel support layer for accessing the TRIO hardware shim.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Hi Chris,

I don't know if we discussed it during the initial merge, but I notice that the PIO
accessors (inb/outb and friends) are still not implemented in this patch. Normally
PIO can just be mapped into the MMIO address space, so that inb() becomes
a call to readb() with an offset on the address.

> +/*
> + * Second PCI initialization entry point, called by subsys_initcall.
> + *
> + * The controllers have been set up by the time we get here, by a call to
> + * tile_pci_init.
> + */
> +int __devinit pcibios_init(void)
> +{
> +	resource_size_t offset;
> +	int i;
> +
> +        if (num_rc_controllers == 0 && num_ep_controllers == 0)
> +		return 0;
> +
> +	pr_info("PCI: Probing PCI hardware\n");
> +
> +	/*
> +	 * We loop over all the TRIO shims and set up the MMIO mappings.
> +	 * This step can't be done in tile_pci_init because the MM subsystem
> +	 * hasn't been initialized then.
> +	 */
> +	for (i = 0; i < TILEGX_NUM_TRIO; i++) {
> +		gxio_trio_context_t *context = &trio_contexts[i];
> +
> +		if (context->fd < 0)
> +			continue;
> +
> +		/*
> +		 * Map in the MMIO space for the MAC.
> +                 */
> +		offset = 0;
> +		context->mmio_base_mac =
> +			iorpc_ioremap(context->fd, offset,
> +				      HV_TRIO_CONFIG_IOREMAP_SIZE);
> +		if (context->mmio_base_mac == NULL) {
> +			pr_err("PCI: MAC map failure on TRIO %d\n", i);
> +
> +			hv_dev_close(context->fd);
> +			context->fd = -1;
> +			continue;
> +		}
> +	}
> +
> +	/*
> +	 * Delay a bit in case devices aren't ready.  Some devices are
> +	 * known to require at least 20ms here, but we use a more
> +	 * conservative value.
> +	 */
> +	mdelay(250);

Using mdelay is generally considered very rude. Since you are not in atomic
context here, just use msleep() instead.

	Arnd
