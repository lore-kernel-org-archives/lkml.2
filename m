Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783Ab0G3R5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:57:39 -0400
Received: from kroah.org ([198.145.64.141]:58687 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932511Ab0G3R4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:21 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:43 2010
Message-Id: <20100730175143.447230105@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [106/205] virtio: fix oops on OOM
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

commit 1fe9b6fef11771461e69ecd1bc8935a1c7c90cb5 upstream.

virtio ring was changed to return an error code on OOM,
but one caller was missed and still checks for vq->vring.num.
The fix is just to check for <0 error code.

Long term it might make sense to change goto add_head to
just return an error on oom instead, but let's apply
a minimal fix for 2.6.35.

Reported-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/virtio/virtio_ring.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -162,7 +162,8 @@ static int vring_add_buf(struct virtqueu
 			 void *data)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
-	unsigned int i, avail, head, uninitialized_var(prev);
+	unsigned int i, avail, uninitialized_var(prev);
+	int head;
 
 	START_USE(vq);
 
@@ -172,7 +173,7 @@ static int vring_add_buf(struct virtqueu
 	 * buffers, then go indirect. FIXME: tune this threshold */
 	if (vq->indirect && (out + in) > 1 && vq->num_free) {
 		head = vring_add_indirect(vq, sg, out, in);
-		if (head != vq->vring.num)
+		if (likely(head >= 0))
 			goto add_head;
 	}
 


