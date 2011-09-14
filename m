Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212Ab1INUVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:21:22 -0400
Received: from mx2.parallels.com ([64.131.90.16]:51637 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933142Ab1INUVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:21:21 -0400
Message-ID: <4E710C93.40609@parallels.com>
Date: Wed, 14 Sep 2011 17:20:35 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <xemul@parallels.com>,
        <paul@paulmenage.org>, <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <mingo@elte.hu>, <jbottomley@parallels.com>
Subject: Re: [PATCH 0/9] Per-cgroup /proc/stat
References: <1316030695-19826-1-git-send-email-glommer@parallels.com> <1316031196.5040.46.camel@twins>
In-Reply-To: <1316031196.5040.46.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.106.51.14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2011 05:13 PM, Peter Zijlstra wrote:
> On Wed, 2011-09-14 at 17:04 -0300, Glauber Costa wrote:
>> [[ For those getting this twice: I sent it previously to containers
>>     ml, but I guess it was out. Sending now to a broader audience anyway ]]
>>
>> Hi,
>>
>> This patchset is a simple initial proposal for a per-cgroup/container
>> display of /proc/stat. The display method is based on Daniel's idea of
>> exposing a file that can be bind mounted (Daniel, is that more or less
>> what you had in mind?)
>>
>> To grab the stats themselves, I am (ab)using cpuacct cgroup. percpu counters
>> are dropped in favor of normal percpu pointers, so we can easily track
>> per-cpu quantities.
>>
>> In case you guys like this idea, my TODO list would include the removal
>> of the show stat code in fs/proc/stat.c altogether, and the displaying
>> of some fields I haven't touched yet.
>>
>> Also, to demonstrate one of the potential ideas for such method, I
>> implemented a feature comonly found in hypervisors - steal time - on top
>> of it. I arguee that containers can/should also display steal time when
>> available. Turns out that due to the fact that we run on the same kernel,
>> steal time is quite easy to implement once we have per-container tick
>> accounting in place.
>>
>> Please let me know what you guys think
>>
>> Glauber Costa (9):
>>    Remove parent field in cpuacct cgroup
>>    Make cpuacct fields per cpu variables
>>    Include nice values in cpuacct
>>    Include irq and softirq fields in cpuacct
>>    Include guest fields in cpuacct
>>    Include idle and iowait fields in cpuacct
>>    Create cpuacct.proc.stat file
>>    per-cgroup boot time
>>    Report steal time for cgroup
>>
>>   kernel/sched.c |  265 +++++++++++++++++++++++++++++++++++++++++++++++++-------
>>   1 files changed, 234 insertions(+), 31 deletions(-)
>
> I hate it already.. it just smells of more senseless accounting
> overhead.
>
> Guys we should seriously trim back a lot of that code, not grow ever
> more and more. The sad fact is that if you build a kernel with
> cpu-cgroup support the context switch cost is more than double that of a
> kernel without, and then you haven't even started creating cgroups yet.
>
> Also, how doesn't all this duplicate part of cpuacct-cgroup?
>
> /me won't actually look at the patches for a little while longer.
Hey Peter,

Answering just a single point here, if you look closely, it does not 
duplicate  anything from cpuacct. What it does, is to divide it in more
fine grained groups than just user/system. But it is not even called 
more than it already used to be. Also, I change the counters to per-cpu 
variables instead of percpu counters (so we can access per-cpu data). If 
there is any perf. change wrt the current code, it comes from that, and 
since percpu variables are cheaper to update (and summing up is much 
less frequent), it will end up even cheaper.

The steal time feature is really trivial once it is in place.

About your point of the context switch cost, how would you feel if we 
optimized it out using static_branch() like it was done for kvm steal time?

I can also commit to taking a look at making the overall performance 
suck less here, but it is really orthogonal to what I just posted.

