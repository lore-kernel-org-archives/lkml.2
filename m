Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2LDOhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:37:43 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62786 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab2LDOhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:37:42 -0500
MIME-Version: 1.0
In-Reply-To: <20121203141701.GN8218@suse.de>
References: <1354305521-11583-1-git-send-email-mingo@kernel.org>
	<CA+55aFwjxm7OYuucHeE2WFr4p+jwr63t=kSdHndta_QkyFbyBQ@mail.gmail.com>
	<20121201094927.GA12366@gmail.com>
	<20121201122649.GA20322@gmail.com>
	<CA+55aFx8QtP0hg8qxn__4vHQuzH7QkhTN-4fwgOpM-A=KuBBjA@mail.gmail.com>
	<20121201184135.GA32449@gmail.com>
	<CA+55aFyq7OaUxcEHXvJhp0T57KN14o-RGxqPmA+ks8ge6zJh5w@mail.gmail.com>
	<20121201201538.GB2704@gmail.com>
	<20121203141701.GN8218@suse.de>
Date: Tue, 4 Dec 2012 06:37:41 -0800
Message-ID: <CANN689Hm=g+PhJrVZ8mngPL58k45GfmwL_19F27WtwJC0G-=6g@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/migration: Make rmap_walk_anon() and
 try_to_unmap_anon() more scalable
From: Michel Lespinasse <walken@google.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 6:17 AM, Mel Gorman <mgorman@suse.de> wrote:
> On Sat, Dec 01, 2012 at 09:15:38PM +0100, Ingo Molnar wrote:
>> @@ -732,7 +732,7 @@ static int page_referenced_anon(struct p
>>       struct anon_vma_chain *avc;
>>       int referenced = 0;
>>
>> -     anon_vma = page_lock_anon_vma(page);
>> +     anon_vma = page_lock_anon_vma_read(page);
>>       if (!anon_vma)
>>               return referenced;
>
> This is a slightly trickier one as this path is called from reclaim. It does
> open the possibility that reclaim can stall something like a parallel fork
> or anything that requires the anon_vma rwsem for a period of time. I very
> severely doubt it'll really be a problem but keep an eye out for bug reports
> related to delayed mmap/fork/anything_needing_write_lock during page reclaim.

I don't see why this would be a problem - rwsem does implement
reader/writer fairness, so having some sites do a read lock instead of
a write lock shouldn't cause the write lock sites to starve. Is this
what you were worried about ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
