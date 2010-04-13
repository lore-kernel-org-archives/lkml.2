Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab0DMEYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 00:24:01 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:57287 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab0DMEYA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 00:24:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GEcenOpM13/GZG+1I4bng6P7InFSU4sax+qeUlM713Buem9Mb0bvIPSP5AfDEC2He8
         /2F06ZAGoTqmcbILewSEt7jqMhIw0hU36tAcXlELfhbsD7tqm9BgANefWw6F9U50OlZ5
         zcKYU571llIo2MoGP8TLUcK0s4UUiqYY1q474=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004121806510.3647@i5.linux-foundation.org>
References: <20100412072056.GA2432@liondog.tnic> <4BC36916.3080005@redhat.com>
	 <20100412190002.GA8595@a1.tnic>
	 <alpine.LFD.2.00.1004121201480.3714@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004121322400.3683@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004121323080.3683@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004121323270.3683@i5.linux-foundation.org>
	 <20100413004117.GD20163@cmpxchg.org>
	 <alpine.LFD.2.00.1004121806510.3647@i5.linux-foundation.org>
Date: Tue, 13 Apr 2010 13:23:59 +0900
Message-ID: <w2j28c262361004122123w9b97e2bck47c1656cdff9f30e@mail.gmail.com>
Subject: Re: [PATCH 4/4] anonvma: when setting up page->mapping, we need to 
	pick the _oldest_ anonvma
From: Minchan Kim <minchan.kim@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Borislav Petkov <bp@alien8.de>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
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

On Tue, Apr 13, 2010 at 10:08 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 13 Apr 2010, Johannes Weiner wrote:
>>
>> Would you mind pasting that nice description of the error case from your
>> other email into that changelog?  I skimmed over the description but when
>> I read this patch several hours later, I had to go back to that previous
>> email to fully make sense of it.
>
> It now looks like this..
>
>                Linus
> ---
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Mon, 12 Apr 2010 12:44:29 -0700
> Subject: [PATCH 4/4] anonvma: when setting up page->mapping, we need to pick the _oldest_ anonvma
>
> Otherwise we might be mapping in a page in a new mapping, but that page
> (through the swapcache) would later be mapped into an old mapping too.
> The page->mapping must be the case that works for everybody, not just
> the mapping that happened to page it in first.
>
> Here's the scenario:
>
>  - page gets allocated/mapped by process A. Let's call the anon_vma we
>   associate the page with 'A' to keep it easy to track.
>
>  - Process A forks, creating process B. The anon_vma in B is 'B', and has
>   a chain that looks like 'B' -> 'A'. Everything is fine.
>
>  - Swapping happens. The page (with mapping pointing to 'A') gets swapped
>   out (perhaps not to disk - it's enough to assume that it's just not
>   mapped any more, and lives entirely in the swap-cache)
>
>  - Process B pages it in, which goes like this:
>
>        do_swap_page ->
>          page = lookup_swap_cache(entry);
>         ...
>          set_pte_at(mm, address, page_table, pte);
>          page_add_anon_rmap(page, vma, address);
>
>   And think about what happens here!
>
>   In particular, what happens is that this will now be the "first"
>   mapping of that page, so page_add_anon_rmap() used to do
>
>        if (first)
>                __page_set_anon_rmap(page, vma, address);
>
>   and notice what anon_vma it will use? It will use the anon_vma for
>   process B!
>
>   What happens then? Trivial: process 'A' also pages it in (nothing
>   happens, it's not the first mapping), and then process 'B' execve's
>   or exits or unmaps, making anon_vma B go away.
>
>   End result: process A has a page that points to anon_vma B, but
>   anon_vma B does not exist any more.  This can go on forever.  Forget
>   about RCU grace periods, forget about locking, forget anything like
>   that.  The bug is simply that page->mapping points to an anon_vma
>   that was correct at one point, but was _not_ the one that was shared
>   by all users of that possible mapping.
>
> Changing it to always use the deepest anon_vma in the anonvma chain gets
> us to the safest model.
>
> This can be improved in certain cases: if we know the page is private to
> just this particular mapping (for example, it's a new page, or it is the
> only swapcache entry), we could pick the top (most specific) anon_vma.
>
> But that's a future optimization. Make it _work_ reliably first.
>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Tested-by: Borislav Petkov <bp@alien8.de> [ "What do you know, I think you fixed it!" ]
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Minchan Kim <minchan.kim>

It was great hunting and was a chance to learn many things
from LKML smart guys.
I feel again about OSS's power and great procedure of linux evolution

Thanks for everybody.

-- 
Kind regards,
Minchan Kim
