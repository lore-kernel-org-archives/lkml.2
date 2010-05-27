Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab0E0LSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:18:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:46138 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758641Ab0E0LSM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 07:18:12 -0400
Subject: Re: [PATCH 00/11] V4: rwsem changes + down_read_critical() proposal
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
In-Reply-To: <20100527105948.GA20625@google.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	 <1274777239.5882.581.camel@twins>
	 <AANLkTikbeXjmRW4gqiy1Ss-Suce5gIM4xJ5o9Z81ZTQX@mail.gmail.com>
	 <1274779675.5882.684.camel@twins>  <20100527105948.GA20625@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 13:18:00 +0200
Message-ID: <1274959080.27810.4438.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 03:59 -0700, Michel Lespinasse wrote:
> On Tue, May 25, 2010 at 11:27:55AM +0200, Peter Zijlstra wrote:
> > On Tue, 2010-05-25 at 02:12 -0700, Michel Lespinasse wrote:
> > > Yes, we do have patches trying to release the mmap_sem when a page
> > > fault for a file backed VMA blocks on accessing the corresponding
> > > file. We have not given up on these, and we intend to try submitting
> > > them again. However, these patches do *not* address the case of a page
> > > fault blocking while trying to get a free page (i.e. when you get
> > > under high memory pressure).
> > 
> > But I guess they could, right? Simply make the allocation under mmap_sem
> > be __GFP_HARDWALL|__GFP_HIGHMEM|__GFP_MOVABLE__GFP_NOWARN or
> > (GFP_HUGHUSER_MOVABLE & ~(__GFP_WAIT|__GFP_IO|__GFP_FS))|__GFP_NOWARN
> > 
> > and drop the mmap_sem when that fails.
> 
> It's not clear to me if this can lead to a clean uncontroversial solution.
> Doing this for file backed VMAs does not sound any harder in principle,
> but we could not get it past linus's NACK last time. I think it's worth
> exploring again, but I don't expect it to be so easy :)

Right, I was planning to have a look again, but my todo list is getting
out of hand again.

> > > > I really don't like people tinkering with the lock implementations like
> > > > this. Nor do I like the naming, stats are in no way _critical_.
> > > 
> > > Critical here refers to the fact that you're not allowed to block
> > > while holding the unfairly acquired rwsem.
> > 
> > We usually call that atomic, your 0/n patch didn't explain any of that.
> 
> Would replacing the 'critical' name with 'atomic' address your concern
> though, or would you remain fundamentally opposed to anything that involves
> an unfair acquire path ?

Yeah, I don't think its a good idea to add unfairness to the lock, such
things tend to backfire and generate starvation cases. For instance, a
tight loop around your /proc/$pid/maps mod will starve $pid from doing
anything requiring mmap_sem for writing.

> What about patches 1-7 which don't deal with the critical/atomic API;
> can we agree to get these in before we we figure out what to do with
> the the last 4 ?

patch 6 looks like it will break fairness, either that or the changelog
got me totally confused (already had to read it twice).
