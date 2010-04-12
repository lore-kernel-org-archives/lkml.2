Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab0DLPR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 11:17:58 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:46681 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0DLPR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 11:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VFVdwmtx5TeCEzkRXnpKKGGaE+zF2trTx9rM6v7/sgIMAouWPnmafw8urVaX2+jKWb
         UAAM0kgRWQ5zT/8z+gk7bUTFO475Ejkbs7SrdxxMgsLMQnM5M7Za1ZSkx3wfeIEQtA0w
         acqXw7TMD9SzxTm8hppbWpmflQmjYCx5dw1EI=
MIME-Version: 1.0
In-Reply-To: <1271083207.4807.18.camel@twins>
References: <20100409191425.GB10780@a1.tnic>
	 <20100410003110.GI28964@cmpxchg.org>
	 <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>
	 <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic>
	 <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>
	 <20100410163828.GA25579@a1.tnic>
	 <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
	 <1271083207.4807.18.camel@twins>
Date: Tue, 13 Apr 2010 00:17:56 +0900
Message-ID: <r2i28c262361004120817hbd161cd2k4476ea3a6ad3de6a@mail.gmail.com>
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas 
	of a mergeable VMA
From: Minchan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 11:40 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, 2010-04-10 at 11:21 -0700, Linus Torvalds wrote:
>>
>
>> Ho humm.
>>
>> Maybe I'm crazy, but something started bothering me. And I started
>> wondering: when is the 'page->mapping' of an anonymous page actually
>> cleared?
>>
>> The thing is, the mapping of an anonymous page is actually cleared only
>> when the page is _freed_, in "free_hot_cold_page()".
>>
>> Now, let's think about that. And in particular, let's think about how that
>> relates to the freeing of the 'anon_vma' that the page->mapping points to.
>>
>> The way the anon_vma is freed is when the mapping is torn down, and we do
>> roughly:
>>
>>       tlb = tlb_gather_mmu(mm,..)
>>       ..
>>       unmap_vmas(&tlb, vma ..
>>       ..
>>       free_pgtables()
>>       ..
>>       tlb_finish_mmu(tlb, start, end);
>>
>> and we actually unmap all the pages in "unmap_vmas()", and then _after_
>> unmapping all the pages we do the "unlink_anon_vmas(vma);" in
>> "free_pgtables()". Fine so far - the anon_vma stay around until after the
>> page has been happily unmapped.
>>
>> But "unmapped all the pages" is _not_ actually the same as "free'd all the
>> pages". The actual _freeing_ of the page happens generally in
>> tlb_finish_mmu(), because we can free the page only after we've flushed
>> any TLB entries.
>>
>> So what we have in that tlb_gather structure is a list of _pending_ pages
>> to be freed, while we already actually free'd the anon_vmas earlier!
>>
>> Now, the thing is, tlb_gather_mmu() begins a preempt-safe region (because
>> we use a per-cpu variable), but as far as I can tell it is _not_ an
>> RCU-safe region.
>>
>> So I think we might actually get a real RCU freeing event while this all
>> happens. So now the 'anon_vma' that 'page->mapping' points to has not just
>> been released back to the SLUB caches, the page itself might have been
>> released too.
>>
>> I dunno. Does the above sound at all sane? Or am I just raving?
>>
>> Something hacky like the above might fix it if I'm not just raving. I
>> really might be missing something here.
>
> Right, so unless you have CONFIG_TREE_PREEMPT_RCU=y, the preempt-disable
> == RCU read lock assumption does hold.

Indeed.

>
> But even with your patch it doesn't close all holes because while
> zap_pte_range() can remove the last mapcount of the page, the
> page_remove_tlb() et al. don't need to be the last use count of the
> page.
>
> Concurrent reclaim/gup/whatever could still have a count out on the page
> delaying the actual free beyond the tlb gather RCU section.

anon_vma lock is just valid in case of page_mapped.
if reclaim/gup/whatever want to use anon_vma, it should check with page_mapped.
And last put_page doesn't touch anon_vma for freeing the page so I
think it's not a problem. Do I miss something?

>
> This also complicates the whole page_lock_anon_vma() thing, so it would
> be nice to be able to remove this race and clear page->mapping in
> page_remove_rmap().
>

BTW, I totally agree with you.
Now anon_vma is very complicated.
SLAB_DESTROY_BY_RCU, vma merge, when page->mapping is cleared,
anon_vma_chain and so on.. :(


-- 
Kind regards,
Minchan Kim
