Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab1BBAHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:07:09 -0500
Received: from sh.osrg.net ([192.16.179.4]:43055 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab1BBAHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:07:07 -0500
Date: Wed, 2 Feb 2011 09:06:34 +0900
To: cebbert@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, hancockrwd@gmail.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: b44 driver causes panic when using swiotlb
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20110201161859.467676b0@katamari>
References: <4D4759BD.2000006@gmail.com>
	<20110201102707C.fujita.tomonori@lab.ntt.co.jp>
	<20110201161859.467676b0@katamari>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110202090615Q.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 02 Feb 2011 09:06:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 16:18:59 -0500
Chuck Ebbert <cebbert@redhat.com> wrote:

> > swiotlb allocates the bounce buffer when a system boots up. We can't
> > allocate much in GFP_DMA. swiotlb uses somewhere under 4GB. So it
> > can't help devices that have odd dma_mask (that is, except for 4GB).
> > 
> > Unfortunately, Such device needs to do own custom bouncing or needs
> > their subsystem to does that.
> 
> I think we're chasing the wrong problem here.
> 
> swiotlb uses alloc_bootmem_low_pages() to try to get buffers as low
> in memory as possible. I asked someone who is hitting this bug to
> try 2.6.36 and he reports the buffers really are low there:
> 
> 2.6.36:  5c00000
> 2.6.37: db600000
> 
> So something happened very early in the 2.6.37-rc cycle that changed
> this behavior. I tried looking at the bootmem code but could not see
> the problem. The only related option I could find in .config was this:
> 
> # CONFIG_NO_BOOTMEM is not set
> 
> It was set this way in both .36 and .37.

I don't think this matters because we can't guarantee that swiotlb
can't allocate ZONE_DMA. Obviously, the default swiotlb bouncing
buffer size, 64MB, is too large for ZONE_DMA.

If you are lucky, you sometimes can allocate lower memory if swiotlb
allocates lower memory at the boot time. But you can't assume
that. swiotlb isn't designed to handle such.

Can you try the patch that I sent you? As I wrote, b44 has the own
bouncing mechanism, so we should be fine if swiotlb returns an
appropriate error instead of just panicking.
