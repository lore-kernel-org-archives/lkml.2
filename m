Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab0LMDdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 22:33:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:36991 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685Ab0LMDdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 22:33:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,334,1288594800"; 
   d="scan'208";a="583080646"
Date: Mon, 13 Dec 2010 10:09:25 +0800
From: Shaohui Zheng <shaohui.zheng@linux.intel.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, Andi Kleen <ak@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [7/7,v8] NUMA Hotplug Emulator: Implement per-node add_memory
 debugfs interface
Message-ID: <20101213020924.GB19637@shaohui>
References: <A24AE1FFE7AEC5489F83450EE98351BF2A40FED20A@shsmsx502.ccr.corp.intel.com>
 <20101209012124.GD5798@shaohui>
 <alpine.DEB.2.00.1012091325530.13564@chino.kir.corp.google.com>
 <20101209235705.GA10674@shaohui>
 <alpine.DEB.2.00.1012101529190.30039@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012101529190.30039@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 03:30:38PM -0800, David Rientjes wrote:
> On Fri, 10 Dec 2010, Shaohui Zheng wrote:
> 
> > > That doesn't address the question.  My question is whether or not adding 
> > > memory to a memoryless node in this way transitions its state to 
> > > N_HIGH_MEMORY in the VM?
> > I guess that you are talking about memory hotplug on x86_32, memory hotplug is
> > NOT supported well for x86_32, and the function add_memory does not consider
> > this situlation.
> > 
> > For 64bit, N_HIGH_MEMORY == N_NORMAL_MEMORY, so we need not to do the transition.
> > 
> 
> One more time :)  Memoryless nodes do not have their bit set in 
> N_HIGH_MEMORY.  When memory is added to a memoryless node with this new 
> interface, does the bit get set?

When we use debugfs add_node interface to add a fake node, the node was created, 
and memory sections were created, but the state of the memory section is still 
__offline__, so the new added node is still memoryless node. the result of debugfs
add_memory interface doing the similar thing with add_node, it just add memory
to an exists node.

For the state transition to N_HIGH_MEMORY, it does not happen on the above too
interfaces. It happens when the memory was onlined with sysfs /sys/device/system/memory/memoryXX/online
interface.

That is the code path:
store_mem_state
	->memory_block_change_state
	 	->memory_block_action
			->online_pages

			if (onlined_pages) {
				kswapd_run(zone_to_nid(zone));
				node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
			}

does it address your question? thanks.

-- 
Thanks & Regards,
Shaohui

