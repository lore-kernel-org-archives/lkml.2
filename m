Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161364Ab1FAJ1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:27:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:43260 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161307Ab1FAIIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:08:43 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:02:56 2011
Message-Id: <20110601080255.766038513@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:24 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <jaxboe@fusionio.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [028/146] block: add proper state guards to __elv_next_request
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <James.Bottomley@suse.de>

commit 0a58e077eb600d1efd7e54ad9926a75a39d7f8ae upstream.

blk_cleanup_queue() calls elevator_exit() and after this, we can't
touch the elevator without oopsing.  __elv_next_request() must check
for this state because in the refcounted queue model, we can still
call it after blk_cleanup_queue() has been called.

This was reported as causing an oops attributable to scsi.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/block/blk.h
+++ b/block/blk.h
@@ -68,7 +68,8 @@ static inline struct request *__elv_next
 				return rq;
 		}
 
-		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
+		if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags) ||
+		    !q->elevator->ops->elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
 }


