Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab1C3VtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:49:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:48774 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933467Ab1C3VHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133230"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: namhyung@gmail.com, efault@gmx.de, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, mingo@elte.hu, dhaval.giani@gmail.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [109/275] kernel/user.c: add lock release annotation on free_user()
Message-Id: <20110330210548.6BD753E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@gmail.com>

commit 571428be550fbe37160596995e96ad398873fcbd upstream.

free_user() releases uidhash_lock but was missing annotation.  Add it.
This removes following sparse warnings:

 include/linux/spinlock.h:339:9: warning: context imbalance in 'free_user' - unexpected unlock
 kernel/user.c:120:6: warning: context imbalance in 'free_uid' - wrong count at exit

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval.giani@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 kernel/user.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/kernel/user.c
===================================================================
--- linux-2.6.35.y.orig/kernel/user.c	2011-03-29 22:51:25.263076751 -0700
+++ linux-2.6.35.y/kernel/user.c	2011-03-29 23:03:00.463288316 -0700
@@ -91,6 +91,7 @@
  * upon function exit.
  */
 static void free_user(struct user_struct *up, unsigned long flags)
+	__releases(&uidhash_lock)
 {
 	uid_hash_remove(up);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
