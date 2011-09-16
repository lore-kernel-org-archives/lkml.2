Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1IPIWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 04:22:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62488 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab1IPIWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 04:22:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:message-id:date:from:user-agent:
	mime-version:newsgroups:to:cc:subject:references:in-reply-to:
	content-type:content-transfer-encoding:x-system-of-record;
	b=ssfIjNC97cMFvZO9YF19zTNagqvPAnWCwCZEJLc6SK7FVq21+4h63FC3yWNLYxPLm
	wz7IwAQEpY5SRkCnjxp0w==
Message-ID: <4E73074D.8090305@google.com>
Date: Fri, 16 Sep 2011 01:22:37 -0700
From: Paul Turner <pjt@google.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned
 vs unpinnede
References: <20110503092846.022272244@google.com> <20110607154542.GA2991@linux.vnet.ibm.com> <1307529966.4928.8.camel@dhcp-10-30-22-158.sw.ru> <20110608163234.GA23031@linux.vnet.ibm.com> <BANLkTim7a9uhH_K6sw4YdqWB6frT+HUqqQ@mail.gmail.com> <20110610181719.GA30330@linux.vnet.ibm.com> <BANLkTimE1b8HP-q4jgsv5jPD5S-dRoUi_g@mail.gmail.com> <20110615053716.GA390@linux.vnet.ibm.com> <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com> <20110907152009.GA3868@linux.vnet.ibm.com>
In-Reply-To: <20110907152009.GA3868@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/11 08:20, Srivatsa Vaddagiri wrote:
> [Apologies if you get this email multiple times - there is some email
> client config issue that I am fixing up]
>
> * Paul Turner<pjt@google.com>  [2011-06-21 12:48:17]:
>
>> Hi Kamalesh,
>>
>> Can you see what things look like under v7?
>>
>> There's been a few improvements to quota re-distribution that should
>> hopefully help your test case.
>>
>> The remaining idle% I see on my machines appear to be a product of
>> load-balancer inefficiency.
>

Hey Srivatsa,

Thanks for taking another look at this -- sorry for the delayed reply!

> which is quite a complex problem to solve! I am still surprised that
> we can't handle 32 cpuhogs on a 16-cpu system very easily. The tasks seem to
> hop around madly rather than settle down as 2 tasks/cpu. Kamalesh, can you post
> the exact count of migrations we saw on latest tip over a 20-sec window?
>
> Anyway, here's a "hack" to minimize the idle time induced due to load-balance
> issues. It brings down idle time from 7+% to ~0% ..I am not too happy about
> this, but I don't see any other simpler solutions to solve the idle time issue
> completely (other than making load-balancer completely fair!).

Hum,

So BWC returns bandwidth on voluntary sleep to the parent, so the most 
we can really lose is NR_CPUS * 1ms (how much a cpu keeps in case the 
entity re-wakes up quickly).  Technically we could lose another few ms 
if there's not enough BW left to bother distributing and we're near the 
end of the period; but I think that works out to another 6ms or so at 
worst.

As discussed in the long thread dangling off this; it's load-balance 
that's at fault -- allowing steal time is just hiding this by instead 
letting cpus run over quota within a period.

If you for example set-up a deadline oriented test that tried to 
accomplish the same amount of work (without bandwidth limits) and threw 
away the rest of the work when it reached period expiration (a benchmark 
I've been meaning to write and publish as a more general load-balance 
test actually); then I suspect we'd see similar problems; and sadly, 
this case is both more representative of real-world performance and not 
fixable by something like steal-time.

So... we're probably better off trying to improve LB; I raised it in 
another reply on the chain but the NOHZ vs ticks ilb numbers look pretty 
compelling as an area for improvement in this regard.

Thanks!

- Paul
>
> --
>
> Fix excessive idle time reported when cgroups are capped.  The patch
> introduces the notion of "steal" (or "grace") time which is the surplus
> time/bandwidth each cgroup is allowed to consume, subject to a maximum
> steal time (sched_cfs_max_steal_time_us). Cgroups are allowed this "steal"
> or "grace" time when the lone task running on a cpu is about to be throttled.

