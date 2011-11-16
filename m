Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1KPJk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:40:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab1KPJk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:40:27 -0500
Message-ID: <4EC384FF.4050003@redhat.com>
Date: Wed, 16 Nov 2011 11:40:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Ohad Ben-Cohen <ohad@wizery.com>,
        David Brown <davidb@codeaurora.org>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 0/2] Introduce iommu_commit() function
References: <1308843083-10442-1-git-send-email-joerg.roedel@amd.com> <1308843536.16742.48.camel@i7.infradead.org>
In-Reply-To: <1308843536.16742.48.camel@i7.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2011 06:38 PM, David Woodhouse wrote:
> On Thu, 2011-06-23 at 17:31 +0200, Joerg Roedel wrote:
> > David, I think especially VT-d can benefit from such a callback. I will
> > implement support for it in the AMD IOMMU driver and post a patch-set
> > soon.
> > 
> > Any comments, thoughts?
>
> Ick. We *already* do the flushes as appropriate while we're filling the
> page tables. So every time we move on from one page table page to the
> next, we'll flush the old one. And when we've *done* filling the page
> tables for the range we've been asked to map, we flush the last writes
> too.

For the current kvm use case flushing just once on commit is most
efficient.  If/when we get resumable io faults, per-page flushing
becomes worthwhile.

> The problem with KVM is that it calls us over and over again to map a
> single 4KiB page.
>
> It doesn't seem simple to make use of a 'commit' function, because we'd
> have to keep track of *which* page tables are dirty.

You could easily do that by using a free bit in the pte as a dirty bit. 
You can then choose whether to use per-page flush or a full flush.

> I'd much rather KVM just gave us a list of the pages to map, in a single
> call. 

The list can easily be several million pages long.

> Or even a 'translation' callback we could call to get the physical
> address for each page in the range.

This is doable, and is probably most flexible.  If the translation also
returns ranges, then you don't have to figure out large mappings yourself.

Not that there's a huge difference between

   iommu_begin(iommu_transaction, domain)
   for (page in range)
         iommu_map(iommu_transaction, page, translate(page))
    iommu_commit(iommu_transaction)

and

   iommu_map(domain, range, translate)

- one can be converted to the other.

-- 
error compiling committee.c: too many arguments to function

