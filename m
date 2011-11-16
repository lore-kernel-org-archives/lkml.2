Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab1KPFof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 00:44:35 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37662 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab1KPFoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 00:44:34 -0500
Date: Tue, 15 Nov 2011 21:44:27 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH 0/4] Checkpoint/Restore: Show in proc IDs of objects that
 can be shared between tasks
Message-ID: <20111116054427.GA14827@count0.beaverton.ibm.com>
References: <4EC24E9E.8040502@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC24E9E.8040502@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11111605-6078-0000-0000-00000471D42D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 03:35:58PM +0400, Pavel Emelyanov wrote:
> While doing the checkpoint-restore in the userspace one need to determine
> whether various kernel objects (like mm_struct-s of file_struct-s) are shared
> between tasks and restore this state.
> 
> The 2nd step can for now be solved by using respective CLONE_XXX flags and
> the unshare syscall, while there's currently no ways for solving the 1st one.
> 
> One of the ways for checking whether two tasks share e.g. an mm_struct is to
> provide some mm_struct ID of a task to its proc file. The best from the
> performance point of view ID is the object address in the kernel, but showing
> them to the userspace is not good for performance reasons.

(I think you meant "not good for security reasons."...)

> The previous attempt to solve this was to generate an ID for slab/slub and then
> mix it up with the object index on the slab page. This attempt wasn't met
> warmly by slab maintainers, so here's the 2nd approach.
> 
> The object address is XOR-ed with a "random" value of the same size and then
> shown in proc. Providing this poison is not leaked into the userspace then
> ID seem to be safe.

Really? There's no way to quickly derive the random number from known
allocation patterns and thereby break the obfuscation scheme?
To start we can note that the low N bits are directly exposed in the ID
of anything that requires 2^N-byte alignment.

I think it's really a question of whether the high order bits can be derived.

And of course the random number only needs to be derived once per boot
before it reveals the address of everything with an ID.

Some wild speculation:

I bet you could use some cpu affinity, mem policy, slab info, mmap
tricks, etc. to derive more low bits of the random number. You can probably
get even more when you consider objects that don't fit evenly in slabs.
Speaking of slabs, is there some way to use the fact that nearby slab objects
will share their high ID bits? If any of the ID-bearing objects allocated via
kmalloc then inducing memory pressure and/or watching for buddy allocator
merge/splits might reveal more low bits...

Cheers,
	-Matt Helsley

