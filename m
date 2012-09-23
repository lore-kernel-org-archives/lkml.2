Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab2IWASU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 20:18:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:57344 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab2IWASS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 20:18:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,469,1344236400"; 
   d="scan'208";a="225351234"
Date: Sun, 23 Sep 2012 08:18:06 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shaun Ruffell <sruffell@digium.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Kim Phillips <kim.phillips@freescale.com>, linux-edac@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] edac_mc: fix messy kfree calls in the error path
Message-ID: <20120923001806.GB8383@localhost>
References: <CA+55aFxMmqG32dJXhUe7N+aS=M1q_5hf7iTfsnPKDU4d610EoQ@mail.gmail.com>
 <20120922005905.GA8335@digium.com>
 <CA+55aFzCzF5DZvR6i=Jg+0abSzN_nbAVr7Ef1dzmR3_NNLWmfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzCzF5DZvR6i=Jg+0abSzN_nbAVr7Ef1dzmR3_NNLWmfw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

coccinelle warns about:

+ drivers/edac/edac_mc.c:429:9-23: ERROR: reference preceded by free on line 429

   421         if (mci->csrows) {
 > 422                 for (chn = 0; chn < tot_channels; chn++) {
   423                         csr = mci->csrows[chn];
   424                         if (csr) {
 > 425                                 for (chn = 0; chn < tot_channels; chn++)
   426                                          kfree(csr->channels[chn]);
   427                                  kfree(csr);
   428                          }
 > 429                          kfree(mci->csrows[i]);
   430                  }
   431                  kfree(mci->csrows);
   432          }

and that code block seem to mess things up in several ways (double free, memory
leak, out-of-bound reads etc.):

L422: The iterator "chn" and bound "tot_channels" are totally wrong. Should be
      "row" and "tot_csrows" respectively. Which means either memory leak, or
      out-of-bound reads (which if does not trigger an immediate page fault
      error, will further lead to kfree() on random addresses).

L425: The inner loop is reusing the same iterator "chn" as the outer loop,
      which could lead to premature end of the outer loop, and hence memory leak.

L429: The array index 'i' in mci->csrows[i] is a temporary value used in
      previous loops, and won't change at all in the current loop. Which
      means either out-of-bound read and possibly kfree(random number), or the
      same mci->csrows[i] get freed once and again, and possibly double free
      for the kfree(csr) in L427.

L426/L427: a kfree(csr->channels) is needed in between to avoid leaking the memory.

The buggy code was introduced by commit de3910eb ("edac: change the mem
allocation scheme to make Documentation/kobject.txt happy") in the 3.6-rc1
merge window. Fix it by freeing up resources in this order: 

  free csrows[i]->channels[j]
  free csrows[i]->channels
  free csrows[i]
  free csrows

CC: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/edac/edac_mc.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- linux.orig/drivers/edac/edac_mc.c	2012-08-12 10:10:38.115520521 +0800
+++ linux/drivers/edac/edac_mc.c	2012-09-23 07:30:40.382206820 +0800
@@ -419,14 +419,16 @@ error:
 		kfree(mci->dimms);
 	}
 	if (mci->csrows) {
-		for (chn = 0; chn < tot_channels; chn++) {
-			csr = mci->csrows[chn];
+		for (row = 0; row < tot_csrows; row++) {
+			csr = mci->csrows[row];
 			if (csr) {
-				for (chn = 0; chn < tot_channels; chn++)
-					kfree(csr->channels[chn]);
+				if (csr->channels) {
+					for (chn = 0; chn < tot_channels; chn++)
+						kfree(csr->channels[chn]);
+					kfree(csr->channels);
+				}
 				kfree(csr);
 			}
-			kfree(mci->csrows[i]);
 		}
 		kfree(mci->csrows);
 	}
