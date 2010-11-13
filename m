Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab0KMTNx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 14:13:53 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47523 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab0KMTNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 14:13:50 -0500
Message-ID: <4CDEE314.6090107@kernel.org>
Date: Sat, 13 Nov 2010 11:12:20 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Nikanth Karthikesan <knikanth@suse.de>,
        David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [BUG 2.6.27-rc1] find_busiest_group() LOCKUP
References: <20101111100628.GA24728@localhost> <1289478978.2084.74.camel@laptop> <20101111124015.GA9706@localhost> <1289480656.2084.80.camel@laptop> <20101113084018.GA23098@localhost> <1289644224.2084.521.camel@laptop> <20101113120030.GA31517@localhost> <1289653078.2084.675.camel@laptop> <20101113131042.GA5522@localhost>
In-Reply-To: <20101113131042.GA5522@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2010 05:10 AM, Wu Fengguang wrote:
> On Sat, Nov 13, 2010 at 08:57:58PM +0800, Peter Zijlstra wrote:
>> On Sat, 2010-11-13 at 20:00 +0800, Wu Fengguang wrote:
>>> On Sat, Nov 13, 2010 at 06:30:24PM +0800, Peter Zijlstra wrote:
>>>> On Sat, 2010-11-13 at 16:40 +0800, Wu Fengguang wrote:
>>>>>> Will try and figure out how the heck that's happening, Ingo any clue?
>>>>>
>>>>> It's back to normal on 2.6.37-rc1 when reverting commit 50f2d7f682f9
>>>>> ("x86, numa: Assign CPUs to nodes in round-robin manner on fake NUMA").
>>>>>
>>>>> The interesting part is, the commit was introduced in 
>>>>> 2.6.36-rc7..2.6.36, however 2.6.36 boots OK, while 2.6.37-rc1 panics.
>>>>
>>>> Argh, that commit again..
>>>>
>>>> Does this fix it: http://lkml.org/lkml/2010/11/12/8
>>>
>>> No it still panics. Here is the dmesg.
>>
>> OK, I'll let Nikanth have a look, if all else fails we can always
>> revert that patch.
> 
> It's the same bug.
> 
> Just tried another machine, I get the same divide error.  The patch
> posted in lkml/2010/11/12/8 does not fix it. But after reverting
> commit 50f2d7f682f9, it boots OK.
> 
> Thanks,
> Fengguang
> ---
> PS. dmesg with divide error
> 
> [    0.000000] console [ttyS0] enabled, bootconsole disabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 6367 kB
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000] allocated 167772160 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] ODEBUG: 15 of 15 active objects replaced
> [    0.000000] hpet clockevent registered
> [    0.001000] Fast TSC calibration using PIT
> [    0.002000] Detected 2800.469 MHz processor.
> [    0.000010] Calibrating delay loop (skipped), value calculated using timer frequency.. 5600.93 BogoMIPS (lpj=2800469)
> [    0.010818] pid_max: default: 32768 minimum: 301
> [    0.021745] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
> [    0.035657] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
> [    0.044553] Mount-cache hash table entries: 256
> [    0.049469] Initializing cgroup subsys debug
> [    0.053834] Initializing cgroup subsys ns
> [    0.057940] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
> [    0.066968] Initializing cgroup subsys cpuacct
> [    0.071511] Initializing cgroup subsys memory
> [    0.075988] Initializing cgroup subsys devices
> [    0.080527] Initializing cgroup subsys freezer
> [    0.085107] CPU: Physical Processor ID: 0
> [    0.089209] CPU: Processor Core ID: 0
> [    0.092974] mce: CPU supports 9 MCE banks
> [    0.097095] CPU0: Thermal monitoring enabled (TM1)
> [    0.101990] using mwait in idle threads.
> [    0.106006] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
> [    0.113535] ... version:                3
> [    0.117641] ... bit width:              48
> [    0.121828] ... generic registers:      4
> [    0.125926] ... value mask:             0000ffffffffffff
> [    0.131328] ... max period:             000000007fffffff
> [    0.136734] ... fixed-purpose events:   3
> [    0.140839] ... event mask:             000000070000000f
> [    0.147297] ACPI: Core revision 20101013
> [    0.175646] ftrace: allocating 24175 entries in 95 pages
> [    0.190912] Setting APIC routing to flat
> [    0.195562] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.211643] CPU0: Intel(R) Xeon(R) CPU           X5660  @ 2.80GHz stepping 01
> [    0.325243] lockdep: fixing up alternatives.
> [    0.330242] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
> [    0.430140]  #2lockdep: fixing up alternatives.
> [    0.526962]  #3lockdep: fixing up alternatives.
> [    0.623755]  #4lockdep: fixing up alternatives.
> [    0.720588]  Ok.
> [    0.722525] Booting Node   1, Processors  #5lockdep: fixing up alternatives.
> [    0.822389]  Ok.
> [    0.824327] Booting Node   0, Processors  #6
> [    0.919089] TSC synchronization [CPU#0 -> CPU#6]:
> [    0.924155] Measured 296 cycles TSC warp between CPUs, turning off TSC clock.
> [    0.003999] Marking TSC unstable due to check_tsc_sync_source failed
> [    0.557048] lockdep: fixing up alternatives.
> [    0.558041]  Ok.
> [    0.559004] Booting Node   1, Processors  #7 Ok.
> [    0.632157] Brought up 8 CPUs
> [    0.633006] Total of 8 processors activated (44799.46 BogoMIPS).

assume that when you have 
CONFIG_NR_CPUS=16
instead of
CONFIG_NR_CPUS=8

it will boot ok?

Thanks

	Yinghai
