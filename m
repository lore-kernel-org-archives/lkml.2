Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab0KSBxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 20:53:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:56603 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab0KSBxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 20:53:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,220,1288594800"; 
   d="scan'208";a="628259872"
Date: Fri, 19 Nov 2010 08:32:25 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [2/8,v3] NUMA Hotplug Emulator: infrastructure of NUMA hotplug
 emulation
Message-ID: <20101119003225.GB3327@shaohui>
References: <20101117020759.016741414@intel.com>
 <20101117021000.568681101@intel.com>
 <alpine.DEB.2.00.1011162359160.17408@chino.kir.corp.google.com>
 <20101117075128.GA30254@shaohui>
 <alpine.DEB.2.00.1011171304060.10254@chino.kir.corp.google.com>
 <20101118041407.GA2408@shaohui>
 <20101118062715.GD17539@linux-sh.org>
 <20101118052750.GD2408@shaohui>
 <alpine.DEB.2.00.1011181321470.26680@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011181321470.26680@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 01:24:52PM -0800, David Rientjes wrote:
> On Thu, 18 Nov 2010, Shaohui Zheng wrote:
> 
> > in our draft patch, we re-setup nr_node_ids when CONFIG_ARCH_MEMORY_PROBE enabled 
> > and mem=XXX was specified in grub. we set nr_node_ids as MAX_NUMNODES + 1, because
> >  we do not know how many nodes will be hot-added through memory/probe interface. 
> >  it might be a little wasting of memory.
> > 
> 
> nr_node_ids need not be set to anything different at boot, the 
> MEM_GOING_ONLINE callback should be used for anything (like the slab 
> allocators) where a new node is introduced and needs to be dealt with 
> accordingly; this is how regular memory hotplug works, we need no 
> additional code in this regard because it's emulated.  If a subsystem 
> needs to change in response to a new node going online and doesn't as a 
> result of using your emulator, that's a bug and either needs to be fixed 
> or prohibited from use with CONFIG_MEMORY_HOTPLUG.
> 
> (See the MEM_GOING_ONLINE callback in mm/slub.c, for instance, which deals 
> only with the case of node hotplug.)

nr_node_ids is the possible node number. when we do regular memory online,
it is oline to a possible node, and it is already counted in to nr_node_ids.

if you increment nr_node_ids dynamically when node online, it causes a lot of
problems. Many data are initialized according to nr_node_ids. That is our
experience when we debug the emulator.

mm/page_alloc.c:
/*
 * Figure out the number of possible node ids.
 */
static void __init setup_nr_node_ids(void)
{
	unsigned int node;
	unsigned int highest = 0;

	for_each_node_mask(node, node_possible_map)
		highest = node;
	nr_node_ids = highest + 1;
}

There is no conflict between emulator and CONFIG_MEMORY_HOTPLUG. A real node can be
 onlined because we already set it as _possible_; if emulator is enabled, all the 
nodes were marked as _possbile_ node, the real ndoe is also included in.

-- 
Thanks & Regards,
Shaohui

