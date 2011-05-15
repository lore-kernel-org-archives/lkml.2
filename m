Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080Ab1EOWV0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 18:21:26 -0400
Received: from mout.perfora.net ([74.208.4.194]:51225 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761295Ab1EOWVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 18:21:20 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH v2 0/9] avoid allocation in show_numa_map()
Date: Sun, 15 May 2011 18:20:20 -0400
Message-Id: <1305498029-11677-1-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.4.4
X-Provags-ID: V02:K0:Cbq10bCDwk79I6x+kKtmChoBcpd8SlAk2Ve95bkYti9
 2g+AE4KInnjYA24vEeC8fJiwybfRKZDJbdJyccwad1m8QE179Q
 ewkPrV92DIbQXLYb/rPDQumSFH2D6iKhrmdfzRzTykqAePrXBK
 jr75nc+x/7ecB2Aqr8LlRdl+xWq77eHBjKQkOm+2fZD2Opp8+1
 JnEJ3ysWux9pDSWtpTHRQKw6kB9SFtEK5Doq3VtXVE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is version 2 of a patch series[1] aimed at removing repeated
allocation/free cycles happening in show_numa_maps() while we hold a reference
to an mm.  The concern is that performing an allocation while referencing an mm
could lead to a stalemate in the oom killer as previously explained by Hugh
Dickins[2].

This series addresses all issues raised in the previous round and is organized
as follows:

Patches 1-6 convert show_numa_maps() to use the generic walk_page_range()
functionality instead of the mempolicy.c specific page table walking logic.
Also, get_vma_policy() and mpol_to_str() are exported.  This makes the
show_numa_maps() implementation independent of mempolicy.c.

Patch 7 moves show_numa_maps() and supporting routines over to
fs/proc/task_mmu.c.

Finally, patches 8 and 9 provide minor cleanup and eliminate the troublesome
allocation.


These patches are based on mmotm-2011-05-12-15-52 and have been tested on a
dual node NUMA machine.


Thanks,

--
steve

[1] http://lkml.org/lkml/2011/4/27/578
[2] http://lkml.org/lkml/2011/4/25/496


Changes since v1:
	- Fix compilation error when CONFIG_TMPFS=n.

	- Traverse pte's with proper locking and checks.


Stephen Wilson (9):
      mm: export get_vma_policy()
      mm: use walk_page_range() instead of custom page table walking code
      mm: remove MPOL_MF_STATS
      mm: make gather_stats() type-safe and remove forward declaration
      mm: remove check_huge_range()
      mm: declare mpol_to_str() when CONFIG_TMPFS=n
      mm: proc: move show_numa_map() to fs/proc/task_mmu.c
      proc: make struct proc_maps_private truly private
      proc: allocate storage for numa_maps statistics once


 fs/proc/internal.h        |    7 ++
 fs/proc/task_mmu.c        |  204 ++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/mempolicy.h |    7 +-
 include/linux/proc_fs.h   |    8 --
 mm/mempolicy.c            |  164 +-----------------------------------
 5 files changed, 215 insertions(+), 175 deletions(-)

