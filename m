Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab0LFBXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 20:23:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:39231 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab0LFBXC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 20:23:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,303,1288594800"; 
   d="scan'208";a="580818771"
From: "Zheng, Shaohui" <shaohui.zheng@intel.com>
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Greg KH <gregkh@suse.de>, "Li, Haicheng" <haicheng.li@intel.com>,
        "shaohui.zheng@linux.intel.com" <shaohui.zheng@linux.intel.com>
Date: Mon, 6 Dec 2010 09:22:54 +0800
Subject: RE: [8/8, v6] NUMA Hotplug Emulator: implement debugfs interface
 for memory probe
Thread-Topic: [8/8, v6] NUMA Hotplug Emulator: implement debugfs interface
 for memory probe
Thread-Index: AcuSeXLMeHAqi1WZQjqaSOhs+PmyNQCafYPw
Message-ID: <A24AE1FFE7AEC5489F83450EE98351BF28B3BB8C31@shsmsx502.ccr.corp.intel.com>
References: <A24AE1FFE7AEC5489F83450EE98351BF288D88D224@shsmsx502.ccr.corp.intel.com>
 <20101202002716.GA13693@shaohui>
 <alpine.DEB.2.00.1012011807190.13942@chino.kir.corp.google.com>
 <A24AE1FFE7AEC5489F83450EE98351BF288D88D2B8@shsmsx502.ccr.corp.intel.com>
 <alpine.DEB.2.00.1012021528170.6878@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1012021528170.6878@chino.kir.corp.google.com>
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

After introduce the per-node interface, the following directive can be avoided.

	echo '0x80000000,3' > /sys/kernel/debug/mem_hotplug/add_memory
	echo 'physical_addr=0x80000000 node_id=3' > /sys/kernel/debug/mem_hotplug/add_memory

I already implemented a draft in another thread, and waiting for comments, thanks for the proposal.

Thanks & Regards,
Shaohui


-----Original Message-----
From: David Rientjes [mailto:rientjes@google.com] 
Sent: Friday, December 03, 2010 7:34 AM
To: Zheng, Shaohui
Cc: Andrew Morton; linux-mm@kvack.org; linux-kernel@vger.kernel.org; lethal@linux-sh.org; Andi Kleen; Dave Hansen; Greg KH; Li, Haicheng
Subject: RE: [8/8, v6] NUMA Hotplug Emulator: implement debugfs interface for memory probe

On Thu, 2 Dec 2010, Zheng, Shaohui wrote:

> Why should we add so many interfaces for memory hotplug emulation?

Because they are functionally different from real memory hotplug and we 
want to support different configurations such as mapping memory to a 
different node id or onlining physical nodes that don't exist.

They are in debugfs because the emulation, unlike real memory hotplug, is 
used only for testing and debugging.

> If so, we should create both sysfs and debugfs 
> entries for an online node, we are trying to add redundant code logic.
> 

We do not need sysfs triggers for onlining a node, that already happens 
automatically if the memory that is being onlined has a hotpluggable node 
entry in the SRAT that has an offline node id.

> We need not make a simple thing such complicated, Simple is beautiful, I'd prefer to rename the mem_hotplug/probe 
> interface as mem_hotplug/add_memory.
> 
> 	/sys/kernel/debug/mem_hotplug/add_node (already exists)
> 	/sys/kernel/debug/mem_hotplug/add_memory (rename probe as add_memory)
> 

No, add_memory would then require these bizarre lines that you've been 
parsing like

	echo 'physical_addr=0x80000000 node_id=3' > /sys/kernel/debug/mem_hotplug/add_memory

which is unnecessary if you introduce my proposal for per-node debugfs 
directories similar to that under /sys/devices/system/node that is 
extendable later if we add additional per-node triggers under 
CONFIG_DEBUG_FS.

Adding /sys/kernel/debug/mem_hotplug/node2/add_memory that you write a 
physical address to is a much more robust, simple, and extendable 
interface.
