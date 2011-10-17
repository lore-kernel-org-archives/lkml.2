Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab1JQVXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:23:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36579 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab1JQVXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:23:34 -0400
Message-ID: <4E9C9CAE.9090207@zytor.com>
Date: Mon, 17 Oct 2011 14:22:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: Linux 3.1-rc9
References: <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca> <1318060551.8395.0.camel@twins> <20111012213555.GC24461@hostway.ca> <20111013232521.GA5654@hostway.ca> <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com> <20111017045806.GA11561@elte.hu> <alpine.LFD.2.02.1110171101250.3240@ionos> <20111017184916.GA5545@elte.hu> <4E9C917B.2050802@zytor.com> <20111017211951.GA8043@elte.hu>
In-Reply-To: <20111017211951.GA8043@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2011 02:19 PM, Ingo Molnar wrote:
> 
> it's 64/32 division - it's the /1000000000 /1000000 /1000 divisions 
> in the large majority of cases, to convert between 
> seconds/milliseconds/microseconds and scalar nanoseconds.
> 
> the kernel-internal ktime_t in the 32-bit optimized case is:
> 
> union ktime {
>         s32     sec, nsec;
> };
> 
> which is the same as timespec and arithmetically close to timeval, 
> which many ABIs use. So conversion is easy in that case - but 
> arithmetics gets a bit harder.
> 
> If we used a scalar 64-bit form for all kernel internal time 
> representations:
> 
> 	s64	nsecs;
> 
> then conversions back to timespec/timeval would involve dividing this 
> 64-bit value with 1000000000 or 1000000.
> 
> Is there no faster approximation for those than bit by bit?
> 
> In particular we could try something like:
> 
> 	(high*2^32 + low)/1e9 ~==  ( high * (2^64/1e9) ) / 2^32
> 
> ... which reduces it all to a 64-bit multiplication (or two 32-bit 
> multiplications) with a known constant, at the cost of 1 nsec 
> imprecision of the result - but that's an OK approximation in my 
> opinion.
> 

We can do much better than that with reciprocal multiplication.  We're
already playing reciprocal multiplication tricks for jiffies conversion,
and in this case it's much easier because the constant is already known.

	-hpa

