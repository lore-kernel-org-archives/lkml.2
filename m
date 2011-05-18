Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab1ERIcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 04:32:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44014 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab1ERIcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 04:32:22 -0400
Date: Wed, 18 May 2011 10:31:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Lutomirski <luto@mit.edu>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
Message-ID: <20110518083147.GD14805@elte.hu>
References: <BANLkTinVnr1ZM2wOxuH-rHZGh+_SBWT-+g@mail.gmail.com>
 <alpine.LFD.2.02.1105170022430.3078@ionos>
 <20110517080029.GB22093@elte.hu>
 <BANLkTimpEfb3P9FWgrCDwSSVr6RA8nXb5w@mail.gmail.com>
 <20110517113634.GC13475@elte.hu>
 <4DD2BEFB.6070609@mit.edu>
 <m2hb8typxt.fsf@firstfloor.org>
 <alpine.LFD.2.02.1105172354040.3078@ionos>
 <BANLkTik9+UGLvPCLYO246N4fMxJ5F=vHwA@mail.gmail.com>
 <alpine.LFD.2.02.1105180839370.3078@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105180839370.3078@ionos>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> > And time() and sched_getcpu() call the vsyscall page unconditionally.
> 
> Dammit, time() is a real problem. I missed that and thought that it's 
> gettimeofday() alone for the static case. sched_getcpu() is nothing to worry 
> about.

There's a relatively simple solution for all this:

 - We can make the old vsyscall page contain an int $0x81 (it is a free vector)

 - We can use vector 0x81 as a wrapper around the int80 entry: it would check 
   the syscall nrs and return if it's outside the small number of permitted 
   syscalls

 - We can put this behind a straightforward CONFIG_COMPAT_VSYSCALL=y option, 
   enabled by default for compatibility.

 - Distros that fix glibc can turn it off

Costs:

 - the performance cost of this solution is minimal: weirdly built binaries on 
   unfixed glibc will have a handful of syscalls execute via int $0x81 not the 
   syscall instruction. The cost of that is +50 nsecs at most - not 500.

 - almost zero maintenance cost: it just wraps existing int80 logic. It does not
   even have to use any kernel stack, it only checks register arguments so the 
   code is truly small and trivial to keep secure.

Advantages:

 - we defang the constant-address syscall instruction this way - it cannot be 
   used for anything even remotely useful to an exploit.

 - it's very simple

 - there's a future path out of it and a future path to deprecate this

What do you think?

Thanks,

	Ingo
