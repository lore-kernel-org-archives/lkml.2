Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab0DBGUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 02:20:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:41669 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758028Ab0DBGUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 02:20:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+LuJZwYT+LOMD3/ddKco9TJLUuxV2PNg5kU+VlwB
	CjcwvleJgaYNww
Subject: Re: [patch v2 1/2] sched: check for prev_cpu == this_cpu before
 calling wake_affine()
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1270155872.2762.310.camel@sbs-t61.sc.intel.com>
References: <20100308221946.842728363@sbs-t61.sc.intel.com>
	 <1270031119.5003.93.camel@laptop>
	 <1270079265.7835.8.camel@sbs-t61.sc.intel.com>
	 <1270099940.6707.148.camel@marge.simson.net>
	 <1270155872.2762.310.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain
Date: Fri, 02 Apr 2010 08:20:39 +0200
Message-Id: <1270189239.6513.78.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 14:04 -0700, Suresh Siddha wrote:

> Consider this scenario. Today we do balance on fork() and exec(). This
> will cause the tasks to start far away. On systems like NHM-EP, tasks
> will start on two different sockets/nodes(as each socket is a numa node)
> and allocate their memory locally etc. Task A starting on Node-0 and
> Task B starting on Node-1. Once task B sleeps and if Task A or something
> else wakes up task B on Node-0, (with the recent change) just because
> there is an idle HT sibling on node-0 we endup waking the task on
> node-0. This is wrong. We should first atleast go through wake_affine()
> and if wake_affine() says ok to move the task to node-0, then we can
> look at the cache siblings for node-0 and select an appropriate cpu.

Yes, if task A and task B are more or less unrelated, you'd want them to
stay in separate domains, you'd not want some random event to pull.  The
other side of the coin is tasks which fork off partners that they will
talk to at high frequency.  They land just as far away, and desperately
need to move into a shared cache domain.  There's currently no
discriminator, so while always asking wake_affine() may reduce the risk
of moving a task with a large footprint, it also increases the risk of
leaving buddies jabbering cross cache.  You can tweak it in either
direction, and neither can be called "wrong", it's all compromise.

Do you have a compute load bouncing painfully which this patch cures?

I have no strong objections, and the result is certainly easier on the
eye.  If I were making the decision, I'd want to see some numbers.

	-Mike

