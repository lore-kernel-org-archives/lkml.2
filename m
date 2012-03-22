Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab2CVQ0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 12:26:24 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:48074 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751514Ab2CVQ0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 12:26:21 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: qVPa2gYVM1lB_QPTcgN2lLflx1MznaNO0lNuM38JvDdoD4z
 9rGRx4Y1j34z_4kC4iNZUkCOVtv36xii5cJE5jUAUuYuKqk3k2b2dgFTZb73
 MchZw25_Pa0HKZBueKDr6ZGbEEbv13eD58uKvPiu8hkYluxNLgXvdEkYGKkG
 r8UACTTZbh5WSMT_Upim9eOzM1MBnAT56XFzpOALqTB8LjG8uHtekwmx7OI7
 jX85yuXJ5m6ynsh1FEn2bKefguKcZ3uat.KiaNL_y2rWtj7n9n9FoG9onTv7
 HYivHmx3HdMPDGuKF1PWcpghca.Cug9awGUGsJu3m04koW.SCw2fDFWFbEMX
 t9Lc.CJJhF0YpL1VJCTfWThTngPdpeFyWZv0AvF6EsAieYSzB6OXN4M94YSo
 T
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 22 Mar 2012 11:26:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mike Galbraith <efault@gmx.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Subject: Re: [PATCH 07/32] cpuset: Set up interface for nohz flag
In-Reply-To: <1332389033.5759.52.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.00.1203221118550.25011@router.home>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com> <1332338318-5958-9-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.1203210949440.20482@router.home> <1332389033.5759.52.camel@marge.simpson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2012, Mike Galbraith wrote:

> > > We use here a per cpu refcounter. As long as a CPU
> > > is contained into at least one cpuset that has the
> > > nohz flag set, it is part of the set of CPUs that
> > > run into adaptive nohz mode.
> >
> > What are the drawbacks for nohz?
>
> For nohz in general, latency.  To make it at all usable for rt loads, I

Well nohz while a process is running on a dedicated cpu means the cpu is
running full power and no disruptions occur. This is a tremendous benefit.

> had to make isolated cores immune from playing load balancer.  Even so,
> to achieve target latency, I had to hack up cpusets to let the user
> dynamically switch nohz off for specified sets (and the tick has to be
> skewed in both cases or you can just forget it).  With nohz, I can't
> quite achieve 30us jitter target, turn it off, I get single digit.  Out

Less than 10us jitter can alrady be accomplished by building a kernel with
certain options off (like for example preemption...) and ensuring that
stuff stays off certain processors. Lets not confuse realtime with low
latency. Real time in the sense of deterministic execution is bad for
latency because overhead is added to ensure the determinism which
increases latency.

I have a patch here that adds a system call to simply switch off the timer
interrupt cold turkey and with that I can get down to 1-2 usecs jitter.

> of the current box, triple digit for simple synchronized frame timers +
> compute worker-bees load on 64 cores.  Patch 4 probably helps that, but
> don't _think_ it'll fix it.  If you (currently) ever become balancer,
> you're latency target is smoking wreckage.

Yes so we need something to tell the system which cpu is the sacrificial
lamb that will not run low latency applications.
