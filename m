Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab1DYUZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:25:46 -0400
Received: from 1wt.eu ([62.212.114.60]:34618 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512Ab1DYUZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:39 -0400
Message-Id: <20110425200237.773652637@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Peter Holik <peter@holik.at>, Thomas Sailer <t.sailer@alumni.ethz.ch>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 110/173] USB: uss720 fixup refcount position
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Holik <peter@holik.at>

commit adaa3c6342b249548ea830fe8e02aa5b45be8688 upstream.

My testprog do a lot of bitbang - after hours i got following warning and my machine lockups:
WARNING: at /build/buildd/linux-2.6.38/lib/kref.c:34
After debugging uss720 driver i discovered that the completion callback was called before
usb_submit_urb returns. The callback frees the request structure that is krefed on return by
usb_submit_urb.

Signed-off-by: Peter Holik <peter@holik.at>
Acked-by: Thomas Sailer <t.sailer@alumni.ethz.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/misc/uss720.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -176,12 +176,11 @@ static struct uss720_async_request *subm
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


