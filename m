Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0DLJAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 05:00:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49185 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab0DLI77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:59:59 -0400
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       Pedro Ribeiro <pedrib@gmail.com>, <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, <alsa-devel@alsa-project.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
From: Andi Kleen <andi@firstfloor.org>
References: <20100407090623.GN30807@buzzloop.caiaq.de>
	<Pine.LNX.4.44L0.1004071036060.1779-100000@iolanthe.rowland.org>
Date: Mon, 12 Apr 2010 10:59:57 +0200
In-Reply-To: <Pine.LNX.4.44L0.1004071036060.1779-100000@iolanthe.rowland.org> (Alan Stern's message of "Wed, 7 Apr 2010 10:59:47 -0400 (EDT)")
Message-ID: <87sk719hbm.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:
>> 
>> The fix is to use usb_buffer_alloc() for that purpose which ensures
>> memory that is suitable for DMA. And on x86_64, this also means that the
>> upper 32 bits of the address returned are all 0's.
>
> That is not a good fix.  usb_buffer_alloc() provides coherent memory, 
> which is not what we want.  I believe the correct fix is to specify the 
> GFP_DMA32 flag in the kzalloc() call.

The traditional way to handle this is to leave it to swiotlb in
pci_map_*. pci_map_* is needed anyways if you run with a IOMMU.

Also note at least on x86 systems coherent memory is the same as non coherent
memory. And GFP_DMA32 is a x86 specific flag, doesn't necessarily 
do any good anywhere else.

So if you add x86isms anyways you could as well use dma_alloc_coherent()
directly which is actually better at this than a simple GFP_DMA32
and as a bonus handles the IOMMUs correctly too.

Or just use GFP_KERNEL and pci_map_* later.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
