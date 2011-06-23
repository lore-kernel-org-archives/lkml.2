Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774Ab1FWRi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:38:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:35473 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933756Ab1FWRiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:23 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Peter Holik <peter@holik.at>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 214/247] USB: uss720 fixup refcount position
Date: Thu, 23 Jun 2011 13:34:42 -0400
Message-Id: <1308850515-15242-155-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Holik <peter@holik.at>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit adaa3c6342b249548ea830fe8e02aa5b45be8688 upstream.

My testprog do a lot of bitbang - after hours i got following warning and my machine lockups:
WARNING: at /build/buildd/linux-2.6.38/lib/kref.c:34
After debugging uss720 driver i discovered that the completion callback was called before
usb_submit_urb returns. The callback frees the request structure that is krefed on return by
usb_submit_urb.

Signed-off-by: Peter Holik <peter@holik.at>
Acked-by: Thomas Sailer <t.sailer@alumni.ethz.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/misc/uss720.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index 4ff2158..9727daa 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -177,12 +177,11 @@ static struct uss720_async_request *submit_async_request(struct parport_uss720_p
 	spin_lock_irqsave(&priv->asynclock, flags);
 	list_add_tail(&rq->asynclist, &priv->asynclist);
 	spin_unlock_irqrestore(&priv->asynclock, flags);
+	kref_get(&rq->ref_count);
 	ret = usb_submit_urb(rq->urb, mem_flags);
-	if (!ret) {
-		kref_get(&rq->ref_count);
+	if (!ret)
 		return rq;
-	}
-	kref_put(&rq->ref_count, destroy_async);
+	destroy_async(&rq->ref_count);
 	err("submit_async_request submit_urb failed with %d", ret);
 	return NULL;
 }
-- 
1.7.4.4

