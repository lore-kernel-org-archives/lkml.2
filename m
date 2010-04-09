Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0DIOll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:41:41 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:43415 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab0DIOli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:41:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GiJuLs2mcSrx21G9uG1ZjJ97xhdXnmxcgFym2bW70Zobj2wf5tI5jJiMFG8BM1AF5g
         KLbNDB98rrNxhR8vfzFW34t3TLf3fPErmdaarSj3VUiW4iwUgj8HJpUvSn4fbl/AP7ji
         y/tLzBZBOszaV5tzQyYnWA5kayF5EyPbqZxYY=
Subject: mlock and pageout race?
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20100409170529.80E9.A69D9226@jp.fujitsu.com>
References: <20100409160252.80E6.A69D9226@jp.fujitsu.com>
	 <n2x28c262361004090101ufa54ff03zc9a94c8808841206@mail.gmail.com>
	 <20100409170529.80E9.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 23:41:19 +0900
Message-ID: <1270824079.2524.63.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kosaki. 

I don't want to make noise due to off-topic.
So I open new thread. 

On Fri, 2010-04-09 at 17:17 +0900, KOSAKI Motohiro wrote:
> Hi Minchan,
> 
> > OFF-TOPIC:
> > 
> > I think you pointed out good thing, too. :)
> > 
> > You mean although application call mlock of any vma, few pages on the vma can
> > be swapout by race between mlock and reclaim?
> > 
> > Although it's not disaster, apparently it breaks API.
> > Man page
> > " mlock() and munlock()
> >   mlock()  locks pages in the address range starting at addr and
> > continuing for len bytes. All pages that contain a part of the
> > specified address range are guaranteed to be resident in RAM when the
> > call returns  successfully;  the pages are guaranteed to stay in RAM
> > until later unlocked."
> > 
> > Do you have a plan to solve such problem?
> > 
> > And how about adding simple comment about that race in page_referenced_one?
> > Could you send the patch?
> 
> I'm surprising this mail. you were pushing much patch in this area.
> I believed you know all stuff ;)

If I disappoint you, sorry for that. 
Still, there are many thing to study to me. :)

> 
> My answer is, it don't need to fix, because it's not bug. The point is
> that this one is race issue. not "pageout after mlock" issue.
> If pageout and mlock occur at the exactly same time, the human can't
> observe which event occur in first. it's not API violation.


If it might happen, it's obviously API violation, I think.

int main()
{
	mlock(any vma, CURRENT|FUTURE);
	system("cat /proc/self/smaps | grep "any vma");
	..
}
result : 

08884000-088a5000 rw-p 00000000 00:00 0          [any vma]
Size:                  4 kB
Rss:                   4 kB
...
Swap:                  4 kB
...

Apparently, user expected that "If I call mlock, there are whole pages
of the vma in DRAM". But the result make him embarrassed :(

side note : 
Of course, mlock's semantic is rather different with smaps's Swap. 
mlock's semantic just makes sure pages on DRAM after success of mlock
call. it's not relate smap's swap entry. 
Actually, smaps's swap entry cannot compare to mlock's semantic.
Some page isn't on swap device yet but on swap cache and whole PTEs of
page already have swap entry(ie, all unmapped). In such case, smap's
Swap entry represent it with swap page. But with semantic of mlock, it's
still on RAM so that it's okay.  

I looked the code more detail.
Fortunately, the situation you said "page_referenced() already can take
unstable VM_LOCKED value. So, In worst case we make false positive
pageout, but it's not disaster" cannot happen, I think. 

1) 
mlock_fixup				shrink_page_list

					lock_page
					try_to_unmap

vma->vm_flags = VM_LOCKED
pte_lock				
pte_present test
get_page
pte_unlock
					pte_lock
					VM_LOCKED test fail
					pte_unlock
					never pageout
So, no problem. 

2) 
mlock_fixup				shrink_page_list

					lock_page
					try_to_unmap
					pte_lock
					VM_LOCKED test pass
vma->vm_flags = VM_LOCKED		make pte to swap entry
pte_lock				pte_unlock
pte_present test fail
pte_unlock
					pageout
swapin by handle_mm_fault     

So, no problem. 

3)
mlock_fixup				shrink_page_list

					lock_page
					try_to_unmap
					pte_lock
					VM_LOCKED test pass
vma->vm_flags = VM_LOCKED		make pte to swap entry
pte_lock				pte_unlock
pte_present test fail
pte_unlock
cachehit in swapcache by handle_mm_fault 
					pageout
					is_page_cache_freeable fail
So, no problem, too. 

I can't think the race situation you mentioned.
When 'false positive pageout' happens?
Could you elaborate on it?


-- 
Kind regards,
Minchan Kim


