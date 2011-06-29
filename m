Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1F2GDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 02:03:41 -0400
Received: from mail.candelatech.com ([208.74.158.172]:37873 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab1F2GDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 02:03:35 -0400
Message-ID: <4E0ABFB5.2050403@candelatech.com>
Date: Tue, 28 Jun 2011 23:01:25 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Thunderbird/3.1.9
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question on debugging use-after-free memory issues.
References: <4E08C80B.9070602@candelatech.com>	 <alpine.LRH.2.00.1106282358450.14213@twin.jikos.cz> <1309326112.2532.104.camel@edumazet-laptop>
In-Reply-To: <1309326112.2532.104.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2011 10:41 PM, Eric Dumazet wrote:
> Le mercredi 29 juin 2011 à 00:00 +0200, Jiri Kosina a écrit :
>> On Mon, 27 Jun 2011, Ben Greear wrote:

>> Anyway, I'd propose to start with kmemcheck (see
>> Documentation/kmemcheck.txt). It could pin-point the problemtic spot
>> immediately (or it might not).
>>
>
> kmemcheck is fine if problem is not coming from an SMP bug only. Also
> kmemcheck is so slow it makes a rare bug becoming very hard to trigger.

I think I've pretty much verified that deleted memory is passed down
a certain call path with the slub patches I posted.
What I can't figure out is how that came to be.

> Ben, given that you know that RPC might have a problem on a given small
> object (struct rpcbind_args ), you could afford changing the
> kmalloc()/kfree() used to allocate/free such objects by calls to page
> allocator, and dont free the page but unmap it from kernel mapping so
> that any further read/write access triggers a fault. You can then have a
> more precise idea of what's happening, without slowing down whole
> kernel. Of course there is a mem leak for each "struct rpcbind_args"
> allocated, so this is a debugging aid only.
>
> DEBUG_PAGEALLOC might be too expensive, so try this patch (untested, you
> might need to complete it)
>
> diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
> index 9a80a92..9b4dbaf 100644
> --- a/net/sunrpc/rpcb_clnt.c
> +++ b/net/sunrpc/rpcb_clnt.c
> @@ -158,7 +158,7 @@ static void rpcb_map_release(void *data)
>   	rpcb_wake_rpcbind_waiters(map->r_xprt, map->r_status);
>   	xprt_put(map->r_xprt);
>   	kfree(map->r_addr);
> -	kfree(map);
> +	kernel_map_pages(virt_to_page(map), 1, 0);
>   }
>
>   /*
> @@ -668,7 +668,7 @@ void rpcb_getport_async(struct rpc_task *task)
>   		goto bailout_nofree;
>   	}
>
> -	map = kzalloc(sizeof(struct rpcbind_args), GFP_ATOMIC);
> +	map = (struct rpcbind_args *)__get_free_page(GFP_ATOMIC | __GFP_ZERO);
>   	if (!map) {
>   		status = -ENOMEM;
>   		dprintk("RPC: %5u %s: no memory available\n",
>

It takes possibly hours of heavy load to hit the problem, so I think
I cannot afford to leak that much memory.

Interestingly, I added this code below, and haven't hit the problem since.
I'm not sure if it just changed the timing, or what...or maybe I'll
hit it overnight...

I tried setting this (below) to 0x6b instead of 0x0 (mempool doesn't
really kmalloc/free too often, so the slub poisoning doesn't help),
but never did hit the bug again.

I suspect that somehow the task object is still on the work-queue,
when it is deleted, but since the 0x6b and 0x0 poisoning didn't cause
any funny crashes, I could easily be wrong about that.

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 17c3e3a..d94f009 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -859,6 +859,12 @@ static void rpc_free_task(struct rpc_task *task)

         if (task->tk_flags & RPC_TASK_DYNAMIC) {
                 dprintk("RPC: %5u freeing task\n", task->tk_pid);
+               /* HACK:  Have been seeing use-after-free of calldata.  Zero this memory
+                * so that it cannot happen here.  Seems to have fixed the problem
+                * in 3.0 kernel, but maybe it just adjusted timing..either way,
+                * it's not a real fix. --Ben
+                */
+               memset(task, 0, sizeof(*task));
                 mempool_free(task, rpc_task_mempool);
         }
         rpc_release_calldata(tk_ops, calldata);


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
