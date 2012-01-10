Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab2AJCb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 21:31:59 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:36592 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab2AJCb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 21:31:57 -0500
X-Greylist: delayed 1159 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jan 2012 21:31:57 EST
Message-ID: <0c92071a002c16120b424c4057056a05.squirrel@webmail.greenhost.nl>
In-Reply-To: <1326120367.2442.84.camel@twins>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
    <1326103578.2442.50.camel@twins>
    <20120110001445.GA20542@linux-youquan.bj.intel.com>
    <1326107563.2442.65.camel@twins>
    <CAKfTPtDM-L-AcHr_o44vmR9VYRvQqOyXuwEgnZ61d4pbDOPFUg@mail.gmail.com>
    <1326120367.2442.84.camel@twins>
Date: Tue, 10 Jan 2012 03:12:29 +0100
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
From: "Indan Zupancic" <indan@nul.nu>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Cc: "Vincent Guittot" <vincent.guittot@linaro.org>,
        "Youquan Song" <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 3b058867a8808b2a73617ccb478d635a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, January 9, 2012 15:46, Peter Zijlstra wrote:
> On Mon, 2012-01-09 at 15:29 +0100, Vincent Guittot wrote:
>
>> I'm also using sched_mc level for doing powersaving load balance on
>> ARM platform and we have real benefits.
>
> Right, I've never said that power aware balancing was without merit, I
> know it matters (quite a lot for some).
>
>> We might modify the way we choose between power or performance mode
>> because it's not always a matter of gathering or spreading tasks on
>> cpus but until we found a best interface it's the way to enable
>> powersaving mode
>
> Sure, it was the only interface available.
>
> But I really want to get rid of the topology based knobs we have now,
> preferably I even want to get rid of the multi-value thing.
>
> pjt still needs to post his linsched rework *poke* *poke*, that should
> give a good basis to rework most of this without regressing the world
> and then some.
>
> But even without that I think we can do better than we do currently.

Perhaps it should be controlled by the CPU governor instead of being
a separate knob? Because in the end it is about power saving and that
is the CPU governor's role. So to me it seems that at least the policy
should come from/via the CPU governor. It seems right that there is one
place that controls both frequencies and active core count.

I guess what happens now is that powersaving aware scheduling causes a
core to become idle, with the CPU governor detecting that and putting
the core to sleep. Maybe it should be the other way round, with the
governor detecting that not all cores are needed and putting one to
sleep?

This way the scheduler can schedule optimally over the available cores
for maximum performance. For some hardware it may also be much better
to have multiple active cores at low voltage and frequency instead of
fewer cores at high frequency, especially if more cache is available.
To pick the right policy automatically this kind of information has to
be known, and currently such kind of information seems to come from the
cpuidle/cpufreq drivers.

Having just one knob which chooses between gathering or spreading tasks
is a good start. But in the end it seems core idling should be controlled
automatically depending on the hardware and circumstances by something
like a CPU governor. It probably should also be aware of IRQ balancing
and making sure idle cores don't get any interrupts while there are active
cores that could handle them.

I know people weren't too happy with the current implementation of the
CPU governors either. Didn't someone implement a proof of concept version
of an improved governor a while ago? (Arjan?)

Greetings,

Indan


