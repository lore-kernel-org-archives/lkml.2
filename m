Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762062Ab0HMTFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 15:05:48 -0400
Received: from smtp-out.google.com ([74.125.121.35]:17240 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab0HMTFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 15:05:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=eapc15RJ6LarJFXyB5XhgEFRkfF2ed6pIagfM+W7579ftxC1SSKtHvwXSfeAT9N80
	Jhazt6Mf9HJvKab6+C6KA==
MIME-Version: 1.0
In-Reply-To: <AANLkTineUH2Z2CYVEz001S7srZHmF73qZJfQU9WOjVnM@mail.gmail.com>
References: <1281648529-29678-1-git-send-email-venki@google.com>
	<20100813070435.GE4569@loge.amd.com>
	<AANLkTineUH2Z2CYVEz001S7srZHmF73qZJfQU9WOjVnM@mail.gmail.com>
Date: Fri, 13 Aug 2010 12:05:43 -0700
Message-ID: <AANLkTikDhWyX=sjcpXXLnRXyPQN=2p98UvsHBsXjO+Ri@mail.gmail.com>
Subject: Re: [PATCH] x86: Wrong /proc/cpuinfo core id on AMD fam_f model_9
From: Venkatesh Pallipadi <venki@google.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 10:52 AM, Venkatesh Pallipadi <venki@google.com> wrote:
> On Fri, Aug 13, 2010 at 12:04 AM, Andreas Herrmann
> <andreas.herrmann3@amd.com> wrote:
>> On Thu, Aug 12, 2010 at 05:28:49PM -0400, Venkatesh Pallipadi wrote:
>>> Commit 4a376ec3a2599c02207cd4cbd5dbf73783548463 changes cpuinfo cpu_core_id
>>> from an unique id in a physical package to core id within a node. And it
>>> does not change phys_proc_id or booted_cores to reflect this new topology.
>>
>> It shouldn't change phys_proc_id because that is supposed to be the
>> socket information. (both for AMD and Intel)
>>
>>> This breaks the user view of topology in /proc/cpuinfo.
>>>
>>> With commit 4a376ec /proc/cpuinfo output (for one package) looks something like
>>> processor: 0..11
>>> physical id: 0..0
>>> core id: 0..5 0..5
>>> siblings: 12
>>> cpu cores: 12
>>>
>>> That is, there are processors with same "physical id" and same "core id" (which
>>> are not SMT siblings). As I understand, if /proc/cpuinfo says there are 12
>>> "cpu cores" per package, there should be 12 unique core ids in that package.
>>> And same "physical id" and "core id" is supposed to indicate SMT siblings.
>>
>> I don't agree. That's rather an Intel centric view. You should use
>> thread_sibling information to identify this.  See the topology
>> sub-directory for each CPU.
>
> The reason for this patch was a breakage in the app that tries to
> build CPU maps for packages and cores (Nothing to do with Intel or
> AMD). The app is using info under /sys/devices/system//node/ and
> /sys/device/system/cpu/cpu0/cache to get the NUMA node and cache
> sharing info etc. And looking at cpuinfo for core package info. And is
> getting confused with NUMA overloaded package and core info in
> /proc/cpunfo. I can of course change this specific app to workaround
> this. But, I think changing core id to reflect numa-ness without a
> numa id to go with it is not right.
>
> Basically, with this NUMA overloading of core id, we are loosing the
> unique id of cores that was in "core id" before. Without this
> /proc/cpuinfo output makes sense with "cpu cores" being 12 and 12
> unique ids for cores under one physical id. With this change, "cpu
> cores" under a package is still 12. But, trying to id those 12 cores,
> one ends up with 0..5 0..5. We are loosing the MSB on these IDs only
> to give some implicit and incomplete information ( Number of nodes =
> "cpu cores" /  number of unique core ids, but we wont tell you here
> how to identify those nodes. Look at /sys..node for that).
>
> Isn't it better to leave /proc/cpuinfo out of this so that older apps
> continue to work and newer apps can use all the /sys fs topology
> information to get the complete info?
>
> Taking this a bit further, this different cores sharing same core id
> within a package is going to be messy in general. Consider totally
> hypothetical CPU package with 2 nodes and 2 SMT siblings in each node.
> If we follow this current scheme of things of - stuffing node info
> without node id - in proc/cpuinfo, it will look something like

Correction. s/cpu cores: 4/cpu cores: 2/ for this case. But, the
problem with core id will still be there.

> processor: 0
> physical id: 0
> siblings: 4
> core id: 0
> cpu cores: 4
>
> processor: 1
> physical id: 0
> siblings: 4
> core id: 0
> cpu cores: 4
>
> processor: 2
> physical id: 0
> siblings: 4
> core id: 0
> cpu cores: 4
>
> processor: 3
> physical id: 0
> siblings: 4
> core id: 0
> cpu cores: 4
>
> Which would be very much useless. We should either have "node id" info
> or not change the "core id" meaning to include node info.
>
>>> The change below reverts the cpu_core_id part of that commit and
>>
>> Please don't do that. Potentially you are breaking user space. You
>> rather need to know the core id (0..5) within a node instead of the
>> CoreId (0..11) within the entire package. See AMD's BKDG for family
>> 0x10 CPUs. As a rule of thumb you require the ID of a core within one
>> Node -- not within a package.
>
> The problem is the core_id change is breaking the userspace decoding
> of package/core/thread info from /proc/cpuinfo. Yes. I may need to
> know core id's in a node. But, /proc/cpuinfo is not giving be that
> info of "ID of core withing one Node". There is no Node info there.
> Its still giving me Core ID withing a physical package with no way of
> knowing which cores are within a node.
>
>>
>>> /proc/cpuinfo has
>>> processor: 0..11
>>> physical id: 0..0
>>> core id: 0..11
>>> siblings: 12
>>> cpu cores: 12
>>
>>> Also, if the intention of the original change was to export two node info,
>>> then changing just the core id is not enough. User has no way to determine
>>> which of these 6 cores out of 12 belong to same node by looking at
>>> /proc/cpuinfo output.
>>
>> Yes, you can't get this info from /proc/cpuinfo output. But
>> /proc/cpuinfo is completely useless to gather entire toplogy
>> information anyway.  You should extract most stuff from the topology
>> subdirectory for CPUs.
>
> So, if you think cpuinfo is useless for NUMA topology, then why do you
> think core id should be change to reflect NUMA info?
>
>>
>>> Both "physical id" and "cpu cores" has to change
>>> to reflect that or one more node id needs to be added (I didn't say that :))
>>
>> No, physical id has _not_ to change.
>
> I agree with physical id should not change, so that user will get the
> package info correctly. I mentioned that as one option to make
> /proc/cpuinfo self-contained with this NUMA overloading.
>
>> The other option -- exporting NodeId -- I tried last year but this
>> was rejected. (see http://marc.info/?l=linux-kernel&m=124964980507887)
>> Did not have time to work on implementing other proposed solutions though ... Sigh
>>
>> Thus, so far, the node sibling information is only reflected in the L3
>> cache sibling mask for Magny-Cours-CPUs. Ugly, but working.
>
> Just to summarize, I am of the opinion that if we can't describe
> something in /proc/cpuinfo fully, we should not stuff partial info and
> break existing assumptions and add new assumptions. We have new APIS
> is /sys anyway to describe full topology.
>
> Thanks,
> Venki
>
