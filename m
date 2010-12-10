Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab0LJIBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 03:01:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:23915 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab0LJIBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 03:01:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,323,1288594800"; 
   d="scan'208";a="359770583"
From: "Zheng, Shaohui" <shaohui.zheng@intel.com>
To: Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        Andi Kleen <ak@linux.intel.com>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Brown, Len" <len.brown@intel.com>, Yinghai Lu <Yinghai.Lu@sun.com>,
        "Li, Haicheng" <haicheng.li@intel.com>,
        Shaohui Zheng <shaohui.zheng@linux.intel.com>
Date: Fri, 10 Dec 2010 16:01:39 +0800
Subject: RE: [5/7,v8] NUMA Hotplug Emulator: Support cpu probe/release in
 x86_64
Thread-Topic: [5/7,v8] NUMA Hotplug Emulator: Support cpu probe/release in
 x86_64
Thread-Index: AcuXhLRbzNOdU3OqTYivk+EJhLYXaQAuJZ6Q
Message-ID: <A24AE1FFE7AEC5489F83450EE98351BF2A40FED8E3@shsmsx502.ccr.corp.intel.com>
References: <20101207010033.280301752@intel.com>
 <20101207010140.092555703@intel.com>
 <alpine.DEB.2.00.1012081334160.15658@chino.kir.corp.google.com>
 <4D00A345.6070100@kernel.org>
In-Reply-To: <4D00A345.6070100@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unification numa code of 32 and 64 bit make the codes much simpler to maintain. It is good direction.

I already rework this patch based on your unification numa code, add I add you in the CC list in my patch.

Thanks & Regards,
Shaohui


-----Original Message-----
From: Tejun Heo [mailto:tj@kernel.org] 
Sent: Thursday, December 09, 2010 5:37 PM
To: David Rientjes
Cc: Zheng, Shaohui; Andrew Morton; linux-mm@kvack.org; linux-kernel@vger.kernel.org; haicheng.li@linux.intel.com; lethal@linux-sh.org; Andi Kleen; dave@linux.vnet.ibm.com; Greg Kroah-Hartman; Ingo Molnar; Brown, Len; Yinghai Lu; Li, Haicheng
Subject: Re: [5/7,v8] NUMA Hotplug Emulator: Support cpu probe/release in x86_64

Hello,

On 12/08/2010 10:36 PM, David Rientjes wrote:
> On Tue, 7 Dec 2010, shaohui.zheng@intel.com wrote:
> 
>> From: Shaohui Zheng <shaohui.zheng@intel.com>
>>
>> CPU physical hot-add/hot-remove are supported on some hardwares, and it 
>> was already supported in current linux kernel. NUMA Hotplug Emulator provides
>> a mechanism to emulate the process with software method. It can be used for
>> testing or debuging purpose.
>>
>> CPU physical hotplug is different with logical CPU online/offline. Logical
>> online/offline is controled by interface /sys/device/cpu/cpuX/online. CPU
>> hotplug emulator uses probe/release interface. It becomes possible to do cpu
>> hotplug automation and stress
>>
>> Add cpu interface probe/release under sysfs for x86_64. User can use this
>> interface to emulate the cpu hot-add and hot-remove process.
>>
>> Directive:
>> *) Reserve CPU thru grub parameter like:
>> 	maxcpus=4
>>
>> the rest CPUs will not be initiliazed. 
>>
>> *) Probe CPU
>> we can use the probe interface to hot-add new CPUs:
>> 	echo nid > /sys/devices/system/cpu/probe
>>
>> *) Release a CPU
>> 	echo cpu > /sys/devices/system/cpu/release
>>
>> A reserved CPU will be hot-added to the specified node.
>> 1) nid == 0, the CPU will be added to the real node which the CPU
>> should be in
>> 2) nid != 0, add the CPU to node nid even through it is a fake node.
>>
> 
> This patch is undoubtedly going to conflict with Tejun's unification of 
> the 32 and 64 bit NUMA boot paths, specifically the patch at 
> http://marc.info/?l=linux-kernel&m=129087151912379.

Oh yeah, it definitely looks like it will collide with the unification
patch.  The problem is more fundamental than the actual patch
collisions tho.  During x86_32/64 merge, some parts were left unmerged
- some reflect actual differences between 32 and 64 but more were
probably because it was too much work.

These subtle diversions make the code unnecessarily complicated,
fragile and difficult to maintain, so, in general, I think we should
be heading toward unifying 32 and 64 unless the difference is caused
by actual hardware even when the feature or code might not be too
useful for 32bit.

So, the same thing holds for NUMA hotplug emulator.  32bit supports
NUMA and there already is 64bit only NUMA emulator.  I think it would
be much better if we take this chance to unify 32 and 64bit code paths
on this area rather than going further toward the wrong direction.

> Tejun, what's the status of that patchset posted on November 27?  Any 
> comments about this change?

I don't know.  I pinged Ingo yesterday.  Ingo?

Thanks.

-- 
tejun
