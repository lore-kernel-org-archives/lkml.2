Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0EPWmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:42:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41856 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab0EPWmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:42:13 -0400
Date: Sun, 16 May 2010 18:40:57 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Nick Piggin <npiggin@suse.de>, zach.brown@oracle.com,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in
 semtimedop
Message-ID: <20100516224057.GB27216@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Manfred Spraul <manfred@colorfullife.com>,
	Nick Piggin <npiggin@suse.de>, zach.brown@oracle.com,
	jens.axboe@oracle.com, linux-kernel@vger.kernel.org
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com>
 <1271098163-3663-2-git-send-email-chris.mason@oracle.com>
 <4BC4A6B2.1090906@colorfullife.com>
 <20100413173941.GI13327@think>
 <20100413180945.GD5683@laptop>
 <20100413181937.GM13327@think>
 <20100413185756.GE5683@laptop>
 <4BF02402.8060204@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF02402.8060204@colorfullife.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4BF074C1.0048:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 06:57:38PM +0200, Manfred Spraul wrote:
> On 04/13/2010 08:57 PM, Nick Piggin wrote:
> >On Tue, Apr 13, 2010 at 02:19:37PM -0400, Chris Mason wrote:
> >>I don't see anything in the docs about the FIFO order.  I could add an
> >>extra sort on sequence number pretty easily, but is the starvation case
> >>really that bad?
> >Yes, because it's not just a theoretical livelock, it can be basically
> >a certainty, given the right pattern of semops.
> >
> >You could have two mostly-independent groups of processes, each taking
> >and releasing a different sem, which are always contended (eg. if it is
> >being used for a producer-consumer type situation, or even just mutual
> >exclusion with high contention).
> >
> >Then you could have some overall management process for example which
> >tries to take both sems. It will never get it.
> >
> The management process won't get the sem on Linux either:
> Linux implements FIFO, but there is no protection at all against starvation.
> 
> If I understand the benchmark numbers correctly, a 4-core, 2 GHz
> Phenom is able to do ~ 2 million semaphore operations per second in
> one semaphore array.
> That's the limit - cache line trashing on the sma structure prevent
> higher numbers.
> 
> For a NUMA system, the limit is probably lower.
> 
> Chris:
> Do you have an estimate how many semop() your app will perform in one array?

There are two different workloads at play.  The first is to just use
semaphores as a lock, which is a traditional mutex type operation (one
at a time).  This isn't a problem with the current code, aside from lock
contention created by the second case.

The second case is batched wakeup.  One process will wake hundreds or
more at once that are each waiting on their own semaphore.

> 
> Perhaps we should really remove the per-array list,
> sma->sem_perm.lock and sma->sem_otime.

So far for our uses the per-array list was the biggest trouble.  I tried
to benchmark your patches on Friday, but these are preproduction systems
and it appears to have woken up in a bad mood.

The hardware guys are giving it some TLC and I'll be able to run on
Monday.

-chris

