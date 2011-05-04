Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1EDWH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 18:07:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:38816 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab1EDWHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 18:07:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,316,1301900400"; 
   d="scan'208";a="638069858"
From: Andi Kleen <andi@firstfloor.org>
To: Dave Kleikamp <dkleikamp@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, paulmck@us.ibm.com
Subject: Re: idle issues running sembench on 128 cpus
References: <4DC1C95B.4040706@gmail.com>
Date: Wed, 04 May 2011 15:07:27 -0700
In-Reply-To: <4DC1C95B.4040706@gmail.com> (Dave Kleikamp's message of "Wed, 04
	May 2011 16:47:07 -0500")
Message-ID: <m2pqnyyva8.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp <dkleikamp@gmail.com> writes:
>
> I am able to avoid this problem with either kernel parameter,
> "idle=mwait" or "processor.max_cstate=1". Similarly, defining
> CONFIG_INTEL_IDLE=y and using the kernel parameter
> intel_idle.max_cstate=1 exposes a different spinlock, pm_qos_lock, but
> I found this patch which fixes that contention:
> https://lists.linux-foundation.org/pipermail/linux-pm/2011-February/030266.html
> https://patchwork.kernel.org/patch/550721/

The pm_qos patch really needs to be merged ASAP. Len?

> Of course, we'd like to find a way to reduce the spinlock contention
> and not resort to prohibiting the cpus from entering C3 state at
> all. I don't see a simple fix, and want to know if you've seen
> anything like this before and given it any thought.
>
> I also don't know if it makes sense to be able to tune the cpuidle
> governors to add more resistance to enter the C3 state, or even being
> able to switch to a performance governor at runtime, similar to
> cpufreq.
>
> I'd like to hear your thoughts before I dive any deeper into this.

It's fixed on Westmere. There the APIC timer will always tick
and all that logic is not needed anymore and disabled.

That is mostly fixed. One problem right now is that the
CLOCK_EVT_FEAT_C3STOP test is inside the lock. But we
can easily move it out, assuming the clock_event_device
gets RCU freed or has a reference count.

But yes it would be still good to fix Nehalem too.

One fix would be to make all the masks hierarchical,
similar to what RCU does. Perhaps even some code 
could be shared with RCU on that because it's a very
similar problem.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
