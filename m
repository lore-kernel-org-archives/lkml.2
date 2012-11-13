Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab2KMWpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:45:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:37900 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab2KMWpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:45:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,768,1352102400"; 
   d="scan'208";a="246574632"
Message-ID: <50A2CD77.7000403@linux.intel.com>
Date: Tue, 13 Nov 2012 14:45:11 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 3/3] PM: Introduce Intel PowerClamp Driver
References: <1352757831-5202-1-git-send-email-jacob.jun.pan@linux.intel.com> <1352757831-5202-4-git-send-email-jacob.jun.pan@linux.intel.com> <20121113211602.GA30150@linux.vnet.ibm.com> <20121113133922.47144a50@chromoly> <20121113222350.GH2489@linux.vnet.ibm.com>
In-Reply-To: <20121113222350.GH2489@linux.vnet.ibm.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 2:23 PM, Paul E. McKenney wrote:
> On Tue, Nov 13, 2012 at 01:39:22PM -0800, Jacob Pan wrote:
>> On Tue, 13 Nov 2012 13:16:02 -0800
>> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
>>
>>>> Please refer to Documentation/thermal/intel_powerclamp.txt for more
>>>> details.  
>>>
>>> If I read this correctly, this forces a group of CPUs into idle for
>>> about 600 milliseconds at a time.  This would indeed delay grace
>>> periods, which could easily result in user complaints.  Also, given
>>> the default RCU_BOOST_DELAY of 500 milliseconds in kernels enabling
>>> RCU_BOOST, you would see needless RCU priority boosting.
>>>
>> the default idle injection duration is 6ms. we adjust the sleep
>> interval to ensure idle ratio. So the idle duration stays the same once
>> set. So would it be safe to delay grace period for this small amount in
>> exchange for less over head in each injection period?
> 
> Ah, 6ms of delay is much better than 600ms.  Should be OK (famous last
> words!).

well... power clamping is not "free".
You're going to lose performance as a trade off for dropping instantaneous power consumption....
in the measurements we've done comparing various methods.. this one is doing remarkably well.

> 
> For most kernel configuration options, it does use softirq.  And yes,
> the kthread you are using would yield to softirqs -- but only as long
> as softirq processing hasn't moved over to ksoftirqd.  Longer term,
> RCU will be moving from softirq to kthreads, though, and these might be
> prempted by your powerclamp kthread, depending on priorities.  It looks
> like you use RT prio 50, which would usually preempt the RCU kthreads
> (unless someone changed the priorities).

we tried to pick a "middle of the road" value, so that usages that really really
want to run, still get to run, but things that are more loose about it, get put on hold.


> 
>>> It looks like you could end up with part of the system powerclamped
>>> in some situations, and with all of it powerclamped in other
>>> situations. Is that the case, or am I confused?
>>>
>> could you explain the part that is partially powerclamped?
> 
> Suppose that a given system has two sockets.  Are the two sockets
> powerclamped independently, or at the same time?  My guess was the
> former, but looking at the code again, it looks like the latter.
> So it is a good thing I asked, I guess.  ;-)

they are clamped together, and they have to.
you don't get (on the systems where this driver works) any "package" C state unless
all packages are idle completely.
And it's these package C states where the real deep power savings happen, that's
why they are such a juicy target for power clamping ;-)

