Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0F2TBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 15:01:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:53276 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070Ab0F2TBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 15:01:43 -0400
Message-ID: <4C2A428E.10400@kernel.org>
Date: Tue, 29 Jun 2010 20:59:26 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, oleg@redhat.com,
       axboe@kernel.dk, dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de,
       florian@mickler.org, andi@firstfloor.org, mst@redhat.com,
       randy.dunlap@oracle.com, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 34/35] async: use workqueue for worker pool
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <4C2A2688.1020206@kernel.org> <4C2A3652.7030806@linux.intel.com> <4C2A385B.3010909@kernel.org> <4C2A39D4.8040505@linux.intel.com> <4C2A3CD0.70706@kernel.org> <4C2A3E4D.9050607@linux.intel.com>
In-Reply-To: <4C2A3E4D.9050607@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 18:59:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/29/2010 08:41 PM, Arjan van de Ven wrote:
>> Well, the thing is, for most cases, binding to cpus is simply better.
> 
> depends on the user.

Heh, yeah, sure, can't disagree with that.  :-)

> For "throw over the wall" work, this is unclear.  Especially in the
> light of hyperthreading (sharing L1 cache) or even modern cpus
> (where many cores share a fast L3 cache).

There will be many variants of memory configurations and the only way
the generic kernel can optimize memory access is if it localizes stuff
per cpu which is visible to the operating system.  That's the lowest
common denominator.  From there, we sure can add considerations for
specific shared configurations but I don't think that will be too
common outside of scheduler and maybe memory allocator.  It just
becomes too specific to apply to generic kernel core code.

> I'm fine with a solution that has the caller say 'run anywhere' vs
> 'try to run local'.  I suspect there will be many many cases of 'run
> anywhere'.isn't hard at all. I just wanna know whether it's
> something which is

Yeah, sure.  I can almost view the code in my head right now.  If I'm
not completely mistaken, it should be really easy.  When a cpu goes
down, all the left works are already executed unbound, so all the
necessary components are already there.

The thing is that once it's not bound to a cpu, where, how and when a
worker runs is best regulated by the scheduler.  That's why I kept
talking about wq being simple context provider.

If something is not CPU intensive, CPU parallelism doesn't buy much,
so works which would benefit from parallel execution are likely to be
CPU intensive ones.  For CPU intensive tasks, fairness, priority and
all that stuff are pretty important and that's scheduler's job.  cmwq
can provide contexts and put some safety limitations but most are best
left to the scheduler.

>> actually useful.  So, where would that be useful?
> 
> I think it's useful for all users of your worker pool, not (just) async.
> 
> it's a severe limitation of the current linux infrastructure, and your
> infrastructure has the chance to fix this...

Yeah, there could be situations where having a generic context
provider can be useful.  I'm just not sure async falls in that
category.  For the current users, I think we would be (marginally)
better off with bound workers.  So, that's the reluctance I have about
updating async conversion.

Thanks.

-- 
tejun
