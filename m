Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab1DGW1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:27:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43132
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755867Ab1DGW1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:27:43 -0400
Date: Thu, 07 Apr 2011 15:27:07 -0700 (PDT)
Message-Id: <20110407.152707.39195948.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, bheglaas@google.com, monstr@monstr.eu,
        tglx@linuxtronix.de, bigeasy@linuxtronix.de
Subject: Re: [PATCH 1/5] pci/of: Match PCI devices to OF nodes dynamically
From: David Miller <davem@davemloft.net>
In-Reply-To: <1302146796-26825-2-git-send-email-benh@kernel.crashing.org>
References: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
	<1302146796-26825-2-git-send-email-benh@kernel.crashing.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu,  7 Apr 2011 13:26:32 +1000

> powerpc has two different ways of matching PCI devices to their
> corresponding OF node (if any) for historical reasons. The ppc64 one
> does a scan looking for matching bus/dev/fn, while the ppc32 one does a
> scan looking only for matching dev/fn on each level in order to be
> agnostic to busses being renumbered (which Linux does on some
> platforms).
> 
> This removes both and instead moves the matching code to the PCI core
> itself. It's the most logical place to do it: when a pci_dev is created,
> we know the parent and thus can do a single level scan for the matching
> device_node (if any).
> 
> The benefit is that all archs now get the matching for free. There's one
> hook the arch might want to provide to match a PHB bus to its device
> node. A default weak implementation is provided that looks for the
> parent device device node, but it's not entirely reliable on powerpc for
> various reasons so powerpc provides its own.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This patch breaks the build on sparc:

> diff --git a/drivers/pci/of.c b/drivers/pci/of.c
> new file mode 100644
> index 0000000..c94d37e
> --- /dev/null
> +++ b/drivers/pci/of.c

This gets compiled in on all CONFIG_OF platforms, and:

> +void pci_set_of_node(struct pci_dev *dev)
> +{
> +	if (!dev->bus->dev.of_node)
> +		return;
> +	dev->dev.of_node = of_pci_find_child_device(dev->bus->dev.of_node,
> +						    dev->devfn);
> +}

it references of_pci_find_child_device().

However, of_pci_find_child_device() lives in drivers/of/of_pci.c which is not
built into the tree because you haven't provided the necessary changes to
drivers/of/Makefile in this patch.
