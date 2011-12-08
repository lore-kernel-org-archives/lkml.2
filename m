Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab1LHRro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 12:47:44 -0500
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:49030 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751545Ab1LHRrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 12:47:40 -0500
MIME-Version: 1.0
In-Reply-To: <CALfB72BHLmN_vkpz9j7mi4yQWaYfJOojqopJ6d4911vuf3WRAA@mail.gmail.com>
References: <CALfB72BHLmN_vkpz9j7mi4yQWaYfJOojqopJ6d4911vuf3WRAA@mail.gmail.com>
From: Roland Dreier <roland@purestorage.com>
Date: Thu, 8 Dec 2011 09:47:18 -0800
Message-ID: <CAL1RGDVh7gNTrteiEaGg=4fxW=p3ydZPVf4d1hgtwNT9xUdOMw@mail.gmail.com>
Subject: Re: kernel BUG at drivers/iommu/intel-iommu.c:1767 on F16 3.1.1-2.fc16.x86_64
To: Albert Strasheim <fullung@gmail.com>
Cc: linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Any help would be appreciated. Would a firmware upgrade make a difference?

Almost certainly not a firmware issue.

 > [  597.412843] kernel BUG at drivers/iommu/intel-iommu.c:1767!

So this is

        BUG_ON(addr_width < BITS_PER_LONG && (iov_pfn + nr_pages - 1)
>> addr_width);

in __domain_mapping() I believe.  And we have:

        int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;

How much RAM does you system have?

I don't know too much about the low-level VT-d details, but is it
possible the setup code
is choosing a too small "guest address width" to cover all your memory?

drivers/net/ethernet/mellanox/mlx4/main.c has

        err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
        if (err) {
                dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI
DMA mask.\n");
                err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
                if (err) {
                        dev_err(&pdev->dev, "Can't set PCI DMA mask,
aborting.\n");
                        goto err_release_regions;
                }
        }
        err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
        if (err) {
                dev_warn(&pdev->dev, "Warning: couldn't set 64-bit "
                         "consistent PCI DMA mask.\n");
                err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
                if (err) {
                        dev_err(&pdev->dev, "Can't set consistent PCI
DMA mask, "
                                "aborting.\n");
                        goto err_release_regions;
                }
        }

do you see any warnings in your kernel log about setting the PCI DMA mask?
(in any case that should only affect bus addresses, not "guest addresses")

David, any idea?

 - R.
