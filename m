Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2D3IFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 04:05:19 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:55485 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688Ab2D3IFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 04:05:16 -0400
Message-ID: <4F9E47B4.3000004@ti.com>
Date: Mon, 30 Apr 2012 13:35:08 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
References: <20120420122120.097464672@linutronix.de>
In-Reply-To: <20120420122120.097464672@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2012 06:35 PM, Thomas Gleixner wrote:
> Dear all,
> 
> I'm working on refactoring the SMP boot and CPU hotplug implementation.
> 
> The current code has evolved over time into a conglomerate of
> warts. My main goals are to:
> 
>  - reduce the architecture code by moving repeating constructs to the
>    core
> 
>  - redesigning the handling of per cpu threads. There is no point to
>    tear down the threads just to create them again.
> 
>  - restructuring the notifier facility into a proper tree with
>    dependencies to avoid the gazillion of callbacks and moving
>    setup/teardown code into the context of the upcoming/dying cpu
> 
> The motivation behind this work is the cpu hotplug nightmare which we
> are facing in the RT kernel and the requests from several groups
> (e.g. ARM) to make hotplug more lightweight and faster.
> 
> This first part moves the idle thread management for non-boot cpus
> into the core. fork_idle() is called in a workqueue as it is
> implemented in a few architectures already. This is necessary when not
> all cpus are brought up by the early boot code as otherwise we would
> take a ref on the user task VM of the thread which brings the cpu up
> via the sysfs interface.
> 
> This converts all architectures except m32r, mn10300, tile and UM to
> the new core facility. These architecture are calling fork_idle() in
> the very early boot code in smp_prepare_cpus() for unknown reasons.
> I haven't analyzed yet, whether this is on purpose or can be moved
> over to the generic facility. It'd be nice if the responsible maintainers
> could look into that as well.
> 

Tried this series on OMAP4 (Dual Core ARM machine) and did some
some testing with CPU hot-plug by creating variable CPU loads and
running CPU hot-plug script in the background.
No issue observed in 2 hours of testing.

Not sure your stand on Suresh's patch[1], but I did another
round of testing with [1] included. I thought this patch
might be considered since it eliminate the need for work-queue
based idle thread allocation which can be a problem as
discussed on this thread.

Regards
Santosh

[1] https://lkml.org/lkml/2012/4/20/524





