Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab0JPGwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 02:52:17 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:34812 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751940Ab0JPGwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 02:52:16 -0400
Date: Sat, 16 Oct 2010 17:52:06 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@us.ibm.com>
Subject: ima: use of radix tree cache indexing == massive waste of memory?
Message-ID: <20101016065206.GO4681@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

I was doing a quick check of kernel.org memory usage and behaviour
after the recent outage that occurred. I just noticed that slabtop
was reportingi an awfully high usage of radix tree nodes:

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
4200331 2778082  66%    0.55K 144839       29   2317424K radix_tree_node
2321500 2060290  88%    1.00K  72581       32   2322592K xfs_inode
2235648 2069791  92%    0.12K  69864       32    279456K iint_cache

That is, 2.7M radix tree nodes are allocated, and the cache itself
is consuming 2.3GB of RAM. I know that the XFS inodei caches are
indexed by radix tree node, but for 2 million cached inodes that
would mean a density of 1 inode per radix tree node, which for a
system with 16M inodes in the filsystems is an impossibly low
density. The worst I've seen in a production system like kernel.org
is about 20-25% density, which would mean about 150−200k radix tree
nodes for that many inodes. So it's not the inode cache.

There's about 5GB of cached pages, so there's a few hundred thousand
nodes there, but even considering that there's still roughly 2
million nodes unaccounted for.

So I looked up what the iint_cache was. It appears to used for storing
per-inode IMA information, and uses a radix tree for indexing.
It uses the *address* of the struct inode as the indexing key. That
means the key space is extremely sparse - for XFS the struct inode
addresses are approximately 1000 bytes apart, which means the
closest the radix tree index keys get is ~1000. Which means
that there is a single entry per radix tree leaf node, so the radix
tree is using roughly 550 bytes for every 120byte structure being
cached. For the above example, it's probably wasting close to 1GB of
RAM....

IOWs, it looks to me like the choice a a radix tree for indexing the
IMA structures is probably the worst choice that could be made from
a memory usage point of view. Is there any specific reason this
cache uses radix trees, or can it be converted to use btrees or
rbtrees to stop it wasting so much memory?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
