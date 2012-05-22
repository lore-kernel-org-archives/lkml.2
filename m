Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab2EVNeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:34:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab2EVNeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:34:10 -0400
Date: Tue, 22 May 2012 09:33:56 -0400
From: Don Zickus <dzickus@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]x86, reboot: Fix a warning message triggered by
 stop_other_cpus()
Message-ID: <20120522133356.GW32472@redhat.com>
References: <20120522105233.725be041@feng-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120522105233.725be041@feng-i7>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:52:33AM +0800, Feng Tang wrote:
> 
> The root cause seems to be the default_send_IPI_mask_allbutself_phys()
> takes quiet some time (I measured it could be several ms) to complete
> sending NMIs to all the other 23 CPUs, and for HZ=250/1000 system, the

I sent Ingo a patch (which he took in), that reverts this path to interrupts
again (and NMIs as a fallback if it fails).  The problem will still exist
I assume though I don't know if it changes the timing characteristics.

> time is long enough for a timer interrupt to happen, which will in
> turn trigger to kick load balance to a stopped CPU and cause this
> warning in native_smp_send_reschedule().
> 
> So disabling the local irq before stop_other_cpu() can fix this
> problem (tested 25 times reboot ok), and it is fine as there should
> be nobody caring the timer interrupt in such reboot stage.

It seems to be fine.  I just do not know enough about the load balancing
the timer interrupt does to know if this is the right way to go or not.

So from the shutdown cpu perspective, you are just blocking the interrupt
from occurring while we shutdown the other cpus, which prevents the load
balancer from running and seeing cpus disappear beneath it.  Sounds
reasonable.

Though on the other hand the same interrupt on another cpu might spit out
the same warning as cpus disappear without notification if it tries to
reschedule.  Probably rare and the window is probably small as the cpus
would probably all 'stop' rather quickly.

I don't know.  I guess it is ok.

Cheers,
Don
