Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab3AHQYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:24:24 -0500
Received: from tex.lwn.net ([70.33.254.29]:41713 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756502Ab3AHQYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:24:23 -0500
Date: Tue, 8 Jan 2013 09:24:22 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2nd attempt: help with dma_alloc_coherent() +
 dma_free_coherent()
Message-ID: <20130108092422.08fa669c@lwn.net>
In-Reply-To: <CAAJw_Zv8O1LPX-jmpg3fvNrWMLWbQC=1tbZ6T7nsm6cyC008fg@mail.gmail.com>
References: <CAAJw_Zv8O1LPX-jmpg3fvNrWMLWbQC=1tbZ6T7nsm6cyC008fg@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2013 23:51:59 +0800
Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> I'm trying to understand how this oops in the diva driver and it's just a
> simple dma_alloc_coherent() followed by dma_free_coherent(), but it oops.
> Why?

Hmm...from a quick look...

> static u32 *clock_data_addr;
> static dma_addr_t clock_data_bus_addr;
> 
>         if((clock_data_addr = dma_alloc_coherent(NULL, PAGE_SIZE,
>                         &clock_data_bus_addr, GFP_KERNEL)) != 0) {
>                 printk(KERN_INFO "dma_alloc_coherent ok\n");
>                 memset (clock_data_addr, 0x00, PAGE_SIZE);
>         } else
>                 printk(KERN_INFO "dma_alloc_coherent bad!!!\n");
>         if(clock_data_addr) {
>                 printk(KERN_INFO "dma_free_coherent!!!\n");
>                 dma_free_coherent(NULL, PAGE_SIZE, clock_data_addr,
>                         clock_data_bus_addr);
>                 clock_data_addr = NULL;
>         }

Perhaps passing NULL as your device structure pointer might just have
something to do with a crash due to a null pointer dereference?  If you're
doing DMA, you should have a device.  Try passing it and you might just
find that things work better.

(Incidentally, this:

> IP: [<ffffffff813ec01c>] iommu_no_mapping+0xc/0xee

is a fairly good clue as well - it's trying to dereference the device
structure pointer).

jon
