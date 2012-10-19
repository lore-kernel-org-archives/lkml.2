Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab2JSDVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:21:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36481 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161035Ab2JSDVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:21:43 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Date: Fri, 19 Oct 2012 12:20:54 +0900 (JST)
Message-Id: <20121019.122054.476812873.d.hatayama@jp.fujitsu.com>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, x86@kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, len.brown@intel.com,
        fenghua.yu@intel.com, ebiederm@xmission.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Subject: Re: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20121018141449.GB18147@redhat.com>
References: <20121017141234.GD31663@redhat.com>
	<20121018.120805.464238435.d.hatayama@jp.fujitsu.com>
	<20121018141449.GB18147@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
Date: Thu, 18 Oct 2012 10:14:49 -0400

> On Thu, Oct 18, 2012 at 12:08:05PM +0900, HATAYAMA Daisuke wrote:
> 
> [..]
>> > Do you have any rough numbers on what kind of speed up we are looking
>> > at. IOW, what % of time is gone compressing a filetered dump. On large
>> > memory machines, saving huge dump files is anyway not an option due to
>> > time it takes. So we need to filter it to bare minimum and after that
>> > vmcore size should be reasonable and compression time might not be a
>> > big factor. Hence I am curious what kind of gains we are looking at.
>> > 
>> 
>> I did two kinds of benchmark 1) to evaluate how well compression and
>> writing dump into multiple disks performs on crash dump and 2) to
>> compare three kinds of compression algorhythm --- zlib, lzo and snappy
>> --- for use of crash dump.
>> 
>> >From 1), 4 disks with 4 cpus performs 300 MB/s on compression with
>> snappy. 1 hour for 1 TB. But on this benchmark, sample data is
>> intentionally randomized enough so data size is not reduced during
>> compression, it must be quicker on most of actual dumps. See also
>> bench_comp_multi_IO.tar.xz for image of graph.
> 
> Ok, I looked at the graphs. So somehow you seem to be dumping to multiple
> disks. How do you do that? Are these disks in some stripe configuration
> or they are JBOD and you have written special programs to dump a
> particular section of memory to a specific disk to achieve parallelism?
> 

This was neither stripe like RAID0 nor JBOD, but the purpose was
stripe and what I did is simpler than such disk management features,
splitting crash dump into a given number of sections and writing them
into the same number of disks seprately. makedumpfiles already
supports this; see makedumpfile --split.

However, I didn't use makedumpfile --split. I wrote a benchmark script
that does this in Python and I used it. The reason is that
makedumpfile can input only crash dump format, and if I used
makedumpfile, I had to modify sample data in some crash dump formats,
which was not flexble.

> Looking at your graphs, 1 cpu can keep up with 4 disks and achieve
> 300MB/s and after that it looks like cpu saturates. Adding more disks
> with 1 cpu does not help. But increasing number of cpus can keep up
> with increasing number of disks and you achieve 800MB/s. Sounds good.
> 

BTW, recent SDD shows over 1000MB/s maximally. lzo and snappy shows
200MB/s on worst case of my benchmark for compression
performance. This is too slow to use. I guess compression block size
needs to be increased. Then, compression needs more cpu power, and
difference on 4 disks case between cpu=1 to cpu=4 gets more clear.

>> 
>> In the future, I'm going to do this benchmark again using quicker SSD
>> disks if I get them.
>> 
>> >From 2), zlib, used when doing makedumpfile -c, turns out to be too
>> slow to use it for crash dump. lzo and snappy is quick and relatively
>> as good compression ratio as zlib. In particular, snappy speed is
>> stable on any ratio of randomized part. See also
>> bench_compare_zlib_lzo_snappy.tar.xz for image of graph.
>> 
>> BTW, makedumpfile has already supported lzo since v1.4.4 and is going
>> to support snappy on v1.5.1.
>> 
>> OTOH, we have some requirements where we cannot use filtering.
>> Examples are:
>> 
>> - high-availability cluster system where application triggers crash
>>   dump to switch the active node to inactive node quickly. We retrieve
>>   the application image as process core dump later and analize it. We
>>   cannot filter user-space memory.
> 
> Do you have to really crash the node to take it offline? There should
> be other ways to do this? If you are analyzing application performance
> issues, why should you crash kernel and capture the whole crash dump.
> There should be other ways to debug applications?
>  

Certainly, this might be weak to the current situation where memory is
huge. I only wanted to say here that we sometimes need user-space
memory too.

>> 
>> - On qemu/kvm environment, we sometimes face a complicated bug caused
>>   by interaction between guest and host.
>> 
>>   For example, previously, there was a bug causing guest machine to
>>   hang, where IO scheduler handled guest's request as wrongly lower
>>   request than the actual one and guest was waiting for IO completion
>>   endlessly, repeating VMenter-VMexit forever.
>> 
>>   To address such kind of bug, we first reproduce the bug, get host's
>>   crash dump to capture the situation, and then analyze the bug by
>>   investigating the situation from both host's and guest's views. On
>>   the bug above, we saw guest machine was waiting for IO, and we could
>>   resolve the issue relatively quickly. For this kind of complicated
>>   bug relevant to qemu/kvm, both host and guest views are very
>>   helpful.
>> 
>>   guest image is in user-space memory, qemu process, and again we
>>   cannot filter user-space memory.
> 
> Instead of capturing the dump of whole memory, isn't it more efficient
> to capture the crash dump of VM in question and then if need be just
> take filtered crash dump of host kernel. 
> 
> I think that trying to take unfiltered crash dumps of tera bytes of memory
> is not practical or woth it for most of the use cases.
> 

If there's a lag between VM dump and host dump, situation on the host
can change, and VM dump itself changes the situation. Then, we cannot
know what kind of bug resides in now, so we want to do as few things
as possible between detecting the bug reproduced and taking host
dump. So I expressed ``capturing the situation''.

>> 
>> - Filesystem people say page cache is often necessary for analysis of
>>   crash dump.
>> 
> 
> Do you have some examples of how does it help?
> 

Sorry, I heard this only and don't know in more detail now on the
usecase.

<cut>
>> > How well does it work with nr_cpus kernel parameter. Currently we boot
>> > with nr_cpus=1 to save upon amount of memory to be reserved. I guess
>> > you might want to boot with nr_cpus=2 or nr_cpus=4 in your case to
>> > speed up compression?
>> 
>> Exactly, it seems reasonable to specify at most nr_cpus=4 on usual
>> machines becaue reserved memory is severely limited, and many disks
>> are difficult to connect only for crash dump use without special
>> requrement.
>> 
>> But there might be the system where crash dump is definitely done
>> quickly and for it, more reserved memory and more disks are no
>> problem. On such system, I think it's necessary to be able to set up
>> more reserved memory and more cpus.
> 
> We have this limitation of on x86 that we can't reserve more memory. I
> think for x86_64, we could not load kernel above 896MB, due to 
> various limitations. So you will have to cross those barriers too if
> you want to reserve more memory to capture full dumps.
> 
> So I am fine with trying to bring up more cpus in second kernel in an
> effort to improve scalability but I remain skeptical about the
> practicality of dumping TBs of unfiltered data after crash. Filtering

I also think I don't want to take unnecessary parts because it makes
dump slow only. Taking a whole memory would be non-sense. So, I think
another featuer might also be needed here. For example, it might be
useful if we can specify filtering user-space per process.

But even so, I suspect crash dump with user-space necessary for us
only can sometimes reach at most 500GB ~ 1TB. Then, it takes 2 ~ 4
hours to take dump on one cpu and one disk.

> capability was the primary reason that s390 also wants to support
> kdump otherwise there firmware dumping mechanism was working just
> fine.
> 

I don't know s390 firmware dumping mechanism at all, but is it possble
for s390 to filter crash dump even on firmware dumping mechanism?

Thanks.
HATAYAMA, Daisuke

