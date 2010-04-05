Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab0DESpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 14:45:54 -0400
Received: from mail.lang.hm ([64.81.33.126]:54536 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907Ab0DESps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 14:45:48 -0400
Date: Mon, 5 Apr 2010 11:44:35 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Arjan van de Ven <arjan@linux.intel.com>
cc: paulmck@linux.vnet.ibm.com, Dominik Brodowski <linux@dominikbrodowski.net>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
In-Reply-To: <4BBA0AC5.1080905@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1004051137160.12764@asgard.lang.hm>
References: <20100403223328.GA4507@comet.dominikbrodowski.net> <Pine.LNX.4.44L0.1004041110010.2750-100000@netrider.rowland.org> <20100404163924.GA18428@comet.dominikbrodowski.net> <20100404204725.GC2644@linux.vnet.ibm.com> <20100404233702.GA24102@linux.vnet.ibm.com>
 <4BB95C85.80205@linux.intel.com> <20100405042222.GD2644@linux.vnet.ibm.com> <4BB9F657.4050901@linux.intel.com> <20100405151401.GA2525@linux.vnet.ibm.com> <4BBA0AC5.1080905@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Apr 2010, Arjan van de Ven wrote:

> On 4/5/2010 8:14, Paul E. McKenney wrote:
>> So the main issue is that for many workloads, it is best to run full bore
>> and get done quickly, thus allowing the entire machine to be powered down?
>
> yep

Race To Idle works extremely well in a batch type situation where there is 
not going to be any work to do after you finish what you have.

It doesn't work quite as well if you are going to have new work to do in 
the near future.

You cannot power down the entire machine if you have to look for user 
input.

It takes time (and power) to shut down and start back up, if you are going 
to have more work to do before you can make the complete cycle (and save 
more power than it costs to make the transitions), it's best to stay at 
full power, even if you are idle.


As an example, video/audio playback.

This requires relativly little cpu, but it needs it frequently (to keep 
the hardware buffers filled), and you cannot power down even when the cpu 
is idle.

But you could save power by disabling cores, switching to a slower clock 
speed, etc while still having one core remaining awake all the time.


The key is to look at what you are waiting for. If you are just waiting 
for the processing to finish, race to idle is great. However if you are 
waiting for the outside world or for a clock tick you need to look into 
the exact situation more closely.

David Lang

>> If so, it seems likely that there would be some workloads that were 
>> sometimes
>> unable to use all the CPUs, in which case shutting down (idling, offlining,
>> dyntick-idling, whatever) the excess CPUs might nevertheless be the right
>> thing to do.
>
> but the point is that the normal scheduler + idle behavior gives you exactly 
> that
> in a natural way !
> If you don't have enough work (tasks) to keep all cores busy, the others are 
> and stay idle.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
