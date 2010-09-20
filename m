Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab0ITKed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 06:34:33 -0400
Received: from science.horizon.com ([71.41.210.146]:42335 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755678Ab0ITKec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 06:34:32 -0400
Date: 20 Sep 2010 06:34:29 -0400
Message-ID: <20100920103429.8975.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: benh@kernel.crashing.org, miklos@szeredi.hu
Subject: Re: memory barrier question
Cc: linux@horizon.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>    LOAD inode = next.dentry->inode
>>    if (inode != NULL)
>>    	LOAD inode->f_op
>> 
>> What is there the compiler can optimize?

> Those two loads depend on each other, I don't think any implementation
> can re-order them. In fact, such data dependency is typically what is
> used to avoid having barriers in some cases. The second load cannot be
> issued until the value from the first one is returned.

It's quite hard for the *compiler* to do the loads out of order, but it's
vaguely possible on, say, an ia64 system which supports non-faulting loads.

That is, the compiled code could be:

"I guess the next inode will be at address X"
retry:
LOAD preloaded == *X;
LOAD inode = next.dentry->inode
if (inode == X)
	TRAP if fetch of preloaded had a page fault
	LOAD preloaded.f_op (guaranteed non blocking)
else
	update guess X = inode
	goto retry;
	
However, it's *very* easy for a processor to do exactly that!  There
days, hardware cache prefetchers look for sequential access patterns,
and if your inodes happen to get allocated to consecutive addresses,
it's possible that the prefetcher could have done the read ahead of you.

Even if reads are generated in one order, there's no reason that one can't
be stalled due to some resource conflict (say a bank conflict in the L1
cache) while the second is not stalled and ends up completing first.


So, for example, the following is not safe without barriers:

START:
	dentry->inode == a
	a->f_op == a_op
	b->f_op = INVALID
CPU 1:
	b->f_op = b_op
	dentry->inode = b
CPU 2:
	LOAD inode = dentry->inode
	LOAD op = inode->f_op
	assert(op != INVALID)

While this is a FALSE OVERSIMPLIFICATION that will lead you astray if
you take it to far, you can describe hazards in terms of a serialized stream
of "external observer" memory updates.

The above code has two hazards:
- CPU 1 might write dentry->inode before the b->f_op write is complete, or
- CPU 2 might read inode->f_op befire is reads dentry->inode.  This is
  difficult, but a hardware prefetcher might make a lucky guess.

Either way, CPU 2 ends up reading an invalid op vector.


Although the single serialized stream conceptual model works fine between
two processors, it is not guaranteed to work between three.  That is,
there is no guarantee that the following won't happen:

START:
	a = b = 0
CPU 1:
	a = 1;
	/* No barrier! */
	b = 1;
CPU 2:
	LOAD a;	(loads 1)
	-- read barrier --
	LOAD b; (loads 0)
CPU 3:
	LOAD b;	(loads 1)
	-- read barrier --
	LOAD a; (loads 0)

This is obviously inconsistent with the existence of a "true" sequential
ordering, but is entirely legal according to a less-strict memory ordering.

The lack of a write barrier on CPU 1 means that the order in which the
writes will be seen by other processor is not only undefined, it might
be different for different processors!

The Alpha processor manual had a good description of various ugly corner
cases.
