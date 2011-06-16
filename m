Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab1FPHKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:10:18 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35123 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756555Ab1FPHKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:10:10 -0400
X-Sasl-enc: Xyczqrmmz+R3N9EnZAQLePv3DZOGY7vk8pD/Lf1YsEnz 1308208209
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:04 2011
Message-Id: <20110616002904.475274846@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [07/85] block: add proper state guards to __elv_next_request
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -62,7 +62,8 @@ static inline struct request *__elv_next
 				return rq;
 		}
 
-		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
+		if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags) ||
+		    !q->elevator->ops->elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
 }


