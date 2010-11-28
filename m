Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab0K1CA2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 21:00:28 -0500
Received: from smtp-out.google.com ([74.125.121.35]:10255 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab0K1CAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 21:00:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=K1f8OFLzwK9DsdC9WBedqOJY7Pji63Al8oIoFiQeklKNJojJifJDpP2e+LegnTiMnn
         k9/BU+rH7ycfajluX4eQ==
Date: Sat, 27 Nov 2010 18:00:15 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: akpm@linux-foundation.org, gregkh@suse.de, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, lethal@linux-sh.org, ak@linux.intel.com,
        yinghai@kernel.org, randy.dunlap@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        haicheng.li@intel.com, haicheng.li@linux.intel.com,
        shaohui.zheng@linux.intel.com
Subject: Re: [patch 2/2] mm: add node hotplug emulation
In-Reply-To: <20101122014706.GB9081@shaohui>
Message-ID: <alpine.DEB.2.00.1011271754260.3764@chino.kir.corp.google.com>
References: <A24AE1FFE7AEC5489F83450EE98351BF28723FC4A7@shsmsx502.ccr.corp.intel.com> <20101122014706.GB9081@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010, Shaohui Zheng wrote:

> > and then creating a new 128M node at runtime:
> > 
> > 	# echo 128M@0x80000000 > /sys/devices/system/memory/add_node
> > 	On node 1 totalpages: 0
> > 	init_memory_mapping: 0000000080000000-0000000088000000
> > 	 0080000000 - 0088000000 page 2M
> 
> For cpu/memory physical hotplug, we have the unique interface probe/release,
> it is the _standard_ interface, it is not only for x86, ppc use the the interface
> as well. For node hotplug, it should follow the rule.
> 
> You are creating a new interface /sys/devices/system/memory/add_node to add both
> memory and node, you are just trying to create DUPLICATED feature with the
> memory probe interface, it breaks the rule. 
> 

It's not duplicated, the function of add_node is distinct since it maps 
the added memory to a node that wasn't previously defined (for the x86 
case, defined by the SRAT).  I think this is better than an additional 
abstraction layer that remaps memory to nodes above what the BIOS has 
defined, and there's nothing architecture specific about add_node; if an 
arch can do probe then it can use this new interface.

> I did NOT see the feature difference with our emulator patch http://lkml.org/lkml/2010/11/16/740,
> you pick up a piece of feature from emulator, and create an other thread. You
> are trying to replace the interface with a new one, which is not recommended.
> the memory probe interface is already powerful and flexible enough after apply
> our patch. What's more important, it keeps the old directives, and it maintains
> backwards compatibility.
> 

This achieves the same goal in a much cleaner and generic way.  It doesn't 
replace anything that currently sits in the kernel, instead it competes 
directly with your model for node hotplug emulation.

> Add a memory section(128M) to node 3(boots with mem=1024m)
> 
> 	echo 0x40000000,3 > memory/probe
> 
> And more we make it friendly, it is possible to add memory to do
> 
> 	echo 3g > memory/probe
> 	echo 1024m,3 > memory/probe
> 
> It maintains backwards compatibility.
> 

My patch doesn't break backwards compatibility, it adds a new debugfs file 
that allows you to test node hotplug.

> Another format suggested by Dave Hansen:
> 
> 	echo physical_address=0x40000000 numa_node=3 > memory/probe
> 
> we should not need duplicated interface /sys/devices/system/memory/add_node here.
> 

We don't need to define a node id, we only need to ensure that a possible 
node is not yet online and use it; we don't gain anything by trying to 
hotplug node ids in a sparse or interleaved way (although it is certainly 
possible with a combination of my patch and CONFIG_MEMORY_HOTREMOVE).
