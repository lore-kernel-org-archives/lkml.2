Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab0DMTZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 15:25:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:48989 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab0DMTZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 15:25:56 -0400
Date: Wed, 14 Apr 2010 05:25:51 +1000
From: Nick Piggin <npiggin@suse.de>
To: Chris Mason <chris.mason@oracle.com>,
       Manfred Spraul <manfred@colorfullife.com>, zach.brown@oracle.com,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in
 semtimedop
Message-ID: <20100413192551.GF5683@laptop>
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com>
 <1271098163-3663-2-git-send-email-chris.mason@oracle.com>
 <4BC4A6B2.1090906@colorfullife.com>
 <20100413173941.GI13327@think>
 <20100413180945.GD5683@laptop>
 <20100413181937.GM13327@think>
 <20100413185756.GE5683@laptop>
 <20100413190110.GR13327@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413190110.GR13327@think>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 03:01:10PM -0400, Chris Mason wrote:
> On Wed, Apr 14, 2010 at 04:57:56AM +1000, Nick Piggin wrote:
> > Yes, because it's not just a theoretical livelock, it can be basically
> > a certainty, given the right pattern of semops.
> > 
> > You could have two mostly-independent groups of processes, each taking
> > and releasing a different sem, which are always contended (eg. if it is
> > being used for a producer-consumer type situation, or even just mutual
> > exclusion with high contention).
> > 
> > Then you could have some overall management process for example which
> > tries to take both sems. It will never get it.
> 
> Ok, fair enough, I'll add the sequence number.
> 
> > 
> > 
> > > > I was looking at doing a sequence number to be able to sort these, but
> > > > it ended up getting over complex (and SAP was only using simple ops so
> > > > it didn't seem to need much better).
> > > > 
> > > > We want to be careful not to change semantics at all. And it gets
> > > > tricky quickly :( What about Zach's simpler wakeup API?
> > > 
> > > Yeah, that's why my patches include code to handle userland sending
> > > duplicate semids.
> > 
> > Duplicate semids? What do you mean?
> 
> Sorry, semnums...index into the array of semaphores.

OK, I wonder just how much it helps, and what.


> > >  Zach's simpler API is cooking too, but if I can get
> > > this done without insane complexity it helps with more than just the
> > > post/wait oracle workload.
> > 
> > Iam worried about complexity and slowing other cases, given that Oracle
> > DB seems willing to adapt to the (better suited) new API. So I'd be
> > interested to know what it helps outside Oracle.
> > 
> 
> Sure, I'd hope that your benchmark from last time around is faster now.

I didn't actually reproduce it here, I think it was a customer or
partner workload. But SAP only seemed to have one contended semnum in
its array, and it was being operated on with "simple" semops (so that's
about as far as the patches went).

I didn't notice anything that should make that go faster?

Yes, with such a workload, using semops is basically legacy and simple
mutexes should work better. So I'm not outright against improving sysv
sem performance for more complex cases where nothing else we have works
as well.

