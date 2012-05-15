Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965089Ab2EOCyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:54:31 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53347 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054Ab2EOCRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:11 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 088/179] cfq-iosched: fix locking around ioc->ioc_data assignment
Date: Mon, 14 May 2012 22:13:04 -0400
Message-ID: <1337048075-6132-89-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jaxboe@fusionio.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit ab4bd22d3cce6977dc039664cc2d052e3147d662 upstream.

Since we are modifying this RCU pointer, we need to hold
the lock protecting it around it.

This fixes a potential reuse and double free of a cfq
io_context structure. The bug has been in CFQ for a long
time, it hit very few people but those it did hit seemed
to see it a lot.

Tracked in RH bugzilla here:

https://bugzilla.redhat.com/show_bug.cgi?id=577968

Credit goes to Paul Bolle for figuring out that the issue
was around the one-hit ioc->ioc_data cache. Thanks to his
hard work the issue is now fixed.

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 block/cfq-iosched.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4fab7c9..510552a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2559,8 +2559,11 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
 	cic->dead_key = (unsigned long) cic->key;
 	cic->key = NULL;
 
-	if (ioc->ioc_data == cic)
+	if (rcu_dereference(ioc->ioc_data) == cic) {
+		spin_lock(&ioc->lock);
 		rcu_assign_pointer(ioc->ioc_data, NULL);
+		spin_unlock(&ioc->lock);
+	}
 
 	if (cic->cfqq[BLK_RW_ASYNC]) {
 		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);
-- 
1.7.9.6

