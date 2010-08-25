Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab0HYVwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 17:52:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24782 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab0HYVwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 17:52:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JyRMi7BkwAWQkBbMQ/M6RYrK7HTGSo1h8E6PVxWPu0stLdY4wsgTkYvcZJKoPjEOx0
         alPxvw7rSSPlnVLTO73Q==
MIME-Version: 1.0
In-Reply-To: <20100818191700.GA6427@loge.amd.com>
References: <1281648529-29678-1-git-send-email-venki@google.com>
	<20100813070435.GE4569@loge.amd.com>
	<AANLkTineUH2Z2CYVEz001S7srZHmF73qZJfQU9WOjVnM@mail.gmail.com>
	<20100818191700.GA6427@loge.amd.com>
Date: Wed, 25 Aug 2010 14:52:33 -0700
Message-ID: <AANLkTimpu0RiDN1daYAQp=cx=jrxmqrRd4_-5ozwVABm@mail.gmail.com>
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

On Wed, Aug 18, 2010 at 12:17 PM, Andreas Herrmann
<andreas.herrmann3@amd.com> wrote:
> On Fri, Aug 13, 2010 at 01:52:37PM -0400, Venkatesh Pallipadi wrote:
>> On Fri, Aug 13, 2010 at 12:04 AM, Andreas Herrmann
>> <andreas.herrmann3@amd.com> wrote:
>
>  [...]
>
>> The reason for this patch was a breakage in the app that tries to
>> build CPU maps for packages and cores (Nothing to do with Intel or
>> AMD). The app is using info under /sys/devices/system//node/ and
>> /sys/device/system/cpu/cpu0/cache to get the NUMA node and cache
>> sharing info etc. And looking at cpuinfo for core package info.
>
> Hmm, and why not using .../cpu/cpuX/topology/core_siblings for the
> package info? It just sounds strange to me to use /proc/cpuinfo for
> CPU topology information.

I think its because, the app is supposed to work across different kernels
(with and without /sys topology) and also using /proc/cpuinfo was working OK
until we saw the problem with this particular platform.

>
>> And is getting confused with NUMA overloaded package and core info
>> in /proc/cpunfo. I can of course change this specific app to
>> workaround this. But, I think changing core id to reflect numa-ness
>> without a numa id to go with it is not right.
>
> Using Node ID from SRAT table would not be right.
> You could have just one NUMA node 0 (spanning all packages) but the
> CPUs are still associated to a node within the physical package.
> So, it is the ID of the northbridge device to which this CPU belongs
> which should be exported.

Agree. I said Node ID in generic sense. In this case it will be northbridge dev.

>> Basically, with this NUMA overloading of core id, we are loosing the
>> unique id of cores that was in "core id" before.
>
> Yes, I see. Just couldn't imagine that some apps are relying on that info
> if there are much more convenient ways of getting it.
> Why parsing /proc/cpuinfo for SMT sibling information if we have a
> CPU list and mask for this in /sys.

We can term such apps as "legacy apps" :-)

>> Without this /proc/cpuinfo output makes sense with "cpu cores" being
>> 12 and 12 unique ids for cores under one physical id. With this
>> change, "cpu cores" under a package is still 12. But, trying to id
>> those 12 cores, one ends up with 0..5 0..5. We are loosing the MSB
>> on these IDs only to give some implicit and incomplete information (
>> Number of nodes = "cpu cores" / number of unique core ids, but we
>> wont tell you here how to identify those nodes. Look at /sys..node
>> for that).
>
> Exporting the node_id for the northbridge devices to which the core
> is attached would solve this problem.
>
>> Isn't it better to leave /proc/cpuinfo out of this so that older apps
>> continue to work and newer apps can use all the /sys fs topology
>> information to get the complete info?
>
> BTW, which app is this?
> I've quickly checked some tools and couldn't find heavy usage of
> /proc/cpuinfo.

This is an internal app.

There are few programs reporting CPU topology like hwloc, x86info.
Not sure whether they are affected by this.

I did find few "knowledge-base" articles that explains /proc/cpuinfo
as "same core id" => same core
[like -
http://planet.admon.org/howto/about-cpu-the-logical-and-physical-cores/
http://linuxhunt.blogspot.com/2010/03/understanding-proccpuinfo.html
]

>
>> Taking this a bit further, this different cores sharing same core id
>> within a package is going to be messy in general. Consider totally
>> hypothetical CPU package with 2 nodes and 2 SMT siblings in each node.
>> If we follow this current scheme of things of - stuffing node info
>> without node id - in proc/cpuinfo, it will look something like
>> processor: 0
>> physical id: 0
>> siblings: 4
>> core id: 0
>> cpu cores: 4
>>
>> processor: 1
>> physical id: 0
>> siblings: 4
>> core id: 0
>> cpu cores: 4
>>
>> processor: 2
>> physical id: 0
>> siblings: 4
>> core id: 0
>> cpu cores: 4
>>
>> processor: 3
>> physical id: 0
>> siblings: 4
>> core id: 0
>> cpu cores: 4
>
> Yep, in theory this could reflect physcial packages having
> - 1 core having 4 SMT siblings
> - 2 nodes with 2 cores each and 2 SMT siblings
> - 4 nodes, 1 core
>
> /proc/cpuinfo is insufficient to reflect full topology information.
> Changing core_id you would still get similar entries for physical
> packages
>
> - having 2 internal nodes, 1 core each with 2 SMT siblings
> - having 2 cores with 2 SMT siblings each

Agree. But, identifying this "internal node" topology is a new
requirement and just overloading core id isn't going to be enough.


>> Which would be very much useless. We should either have "node id" info
>> or not change the "core id" meaning to include node info.
>
> Then I'd vote to provide the CPU northbridge node id information.

<snip>
>
>> and add new assumptions. We have new APIS is /sys anyway to describe
>> full topology.
>
> I still recommend to use sysfs info for topology detection.
> But I also agree that there is some inconsistency in /proc/cpuinfo
>
> It's the maintainers' call to decide how to fix this inconsistency.
> I am fine with both solutions.
> But if core_id is not "normalized" anymore I need to do some more review
> and testing to ensure that nothing breaks.
>

hpa/thomas/ingo: Please let us know how you prefer to deal with this...

Thanks,
Venki
