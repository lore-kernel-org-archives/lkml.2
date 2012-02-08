Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2BHGe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 01:34:29 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:60237 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2BHGe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 01:34:28 -0500
Message-ID: <4F32174E.2050207@linux.vnet.ibm.com>
Date: Wed, 08 Feb 2012 12:03:50 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: paul@paulmenage.org, mingo@elte.hu, rjw@sisk.pl, tj@kernel.org,
        frank.rowand@am.sony.com, pjt@google.com, tglx@linutronix.de,
        lizf@cn.fujitsu.com, prashanth@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling related
 to cpusets
References: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com> <1328671335.2482.72.camel@laptop>
In-Reply-To: <1328671335.2482.72.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12020806-2000-0000-0000-00000656897A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 08:52 AM, Peter Zijlstra wrote:

> On Wed, 2012-02-08 at 00:25 +0530, Srivatsa S. Bhat wrote:
>> There is a very long standing issue related to how cpusets handle CPU
>> hotplug events. The problem is that when a CPU goes offline, it is removed
>> from all cpusets. However, when that CPU comes back online, it is added
>> *only* to the root cpuset. Which means, any task attached to a cpuset lower
>> in the hierarchy will have one CPU less in its cpuset, though it had this
>> CPU in its cpuset before the CPU went offline.
> 
> Yeah so? That's known behaviour..


This might be a known behaviour, but this is surely not the behaviour we
want right? I understand that if you take a CPU offline, we have no other
choice but to remove it from all cpusets. But if the same CPU comes back
online and the userspace did not request any change to cpusets in between
those events (offline-online), then is it not wrong to silently keep that
CPU out of the cpuset even when it comes online?

IOW, consider:

cpuset A has 0-10

- Take CPU 10 offline
  [We are forced to remove CPU 10 from cpuset A, which becomes 0-9 now]


   <Userspace didn't request any change to cpuset A>


- Bring back CPU 10 online

Now cpuset A is still 0-9! IMO, it should have been 0-10.
That is, why should a totally unrelated operation like CPU Hotplug alter
the cpuset silently under the hood? Or, put another way, if the kernel
is intelligent enough to restore the root cpuset on CPU hotplug events,
why should it not restore the rest of the cpusets?

> 
>> The issue gets enormously aggravated in the case of suspend/resume.
> 
> Why does suspend resume does this anyway? hotunplug is terribly
> expensive, surely not doing it would make suspend ever so much faster?
> 


Well, the point I am trying to make is not about speeding up suspend/resume
itself. I am trying to say that there is a bug (or atleast an "undesirable
behaviour" if you feel "bug" is too strong a word to use) in cpu hotplug
handling in cpusets which gets magnified during suspend/resume
(agreed, because suspend/resume relies on cpu hotplug at the moment).

[And one of the promises of suspend/resume is to restore the system to its
original state to the best extent it can. And cpusets is clearly breaking
this promise. And the good news is: this luckily falls under our "things
that we *can* restore after resume" list and this patchset achieves this.]

>>  During
>> suspend, all non-boot CPUs are taken offline. Which means, all those CPUs
>> get removed from all the cpusets. When the system resumes, all CPUs are
>> brought back online; however, the newly onlined CPUs get added only to the
>> root cpuset - and all other cpusets have cpuset.cpus = 0 (boot cpu alone)!
>> This means, (as is obvious), all those tasks attached to non-root cpusets
>> will be constrained to run only on one single cpu!
>>
>> So, imagine the amount of performance degradation after suspend/resume!!
>>
>> In particular, libvirt is one of the active users of cpusets. And apparently,
>> people hit this problem long ago:
>> https://bugzilla.redhat.com/show_bug.cgi?id=714271
>>
>> But unfortunately this never got resolved since people probably thought that
>> the bug was in libvirt... and all this time the kernel was the culprit!
> 
> /me boggles, why do you use cpusets on a system small enough to suspend,
> and I'm so not going to ask about libvirt because I know I'll just get
> sad.
> 
 

Regards,
Srivatsa S. Bhat

