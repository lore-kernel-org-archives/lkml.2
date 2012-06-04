Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2FDRZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:25:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:52171 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182Ab2FDRZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:25:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="152485352"
Message-ID: <4FCCEF94.6010805@linux.intel.com>
Date: Mon, 04 Jun 2012 10:25:40 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Vladimir Davydov <vdavydov@parallels.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>      <1338805967.28282.12.camel@twins> <4FCCB486.4040905@linux.intel.com>     <1338817519.28282.54.camel@twins> <4FCCBC97.8060101@linux.intel.com>    <1338822509.28282.65.camel@twins> <4FCCD0CD.8080700@linux.intel.com>   <1338823568.28282.79.camel@twins> <4FCCD6B7.4030703@linux.intel.com>  <1338827607.28282.99.camel@twins> <4FCCE823.8090700@linux.intel.com> <1338830167.28282.115.camel@twins>
In-Reply-To: <1338830167.28282.115.camel@twins>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> what the logic is trying to do, on a 10 km level, is to limit the damage
>> of accumulated C state exit time.
>> (I'll avoid the word "latency" here, since the real time people will
>> then immediately think this is about controlling latency response, which
>> it isn't)
> 
> But why? There's a natural limit to his, say the wakeup costs 0.2ms then
> you can only do 5k of those a second. Once you need to actually do some
> work as well this comes down.

but if you only do 100 per second, you still burn 20 msec, which can be
too much if you're performance sensitive.


> But its all idle time, you cannot be idle longer than there is a lack of
> work. So if you're idle too long (because of long exit latency) your
> work shifts and the future idle time reduces, eventually causing a lower
> C state to be used.
> 
> Also, when you notice you're waking up too soon, you can quickly ramp
> down on the C state levels.

when wakeups happen too soon, this already happens.
but that's orthogonal to some degree unfortunately.

> 
>> Now, if you're very idle for a sustained duration (e.g. low load),
>> you're assumed not sensitive to a bit of performance cost.
>> but if you're actually busy (over a longer period, not just "right
>> now"), you're assumed to be sensitive to the performance cost,
>> and what the algorithm does is make it less easy to go into the
>> expensive states.
> 
> My brain still sparks and fizzles when I read that.. it just doesn't
> compute.
> 
> What performance? performance isn't a well defined word.

for the sake of argument, lets call it the amount of work the system can
get done. (where 'work' is obviously still vague, but the software
running on the system will know what it is).

can you afford to do no work for those 20 msec every second ?
the answer to that will be "it depends", and estimating that "depends"
is what the load average value is used for.

I will totally accept that the value used right now is not the optimal
or correct value to use (as you said, the "top" type load average is not
available, which would have been much nicer).
