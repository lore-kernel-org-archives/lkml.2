Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935158Ab0KQVzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:55:55 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46676 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367Ab0KQVzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:55:53 -0500
Subject: Re: [7/8,v3] NUMA Hotplug Emulator: extend memory probe interface
 to support NUMA
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: shaohui.zheng@intel.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Haicheng Li <haicheng.li@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Greg KH <greg@kroah.com>
In-Reply-To: <alpine.DEB.2.00.1011171312590.10254@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com>
	 <20101117021000.916235444@intel.com> <1290019807.9173.3789.camel@nimitz>
	 <alpine.DEB.2.00.1011171312590.10254@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Wed, 17 Nov 2010 13:55:45 -0800
Message-ID: <1290030945.9173.4211.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2010-11-17 at 13:18 -0800, David Rientjes wrote:
> On Wed, 17 Nov 2010, Dave Hansen wrote:
> > The other thing that Greg suggested was to use configfs.  Looking back
> > on it, that makes a lot of sense.  We can do better than these "probe"
> > files.
> > 
> > In your case, it might be useful to tell the kernel to be able to add
> > memory in a node and add the node all in one go.  That'll probably be
> > closer to what the hardware will do, and will exercise different code
> > paths that the separate "add node", "then add memory" steps that you're
> > using here.
> 
> That seems like a seperate issue of moving the memory hotplug interface 
> over to configfs and that seems like it will cause a lot of userspace 
> breakage.  The memory hotplug interface can already add memory to a node 
> without using the ACPI notifier, so what does it have to do with this 
> patchset?

I was actually just thinking of the node hotplug interface not using a
'probe' file.  But, you make a good point.  They _have_ to be tied
together, and doing one via configfs would mean that we probably have to
do the other that way.  We wouldn't have to _remove_ the ...memory/probe
interface (breaking userspace), but we would add some redundancy.

> I think what this patchset really wants to do is map offline hot-added 
> memory to a different node id before it is onlined.  It needs no 
> additional command-line interface or kconfig options, users just need to 
> physically hot-add memory at runtime or use mem= when booting to reserve 
> present memory from being used.
> 
> Then, export the amount of memory that is actually physically present in 
> the e820 but was truncated by mem=

I _think_ that's already effectively done in /sys/firmware/memmap.   

> and allow users to hot-add the memory 
> via the probe interface.  Add a writeable 'node' file to offlined memory 
> section directories and allow it to be changed prior to online.

That would work, in theory.  But, in practice, we allocate the mem_map[]
at probe time.  So, we've already effectively picked a node at probe.
That was done because the probe is equivalent to the hardware "add"
event.  Once the hardware where in the address space the memory is, it
always also knows the node.

But, I guess it also wouldn't be horrible if we just hot-removed and
hot-added an offline section if someone did write to a node file like
you're suggesting.  It might actually exercise some interesting code
paths.

-- Dave

