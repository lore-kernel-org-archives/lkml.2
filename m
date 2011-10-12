Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1JLVXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 17:23:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab1JLVXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 17:23:00 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: tj@kernel.org, christophe@saout.de, dm-devel@redhat.com,
        msnitzer@redhat.com, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 2/2] blk-flush: fix invalid BUG_ON in blk_insert_flush
Date: Wed, 12 Oct 2011 17:22:42 -0400
Message-Id: <1318454562-25291-3-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1318454562-25291-1-git-send-email-jmoyer@redhat.com>
References: <1318454562-25291-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A user reported a regression due to commit
4853abaae7e4a2af938115ce9071ef8684fb7af4 (block: fix flush
machinery for stacking drivers with differring flush flags).
Part of the problem is that blk_insert_flush required a
single bio be attached to the request.  In reality, having
no attached bio is also a valid case, as can be observed with
an empty flush.

[1] http://www.redhat.com/archives/dm-devel/2011-September/msg00154.html

Reported-by: Christophe Saout <christophe@saout.de>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 block/blk-flush.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 0ff29c6..720ad60 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -320,7 +320,7 @@ void blk_insert_flush(struct request *rq)
 		return;
 	}
 
-	BUG_ON(!rq->bio || rq->bio != rq->biotail);
+	BUG_ON(rq->bio != rq->biotail); /*assumes zero or single bio rq */
 
 	/*
 	 * If there's data but flush is not necessary, the request can be
-- 
1.7.1

