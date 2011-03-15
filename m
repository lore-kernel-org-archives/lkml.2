Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab1COMTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 08:19:51 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40983 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab1COMTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 08:19:50 -0400
Date: Tue, 15 Mar 2011 05:19:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH V4 1/1] rcu: introduce kfree_rcu()
Message-ID: <20110315121941.GD2167@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D7F356C.8020903@cn.fujitsu.com>
 <201103151115.54426.arnd@arndb.de>
 <20110315112734.GA2167@linux.vnet.ibm.com>
 <201103151302.09381.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103151302.09381.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 01:02:09PM +0100, Arnd Bergmann wrote:
> On Tuesday 15 March 2011, Paul E. McKenney wrote:
> > > Another alternative might be to encode the difference between a
> > > function pointer and an offset in one of the lower bits of the address.
> > 
> > We discussed this some time back, and it turned out that there were
> > CPUs that could legitimately have any combination of low-order bits
> > set -- functions could start at any byte address.
> > 
> > If this has changed, I would prefer to use the low-order bits, but
> > if it has not, we can't.  :-(
> 
> Ok, I see.
> 
> I just had another idea, which may or may not have new problems:
> 
> static inline void *kzalloc_rcu(size_t len, gfp_t flags)
> {
> 	struct rcu_head *head = kzalloc(len + sizeof (struct rcu_head), flags);
> 	return head + 1;
> }
> 
> void __kfree_rcu(struct rcu_head *head)
> {
> 	kfree(head);
> }
> 
> static inline void kfree_rcu(void *p)
> {
> 	struct rcu_head *head = p - sizeof (struct rcu_head);
> 	call_rcu(head, __kfree_rcu);
> }
> 
> The only disadvantage I can see right now is that it messes
> with the alignment of the structure.

And it makes use of statically allocated structures a bit clunky.

The other approach I could imagine would be to create the RCU callback
functions on the fly at compile/link time by creating a new section into
which offsets and places for function pointers are placed.  A link-time
utility could scan the contents of the section, generate the needed
functions, compile them, and place pointers to them into the section.

One disadvantage of this approach (in addition to the changes required
to kbuild) is that it would not allow rcu_barrier() to be removed.

Yet another approach is to use the low-order bit of the rcu_head pointer,
given that the rcu_head structure does have to be aligned.  If this bit
is set, then the function pointer could be interpreted as an offset.
This approach might also allow a slab_free_rcu() to be constructed, given
that the full 32 bits of the function pointer would be available.
For example, if the upper 16 bits are zero, the low-order 16 bits are
the offset.  If the upper 16 bits are 0x1, then the low-order 16 bits
might be an index that selects the desired slab cache.

Other possible approaches?

							Thanx, Paul
