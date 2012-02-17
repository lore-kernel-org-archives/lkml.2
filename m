Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab2BQRTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:19:47 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48894 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2BQRTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:19:46 -0500
Date: Fri, 17 Feb 2012 17:19:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Jon Medhurst <tixy@yxit.co.uk>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sumit Bhattacharya <sumitb@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Naveen Yadav <yad.naveen@gmail.com>
Subject: Re: [PATCH 3/3] ARM: dma-mapping: fix array out of bound access
Message-ID: <20120217171915.GO27825@n2100.arm.linux.org.uk>
References: <1329494160-26942-1-git-send-email-ajeet.yadav.77@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329494160-26942-1-git-send-email-ajeet.yadav.77@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 09:26:00PM +0530, Ajeet Yadav wrote:
> In __dma_alloc_remap(*,size,*,*)/ __dma_free_remap(*,size) functions
> if virtual address is in the last consistent mapping region
> i.e idx == ((CONSISTENT_END - base) >> PMD_SHIFT) - 1
> and off == PTRS_PER_PTE.
> then we have array out of bound access condition.

How?  Where?

At the first loop, off will _never_ be PTRS_PER_PTE.

                u32 off = CONSISTENT_OFFSET(c->vm_start) & (PTRS_PER_PTE-1);

There is _absolutely_ _no_ _way_ that off could ever be PTRS_PER_PTE
here.

If 'base' is CONSISTENT_END, then we have far bigger problems, because
it means that we have a zero sized region - it certainly can't be any
larger than zero size because then we'd be overflowing the DMA region
into something else.

Plus, we know that 'end of region' allocations work fine, because the
code allocates from the top of the region downwards.

So, I don't think there's a problem here.
