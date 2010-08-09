Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab0HILMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 07:12:31 -0400
Received: from www.tglx.de ([62.245.132.106]:49594 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076Ab0HILM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 07:12:29 -0400
Date: Mon, 9 Aug 2010 13:11:56 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Tom Lyon <pugs@cisco.com>, mst@redhat.com, hjk@linutronix.de,
        gregkh@suse.de, chrisw@sous-sol.org, joro@8bytes.org, avi@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: UIO DMA to userspace question
Message-ID: <20100809111155.GB2569@local>
References: <AANLkTimWdaBrJz-dQ3MHWwG7iZ5m1opSmLFKva880csi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimWdaBrJz-dQ3MHWwG7iZ5m1opSmLFKva880csi@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 08:38:30PM +0200, Leon Woestenberg wrote:
> Hello all,
> 
> can I use the UIO framework for the following?
> 
> The userspace portion of the driver allocates memory in user-space
> using malloc() - usually resulting in a scatter pages in physical
> memory.
> The UIO kernel portion of the driver maps those using pci_map_sg().
> 
> Is this possible, or does the UIO framework assume memory for DMA is
> allocated in kernel space?

You would have to write your own mmap() function and and set the pointer
to it in struct uio_info->mmap. Have a look at uio_mmap() in
drivers/uio/uio.c to see when your function will be called, and what is
checked before that call.

If that works, we might invent a new UIO_MEM_* type, and move your function
over to the UIO core, if this is interesting for other people.

Anyway, sooner or later we should have a generic way of handling DMA in
UIO. The topic comes up every few month, but nobody came up with an
acceptable solution yet. It should probably be a separate uio_dma device,
e.g. for a /dev/uio0 you'll get a /dev/uio_dma0 if the driver sets a flag
indicating it needs DMA support. This new uio_dma device should then have
an API (to be defined, without ioctl if possible) that provides the
necessary functionality. But that's just a thought ATM. Ideas/patches are
welcome.

Thanks,
Hans

