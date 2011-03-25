Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260Ab1CZAQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:16:59 -0400
Received: from kroah.org ([198.145.64.141]:41815 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489Ab1CYXwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:53 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:42 2011
Message-Id: <20110325234842.850501156@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:47:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Holik <peter@holik.at>, Thomas Sailer <t.sailer@alumni.ethz.ch>
Subject: [37/55] USB: uss720 fixup refcount position
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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
@@ -177,12 +177,11 @@ static struct uss720_async_request *subm
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


