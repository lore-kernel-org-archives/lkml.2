Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab0KQVLC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:11:02 -0500
Received: from smtp-out.google.com ([216.239.44.51]:59076 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab0KQVLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:11:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=TJCxdvTDTvK+lV8gBffnVCbBylqI1vlA4uToq813bsiWgMuoPigeHRYVQQe4iMMGRI
         Nq6fPzQpd2kmH/Gskanw==
Date: Wed, 17 Nov 2010 13:10:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [2/8,v3] NUMA Hotplug Emulator: infrastructure of NUMA hotplug
 emulation
In-Reply-To: <20101117075128.GA30254@shaohui>
Message-ID: <alpine.DEB.2.00.1011171304060.10254@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com> <20101117021000.568681101@intel.com> <alpine.DEB.2.00.1011162359160.17408@chino.kir.corp.google.com> <20101117075128.GA30254@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, Shaohui Zheng wrote:

> > Hmm, why can't you use numa=hide to hide a specified quantity of memory 
> > from the kernel and then use the add_memory() interface to hot-add the 
> > offlined memory in the desired quantity?  In other words, why do you need 
> > to track the offlined nodes with a state?
> > 
> > The userspace interface would take a desired size of hidden memory to 
> > hot-add and the node id would be the first_unset_node(node_online_map).
> Yes, it is a good idea, your solution is what we indeed do in our first 2
> versions.  We use mem=memsize to hide memory, and we call add_memory interface
> to hot-add offlined memory with desired quantity, and we can also add to
> desired nodes(even through the nodes does not exists). it is very flexible
> solution.
> 
> However, this solution was denied since we notice NUMA emulation, we should
> reuse it.
> 

I don't understand why that's a requirement, NUMA emulation is a seperate 
feature.  Although both are primarily used to test and instrument other VM 
and kernel code, NUMA emulation is restricted to only being used at boot 
to fake nodes on smaller machines and can be used to test things like the 
slab allocator.  The NUMA hotplug emulator that you're developing here is 
primarily used to test the hotplug callbacks; for that use-case, it seems 
particularly helpful if nodes can be hotplugged of various sizes and node 
ids rather than having static characteristics that cannot be changed with 
a reboot.

> Currently, our solution creates static nodes when OS boots, only the node with 
> state N_HIDDEN can be hot-added with node/probe interface, and we can query 
> 

The idea that I've proposed (and you've apparently thought about and even 
implemented at one point) is much more powerful than that.  We need not 
query the state of hidden nodes that we've setup at boot but can rather 
use the amount of hidden memory to setup the nodes in any way that we want 
at runtime (various sizes, interleaved node ids, etc).
