Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab1C3MAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:00:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28944 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab1C3MAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:00:30 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
In-reply-to: <1301485924.4859.181.camel@twins>
References: <20110323153727.GB12003@htj.dyndns.org> <20110324094119.GD12038@htj.dyndns.org> <20110324094151.GE12038@htj.dyndns.org> <20110325101238.GC1409@htj.dyndns.org> <20110329163702.GE29865@htj.dyndns.org> <1301485262-sup-5247@think> <1301485924.4859.181.camel@twins>
Date: Wed, 30 Mar 2011 07:59:13 -0400
Message-Id: <1301485909-sup-4022@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D931B51.0173,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Peter Zijlstra's message of 2011-03-30 07:52:04 -0400:
> On Wed, 2011-03-30 at 07:46 -0400, Chris Mason wrote:
> > 
> > In this case, the only thing we're really missing is a way to mutex_lock
> > without the cond_resched() 
> 
> So you're trying to explicitly avoid a voluntary preemption point? Seems
> like a bad idea, normally people add those :-)

Yeah, but the btrfs fast path (when we're able to spin today) looks like
this:

spin_lock(parent)
binary search, select slot
pull block for that slot out of cache
spin_lock(child)
spin_unlock(parent)

If we switch it all to mutexes:

mutex_lock(parent)
binary search, select slot
pull block for that slot out of cache
mutex_lock(child)
mutex_unlock(parent)

Most of the spinning vs blocking benefits in btrfs came from doing
special things (like dropping the parent lock) when we know we're going
to block with the parent lock held.  Surprise blocking in mutex_lock
isn't great.

It would probably be enough to just move the cond_resched() after the
spinning portion of the mutex_lock()

-chris
