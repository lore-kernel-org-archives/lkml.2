Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab0E0LAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:00:00 -0400
Received: from smtp-out.google.com ([74.125.121.35]:1819 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab0E0K76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 06:59:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:user-agent:x-system-of-record;
	b=RhMpqORAXRIEle8OXjFh6ss5KrhiDjb9CBJCIhLsN16hwlzNgrzf40ZEkCPlTb4wJ
	TUDQe43W9vAbi3DlGNAzA==
Date: Thu, 27 May 2010 03:59:48 -0700
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 00/11] V4: rwsem changes + down_read_critical() proposal
Message-ID: <20100527105948.GA20625@google.com>
References: <1274733081-4623-1-git-send-email-walken@google.com> <1274777239.5882.581.camel@twins> <AANLkTikbeXjmRW4gqiy1Ss-Suce5gIM4xJ5o9Z81ZTQX@mail.gmail.com> <1274779675.5882.684.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274779675.5882.684.camel@twins>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 11:27:55AM +0200, Peter Zijlstra wrote:
> On Tue, 2010-05-25 at 02:12 -0700, Michel Lespinasse wrote:
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

It's not clear to me if this can lead to a clean uncontroversial solution.
Doing this for file backed VMAs does not sound any harder in principle,
but we could not get it past linus's NACK last time. I think it's worth
exploring again, but I don't expect it to be so easy :)

> > > I really don't like people tinkering with the lock implementations like
> > > this. Nor do I like the naming, stats are in no way _critical_.
> > 
> > Critical here refers to the fact that you're not allowed to block
> > while holding the unfairly acquired rwsem.
> 
> We usually call that atomic, your 0/n patch didn't explain any of that.

Would replacing the 'critical' name with 'atomic' address your concern
though, or would you remain fundamentally opposed to anything that involves
an unfair acquire path ?

What about patches 1-7 which don't deal with the critical/atomic API;
can we agree to get these in before we we figure out what to do with
the the last 4 ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
