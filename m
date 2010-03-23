Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0CWTS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 15:18:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45010 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab0CWTS1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 15:18:27 -0400
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge
 regression in performance
From: Peter Zijlstra <peterz@infradead.org>
To: Anton Starikov <ant.starikov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org
In-Reply-To: <9D040E9A-80F2-468F-A6CD-A4912615CD3F@gmail.com>
References: <bug-15618-10286@https.bugzilla.kernel.org/>
	 <20100323102208.512c16cc.akpm@linux-foundation.org>
	 <20100323173409.GA24845@elte.hu>
	 <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org>
	 <9D040E9A-80F2-468F-A6CD-A4912615CD3F@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Mar 2010 20:17:56 +0100
Message-ID: <1269371876.5109.161.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 20:14 +0100, Anton Starikov wrote:
> On Mar 23, 2010, at 6:45 PM, Linus Torvalds wrote:
> 
> > 
> > 
> > On Tue, 23 Mar 2010, Ingo Molnar wrote:
> >> 
> >> It shows a very brutal amount of page fault invoked mmap_sem spinning 
> >> overhead.
> > 
> > Isn't this already fixed? It's the same old "x86-64 rwsemaphores are using 
> > the shit-for-brains generic version" thing, and it's fixed by
> > 
> > 	1838ef1 x86-64, rwsem: 64-bit xadd rwsem implementation
> > 	5d0b723 x86: clean up rwsem type system
> > 	59c33fa x86-32: clean up rwsem inline asm statements
> > 
> > NOTE! None of those are in 2.6.33 - they were merged afterwards. But they 
> > are in 2.6.34-rc1 (and obviously current -git). So Anton would have to 
> > compile his own kernel to test his load.
> 
> 
> Applied mentioned patches. Things didn't improve too much.
> 
> before:
> prog: Total exploration time 9.880 real 60.620 user 76.970 sys
> 
> after:
> prog: Total exploration time 9.020 real 59.430 user 66.190 sys
> 
> perf report:
> 
>     38.58%             prog  [kernel]                                           [k] _spin_lock_irqsave
>     37.42%             prog  ./prog                                             [.] DBSLLlookup_ret
>      6.22%             prog  ./prog                                             [.] SuperFastHash
>      3.65%             prog  /lib64/libc-2.11.1.so                              [.] __GI_memcpy
>      2.09%             prog  ./anderson.6.dve2C                                 [.] get_successors
>      1.75%             prog  [kernel]                                           [k] clear_page_c
>      1.73%             prog  ./prog                                             [.] index_next_dfs
>      0.71%             prog  [kernel]                                           [k] handle_mm_fault
>      0.38%             prog  ./prog                                             [.] cb_hook
>      0.33%             prog  ./prog                                             [.] get_local
>      0.32%             prog  [kernel]                                           [k] page_fault

Could you verify with a callgraph profile what that spin_lock_irqsave()
is? If those rwsem patches were successfull mmap_sem should no longer
have a spinlock to content on, in which case it might be another lock.

If not, something went wrong with backporting those patches.
