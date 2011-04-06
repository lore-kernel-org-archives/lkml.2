Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab1DFSUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 14:20:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:56397 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996Ab1DFSUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 14:20:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,311,1299484800"; 
   d="scan'208";a="729988091"
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/6] x86-64: Micro-optimize vclock_gettime
References: <cover.1301324270.git.luto@mit.edu>
Date: Wed, 06 Apr 2011 11:20:48 -0700
In-Reply-To: <cover.1301324270.git.luto@mit.edu> (Andy Lutomirski's message of
	"Mon, 28 Mar 2011 11:06:40 -0400")
Message-ID: <m2mxk35ji7.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@MIT.EDU> writes:

> This series speeds up vclock_gettime(CLOCK_MONOTONIC) on by almost 30%
> (tested on Sandy Bridge).  They're ordered in roughly decreasing order
> of improvement.
>
> These are meant for 2.6.40, but if anyone wants to take some of them
> for 2.6.39 I won't object.

I read all the patchkit and it looks good to me.  I felt a bit uneasy
about the barrier changes though, it may be worth running of the
paranoid "check monotonicity on lots of cpus" test cases to double check
on different CPUs.  The interesting cases are: P4-Prescott, Merom
(C2Duo), AMD K8.

Thanks for doing these optimizations again. Before generic clock source
these functions used to be somewhat faster, but they regressed
significantly back then. It may be worth comparing the current
asm code against these old code and see if there's still something
obvious missing.

Possible more optimizations if you're still motivated:
 
- Move all the timer state/seqlock into one cache line and start 
with a prefetch. 
I did a similar attempt recently for the in kernel timers.
You won't see any difference in a micro benchmark loop, but you may
in a workload that dirties lots of cache between timer calls.

- Replace the indirect call in vread() with a if ( timer == TSC)
inline() else indirect_call
(manual devirtualization essentially)

- Replace the sysctl checks with code patching use the new
static branch frameworks

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
