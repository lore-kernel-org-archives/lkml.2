Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0DKRUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 13:20:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520Ab0DKRUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 13:20:43 -0400
Date: Sun, 11 Apr 2010 10:16:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org> <20100410185145.GB28952@a1.tnic> <20100410185839.GA32035@a1.tnic> <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004101308250.3618@i5.linux-foundation.org>
 <20100410203628.GB32035@a1.tnic> <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org> <20100410212555.GA1797@a1.tnic> <alpine.LFD.2.00.1004101427090.3618@i5.linux-foundation.org> <20100410215115.GA2599@a1.tnic> <20100411130801.GA7189@a1.tnic>
 <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Apr 2010, Linus Torvalds wrote:
> 
>   But I think the bug you see might be exactly the race between 
>   page_mapped() and actually getting the anon_vma spinlock. I'd have 
>   expected that window to be too small to ever hit, though, which is why I 
>   find it a bit unlikely. But it would explain why you _sometimes_ 
>   actually get a hung spinlock too - you never get the spinlock at all, 
>   and somebody replaced the data with something that the spinlock code 
>   thinks is a locked spinlock - but is no longer a spinlock at all ]

Actually, so if it's that race, then we might get rid of the oops with 
this total hack.

NOTE! If this is the race, then the hack really is just a hack, because it 
doesn't really solve anything. We still take the spinlock, and if bad 
things has happened, _that_ can still very much fail, and you get the 
watchdog lockup message instead. So this doesn't really fix anything.

But if this patch changes behavior, and you no longer see the oops, that 
tells us _something_. I'm not sure how useful that "something" is, but it 
at least means that there are no _mapped_ pages that have that stale 
anon_vma pointer in page->mapping.

Conversely, if you still see the oops (rather than the watchdog), that 
means that we actually have pages that are still marked mapped, and that 
despite that mapped state have a stale page->mapping pointer. I actually 
find that the more likely case, because otherwise the window is _so_ small 
that I don't see how you can hit the oops so reliably.

Anyway - probably worth testing, along with the verify_vma() patch. If 
nothing else, if there is no new behavior, even that tells us something. 
Even if that "something" is not a huge piece of information.

		Linus

---
diff --git a/mm/rmap.c b/mm/rmap.c
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -302,7 +302,11 @@ struct anon_vma *page_lock_anon_vma(struct page *page)
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
 	spin_lock(&anon_vma->lock);
-	return anon_vma;
+
+	if (page_mapped(page))
+		return anon_vma;
+
+	spin_unlock(&anon_vma->lock);
 out:
 	rcu_read_unlock();
 	return NULL;
