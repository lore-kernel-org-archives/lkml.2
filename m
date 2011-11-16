Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab1KPIZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 03:25:38 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:9036 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab1KPIZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 03:25:37 -0500
Message-ID: <4EC3736C.2040006@parallels.com>
Date: Wed, 16 Nov 2011 12:25:16 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] Checkpoint/Restore: Show in proc IDs of objects that
 can be shared between tasks
References: <4EC24E9E.8040502@parallels.com> <20111116054427.GA14827@count0.beaverton.ibm.com>
In-Reply-To: <20111116054427.GA14827@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 09:44 AM, Matt Helsley wrote:
> On Tue, Nov 15, 2011 at 03:35:58PM +0400, Pavel Emelyanov wrote:
>> While doing the checkpoint-restore in the userspace one need to determine
>> whether various kernel objects (like mm_struct-s of file_struct-s) are shared
>> between tasks and restore this state.
>>
>> The 2nd step can for now be solved by using respective CLONE_XXX flags and
>> the unshare syscall, while there's currently no ways for solving the 1st one.
>>
>> One of the ways for checking whether two tasks share e.g. an mm_struct is to
>> provide some mm_struct ID of a task to its proc file. The best from the
>> performance point of view ID is the object address in the kernel, but showing
>> them to the userspace is not good for performance reasons.
> 
> (I think you meant "not good for security reasons."...)
> 
>> The previous attempt to solve this was to generate an ID for slab/slub and then
>> mix it up with the object index on the slab page. This attempt wasn't met
>> warmly by slab maintainers, so here's the 2nd approach.
>>
>> The object address is XOR-ed with a "random" value of the same size and then
>> shown in proc. Providing this poison is not leaked into the userspace then
>> ID seem to be safe.
> 
> Really? There's no way to quickly derive the random number from known
> allocation patterns and thereby break the obfuscation scheme?
> To start we can note that the low N bits are directly exposed in the ID
> of anything that requires 2^N-byte alignment.
> 
> I think it's really a question of whether the high order bits can be derived.
> 
> And of course the random number only needs to be derived once per boot
> before it reveals the address of everything with an ID.

Tejun already proposed to split ID space and use different poisons for them.

> Some wild speculation:
> 
> I bet you could use some cpu affinity, mem policy, slab info, mmap
> tricks, etc. to derive more low bits of the random number. You can probably
> get even more when you consider objects that don't fit evenly in slabs.
> Speaking of slabs, is there some way to use the fact that nearby slab objects
> will share their high ID bits?

OK, let's assume we found out that two mm_struct IDs have higher bits equal, what
can we do next to split address bits from the poison ones?

> If any of the ID-bearing objects allocated via
> kmalloc then inducing memory pressure and/or watching for buddy allocator
> merge/splits might reveal more low bits...
> 
> Cheers,
> 	-Matt Helsley
> 
> .
> 

