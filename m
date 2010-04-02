Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab0DBRGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:06:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:30052 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab0DBRGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:06:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,354,1267430400"; 
   d="scan'208";a="554516879"
Subject: Re: [patch v2 1/2] sched: check for prev_cpu == this_cpu before
 calling wake_affine()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1270189239.6513.78.camel@marge.simson.net>
References: <20100308221946.842728363@sbs-t61.sc.intel.com>
	 <1270031119.5003.93.camel@laptop>
	 <1270079265.7835.8.camel@sbs-t61.sc.intel.com>
	 <1270099940.6707.148.camel@marge.simson.net>
	 <1270155872.2762.310.camel@sbs-t61.sc.intel.com>
	 <1270189239.6513.78.camel@marge.simson.net>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 02 Apr 2010 10:05:25 -0700
Message-Id: <1270227925.2870.49.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 23:20 -0700, Mike Galbraith wrote:
> Yes, if task A and task B are more or less unrelated, you'd want them to
> stay in separate domains, you'd not want some random event to pull.  The
> other side of the coin is tasks which fork off partners that they will
> talk to at high frequency.  They land just as far away, and desperately
> need to move into a shared cache domain.  There's currently no
> discriminator, so while always asking wake_affine() may reduce the risk
> of moving a task with a large footprint, it also increases the risk of
> leaving buddies jabbering cross cache.

Mike, Apart from this small tweak that you added in wake_up() path there
is no extra logic that keeps buddies together for long. As I was saying,
fork/exec balance starts apart and in the partial loaded case (i.e.,
when # of running tasks <= # of sockets or # of total cores) the default
load balancer policy also tries to distribute the load equally among
sockets/cores (for peak cache/memory controller bw etc). While the
wakeup() may keep the buddies on SMT siblings, next load balancing event
will move them far away. If we need to keep buddies together we need
more changes than this small tweak.

> Do you have a compute load bouncing painfully which this patch cures?
> 
> I have no strong objections, and the result is certainly easier on the
> eye.  If I were making the decision, I'd want to see some numbers.

All I saw in the changelog when you added this new tweak was:

commit 8b911acdf08477c059d1c36c21113ab1696c612b
Author: Mike Galbraith <efault@gmx.de>
Date:   Thu Mar 11 17:17:16 2010 +0100

    sched: Fix select_idle_sibling()
    
    Don't bother with selection when the current cpu is idle. ....

Is it me or you who need to provide the data for justification for your
new tweak that changes the current behavior ;)

I will run some workloads aswell!

thanks,
suresh

