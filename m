Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab2AIRFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 12:05:50 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:41070 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab2AIRFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 12:05:49 -0500
Date: Mon, 9 Jan 2012 22:35:21 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
Message-ID: <20120109170521.GB29142@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
 <1326103578.2442.50.camel@twins>
 <1326104915.2442.53.camel@twins>
 <20120109110025.GA7988@dirshya.in.ibm.com>
 <1326119707.2442.77.camel@twins>
 <20120109160317.GA29142@dirshya.in.ibm.com>
 <1326125597.2442.90.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1326125597.2442.90.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12010917-2000-0000-0000-000005FA6B16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-01-09 17:13:17]:

> On Mon, 2012-01-09 at 21:33 +0530, Vaidyanathan Srinivasan wrote:
> 
> > Yes, based on the architecture and topology, we do have two sweet
> > spots for power vs performance trade offs.  The first level should be
> > to reduce power savings with marginal performance impact and second
> > one will be to go for the most aggressive power savings.
> 
> Colour me unconvinced, cache heavy workloads will suffer greatly from
> your 1.

Certain workloads will get hit heavily by '1', so default choice of
'1' is bad for this case. However many general workloads could give
good power savings with marginal performance loss.  For those general
cases, we could keep '1' as default.

> > The first one should generally be recommended as default to have
> > a right balance between performance and power savings, while the
> > second one should be used for reducing power consumption on
> > unimportant workloads or under certain constraints.
> > 
> > Some example policies:
> > 
> > sched_powersavings=1:
> > 
> >         Enable consolidation at MC level
> > 
> > sched_powersavings=2:
> > 
> >         Enable aggressive consolidation at MC level and SMT level if
> >         available. In case arch can benefit from cross node
> >         consolidation, then enable it.
> 
> You fail for mentioning MC/SMT..

My point was that SMT thread level consolidation comes with larger
performance loss compared to core level.  We need not expose this
settings to end user, but kernel can choose 'what' to enable at '2'
based on architecture/topology.

> > Having the above simple split in policy will enable wide adoption
> > where the first level can be a recommended default.  Having just
> > a boolean enable/disable will mean the end-user will have to decide
> > when to turn on and later off for best workload experience.
> 
> Picking one of two states is too hard, hence we given them one of three
> states to pick from.. How does that make sense?

Ok, I am suggesting that having three states will allow the user to
decide 'once' and leave the setting, rather than keep changing the
settings between enable/disable.

I am suggesting that designing powersavings=1 as a good default will
make the adoption simple.  On the other hand, only having
power_savings=enable would mean users will have to decide 'when' to
enable based on some policy, since leaving it enabled could affect
overall performance significantly.

> > Just similar to cpufreq policy of performance, ondemand and powersave.
> > They have their unique use cases and this design choice helps us ship
> > ondemand as default.
> 
> You fail for thinking having multiple cpufreq governors is a good thing.
> The result is that they all suck.

Majority of the users are served by the good default 'ondemand'
governor that has good powersavings without affecting performance
a lot.  If we just had performance and powersave governors, we will
have to choose 'performance' as default and design a method to choose
powersave only when utilization is low.

I agree with you that we do have too many cpufreq governors and
tunables than required.  But a good default covers most use cases,
leaving the rest for corner cases and workload specific tunings.  On
modern systems, cpuidle states and scheduling policy becomes
a significant power savings tradeoffs and hence we will need the
flexibility.

--Vaidy


