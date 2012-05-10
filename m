Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495Ab2EJSx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:53:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42095 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760305Ab2EJSxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:53:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6707"; a="187359282"
Message-ID: <4FAC0EC1.7050803@codeaurora.org>
Date: Thu, 10 May 2012 11:53:53 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] spinlock_debug: Print kallsyms name for lock
References: <1335217525-30709-1-git-send-email-sboyd@codeaurora.org> <1335217525-30709-2-git-send-email-sboyd@codeaurora.org> <20120423145431.617c2b01.akpm@linux-foundation.org> <4F961B2F.4060203@codeaurora.org> <20120424145402.4f9be035.akpm@linux-foundation.org>
In-Reply-To: <20120424145402.4f9be035.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/12 14:54, Andrew Morton wrote:
> On Mon, 23 Apr 2012 20:17:03 -0700
> Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> On 04/23/12 14:54, Andrew Morton wrote:
>>>> --- a/lib/spinlock_debug.c
>>>> +++ b/lib/spinlock_debug.c
>>>> @@ -58,7 +58,7 @@ static void spin_dump(raw_spinlock_t *lock, const char *msg)
>>>>  	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
>>>>  		msg, raw_smp_processor_id(),
>>>>  		current->comm, task_pid_nr(current));
>>>> -	printk(KERN_EMERG " lock: %p, .magic: %08x, .owner: %s/%d, "
>>>> +	printk(KERN_EMERG " lock: %ps, .magic: %08x, .owner: %s/%d, "
>>>>  			".owner_cpu: %d\n",
>>>>  		lock, lock->magic,
>>>>  		owner ? owner->comm : "<none>",
>>> Maybe.  It will only do useful things for statically-allocated locks
>>> which are rare and which we are unlikely to screw up as easily as locks
>>> which lie in dynamically allocated memory.
>> Agreed. It catches the really stupid stuff and that's about it. I was
>> thinking we could get more information about dynamic allocated locks by
>> adding some code to slab to find the slab that a pointer is allocated
>> in. Does that sound possible?
> Well lockdep knows lots of things about the lock, including numerous
> stack backtraces which can be used to identify the lock.  Making 
> spinlock_debug use lockdep infrastructure seems a good fit.
>

I was thinking about this more. In the case of spinlock bad magic I want
to find out who freed this region of memory last because that code most
likely stomped all over my lock and corrupted the magic. With lockdep I
can't find that. I can only find out that the allocator of a lock did a
lock/unlock after a kfree() and I believe lockdep already checks to make
sure live locks are not being freed.

Enabling slub debugging might help, but I would have to get lucky and
allocate the lock after the previous user corrupted it. So I really want
a way to query slab/slub about who last allocated and free this memory
so I can find them when I detect magic corruption.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

