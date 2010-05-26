Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184Ab0EZB2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:28:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45607 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759142Ab0EZB2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:28:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 26 May 2010 10:23:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michel Lespinasse <walken@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 00/11] V4: rwsem changes + down_read_critical() proposal
Message-Id: <20100526102359.da18b89e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1274779675.5882.684.camel@twins>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	<1274777239.5882.581.camel@twins>
	<AANLkTikbeXjmRW4gqiy1Ss-Suce5gIM4xJ5o9Z81ZTQX@mail.gmail.com>
	<1274779675.5882.684.camel@twins>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 11:27:55 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2010-05-25 at 02:12 -0700, Michel Lespinasse wrote:
> > On Tue, May 25, 2010 at 1:47 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > So what happened to those patches that dropped mmap_sem during I/O?
> > 
> > Yes, we do have patches trying to release the mmap_sem when a page
> > fault for a file backed VMA blocks on accessing the corresponding
> > file. We have not given up on these, and we intend to try submitting
> > them again. However, these patches do *not* address the case of a page
> > fault blocking while trying to get a free page (i.e. when you get
> > under high memory pressure).
> 
> But I guess they could, right? Simply make the allocation under mmap_sem
> be __GFP_HARDWALL|__GFP_HIGHMEM|__GFP_MOVABLE__GFP_NOWARN or
> (GFP_HUGHUSER_MOVABLE & ~(__GFP_WAIT|__GFP_IO|__GFP_FS))|__GFP_NOWARN
> 
> and drop the mmap_sem when that fails.
> 
> > > I really don't like people tinkering with the lock implementations like
> > > this. Nor do I like the naming, stats are in no way _critical_.
> > 
> > Critical here refers to the fact that you're not allowed to block
> > while holding the unfairly acquired rwsem.
> 
> We usually call that atomic, your 0/n patch didn't explain any of that.
> 
> Also, do you really think doing something like:
> 
>         /*
>          * Check the vma index is within the range and do
>          * sequential scan until m_index.
>          */
>         vma = NULL;
>         if ((unsigned long)l < mm->map_count) {
>                 vma = mm->mmap;
>                 while (l-- && vma)
>                         vma = vma->vm_next;
>                 goto out;
>         }
> 
> with preemption disabled is a _good_ thing?
> 
> People were talking about raising our vma limit of 64k...

Yes, at least, my customers want over 64k vmas ;)

Hmm..can't we use something speculative lookup for reading maps ?
(as we played in several months ago...)

Thanks,
-Kame


