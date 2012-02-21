Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab2BUMsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 07:48:32 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:39403 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753973Ab2BUMsb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 07:48:31 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Feb 2012 07:48:30 EST
Subject: Re: [PATCH RFC 0/4] Scheduler idle notifiers and users
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <1329318063.2293.136.camel@twins>
Date: Tue, 21 Feb 2012 14:38:28 +0200
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Saravana Kannan <skannan@codeaurora.org>, Ingo Molnar <mingo@elte.hu>,
        linaro-kernel@lists.linaro.org, Nicolas Pitre <nico@fluxnic.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Oleg Nesterov <oleg@redhat.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Chan <mike@android.com>, Dave Jones <davej@redhat.com>,
        Todd Poynor <toddpoynor@google.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org,
        Arjan Van De Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <69B0D95C-2A80-41A9-97E1-86F5840B84CF@antoniou-consulting.com>
References: <20120208013959.GA24535@panacea> <1328670355.2482.68.camel@laptop> <20120208202314.GA28290@redhat.com> <1328736834.2903.33.camel@pasglop> <20120209075106.GB18387@elte.hu> <4F35DD3E.4020406@codeaurora.org> <20120211144530.GA497@elte.hu> <4F3AEC4E.9000303@codeaurora.org> <1329313085.2293.106.camel@twins> <20120215140245.GB27825@n2100.arm.linux.org.uk> <1329318063.2293.136.camel@twins>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

On Feb 15, 2012, at 5:01 PM, Peter Zijlstra wrote:

> On Wed, 2012-02-15 at 14:02 +0000, Russell King - ARM Linux wrote:
> 

<snip>
> 
> I guess that all will depend on the hardware.. there'll still be some
> sort of governor in between taking the per-cpu/task load-tracking data
> and scheduler events and using that to compute some volt/freq setting.
> 
> From what I've heard there's a number of different classes of hardware
> out there, some like race to idle, some can power gate more than others
> etc.. I'm not particularly bothered by those details, I'm sure there's
> people who are.
> 
> All I really want is to consolidate all the various statistics we have
> across cpufreq/cpuidle/sched and provide cpufreq with scheduler
> callbacks because they've been telling me their current polling stuff
> sucks rocks.
> 
> Also the current state of affairs is that the cpufreq stuff is trying to
> guess what the scheduler is doing, and people are feeding that back into
> the scheduler. This I need to stop from happening ;-)

If I may interject one more point here.

If we go to all the trouble of integrating cpufreq/cpuidle/sched into scheduler
callbacks, we should place hooks into the thermal framework/PM as well.

It will pretty common to have per core temperature readings, on most
modern SoCs. 

It is quite conceivable to have a case with a multi-core CPU where due
to load imbalance, one (or more) of the cores is running at full speed
while the rest are mostly idle. What you want do, for best performance
and conceivably better power consumption, is not to throttle either 
frequency or lowers voltage to the overloaded CPU but to migrate the
load to one of the cooler CPUs.

This affects CPU capacity immediately, i.e. you shouldn't schedule more
load on a CPU that its too hot, since you'll only end up triggering thermal 
shutdown. The ideal solution would be to round robin
the load from the hot CPU to the cooler ones, but not so fast that we lose
due to the migration of state from one CPU to the other.

In a nutshell, the processing capacity of a core is not static, i.e. it
might degrade over time due to the increase of temperature caused by the
previous load.

What do you think?

Regards

-- Pantelis
  

