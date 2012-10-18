Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab2JROPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:15:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810Ab2JROPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:15:21 -0400
Date: Thu, 18 Oct 2012 10:14:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, x86@kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, len.brown@intel.com,
        fenghua.yu@intel.com, ebiederm@xmission.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Subject: Re: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
Message-ID: <20121018141449.GB18147@redhat.com>
References: <20121016043357.20003.5885.stgit@localhost6.localdomain6>
 <20121017141234.GD31663@redhat.com>
 <20121018.120805.464238435.d.hatayama@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018.120805.464238435.d.hatayama@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 12:08:05PM +0900, HATAYAMA Daisuke wrote:

[..]
> > Do you have any rough numbers on what kind of speed up we are looking
> > at. IOW, what % of time is gone compressing a filetered dump. On large
> > memory machines, saving huge dump files is anyway not an option due to
> > time it takes. So we need to filter it to bare minimum and after that
> > vmcore size should be reasonable and compression time might not be a
> > big factor. Hence I am curious what kind of gains we are looking at.
> > 
> 
> I did two kinds of benchmark 1) to evaluate how well compression and
> writing dump into multiple disks performs on crash dump and 2) to
> compare three kinds of compression algorhythm --- zlib, lzo and snappy
> --- for use of crash dump.
> 
> >From 1), 4 disks with 4 cpus performs 300 MB/s on compression with
> snappy. 1 hour for 1 TB. But on this benchmark, sample data is
> intentionally randomized enough so data size is not reduced during
> compression, it must be quicker on most of actual dumps. See also
> bench_comp_multi_IO.tar.xz for image of graph.

Ok, I looked at the graphs. So somehow you seem to be dumping to multiple
disks. How do you do that? Are these disks in some stripe configuration
or they are JBOD and you have written special programs to dump a
particular section of memory to a specific disk to achieve parallelism?

Looking at your graphs, 1 cpu can keep up with 4 disks and achieve
300MB/s and after that it looks like cpu saturates. Adding more disks
with 1 cpu does not help. But increasing number of cpus can keep up
with increasing number of disks and you achieve 800MB/s. Sounds good.

> 
> In the future, I'm going to do this benchmark again using quicker SSD
> disks if I get them.
> 
> >From 2), zlib, used when doing makedumpfile -c, turns out to be too
> slow to use it for crash dump. lzo and snappy is quick and relatively
> as good compression ratio as zlib. In particular, snappy speed is
> stable on any ratio of randomized part. See also
> bench_compare_zlib_lzo_snappy.tar.xz for image of graph.
> 
> BTW, makedumpfile has already supported lzo since v1.4.4 and is going
> to support snappy on v1.5.1.
> 
> OTOH, we have some requirements where we cannot use filtering.
> Examples are:
> 
> - high-availability cluster system where application triggers crash
>   dump to switch the active node to inactive node quickly. We retrieve
>   the application image as process core dump later and analize it. We
>   cannot filter user-space memory.

Do you have to really crash the node to take it offline? There should
be other ways to do this? If you are analyzing application performance
issues, why should you crash kernel and capture the whole crash dump.
There should be other ways to debug applications?
 
> 
> - On qemu/kvm environment, we sometimes face a complicated bug caused
>   by interaction between guest and host.
> 
>   For example, previously, there was a bug causing guest machine to
>   hang, where IO scheduler handled guest's request as wrongly lower
>   request than the actual one and guest was waiting for IO completion
>   endlessly, repeating VMenter-VMexit forever.
> 
>   To address such kind of bug, we first reproduce the bug, get host's
>   crash dump to capture the situation, and then analyze the bug by
>   investigating the situation from both host's and guest's views. On
>   the bug above, we saw guest machine was waiting for IO, and we could
>   resolve the issue relatively quickly. For this kind of complicated
>   bug relevant to qemu/kvm, both host and guest views are very
>   helpful.
> 
>   guest image is in user-space memory, qemu process, and again we
>   cannot filter user-space memory.

Instead of capturing the dump of whole memory, isn't it more efficient
to capture the crash dump of VM in question and then if need be just
take filtered crash dump of host kernel. 

I think that trying to take unfiltered crash dumps of tera bytes of memory
is not practical or woth it for most of the use cases.

> 
> - Filesystem people say page cache is often necessary for analysis of
>   crash dump.
> 

Do you have some examples of how does it help?

> Of course, we use filtering positively on the system where no such
> requreirement is given.
> 
> >> 
> >> To wake up AP, we use the method called INIT-INIT-SIPI. INIT causes
> >> BSP to jump into BIOS init code. A typical visible behaviour is hang
> >> or immediate reset, depending on the BIOS init code.
> >> 
> >> AP can be initiated by INIT even in a fatal state: MP spec explains
> >> that processor-specific INIT can be used to recover AP from a fatal
> >> system error. On the other hand, there's no method for BSP to recover;
> >> it might be possible to do so by NMI plus any hand-coded reset code
> >> that is carefully designed, but at least I have no idea in this
> >> direction now.
> >> 
> >> Therefore, the idea I do in this patch set is simply to disable BSP if
> >> vboot cpu is AP.
> > 
> > So in regular boot BSP still works as we boot on BSP. So this will take
> > effect only in kdump kernel?
> > 
> 
> Yes, this patch is effective only for the case where boot cpu is not
> BSP, AP, and this happens in kexec case only.
> 
> > How well does it work with nr_cpus kernel parameter. Currently we boot
> > with nr_cpus=1 to save upon amount of memory to be reserved. I guess
> > you might want to boot with nr_cpus=2 or nr_cpus=4 in your case to
> > speed up compression?
> 
> Exactly, it seems reasonable to specify at most nr_cpus=4 on usual
> machines becaue reserved memory is severely limited, and many disks
> are difficult to connect only for crash dump use without special
> requrement.
> 
> But there might be the system where crash dump is definitely done
> quickly and for it, more reserved memory and more disks are no
> problem. On such system, I think it's necessary to be able to set up
> more reserved memory and more cpus.

We have this limitation of on x86 that we can't reserve more memory. I
think for x86_64, we could not load kernel above 896MB, due to 
various limitations. So you will have to cross those barriers too if
you want to reserve more memory to capture full dumps.

So I am fine with trying to bring up more cpus in second kernel in an
effort to improve scalability but I remain skeptical about the
practicality of dumping TBs of unfiltered data after crash. Filtering
capability was the primary reason that s390 also wants to support
kdump otherwise there firmware dumping mechanism was working just
fine.

Thanks
Vivek
