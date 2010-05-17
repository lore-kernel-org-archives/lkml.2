Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab0ERGXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:23:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab0ERGXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:23:48 -0400
Date: Mon, 17 May 2010 17:20:13 +1000
From: Nick Piggin <npiggin@suse.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Chris Mason <chris.mason@oracle.com>, zach.brown@oracle.com,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in
 semtimedop
Message-ID: <20100517072013.GA7407@laptop>
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

Yeah I did realise this after I posted. But anyway I think FIFO
is reasonable to have, although you *may* be able to justify
removing it after your research of other UNIXes, if there are
sufficient gains.

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
> 
> Perhaps we should really remove the per-array list,
> sma->sem_perm.lock and sma->sem_otime.
> 
> --
>     Manfred
