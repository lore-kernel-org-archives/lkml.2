Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0HDPkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:40:32 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:38408 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754095Ab0HDPka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:40:30 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: CGnke_AVM1naOkTliF_AKL0JlwWstdKJKAf8KUfefLtCKMd
 cRB8bENGTiXOU5O5cUdkFAk1xE5_i2yc2Dqw0iLtx1y5EEkWd4L4QCi83Hgz
 oVkkUqmnUSwogXfmIeSFhYtWKky1qyvQMQRqBA.3EQx8OukZ1jy6QJRhSaoM
 nfaHW_GJ4EGWjd3wHOJP.4c2oQ23kaIdUPXVdkkgoEe6cJ7_VnHCF5p5HjA_
 Om0AViNRVAVtlu8XBhW9_AeNjdZYfrC39fEVDqyiYVY6CluU3
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 Aug 2010 10:40:27 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Peter Crosthwaite <peter.crosthwaite@petalogix.com>
cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, mpm@selenic.com,
        Michal Simek <michal.simek@petalogix.com>,
        "Edgar E. Iglesias" <edgar.iglesias@petalogix.com>,
        John Williams <john.williams@petalogix.com>
Subject: Re: Using Bootmem for large DMA buffers in the presence of the slab
  allocator
In-Reply-To: <AANLkTimK4NhXasetA4ZeeCeGSGySRNm8n=UgT+1oY_2g@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1008040951170.11084@router.home>
References: <AANLkTimK4NhXasetA4ZeeCeGSGySRNm8n=UgT+1oY_2g@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010, Peter Crosthwaite wrote:

> Because the buffer was too large for kmalloc, the kmalloc call would
> fail. I traced the alloc_bootmem_low_pages() call further and
> discovered that since the kmalloc call was failing, it was falling
> back to alloc_bootmem_core(). So does this mean that the bootmem
> allocator is trying to allocate memory while the slab allocator is up
> and running? And is this supposed to work?

The bootmem allocator should not work when slab is fully up. However,
there is a grey period where the page allocator is not fully functional
yet but the slab allocator is mostly working.

> The reason i ask, is that when testing the system under high memory
> usage conditions, I would get a "Bad page state" BUG() for my
> allocated pages (see below). I have matched the pfns and confirmed
> that they correspond to the pages allocated by the
> alloc_bootmem_low_pages(). My theory is that the slab allocators list
> of free pages does not get updated by the bootmem allocator, so the
> slab allocator is seeing my DMA buffer as un-allocated. Does this
> sound correct?

bootmem allocations do not reserve page structs. So you do not have a page
state at all. If you do something that requires a page state then you will
have strange failures.
