Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab0DMTiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 15:38:50 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:61785 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab0DMTit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 15:38:49 -0400
Date: Tue, 13 Apr 2010 15:38:01 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>, zach.brown@oracle.com,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in
 semtimedop
Message-ID: <20100413193801.GT13327@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Nick Piggin <npiggin@suse.de>,
	Manfred Spraul <manfred@colorfullife.com>, zach.brown@oracle.com,
	jens.axboe@oracle.com, linux-kernel@vger.kernel.org
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com>
 <1271098163-3663-2-git-send-email-chris.mason@oracle.com>
 <4BC4A6B2.1090906@colorfullife.com>
 <20100413173941.GI13327@think>
 <20100413180945.GD5683@laptop>
 <20100413181937.GM13327@think>
 <20100413185756.GE5683@laptop>
 <20100413190110.GR13327@think>
 <20100413192551.GF5683@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413192551.GF5683@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BC4C842.013E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 05:25:51AM +1000, Nick Piggin wrote:
> On Tue, Apr 13, 2010 at 03:01:10PM -0400, Chris Mason wrote:
> > On Wed, Apr 14, 2010 at 04:57:56AM +1000, Nick Piggin wrote:
> > > Yes, because it's not just a theoretical livelock, it can be basically
> > > a certainty, given the right pattern of semops.
> > > 
> > > You could have two mostly-independent groups of processes, each taking
> > > and releasing a different sem, which are always contended (eg. if it is
> > > being used for a producer-consumer type situation, or even just mutual
> > > exclusion with high contention).
> > > 
> > > Then you could have some overall management process for example which
> > > tries to take both sems. It will never get it.
> > 
> > Ok, fair enough, I'll add the sequence number.
> > 
> > > 
> > > 
> > > > > I was looking at doing a sequence number to be able to sort these, but
> > > > > it ended up getting over complex (and SAP was only using simple ops so
> > > > > it didn't seem to need much better).
> > > > > 
> > > > > We want to be careful not to change semantics at all. And it gets
> > > > > tricky quickly :( What about Zach's simpler wakeup API?
> > > > 
> > > > Yeah, that's why my patches include code to handle userland sending
> > > > duplicate semids.
> > > 
> > > Duplicate semids? What do you mean?
> > 
> > Sorry, semnums...index into the array of semaphores.
> 
> OK, I wonder just how much it helps, and what.

Detecting the dups just keeps me from deadlocking.  I'm locking each
individual semaphore in sequence, so if userland does something strange
and sends two updates to the same semaphore, the code detects that and
only locks the first one.

> 
> 
> > > >  Zach's simpler API is cooking too, but if I can get
> > > > this done without insane complexity it helps with more than just the
> > > > post/wait oracle workload.
> > > 
> > > Iam worried about complexity and slowing other cases, given that Oracle
> > > DB seems willing to adapt to the (better suited) new API. So I'd be
> > > interested to know what it helps outside Oracle.
> > > 
> > 
> > Sure, I'd hope that your benchmark from last time around is faster now.
> 
> I didn't actually reproduce it here, I think it was a customer or
> partner workload. But SAP only seemed to have one contended semnum in
> its array, and it was being operated on with "simple" semops (so that's
> about as far as the patches went).
> 
> I didn't notice anything that should make that go faster?

Since I'm avoiding the ipc lock while operating on the array, it'll help
any workload that hits on two or more semaphores in the array at
once.

> 
> Yes, with such a workload, using semops is basically legacy and simple
> mutexes should work better. So I'm not outright against improving sysv
> sem performance for more complex cases where nothing else we have works
> as well.
> 

I'm not in a hurry to overhaul a part of the kernel that has been stable
for a long time.  But it really needs some love I think.  I'll have more
numbers from a tpc run later this week.

-chris

