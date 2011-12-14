Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab1LNQRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:17:14 -0500
Received: from 8bytes.org ([88.198.83.132]:36530 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726Ab1LNQRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:17:10 -0500
Date: Wed, 14 Dec 2011 17:17:08 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/22] iommu/amd: Implement IO page-fault handler
Message-ID: <20111214161708.GB4475@8bytes.org>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com> <1323092077-25501-21-git-send-email-joerg.roedel@amd.com> <20111214161300.GA4184@homer.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214161300.GA4184@homer.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 11:13:00AM -0500, Jerome Glisse wrote:
> On Mon, Dec 05, 2011 at 02:34:35PM +0100, Joerg Roedel wrote:
> > +	npages = get_user_pages(fault->state->task, fault->state->mm,
> > +				fault->address, 1, write, 0, &page, NULL);
> > +
> > +	if (npages == 1)
> > +		put_page(page);
> > +	else
> > +		set_pri_tag_status(fault->state, fault->tag, PPR_INVALID);
> 
> I might be missing something on how mm work in linux but can't the page
> in a vma change anytime (like being migrated to a node or being evicted
> ...) I guess my question is when a fault happen is it because the task
> page table have an invalid entry ?

Yes, but this is not a problem. When the page-fault handler signals
completion of the page-fault back to the device it will start to re-walk
the page-table. If the page-walker detects that the page is not there it
will just signal the fault again. MMU-Notifiers take care of the
TLB management.

> I was under the impression that their was a page table associated with
> each iommu client. Thus that the task page table was never directly use.
> But i haven't carrefully read all the patches.

The IOMMUv2 can handle x86 long-mode page-tables (including
accessed/dirty bits). So it is easy to just re-use the task page-tables
in the IOMMUv2.


Regards,

	Joerg

