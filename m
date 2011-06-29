Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab1F2FmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:42:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61205 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1F2Fl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:41:57 -0400
Subject: Re: Question on debugging use-after-free memory issues.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ben Greear <greearb@candelatech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1106282358450.14213@twin.jikos.cz>
References: <4E08C80B.9070602@candelatech.com>
	 <alpine.LRH.2.00.1106282358450.14213@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 07:41:52 +0200
Message-ID: <1309326112.2532.104.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 29 juin 2011 à 00:00 +0200, Jiri Kosina a écrit :
> On Mon, 27 Jun 2011, Ben Greear wrote:
> 
> > I have a case where deleted memory is being passed into an RPC callback.  
> > I enabled SLUB memory poisoning and verified that the data pointed to 
> > has 0x6b...6b value.
> > 
> > Unfortunately, the rpc code is a giant maze of callbacks and I'm having 
> > a difficult time figuring out where this data could be erroneously 
> > deleted at.
> > 
> > So first question:
> > 
> > Given a pointer to memory, and with SLUB memory debuging on (and/or 
> > other debugging options if applicable), is there a way to get any info 
> > about where the memory was last deleted?
> > 
> > Second:  Any other suggestions for how to go about debugging this?
> > 
> > I hit this problem under load after multiple hours, so just adding 
> > printks in random places may not be feasible...
> 
> First, this is not really a proper list for such questions. I'd propose 
> kernel newbies community next time.
> 

LKML is definitely a place for such questions.

> Anyway, I'd propose to start with kmemcheck (see 
> Documentation/kmemcheck.txt). It could pin-point the problemtic spot 
> immediately (or it might not).
> 

kmemcheck is fine if problem is not coming from an SMP bug only. Also
kmemcheck is so slow it makes a rare bug becoming very hard to trigger.


Ben, given that you know that RPC might have a problem on a given small
object (struct rpcbind_args ), you could afford changing the
kmalloc()/kfree() used to allocate/free such objects by calls to page
allocator, and dont free the page but unmap it from kernel mapping so
that any further read/write access triggers a fault. You can then have a
more precise idea of what's happening, without slowing down whole
kernel. Of course there is a mem leak for each "struct rpcbind_args"
allocated, so this is a debugging aid only.

DEBUG_PAGEALLOC might be too expensive, so try this patch (untested, you
might need to complete it)

diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index 9a80a92..9b4dbaf 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -158,7 +158,7 @@ static void rpcb_map_release(void *data)
 	rpcb_wake_rpcbind_waiters(map->r_xprt, map->r_status);
 	xprt_put(map->r_xprt);
 	kfree(map->r_addr);
-	kfree(map);
+	kernel_map_pages(virt_to_page(map), 1, 0);
 }
 
 /*
@@ -668,7 +668,7 @@ void rpcb_getport_async(struct rpc_task *task)
 		goto bailout_nofree;
 	}
 
-	map = kzalloc(sizeof(struct rpcbind_args), GFP_ATOMIC);
+	map = (struct rpcbind_args *)__get_free_page(GFP_ATOMIC | __GFP_ZERO);
 	if (!map) {
 		status = -ENOMEM;
 		dprintk("RPC: %5u %s: no memory available\n",


