Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab0DFQYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:24:01 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:56820 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0DFQXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:23:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qo9EafoZPedNE34I+ZrcTZh7lT1FIjZpn3J142Ij8kyRrnUojAPCbYDFhHrY2oICjv
         o4iO2ZfrkuHngwsoOgWPOETGPh0ILlRph2cz9hIou2kIaCCo0uVYPNaRMHElD6eObqKJ
         EUQUFGixGVVhNlKWGl53jq66q6A83xvqI7xUM=
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
From: Minchan Kim <minchan.kim@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>
References: <20100402175937.GA19690@liondog.tnic>
	 <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>
	 <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com>
	 <1270568096.1814.145.camel@barrios-desktop>
	 <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 01:23:39 +0900
Message-ID: <1270571019.1814.163.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus. 

On Tue, 2010-04-06 at 08:55 -0700, Linus Torvalds wrote:
> 
> On Wed, 7 Apr 2010, Minchan Kim wrote:
> > 
> > Let's see the unlink_anon_vmas. 
> > 
> > 1. list_for_each_entry_safe(avc,next, vma->anon_vma_chain, same_vma)
> > 2. 	anon_vma_unlink
> > 3. 		spin_lock(anon_vma->lock) <-- HERE LOCK.
> > 4.		list_del(anon_vma_chain->same_anon_vma);
> > 
> > What if anon_vma is destroyed and reuse by SLAB_XXX_RCU for another
> > anon_vma object between 2 and 3?
> > I mean how to make sure 3) does lock valid anon_vma? 
> > 
> > I hope it is culprit.
> 
> I don't think so. That isn't the racy case. We're working with a 
> anon_vma_chain, so the anonvma is all there.
> 

But the anon_vma is using for another anon_vma. 
Nonetheless, anon_vma_unlink does list_del(anon_vma's same_anon_vma).
I doubt it. 

> The racy case is when we look up an anonvma by the page, and the page gets 
> unmapped at the same time because somebody else is travelling over the LRU 
> list of the page itself, isn't it?

Yes. but I thought page might travel with anon_vmas which have
same_anon_vma deleted by race.

> 
> I do wonder if "page_lock_anon_vma()" should check the whole 
> "page_mapped()" case _after_ taking the anon_vma lock. Because if the race 
> happens, we're following a anon_vma list that has nothing to do with that 
> page (it's stilla _valid_ list, since we locked the anon_vma, but will it 
> be ok?)

So we always use it with (vma_address and page_check_address) to make
sure validation of anon_vma.
But I think it's not good design. I want to hold lock ahead checking of
page_mapped but maybe performance issue? I am not sure. 

> 
> IOW, what is it that really keeps the anon_vma list reliable _and_ 
> relevant wrt the page? We know we may get a stale anon_vma, are we ok if 
> that anon_vma list doesn't actually have anything to do with the page any 
> more?
> I think the first check in "page_address_in_vma()" protects us, but 
> whatever.
> 
> However, that made me look at the PAGE_MIGRATION case. That seems to be 
> just broken. It's doing that page_anon_vma() + spin_lock without holding 
> any RCU locks, so there is no guarantee that anon_vma there is at all 
> valid.

FYI, recently there is a patch about migration case. 
http://lkml.org/lkml/2010/4/2/145


> 
> Is that function always called with rcu_read_lock()? 
> 
> 			Linus


-- 
Kind regards,
Minchan Kim


