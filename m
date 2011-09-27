Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab1I0OrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 10:47:18 -0400
Received: from sh.osrg.net ([192.16.179.4]:56741 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab1I0OrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 10:47:16 -0400
Date: Tue, 27 Sep 2011 23:47:03 +0900
To: bigeasy@linutronix.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH] x86/dma: make a zero length mapping length not dma
 capable
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1316540665-15622-1-git-send-email-bigeasy@linutronix.de>
References: <1316540665-15622-1-git-send-email-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110927233330N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 27 Sep 2011 23:47:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011 19:44:25 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> The following ooops happens during a call to dma_map_single():
> 
> | ------------[ cut here ]------------
> | kernel BUG at lib/swiotlb.c:409!
> | invalid opcode: 0000 [#1] SMP
> | CPU 1
> |
> | RIP: 0010:[<ffffffff811a00c9>]  [<ffffffff811a00c9>] swiotlb_tbl_map_single+0x87/0x1e0
> | Call Trace:
> |  [<ffffffff813170e0>] ? printk+0x43/0x48
> |  [<ffffffff8100d027>] ? load_TLS+0x7/0xa
> |  [<ffffffff811a0261>] ? map_single+0x3f/0x3f
> |  [<ffffffff811a02be>] ? swiotlb_map_page+0x5d/0xcd
> |  [<ffffffff811a0261>] ? map_single+0x3f/0x3f
> |  [<ffffffffa02946ca>] ? dwc3_map_buffer_to_dma+0x8a/0xe2 [dwc3]
> 
> As you know from the line 409 the size parameter was 0. This happens
> because the upper layer sends a zero length packet which the dwc3 driver
> tried to map.
> The memory is not really used and the hardware should not really issue a
> dma request however we must setup a dma descriptor which contains an
> address field and a size field which is set to 0 for the zero length
> packet to be sent. So the unconditional mapping was kinda convenient to
> do. ARM does not complain about length == 0, the swiotlb which is
> used on x86 makes trouble. Looking at other udc drivers, they either
> ignore this case or workaround it by incrementing the size by 1 which
> looks nasty.
> For now I fixed this by not mapping zero packets at all. Anything what I
> should expect from the DMA API? I.e. should it be okay to call
> dma_map_single() with size = 0?

I don't think so. I know that some dma API implementations are ok with
it and some are not though. Drivers should calling dma_map_* with a
size that they do DMA with.

Accepting zero means that you can't catch a bug that passes zero. If
calling dma_map_* with zero size returns an address that nicely leads
to a system crash when a driver starts DMA (like calling kmalloc with
zero), then accepting zero size would be ok. But I don't think that
we can implement something like that.

