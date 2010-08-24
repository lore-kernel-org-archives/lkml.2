Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab0HXXIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:08:14 -0400
Received: from kroah.org ([198.145.64.141]:32830 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933675Ab0HXXDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:35 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:09 2010
Message-Id: <20100824224509.777887272@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marek Lindner <lindner_marek@yahoo.de>,
        Sven Eckelmann <sven.eckelmann@gmx.de>
Subject: [098/114] Staging: batman-adv: unify orig_hash_lock spinlock handling to avoid deadlocks
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marek Lindner <lindner_marek@yahoo.de>

commit 9abc10238e1df7ce81c58a441f65efd5e905b9e8 upstream.

The orig_hash_lock spinlock always has to be locked with IRQs being
disabled to avoid deadlocks between code that is being executed in
IRQ context and code that is being executed in non-IRQ context.

Reported-by: Sven Eckelmann <sven.eckelmann@gmx.de>
Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
Signed-off-by: Sven Eckelmann <sven.eckelmann@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/batman-adv/originator.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/staging/batman-adv/originator.c
+++ b/drivers/staging/batman-adv/originator.c
@@ -401,11 +401,12 @@ static int orig_node_add_if(struct orig_
 int orig_hash_add_if(struct batman_if *batman_if, int max_if_num)
 {
 	struct orig_node *orig_node;
+	unsigned long flags;
 	HASHIT(hashit);
 
 	/* resize all orig nodes because orig_node->bcast_own(_sum) depend on
 	 * if_num */
-	spin_lock(&orig_hash_lock);
+	spin_lock_irqsave(&orig_hash_lock, flags);
 
 	while (hash_iterate(orig_hash, &hashit)) {
 		orig_node = hashit.bucket->data;
@@ -414,11 +415,11 @@ int orig_hash_add_if(struct batman_if *b
 			goto err;
 	}
 
-	spin_unlock(&orig_hash_lock);
+	spin_unlock_irqrestore(&orig_hash_lock, flags);
 	return 0;
 
 err:
-	spin_unlock(&orig_hash_lock);
+	spin_unlock_irqrestore(&orig_hash_lock, flags);
 	return -ENOMEM;
 }
 
@@ -480,12 +481,13 @@ int orig_hash_del_if(struct batman_if *b
 {
 	struct batman_if *batman_if_tmp;
 	struct orig_node *orig_node;
+	unsigned long flags;
 	HASHIT(hashit);
 	int ret;
 
 	/* resize all orig nodes because orig_node->bcast_own(_sum) depend on
 	 * if_num */
-	spin_lock(&orig_hash_lock);
+	spin_lock_irqsave(&orig_hash_lock, flags);
 
 	while (hash_iterate(orig_hash, &hashit)) {
 		orig_node = hashit.bucket->data;
@@ -512,10 +514,10 @@ int orig_hash_del_if(struct batman_if *b
 	rcu_read_unlock();
 
 	batman_if->if_num = -1;
-	spin_unlock(&orig_hash_lock);
+	spin_unlock_irqrestore(&orig_hash_lock, flags);
 	return 0;
 
 err:
-	spin_unlock(&orig_hash_lock);
+	spin_unlock_irqrestore(&orig_hash_lock, flags);
 	return -ENOMEM;
 }


