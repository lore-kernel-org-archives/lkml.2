Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab0KUReF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 12:34:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:43987 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab0KUReD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 12:34:03 -0500
Date: Sun, 21 Nov 2010 09:34:38 -0800
From: Greg KH <gregkh@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        Paul Mundt <lethal@linux-sh.org>, Andi Kleen <ak@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org
Subject: Re: [patch 2/2] mm: add node hotplug emulation
Message-ID: <20101121173438.GA3922@suse.de>
References: <20101117075128.GA30254@shaohui> <alpine.DEB.2.00.1011171304060.10254@chino.kir.corp.google.com> <20101118041407.GA2408@shaohui> <20101118062715.GD17539@linux-sh.org> <20101118052750.GD2408@shaohui> <alpine.DEB.2.00.1011181321470.26680@chino.kir.corp.google.com> <20101119003225.GB3327@shaohui> <alpine.DEB.2.00.1011201645230.10618@chino.kir.corp.google.com> <alpine.DEB.2.00.1011201826140.12889@chino.kir.corp.google.com> <alpine.DEB.2.00.1011201827540.12889@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011201827540.12889@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 06:28:38PM -0800, David Rientjes wrote:
> 
> Add an interface to allow new nodes to be added when performing memory
> hot-add.  This provides a convenient interface to test memory hotplug
> notifier callbacks and surrounding hotplug code when new nodes are
> onlined without actually having a machine with such hotpluggable SRAT
> entries.
> 
> This adds a new interface at /sys/devices/system/memory/add_node that
> behaves in a similar way to the memory hot-add "probe" interface.  Its
> format is size@start, where "size" is the size of the new node to be
> added and "start" is the physical address of the new memory.

Ick, we are trying to clean up the system devices right now which would
prevent this type of tree being added.

> The new node id is a currently offline, but possible, node.  The bit must
> be set in node_possible_map so that nr_node_ids is sized appropriately.
> 
> For emulation on x86, for example, it would be possible to set aside
> memory for hotplugged nodes (say, anything above 2G) and to add an
> additional three nodes as being possible on boot with
> 
> 	mem=2G numa=possible=3
> 
> and then creating a new 128M node at runtime:
> 
> 	# echo 128M@0x80000000 > /sys/devices/system/memory/add_node
> 	On node 1 totalpages: 0
> 	init_memory_mapping: 0000000080000000-0000000088000000
> 	 0080000000 - 0088000000 page 2M
> 
> Once the new node has been added, its memory can be onlined.  If this
> memory represents memory section 16, for example:
> 
> 	# echo online > /sys/devices/system/memory/memory16/state
> 	Built 2 zonelists in Node order, mobility grouping on.  Total pages: 514846
> 	Policy zone: Normal
> 
>  [ The memory section(s) mapped to a particular node are visible via
>    /sys/devices/system/node/node1, in this example. ]
> 
> The new node is now hotplugged and ready for testing.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  Documentation/memory-hotplug.txt |   24 ++++++++++++++++++++++++
>  drivers/base/memory.c            |   36 +++++++++++++++++++++++++++++++++++-
>  2 files changed, 59 insertions(+), 1 deletions(-)

When adding sysfs files you need to document it in Documentation/ABI
instead.

But as this is a debugging thing, why not just put it in debugfs
instead?

thanks,

greg k-h
