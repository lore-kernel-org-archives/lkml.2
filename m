Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab0LIJiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:38:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:34830 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830Ab0LIJiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:38:09 -0500
Message-ID: <4D00A345.6070100@kernel.org>
Date: Thu, 09 Dec 2010 10:37:09 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Shaohui Zheng <shaohui.zheng@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, Andi Kleen <ak@linux.intel.com>,
        dave@linux.vnet.ibm.com, Greg Kroah-Hartman <gregkh@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Len Brown <len.brown@intel.com>,
        Yinghai Lu <Yinghai.Lu@sun.com>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [5/7,v8] NUMA Hotplug Emulator: Support cpu probe/release in
 x86_64
References: <20101207010033.280301752@intel.com> <20101207010140.092555703@intel.com> <alpine.DEB.2.00.1012081334160.15658@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1012081334160.15658@chino.kir.corp.google.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 09:37:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
