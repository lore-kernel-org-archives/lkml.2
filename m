Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0HRUDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:03:04 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:51808
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751551Ab0HRUDB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:03:01 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1432N98dN179dN9371P10d1Izz1202hzz8275bhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7D67K-01-T2U-02
X-M-MSG: 
Date: Wed, 18 Aug 2010 21:17:00 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Venkatesh Pallipadi <venki@google.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Wrong /proc/cpuinfo core id on AMD fam_f model_9
Message-ID: <20100818191700.GA6427@loge.amd.com>
References: <1281648529-29678-1-git-send-email-venki@google.com>
 <20100813070435.GE4569@loge.amd.com>
 <AANLkTineUH2Z2CYVEz001S7srZHmF73qZJfQU9WOjVnM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <AANLkTineUH2Z2CYVEz001S7srZHmF73qZJfQU9WOjVnM@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 01:52:37PM -0400, Venkatesh Pallipadi wrote:
> On Fri, Aug 13, 2010 at 12:04 AM, Andreas Herrmann
> <andreas.herrmann3@amd.com> wrote:

  [...]

> The reason for this patch was a breakage in the app that tries to
> build CPU maps for packages and cores (Nothing to do with Intel or
> AMD). The app is using info under /sys/devices/system//node/ and
> /sys/device/system/cpu/cpu0/cache to get the NUMA node and cache
> sharing info etc. And looking at cpuinfo for core package info.

Hmm, and why not using .../cpu/cpuX/topology/core_siblings for the
package info? It just sounds strange to me to use /proc/cpuinfo for
CPU topology information.

> And is getting confused with NUMA overloaded package and core info
> in /proc/cpunfo. I can of course change this specific app to
> workaround this. But, I think changing core id to reflect numa-ness
> without a numa id to go with it is not right.

Using Node ID from SRAT table would not be right.
You could have just one NUMA node 0 (spanning all packages) but the
CPUs are still associated to a node within the physical package.
So, it is the ID of the northbridge device to which this CPU belongs
which should be exported.

> Basically, with this NUMA overloading of core id, we are loosing the
> unique id of cores that was in "core id" before.

Yes, I see. Just couldn't imagine that some apps are relying on that info
if there are much more convenient ways of getting it.
Why parsing /proc/cpuinfo for SMT sibling information if we have a
CPU list and mask for this in /sys.

> Without this /proc/cpuinfo output makes sense with "cpu cores" being
> 12 and 12 unique ids for cores under one physical id. With this
> change, "cpu cores" under a package is still 12. But, trying to id
> those 12 cores, one ends up with 0..5 0..5. We are loosing the MSB
> on these IDs only to give some implicit and incomplete information (
> Number of nodes = "cpu cores" / number of unique core ids, but we
> wont tell you here how to identify those nodes. Look at /sys..node
> for that).

Exporting the node_id for the northbridge devices to which the core
is attached would solve this problem.

> Isn't it better to leave /proc/cpuinfo out of this so that older apps
> continue to work and newer apps can use all the /sys fs topology
> information to get the complete info?

BTW, which app is this?
I've quickly checked some tools and couldn't find heavy usage of
/proc/cpuinfo.

> Taking this a bit further, this different cores sharing same core id
> within a package is going to be messy in general. Consider totally
> hypothetical CPU package with 2 nodes and 2 SMT siblings in each node.
> If we follow this current scheme of things of - stuffing node info
> without node id - in proc/cpuinfo, it will look something like
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

Yep, in theory this could reflect physcial packages having
- 1 core having 4 SMT siblings
- 2 nodes with 2 cores each and 2 SMT siblings
- 4 nodes, 1 core

/proc/cpuinfo is insufficient to reflect full topology information.
Changing core_id you would still get similar entries for physical
packages

- having 2 internal nodes, 1 core each with 2 SMT siblings
- having 2 cores with 2 SMT siblings each

> Which would be very much useless. We should either have "node id" info
> or not change the "core id" meaning to include node info.

Then I'd vote to provide the CPU northbridge node id information.

> >> The change below reverts the cpu_core_id part of that commit and
> >
> > Please don't do that. Potentially you are breaking user space. You
> > rather need to know the core id (0..5) within a node instead of the
> > CoreId (0..11) within the entire package. See AMD's BKDG for family
> > 0x10 CPUs. As a rule of thumb you require the ID of a core within one
> > Node -- not within a package.
> 
> The problem is the core_id change is breaking the userspace decoding
> of package/core/thread info from /proc/cpuinfo.

> Yes. I may need to know core id's in a node. But, /proc/cpuinfo is
> not giving be that info of "ID of core withing one Node". There is
> no Node info there.  Its still giving me Core ID withing a physical
> package with no way of knowing which cores are within a node.

  [...]

> So, if you think cpuinfo is useless for NUMA topology, then why do you
> think core id should be change to reflect NUMA info?

Ehm, sorry I did not decide to not provide the information in
/proc/cpuinfo. IIRC exporting node id in /proc/cpuinfo was part
of the initial topology adaption patch sets that were rejected.

In-kernel we still have the entire info -- but it is just partially
exported (or in too many different places in sysfs) to user space.

  [...]

> Just to summarize, I am of the opinion that if we can't describe
> something in /proc/cpuinfo fully, we should not stuff partial info and
> break existing assumptions

Well, some assumptions might prove false over time.

> and add new assumptions. We have new APIS is /sys anyway to describe
> full topology.

I still recommend to use sysfs info for topology detection.
But I also agree that there is some inconsistency in /proc/cpuinfo

It's the maintainers' call to decide how to fix this inconsistency.
I am fine with both solutions.
But if core_id is not "normalized" anymore I need to do some more review
and testing to ensure that nothing breaks.



Regards,

Andreas


-- 
Operating | Advanced Micro Devices GmbH
  System  | Einsteinring 24, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Alberto Bozzo, Andrew Bowd
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


