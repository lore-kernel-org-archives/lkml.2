Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0INXLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:11:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:58452 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335Ab0INXLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:11:41 -0400
Date: Wed, 15 Sep 2010 09:11:18 +1000
From: Neil Brown <neilb@suse.de>
To: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Wu@suse.de,
        "Fengguang <fengguang.wu"@intel.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Deadlock possibly caused by too_many_isolated.
Message-ID: <20100915091118.3dbdc961@notabene>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

 I recently had a customer (running 2.6.32) report a deadlock during very
 intensive IO with lots of processes.

 Having looked at the stack traces, my guess as to the problem is this:

  There are enough threads in direct_reclaim that too_many_isolated() is
  returning true, and so some threads are blocked in shrink_inactive_list.

  Those threads that are not blocked there are attempting to do filesystem
  writeout.  But that is blocked because...

  Some threads that are blocked there, hold some IO lock (probably in the 
  filesystem) and are trying to allocate memory inside the block device
  (md/raid1 to be precise) which is allocating with GFP_NOIO and has a
  mempool to fall back on.
  As these threads don't have __GFP_IO set, they should not really be blocked
  both other threads that are doing IO.  But it seems they are.


  So I'm wondering if the loop in shrink_inactive_list should abort
  if __GFP_IO is not set ... and maybe if __GFP_FS is not set too???

  Below is a patch that I'm asking the customer to test.

  If anyone can point out a flaw in my reasoning, suggest any other
  alternatives, provide a better patch, or otherwise help me out here, I
  would greatly appreciate it.

  (I sent this email to the people mentioned in commit:
      commit 35cd78156c499ef83f60605e4643d5a98fef14fd
      Author: Rik van Riel <riel@redhat.com>
      Date:   Mon Sep 21 17:01:38 2009 -0700

          vmscan: throttle direct reclaim when too many pages are isolated already
  
   plus the obvious mail lists)

Thanks,
NeilBrown

Index: linux-2.6.32-SLE11-SP1/mm/vmscan.c
===================================================================
--- linux-2.6.32-SLE11-SP1.orig/mm/vmscan.c	2010-09-15 08:37:32.000000000 +1000
+++ linux-2.6.32-SLE11-SP1/mm/vmscan.c	2010-09-15 08:38:57.000000000 +1000
@@ -1106,6 +1106,11 @@ static unsigned long shrink_inactive_lis
 		/* We are about to die and free our memory. Return now. */
 		if (fatal_signal_pending(current))
 			return SWAP_CLUSTER_MAX;
+		if (!(sc->gfp_mask & __GFP_IO))
+			/* Not allowed to do IO, so mustn't wait
+			 * on processes that might try to
+			 */
+			return SWAP_CLUSTER_MAX;
 	}
 
 	/*
