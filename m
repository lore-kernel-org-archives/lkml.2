Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab2JDNot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:44:49 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64168 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab2JDNor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:44:47 -0400
Date: Thu, 4 Oct 2012 09:33:21 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        x86@kernel.org
Subject: Re: [RFC PATCH 0/7] Improve swiotlb performance by using physical
 addresses
Message-ID: <20121004133319.GD9158@phenom.dumpdata.com>
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 05:38:41PM -0700, Alexander Duyck wrote:
> While working on 10Gb/s routing performance I found a significant amount of
> time was being spent in the swiotlb DMA handler.  Further digging found that a
> significant amount of this was due to the fact that virtual to physical
> address translation and calling the function that did it.  It accounted for
> nearly 60% of the total overhead.
> 
> This patch set works to resolve that by changing the io_tlb_start address and
> io_tlb_overflow_buffer address from virtual addresses to physical addresses.

The assertion in your patches is that the DMA addresses (bus address)
are linear is not applicable (unfortunatly). Meaning virt_to_phys() !=
virt_to_dma().

Now, on x86 and ia64 it is true - but one of the users of swiotlb
library is the Xen swiotlb - which cannot guarantee that the physical
address are 1-1 with the bus addresses. Hence the bulk of dealing with
figuring out the right physical to bus address is done in Xen-SWIOTLB
and the basics of finding an entry in the bounce buffer (if needed),
mapping it, unmapping ,etc is carried out by the generic library.

This is sad - b/c your patches are a good move forward.

Perhaps another way to do this is by having your patches split the
lookups in "chunks". Wherein we validate in swiotlb_init_*tbl that the
'tbl' (so the bounce buffer) is linear - if not, we split it up in
chunks. Perhaps the various backends can be responsible for this since
they would know which of their memory regions are linear or not. But
that sounds complicated and we don't want to complicate this library.

Or another way would be to provide 'phys_to_virt' and 'virt_to_phys'
functions for the swiotlb_tbl_{map|unmap}_single and the main library
(lib/swiotlb.c) can decide to use them. If they are NULL, then it
would do what your patches suggested. If they are defined, then
carry out those lookups on the 'empty-to-be-used' bounce buffer
address. Hm, that sounds like a better way of doing it.

