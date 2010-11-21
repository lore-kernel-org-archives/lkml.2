Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab0KUVm6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 16:42:58 -0500
Received: from smtp-out.google.com ([216.239.44.51]:51379 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab0KUVm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 16:42:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=jqvA2ykw7HlT3LoH+IJVSEMUUI3HwPEIGpWK8atJy8NSumOma15oIi7yXA0KH4U1Am
         ribE4/mZ2qgkGrO+g3iw==
Date: Sun, 21 Nov 2010 13:42:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Li, Haicheng" <haicheng.li@intel.com>
cc: "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "shaohui.zheng@linux.intel.com" <shaohui.zheng@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: RE: [2/8,v3] NUMA Hotplug Emulator: infrastructure of NUMA hotplug
 emulation
In-Reply-To: <789F9655DD1B8F43B48D77C5D30659732FE95E6E@shsmsx501.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.00.1011211334150.26304@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com> <20101117021000.568681101@intel.com> <alpine.DEB.2.00.1011162359160.17408@chino.kir.corp.google.com> <20101117075128.GA30254@shaohui> <alpine.DEB.2.00.1011171304060.10254@chino.kir.corp.google.com>
 <20101118041407.GA2408@shaohui> <20101118062715.GD17539@linux-sh.org> <20101118052750.GD2408@shaohui> <alpine.DEB.2.00.1011181321470.26680@chino.kir.corp.google.com> <20101119003225.GB3327@shaohui> <alpine.DEB.2.00.1011201645230.10618@chino.kir.corp.google.com>
 <789F9655DD1B8F43B48D77C5D30659732FE95E6E@shsmsx501.ccr.corp.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010, Li, Haicheng wrote:

> > I think what we'll end up wanting to do is something like this, which
> > adds 
> > a numa=possible=<N> parameter for x86; this will add an additional N
> > possible nodes to node_possible_map that we can use to online later. 
> > It 
> > also adds a new /sys/devices/system/memory/add_node file which takes a
> > typical "size@start" value to hot-add an emulated node.  For example,
> > using "mem=2G numa=possible=1" on the command line and doing
> > echo 128M@0x80000000" > /sys/devices/system/memory/add_node would
> > hot-add 
> > a node of 128M.
> > 
> > Comments?
> 
> Sorry for the late response as I'm in a biz trip recently.
> 
> David, your original concern is just about powerful/flexibility. I'm 
> sure our implementation can better meets such requirments.
> 

Not with hacky hidden nodes or being unnecessarily tied to e820, it can't.

> IMHO, I don't see any powerful/flexibility from your patch, compared to 
> our original implementation. you just make things more complex and mess.
> Why not use "numa=hide=N*size" as originally implemented?

Hidden nodes are a hack and completely unnecessary for node hotplug 
emulation, there's no need to have additional nodemasks or node states 
throughout the kernel.  They also require that you define the node sizes 
at boot, mine allows you to hotplug multiple node sizes of your choice at 
runtime.

> - later you just need to online the node once you want. And it 
> naturally/exactly emulates the behavior that current HW provides.

My proposal allows you to hotplug various node sizes, they can be 
offlined, their sizes can be subsequently changed, and re-hotplugged.  
It's a very dynamic and flexible model that allows you to emulate all 
possible combinations of node hotplug without constantly rebooting.

> - N is the possible node number. And we can use 128M as the default 
> size for each hidden node if user doesn't specify a size.

My model allows you to define the node size you'd like to add at runtime.

> - If user wants more mem for hidden node, he just needs specify the 
> "size".
> - besides, user can also use "mem=" to hide more mem and later use 
> mem-add i/f to freely attach more mem to the hidden node during runtime.
> 

Each of these requires a reboot, you cannot emulate hotplugging a node, 
offlining it, removing the memory, and re-hotplugging the same node with a 
larger amount of added memory with your model.

> Your patch introduces additional dependency on "mem=", but ours is 
> simple and flexibly compatible with "mem=" and "numa=emu". 
> 

This is the natural use case of mem=, to truncate the memory map to only 
allow the kernel to have a portion of usable memory.  The remainder can be 
used by this new interface, if desired, with complete power and control 
over the size of nodes you're adding without having to conform to hidden 
node sizes that you've specified at boot.
