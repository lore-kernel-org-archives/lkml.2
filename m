Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab0DEOkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 10:40:46 -0400
Received: from mga07.intel.com ([143.182.124.22]:53753 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753668Ab0DEOkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 10:40:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,366,1267430400"; 
   d="scan'208";a="262139810"
Message-ID: <4BB9F657.4050901@linux.intel.com>
Date: Mon, 05 Apr 2010 07:40:23 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Dominik Brodowski <linux@dominikbrodowski.net>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
References: <20100403223328.GA4507@comet.dominikbrodowski.net> <Pine.LNX.4.44L0.1004041110010.2750-100000@netrider.rowland.org> <20100404163924.GA18428@comet.dominikbrodowski.net> <20100404204725.GC2644@linux.vnet.ibm.com> <20100404233702.GA24102@linux.vnet.ibm.com> <4BB95C85.80205@linux.intel.com> <20100405042222.GD2644@linux.vnet.ibm.com>
In-Reply-To: <20100405042222.GD2644@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/2010 21:22, Paul E. McKenney wrote:
> On Sun, Apr 04, 2010 at 08:44:05PM -0700, Arjan van de Ven wrote:
>>> And you did mention offlining some CPUs above.  The folloiwng patch
>>> (from Lai Jiangshan) is needed to handle this case.
>>
>> btw on x86... don't offline CPUs if you want to save power.. it doesn't.
>> (at least not during idle.. and when you're busy it might save power,
>> but it won't save you energy normally)
>
> Hmmm...  The fact that offlining CPUs doesn't save power could form
> the basis of an interesting rationalization for my having ignored
> offlined CPUs in my original patch, I suppose.  ;-)
>
> So the proper approach is to affinity everything away from the CPUs
> in question so that they stay in dyntick-idle mode?

that is actually equivalently bad ;)

>  I must confess
> that I find this quite counter-intuitive -- and I suspect that I am
> not the only one who would expect offlined CPUs to drop to the
> lowest possible power consumption.

on x86 (other archs might be different), nowadays idle is VERY efficient.
(and the way to offline a cpu is to put it into the same deep C state as idle would)

the "offline is same power as idle" is only the part where you don't win energy.
the part where you lose energy is the part where you realize that you can only really put
the memory controller and memory in power saving state if all cpus are in idle.
If you offline a cpu (versus leaving it idle), and you have several tasks to run during an
activity burst (which are more common the more we group activity to save power), it can happen
that there are so many things to do that all remaining cpus can't handle it without the scheduler
delaying some tasks. At which point you delay putting the memory (controllers) in low power state
and you lose. In general, the winning strategy seems to be to finish things as quickly as you can,
eg on as many cpus as you have in the system to then let them all go idle.

(this is not always true if you're picking cpu frequency/voltages, but for idle states it tends
to be true. there's always cases where it isn't.... power is like that)
