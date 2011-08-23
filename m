Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab1HWI4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:56:47 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:43797 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754538Ab1HWI4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:56:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloEAN5pU055LIxDgWdsb2JhbABBmQ2PGhUBARYmJYIdIxiBAgO/fYZIBJgmi38
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, khlebnikov@openvz.org
Subject: [PATCH 00/12] RFC: shrinker APi rework and generic LRU lists
Date: Tue, 23 Aug 2011 18:56:13 +1000
Message-Id: <1314089786-20535-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is a current work in progress: 

	- cleans up the shrinker API, fixes a couple of warts and converts all
	  the shrinkers to us it,
	- makes the inode slab cache initialisation consistent across all inode
	  caches,
	- introduces a generic LRU list type and infrstructure
	- converts inode cache to use lru list infrastructure
	- convert xfs buffer cache to use lru list infrastructure
	- converts the dentry cache LRU to per-sb
	- fixes dcache select_parent() use-the-lru-for-disposal abuse
	- makes the dcache consistent about removing inodes from the LRU before
	  disposal of them
	- converts the dentry cache to use lru list infrastructure

The basic concept here is to fix the shrinker API to be somewhat
sane and convert the main slab cache LRUs in the system to use
generic infrastructure. Both the detry and inode caches use LRU
implementations that are almost-but-not-quite the same. There is no
reason for them to be different - it's only the fact that the dentry
cache LRU has been used in for disposal purposes rather than using
dispose lists.

The dentry caceh dispose list also has a problem as a result of the
RCU-ifying of the code - the dispose list is implicitly protected by
the LRU lock, and actaully forms a disjoint part of the LRU as
dentries on the dispose list are still accounted to the LRU and
require a call to dentry_lru_del() to remove from the dispose list
and correct the LRU accounting. THis only works when there is a
single LRU lock - if the dispose list is made upof dentries
protected by different LRU locks, then it fails with list corruption
pretty quickly. This is another reason for moving to the same
strategy as the inode cache, where inodes are completely removed
form thr LRU before being placed on the dispose list....

In case it is not obvious, this is all preparatory work for making
the LRUs and shrinkers node aware. The new generic LRU lists can be
trivially converted to be node aware, and with the addition of node
masks to the struct shrink_control propagated from shrink_slab() we
can easily extend all these caches to have node aware reclaim. We
will then have a generic node-aware LRU implementation that all
subsystems can use to play well with memory reclaim on large NUMA
machines...

