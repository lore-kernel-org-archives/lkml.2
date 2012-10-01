Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab2JAXeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:34:19 -0400
Received: from 1wt.eu ([62.212.114.60]:35132 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757551Ab2JAXAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:20 -0400
Message-Id: <20121001225202.182593652@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 108/180] Btrfs: call the ordered free operation without any locks held
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/btrfs/async-thread.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index c0861e7..8aac2d6 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -211,10 +211,17 @@ static noinline int run_ordered_completions(struct btrfs_workers *workers,
 
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
-- 
1.7.2.1.45.g54fbc



