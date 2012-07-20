Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2GTAjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 20:39:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:44902 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab2GTAjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 20:39:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="174530806"
Message-ID: <5008A847.4070006@linux.intel.com>
Date: Thu, 19 Jul 2012 17:37:27 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Darren Hart <darren@dvhart.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.5-rc6 futex_wait_requeue_pi oops.
References: <20120713180823.GA24972@redhat.com> <alpine.LFD.2.02.1207132032330.32033@ionos> <20120713185402.GA1707@redhat.com> <5008969F.5030901@linux.intel.com>
In-Reply-To: <5008969F.5030901@linux.intel.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/19/2012 04:22 PM, Darren Hart wrote:
> 
> 
> On 07/13/2012 11:54 AM, Dave Jones wrote:
>> On Fri, Jul 13, 2012 at 08:47:38PM +0200, Thomas Gleixner wrote:
>>  > On Fri, 13 Jul 2012, Dave Jones wrote:
>>  > 
>>  > > Looks like calling futex() with garbage makes things unhappy.
>>  > 
>>  >                 WARN_ON(!&q.pi_state);
>>  >                 pi_mutex = &q.pi_state->pi_mutex;
>>  >                 ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
>>  >                 debug_rt_mutex_free_waiter(&rt_waiter);
>>  > 
>>  > So there is some weird way which causes q.pi_state = NULL. Dave, did
>>  > you see the warning before the oops happened ?
>>
>> No, that didn't seem to trigger.
> 
> Well I don't have a fix yet, but I can explain this not triggering.
> 
> q is on the stack, so the ADDRESS for q.pi_state is never going to be
> NULL. However, properly instrumented, we do see this:
> 
> [   23.621501] ---[ end trace 20bdfb44db182a17 ]---
> [   23.622425] q.pi_state @           (null)
> [   23.623272] &q.pi_state @ ffff880185e2dca8
> [   23.624119] ------------[ cut here ]------------
> 
> Duh.
> 
> I'll add a fix to that WARN_ON in my futex-fixes branch along with the
> fix for the bug Dan found.
> 

I think I have root cause. futex_wait_requeue_pi() doesn't like having
uaddr == uaddr2. The handle_early_wakeup() doesn't detect a problem
because key2 IS the same as key1, I think. I've just discovered this and
quickly hacked in a "if (uaddr==uaddr2) return -EINVAL" fix and the test
continues to run (with just ops 0, 11, 12) for several minutes now
(typically fails in a few seconds). I'll let it run for a few hours and
contemplate the proper fix.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


