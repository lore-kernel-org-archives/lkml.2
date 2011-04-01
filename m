Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab1DAP1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:27:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757795Ab1DAP1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:27:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110331190428.GI2258@linux.vnet.ibm.com>
References: <20110331190428.GI2258@linux.vnet.ibm.com> <4D82DB5B.9000302@cn.fujitsu.com> <16158.1301597440@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 31/36] security,rcu: convert call_rcu(user_update_rcu_disposal) to kfree_rcu()
Date: Fri, 01 Apr 2011 16:27:09 +0100
Message-ID: <8112.1301671629@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> commit 316b740440ea0a54615a3516df536fbf9a4c11b8
> Author: Lai Jiangshan <laijs@cn.fujitsu.com>
> Date:   Fri Mar 18 11:15:47 2011 +0800
> 
>     rcu: introduce kfree_rcu()
>     
>     Many rcu callbacks functions just call kfree() on the base structure.
>     These functions are trivial, but their size adds up, and furthermore
>     when they are used in a kernel module, that module must invoke the
>     high-latency rcu_barrier() function at module-unload time.
>     
>     The kfree_rcu() function introduced by this commit addresses this issue.
>     Rather than encoding a function address in the embedded rcu_head
>     structure, kfree_rcu() instead encodes the offset of the rcu_head
>     structure within the base structure.  Because the functions are not
>     allowed in the low-order 4096 bytes of kernel virtual memory, offsets
>     up to 4095 bytes can be accommodated.  If the offset is larger than
>     4095 bytes, a compile-time error will be generated in __kfree_rcu().
>     If this error is triggered, you can either fall back to use of call_rcu()
>     or rearrange the structure to position the rcu_head structure into the
>     first 4096 bytes.
>     
>     Note that the allowable offset might decrease in the future, for example,
>     to allow something like kmem_cache_free_rcu().
>     
>     The new kfree_rcu() function can replace code as follows:
>     
>     	call_rcu(&p->rcu, simple_kfree_callback);
>     
>     where "simple_kfree_callback()" might be defined as follows:
>     
>     	void simple_kfree_callback(struct rcu_head *p)
>     	{
>     		struct foo *q = container_of(p, struct foo, rcu);
>     
>     		kfree(q);
>     	}
>     
>     with the following:
>     
>     	kfree_rcu(&p->rcu, rcu);
>     
>     Note that the "rcu" is the name of a field in the structure being
>     freed.  The reason for using this rather than passing in a pointer
>     to the base structure is that the above approach allows better type
>     checking.
>     
>     This commit is based on earlier work by Lai Jiangshan and Manfred Spraul:
>     
>     Lai's V1 patch: http://lkml.org/lkml/2008/9/18/1
>     Manfred's patch: http://lkml.org/lkml/2009/1/2/115
>     
>     Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>     Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-and-sneakiness-appreciated-by: David Howells <dhowells@redhat.com>
