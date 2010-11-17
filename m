Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935332Ab0KQTEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:04:20 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57972 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934902Ab0KQTET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:04:19 -0500
Subject: Re: [7/8,v3] NUMA Hotplug Emulator: extend memory probe interface
 to support NUMA
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: shaohui.zheng@intel.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Haicheng Li <haicheng.li@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Greg KH <greg@kroah.com>
In-Reply-To: <20101117021000.916235444@intel.com>
References: <20101117020759.016741414@intel.com>
	 <20101117021000.916235444@intel.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Wed, 17 Nov 2010 10:50:07 -0800
Message-ID: <1290019807.9173.3789.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 10:08 +0800, shaohui.zheng@intel.com wrote:
> And more we make it friendly, it is possible to add memory to do
> 
>         echo 3g > memory/probe
>         echo 1024m,3 > memory/probe
> 
> It maintains backwards compatibility.
> 
> Another format suggested by Dave Hansen:
> 
>         echo physical_address=0x40000000 numa_node=3 > memory/probe
> 
> it is more explicit to show meaning of the parameters.

The other thing that Greg suggested was to use configfs.  Looking back
on it, that makes a lot of sense.  We can do better than these "probe"
files.

In your case, it might be useful to tell the kernel to be able to add
memory in a node and add the node all in one go.  That'll probably be
closer to what the hardware will do, and will exercise different code
paths that the separate "add node", "then add memory" steps that you're
using here.

For the emulator, I also have to wonder if using debugfs is the right
was since its ABI is a bit more, well, _flexible_ over time. :)

> +       depends on NUMA_HOTPLUG_EMU
> +       ---help---
> +         Enable memory hotplug emulation. Reserve memory with grub parameter
> +         "mem=N"(such as mem=1024M), where N is the initial memory size, the
> +         rest physical memory will be removed from e820 table; the memory probe
> +         interface is for memory hot-add to specified node in software method.
> +         This is for debuging and testing purpose

mem= actually sets the largest physical address that we're trying to
use.  If you have a 256MB hole at 768MB, then mem=1G will only get you
768MB of memory.  We probably get this wrong in a number of other places
in the documentation, but we might as well get it right here.

Maybe something like:
        
        Enable emulation of hotplug of NUMA nodes.  To use this, you
        must also boot with the kernel command-line parameter
        "mem=N"(such as mem=1024M), where N is the highest physical
        address you would like to use at boot.  The rest of physical
        memory will be removed from firmware tables and may be then be
        hotplugged with this feature. This is for debuging and testing
        purposes.
        
        Note that you can still examine the original, non-modified
        firmware tables in: /sys/firmware/memmap
        
-- Dave

