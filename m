Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0EXCOR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 22:14:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:2191 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab0EXCOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 22:14:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,288,1272870000"; 
   d="scan'208";a="801186996"
Date: Mon, 24 May 2010 09:47:34 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: Ankita Garg <ankita@in.ibm.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, ak@linux.intel.com,
       fengguang.wu@intel.com, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com, Balbir Singh <balbir@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [RFC, 0/7] NUMA Hotplug emulator
Message-ID: <20100524014734.GC25893@shaohui>
Mail-Followup-To: Ankita Garg <ankita@in.ibm.com>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ak@linux.intel.com,
	fengguang.wu@intel.com, haicheng.li@linux.intel.com,
	shaohui.zheng@linux.intel.com, Balbir Singh <balbir@in.ibm.com>,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
References: <20100513113629.GA2169@shaohui>
 <20100521093340.GA7024@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521093340.GA7024@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 03:03:40PM +0530, Ankita Garg wrote:
> 
> I tried the patchset on a non-NUMA machine. So, inorder to create fake
> NUMA nodes and be able to emulate the hotplug behavior, I used the
> following commandline:
> 
> 	"numa=fake=4  numa=hide=2*2048"
> 
> on a machine with 8G memory. I expected to see 4 nodes, out of which 2
> would be hidden. However, the system comes up the 4 online nodes and 2
> offline nodes (thus a total of 6 nodes). While we could decide this to
> be the semantics, however, I feel that numa=fake should define the total
> number of nodes. So in the above case, the system should have come up
> with 2 online nodes and 2 offline nodes.
Ankita,
	it is the expected result, NUMA_EMU and NUMA_HOTPLUG_EMU are 2 different
features, there is no dependency between the 2 features. Even if you disable
NUMA_EMU, the hotplug emualation still working, this implementatin reduces the 
dependency, it make things simple and easy to understand.
	You concern makes sense in semantices, but we do not pefer to combine 2 
independent modules together.
> 
> Also, "numa=hide=N" could also be supported, with the size
> of the hidden nodes being equal to the entire size of the node, with or
> without numa=fake parameter.
> 
> On onlining one of the offline nodes, I see another issue that the
> memory under it is not automatically brought online. For example:
> 
> #ls /sys/devices/system/node
> .... node0 node1 node2..
> 
> #cat /sys/devices/system/node/probe
> 3
> 
> #echo 3 > /sys/devices/system/node/probe
> #ls /sys/devices/system/node
> .... node0 node1 node2 node3
> 
> #cat /sys/devices/system/node/node3/meminfo
> Node 3 MemTotal:              0 kB
> Node 3 MemFree:               0 kB
> Node 3 MemUsed:               0 kB
> Node 3 Active:                0 kB
> ......
> 
> i.e, as memory-less nodes. However, these nodes were designated to have
> memory. So, on onlining the nodes, maybe we could have all their memory
> brought into online state as well ?
it is the same result with the real implemetation for memory hotplug in linux
 kernel, when we hot-add physical memory into machine, the linux kernel create
  the memory entires and create the related data structure, but the OS will never
online the memory, it should finish in user space. 

the node hotplug emulation and memory hotplug emualtioni feature follows up the 
same rules with the kernel.

As we know, when we allocate memory from a memory-less node, it will cause a
OOM issue, Some engineer is already focus on this bug. Because of the OOM issue
can be reproduced with the hotplug emulator, it helps the engineer so much.

This feature is flexible. As I know, Some OSV already online the hotplug memory
automatically, if the mainline kernel decide do the same thing, we will change 
the related code, too.

> 
> -- 
> Regards,                                                                        
> Ankita Garg (ankita@in.ibm.com)                                                 
> Linux Technology Center                                                         
> IBM India Systems & Technology Labs,                                            
> Bangalore, India

-- 
Thanks & Regards,
Shaohui

