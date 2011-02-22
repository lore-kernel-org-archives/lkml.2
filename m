Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab1BVQ3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 11:29:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab1BVQ3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 11:29:48 -0500
Date: Tue, 22 Feb 2011 17:29:40 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, lwoodman@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] Fix interleaving for transparent hugepages
Message-ID: <20110222162940.GE13092@random.random>
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org>
 <1298315270-10434-2-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.00.1102220933500.16060@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102220933500.16060@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 09:34:33AM -0600, Christoph Lameter wrote:
> 
> On Mon, 21 Feb 2011, Andi Kleen wrote:
> 
> > @@ -1830,7 +1830,7 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
> >  	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
> >  		unsigned nid;
> >
> > -		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT);
> > +		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT << order);
> 
> Should be PAGE_SHIFT + order.

This one is very good after changing + order. I updated
alloc_page_interleave to get an order parameter but I didn't adjust
the nid accordingly to order. This was my incomplete modification for
hpage interleaving:

@@ -1830,7 +1832,7 @@ alloc_page_vma(gfp_t gfp, struct vm_area_struct
*vma, unsigned long addr)
 
                nid = interleave_nid(pol, vma, addr, PAGE_SHIFT);
                mpol_cond_put(pol);
-               page = alloc_page_interleave(gfp, 0, nid);
+               page = alloc_page_interleave(gfp, order, nid);
                put_mems_allowed();
                return page;
        }


Andi, can you resubmit this one fixd with + to Andrew, this one can go
in 2.6.38. For the rest frankly I've an hard time to see how it cannot
hurt performance (instead of improving them) especially for KSM. It's
impossible to improve KSM for NUMA with that change to
ksm_does_need_to_copy at the very least. But the same reasoning
applies to the rest. But I'll think more about the others, I just
would prefer to include the above fix quick, the rest don't seem that
urgent even if it's really improving performance (instead of hurting
it as I think).

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
