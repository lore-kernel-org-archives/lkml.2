Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab0DAQeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:34:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757951Ab0DAQdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:33:45 -0400
Message-ID: <4BB480CC.2060503@redhat.com>
Date: Thu, 01 Apr 2010 14:17:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, aarcange@redhat.com,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in mmu_take_all_locks()
References: <1270117906.1653.139.camel@laptop> <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain> <4BB47FC3.1020606@redhat.com>
In-Reply-To: <4BB47FC3.1020606@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 02:13 PM, Avi Kivity wrote:
>
>> Anyway, I don't see a reason why we can't convert those locks to
>> mutexes and get rid of the whole preempt disabled region.
>
> If someone is willing to audit all code paths to make sure these locks 
> are always taken in schedulable context I agree that's a better fix.
>

 From mm/rmap.c:

> /*
>  * Lock ordering in mm:
>  *
>  * inode->i_mutex    (while writing or truncating, not reading or 
> faulting)
>  *   inode->i_alloc_sem (vmtruncate_range)
>  *   mm->mmap_sem
>  *     page->flags PG_locked (lock_page)
>  *       mapping->i_mmap_lock
>  *         anon_vma->lock
...
> *
>  * (code doesn't rely on that order so it could be switched around)
>  * ->tasklist_lock
>  *   anon_vma->lock      (memory_failure, collect_procs_anon)
>  *     pte map lock
>  */

i_mmap_lock is a spinlock, and tasklist_lock is a rwlock, so some 
changes will be needed.

-- 
error compiling committee.c: too many arguments to function

