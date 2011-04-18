Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab1DRH1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 03:27:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41344 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1DRH1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 03:27:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Hq8OCu+Cd4hexHM3Dk4wwfUfQXipZTnITF1VD7v142tAUHF5g6u4I2N66LZbniM3sh
         AD1rvEhPvUPqa4Ci+Ca9DiIFen5+kwqECNQV5MWP33ojyjZ9U3N/suTZcETMFRhTJmY4
         HGgfSF1eVLVxs1uUCwrYg6lFFmD+3W5kdx2Hw=
Subject: Re: [PATCH] mm: Check if PTE is already allocated during page fault
From: raz ben yehuda <raziebe@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, akpm@linux-foundation.org, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, lkml <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, stable@kernel.org, shai@scalex86.com
In-Reply-To: <20110415150606.GP15707@random.random>
References: <20110415101248.GB22688@suse.de>
	 <20110415143916.GN15707@random.random>
	 <20110415150606.GP15707@random.random>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 10:21:13 +0300
Message-ID: <1303111273.3425.0.camel@raz.scalemp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patch works great. thank you Andrea.


On Fri, 2011-04-15 at 17:06 +0200, Andrea Arcangeli wrote:
> On Fri, Apr 15, 2011 at 04:39:16PM +0200, Andrea Arcangeli wrote:
> > On Fri, Apr 15, 2011 at 11:12:4A.M +0100, Mel Gorman wrote:
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 5823698..1659574 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -3322,7 +3322,7 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
> > >  	 * run pte_offset_map on the pmd, if an huge pmd could
> > >  	 * materialize from under us from a different thread.
> > >  	 */
> > > -	if (unlikely(__pte_alloc(mm, vma, pmd, address)))
> > > +	if (unlikely(pmd_none(*pmd)) && __pte_alloc(mm, vma, pmd, address))
> 
> I started hacking on this and I noticed it'd be better to extend the
> unlikely through the end. At first review I didn't notice the
> parenthesis closure stops after pte_none and __pte_alloc is now
> uncovered. I'd prefer this:
> 
>     if (unlikely(pmd_none(*pmd) && __pte_alloc(mm, vma, pmd, address)))
> 
> I mean the real unlikely thing is that we return VM_FAULT_OOM, if we
> end up calling __pte_alloc or not, depends on the app. Generally it
> sounds more frequent that the pte is not none, so it's not wrong, but
> it's even less likely that __pte_alloc fails so that can be taken into
> account too, and __pte_alloc runs still quite frequently. So either
> above or:
> 
>     if (unlikely(pmd_none(*pmd)) && unlikely(__pte_alloc(mm, vma, pmd, address)))
> 
> I generally prefer unlikely only when it's 100% sure thing it's less
> likely (like the VM_FAULT_OOM), so the first version I guess it's
> enough (I'm afraid unlikely for pte_none too, may make gcc generate a
> far away jump possibly going out of l1 icache for a case that is only
> 512 times less likely at best). My point is that it's certainly hugely
> more unlikely that __pte_alloc fails than the pte is none.
> 
> This is a real nitpick though ;).


