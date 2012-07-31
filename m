Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab2GaFBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 01:01:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49054 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755173Ab2GaFBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 01:01:45 -0400
Message-Id: <20120731044322.991037328@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:44:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Mason <chris.mason@fusionio.com>
Subject: [ 72/73] Btrfs: call the ordered free operation without any locks held
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <chris.mason@fusionio.com>

commit e9fbcb42201c862fd6ab45c48ead4f47bb2dea9d upstream.

Each ordered operation has a free callback, and this was called with the
worker spinlock held.  Josef made the free callback also call iput,
which we can't do with the spinlock.

This drops the spinlock for the free operation and grabs it again before
moving through the rest of the list.  We'll circle back around to this
and find a cleaner way that doesn't bounce the lock around so much.

Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/async-thread.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 4270414..58b7d14 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -206,10 +206,17 @@ static noinline void run_ordered_completions(struct btrfs_workers *workers,
 
 		work->ordered_func(work);
 
-		/* now take the lock again and call the freeing code */
+		/* now take the lock again and drop our item from the list */
 		spin_lock(&workers->order_lock);
 		list_del(&work->order_list);
+		spin_unlock(&workers->order_lock);
+
+		/*
+		 * we don't want to call the ordered free functions
+		 * with the lock held though
+		 */
 		work->ordered_free(work);
+		spin_lock(&workers->order_lock);
 	}
 
 	spin_unlock(&workers->order_lock);


