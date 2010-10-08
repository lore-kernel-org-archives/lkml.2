Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab0JHEkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 00:40:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60994 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0JHEkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 00:40:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PP9+l9LbQQzt848Q6kRdLRTkQ/wkZvGiuXi/WDEShxav5Z9n8WhRB9B1JjvXnE87V3
         /JSm50SwY5j4HZXAGO+Q==
Date: Thu, 7 Oct 2010 21:39:56 -0700
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/3] Retry page fault when blocking on disk transfer.
Message-ID: <20101008043956.GA25662@google.com>
References: <1286265215-9025-1-git-send-email-walken@google.com>
 <1286265215-9025-3-git-send-email-walken@google.com>
 <4CAB628D.3030205@redhat.com>
 <AANLkTimdACZ9Xm01DM2+E64+T5XfLffrkFBhf7CJ286p@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimdACZ9Xm01DM2+E64+T5XfLffrkFBhf7CJ286p@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 03:44:22PM -0700, Michel Lespinasse wrote:
> On Tue, Oct 5, 2010 at 10:38 AM, Rik van Riel <riel@redhat.com> wrote:
> > Looks like it should be relatively easy to do something
> > similar in do_swap_page also.
> 
> Good idea. We don't make use of swap too much, which is probably why
> we didn't have that in our kernel, but it seems like a good idea just
> for uniformity. I'll add this in a follow-on patch.

So here's the patch. Sorry for the delay - it did not take long to write,
but I couldn't test it before today.

Please have a look - I'd like to add this to the series I sent earlier.

----------------------------------- 8< ---------------------------------

Retry page fault when blocking on swap in

This change is the cousin of 'Retry page fault when blocking
on disk transfer'. The idea here is to reduce mmap_sem hold times
that are caused by disk transfers when swapping in pages. We drop
mmap_sem while waiting for the page lock, and return the VM_FAULT_RETRY
flag. do_page_fault will then re-acquire mmap_sem and retry the
page fault. It is expected that upon retry the page will now be cached,
and thus the retry will complete with a low mmap_sem hold time.

Signed-off-by: Michel Lespinasse <walken@google.com>

diff --git a/mm/memory.c b/mm/memory.c
index b068c68..0ec70b4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2613,6 +2613,21 @@ int vmtruncate_range(struct inode *inode, loff_t offset, loff_t end)
 	return 0;
 }
 
+static inline int lock_page_or_retry(struct page *page, struct mm_struct *mm,
+				     unsigned int flags)
+{
+	if (trylock_page(page))
+		return 1;
+	if (!(flags & FAULT_FLAG_ALLOW_RETRY)) {
+		__lock_page(page);
+		return 1;
+	}
+
+	up_read(&mm->mmap_sem);
+	wait_on_page_locked(page);
+	return 0;
+}
+
 /*
  * We enter with non-exclusive mmap_sem (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
@@ -2626,6 +2641,7 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct page *page, *swapcache = NULL;
 	swp_entry_t entry;
 	pte_t pte;
+	int locked;
 	struct mem_cgroup *ptr = NULL;
 	int exclusive = 0;
 	int ret = 0;
@@ -2676,8 +2692,12 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		goto out_release;
 	}
 
-	lock_page(page);
+	locked = lock_page_or_retry(page, mm, flags);
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+	if (!locked) {
+		ret |= VM_FAULT_RETRY;
+		goto out_release;
+	}
 
 	/*
 	 * Make sure try_to_free_swap or reuse_swap_page or swapoff did not


-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
