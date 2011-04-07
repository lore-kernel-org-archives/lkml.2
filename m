Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1DGPX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 11:23:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45046 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1DGPX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 11:23:57 -0400
Date: Thu, 7 Apr 2011 17:23:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andy Lutomirski <luto@MIT.EDU>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFT/PATCH v2 2/6] x86-64: Optimize vread_tsc's barriers
Message-ID: <20110407152354.GW21838@one.firstfloor.org>
References: <cover.1302137785.git.luto@mit.edu> <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu> <20110407082550.GG24879@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110407082550.GG24879@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, do we *really* have RDTSC SMP-coherency guarantees on multi-socket CPUs 
> today? It now works on multi-core, but on bigger NUMA i strongly doubt it. So 
> this hack tries to preserve something that we wont be able to offer anyway.

Some larger NUMA systems have explicit TSC consistency in hardware; on those that don't 
we disable TSC as a clocksource so this path should be never taken.

> So the much better optimization would be to give up on exact GTOD coherency and 
> just make sure the same task does not see time going backwards. If user-space 
> wants precise coherency it can use synchronization primitives itsef. By default 
> it would get the fast and possibly off by a few cycles thing instead. We'd 
> never be seriously jump in time - only small jumps would happen in practice, 
> depending on CPU parallelism effects.

That would be a big user visible break in compatibility.

Any small jump can lead to a negative time difference, and negative time differences
are known to break applications.

e.g. typical case is app using this as a event time stamp into a buffer written
from multiple CPUs, and then assuming that the time stamp always goes up.

> If we do that then the optimization would be to RDTSC and not use *any* of the 
> barriers, neither the hardware ones nor your tricky software data-dependency 
> obfuscation barrier.

The barriers were originally added because a stress test was able to observe
time going backwards without them.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
