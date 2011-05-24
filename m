Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab1EXDTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 23:19:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49901 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab1EXDTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 23:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TJlaOd4X72COpsISDKeXLn1wgJMDJvd+fhf/HOvah7eQPtu857hdjXl7qWbAPjiia7
         5nXnNKpVoGJtpaTpgUzHjdXzgE6DvXSb4vYlZDQ5+OGU0Rtb4PAgSgmUwF4lR0t2H7gf
         i3QZ/s4gHpw4WqFf9g0aRTFl9S1eV9w/IxCcE=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] cfq-iosched: free cic_index if cfqd allocation fails
Date: Tue, 24 May 2011 12:18:51 +0900
Message-Id: <1306207131-2296-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306207131-2296-1-git-send-email-namhyung@gmail.com>
References: <1306207131-2296-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When struct cfq_data allocation fails, cic_index need to be freed.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 block/cfq-iosched.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4ceebd346710..7fe732a274b2 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3881,8 +3881,12 @@ static void *cfq_init_queue(struct request_queue *q)
 		return NULL;
 
 	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
-	if (!cfqd)
+	if (!cfqd) {
+		spin_lock(&cic_index_lock);
+		ida_remove(&cic_index_ida, i);
+		spin_unlock(&cic_index_lock);
 		return NULL;
+	}
 
 	/*
 	 * Don't need take queue_lock in the routine, since we are
-- 
1.7.5.2

