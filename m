Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab0DGOtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:49:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576Ab0DGOtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:49:53 -0400
Message-ID: <4BBC9B3A.3060703@redhat.com>
Date: Wed, 07 Apr 2010 10:48:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
References: <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org> <20100406195459.554265e7@annuminas.surriel.com> <20100407151357.FB7E.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100407151357.FB7E.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 03:00 AM, KOSAKI Motohiro wrote:

> Hmm.. probably I'm moron.

Someone might be, but it's not you :)

> I'm also confusing this locking rule as same as linus said.
>
> after this patch, new locking order are

> So, Why mmap_sem read lock can protect vma->anon_vma_chain?
> An another threads seems to be able to change avc list concurrentlly and freely.

You are right, the code needs to take the pagetable_lock
around the call to anon_vma_clone, so other threads
get locked out.

This means the locking order has now been inverted,
with the pagetable_lock on the outside and the
anon_vma locks on the inside.

I have checked all the other call sites to the
anon_vma code.  The direct callers of anon_vma_clone
and anon_vma_fork already hold the mmap_sem for
write.  The callers of anon_vma_prepare hold the
mmap_sem for read - so excluding other callers of
anon_vma_prepare with the page_table_lock is enough.

mm_take_all_locks has the mmap_sem for write.

There seem to be no other traversals of the same_vma
list, so changing the locking order to have the
page_table_lock on the outside of the anon_vma locks
works.

> plus, Why don't we need "vma->anon_vma = merge_vma->anon_vma" assignment?
> if vma->anon_vma keep NULL, I think anon_vma_prepare() call anon_vma_clone()
> multiple times.

Added in the new version.  See the next email.

