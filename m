Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1IGOCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 10:02:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59012 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab1IGOCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 10:02:07 -0400
Date: Wed, 7 Sep 2011 15:01:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frank Rowand <frank.rowand@am.sony.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@tglx.de>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [ANNOUNCE] 3.0.1-rt11
Message-ID: <20110907140130.GT6619@n2100.arm.linux.org.uk>
References: <1313232790.25267.7.camel@twins> <4E559039.8060209@am.sony.com> <20110826235507.GJ2342@linux.vnet.ibm.com> <4E66DCAB.8090801@am.sony.com> <alpine.LFD.2.02.1109071115410.2723@ionos> <20110907104633.GR6619@n2100.arm.linux.org.uk> <20110907104747.GA29282@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1109071254010.2723@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1109071254010.2723@ionos>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 12:57:44PM +0200, Thomas Gleixner wrote:
> The problem is that if you enable interrupts on the CPU _BEFORE_ it is
> set online AND active, then you can end up waking up kernel threads
> which are bound to that CPU and the scheduler will happily schedule
> them on an online CPU. That makes them lose the cpu affinity to the
> CPU as well and hell breaks lose.

How can that happen?

1. The only interrupts we're likely to receive are the local timer
   interrupts - we have not routed any other interrupts to this CPU.

2. We will not schedule on this CPU except at explicit scheduling
   points (such as contended mutexes or explicit calls to schedule)
   as we have a call to preempt_disable().

> Frank has observed this with softirq threads, but the same thing is
> true for any other CPU bound thread like the worker stuff.

So who is scheduling a workqueue from the local timer?

> So moving the online, active thing BEFORE enabling interrupt is the
> only sensible solution.

Yes, that'll be why even x86 enables interrupts before setting the CPU
online for the delay calibration.
