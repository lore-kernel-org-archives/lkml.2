Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab2KLNum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:50:42 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56949 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab2KLNul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:50:41 -0500
MIME-Version: 1.0
Date: Mon, 12 Nov 2012 21:50:40 +0800
Message-ID: <CAPgLHd80RvvGdTKN3aR7dQ_b1S3_pAkMwmGjewc7zgf=4jafcg@mail.gmail.com>
Subject: [PATCH -next] virtio: balloon: fix missing unlock on error in fill_balloon()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: rusty@rustcorp.com.au, mst@redhat.com, aquini@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function fill_balloon()
in the error handling case.

Introduced by 9864a8(virtio_balloon: introduce migration primitives
to balloon pages)

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/virtio/virtio_balloon.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index f70151b..72e8dcb 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -152,8 +152,10 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
 	}
 
 	/* Didn't get any?  Oh well. */
-	if (vb->num_pfns == 0)
+	if (vb->num_pfns == 0) {
+		mutex_unlock(&vb->balloon_lock);
 		return;
+	}
 
 	tell_host(vb, vb->inflate_vq);
 	mutex_unlock(&vb->balloon_lock);


