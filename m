Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab2GKNGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:06:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab2GKNG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:06:29 -0400
Message-ID: <4FFD7A31.8000909@redhat.com>
Date: Wed, 11 Jul 2012 09:05:53 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: John Stultz <johnstul@us.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, stable@vger.kernel.org
Subject: Re: [PATCH 1/6] hrtimer: Provide clock_was_set_delayed()
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com> <1341960205-56738-2-git-send-email-johnstul@us.ibm.com> <4FFD6E5A.9060206@redhat.com> <alpine.LFD.2.02.1207111425260.32033@ionos>
In-Reply-To: <alpine.LFD.2.02.1207111425260.32033@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I wish there was a nicer way to do this ... but looking at the code I can't
>> figure out a better way.  (no offense John, it's just the way the code is ;) )
> 
> Yeah, I had the same discussion with Peter earlier today. There is
> only a rather limited set of options.
> 
> 1) Retrigger the timer interrupt vectors on all CPUs - except the one
>    we are running on, but we have no interface for that at the moment
> 
> 2) Do the nasty __smp_call_function_single() hack
> 
>    Preallocate call_single_data for all cpus and do a
>    __smp_call_function_single() on all online cpus.
> 
>    This can be called from hard interrupt context or irq disabled
>    regions.
> 
>    That would allow to get rid of the whole delay magic all
>    together.
> 
> Thoughts?
> 

Both of those options seem like a lot of work for something that happens once
every 3-4 years, and may not happen ever again[1].  Based on that statement, if
we're going to modify code I would prefer that it be as lightweight as possible.
 So, in terms of the kernel, option 2 is likely the best way to go rather than
introducing new code that will be used once every 3-4 years.

I keep asking the question of why the mechanism of inserting a leap second isn't
moved into userspace ntpd (or some other appropriate daemon).  I suppose there
is a risk of ntpd being starved out on heavily loaded systems...

P.

[1] http://en.wikipedia.org/wiki/Leap_second#Proposal_to_abolish_leap_seconds
