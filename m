Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab0EUJg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:36:56 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:39190 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab0EUJgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:36:53 -0400
Date: Fri, 21 May 2010 15:03:40 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, ak@linux.intel.co, fengguang.wu@intel.com,
       haicheng.li@linux.intel.com, shaohui.zheng@linux.intel.com
Cc: Balbir Singh <balbir@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [RFC, 0/7] NUMA Hotplug emulator
Message-ID: <20100521093340.GA7024@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <20100513113629.GA2169@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513113629.GA2169@shaohui>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 13, 2010 at 07:36:30PM +0800, Shaohui Zheng wrote:
> Hi, All
> 	This patchset introduces NUMA hotplug emulator for x86. it refers too
> many files and might introduce new bugs, so we send a RFC to comminity first
> and expect comments and suggestions, thanks.
> 

<snip>

> * Principles & Usages 
> 
> NUMA hotplug emulator include 3 different parts, We add a menu item to the
> menuconfig to enable/disable them
> (Refer to http://shaohui.org/images/hpe-krnl-cfg.jpg)
> 
> 
> 1) Node hotplug emulation:
> 
> The emulator firstly hides RAM via E820 table, and then it can
> fake offlined nodes with the hidden RAM.
> 
> After system bootup, user is able to hotplug-add these offlined
> nodes, which is just similar to a real hotplug hardware behavior.
> 
> Using boot option "numa=hide=N*size" to fake offlined nodes:
> 	- N is the number of hidden nodes
> 	- size is the memory size (in MB) per hidden node.
> 
> There is a sysfs entry "probe" under /sys/devices/system/node/ for user
> to hotplug the fake offlined nodes:
> 
>  - to show all fake offlined nodes:
>     $ cat /sys/devices/system/node/probe
> 
>  - to hotadd a fake offlined node, e.g. nodeid is N:
>     $ echo N > /sys/devices/system/node/probe
> 

I tried the patchset on a non-NUMA machine. So, inorder to create fake
NUMA nodes and be able to emulate the hotplug behavior, I used the
following commandline:

	"numa=fake=4  numa=hide=2*2048"

on a machine with 8G memory. I expected to see 4 nodes, out of which 2
would be hidden. However, the system comes up the 4 online nodes and 2
offline nodes (thus a total of 6 nodes). While we could decide this to
be the semantics, however, I feel that numa=fake should define the total
number of nodes. So in the above case, the system should have come up
with 2 online nodes and 2 offline nodes.

Also, "numa=hide=N" could also be supported, with the size
of the hidden nodes being equal to the entire size of the node, with or
without numa=fake parameter.

On onlining one of the offline nodes, I see another issue that the
memory under it is not automatically brought online. For example:

#ls /sys/devices/system/node
.... node0 node1 node2..

#cat /sys/devices/system/node/probe
3

#echo 3 > /sys/devices/system/node/probe
#ls /sys/devices/system/node
.... node0 node1 node2 node3

#cat /sys/devices/system/node/node3/meminfo
Node 3 MemTotal:              0 kB
Node 3 MemFree:               0 kB
Node 3 MemUsed:               0 kB
Node 3 Active:                0 kB
......

i.e, as memory-less nodes. However, these nodes were designated to have
memory. So, on onlining the nodes, maybe we could have all their memory
brought into online state as well ?

-- 
Regards,                                                                        
Ankita Garg (ankita@in.ibm.com)                                                 
Linux Technology Center                                                         
IBM India Systems & Technology Labs,                                            
Bangalore, India
