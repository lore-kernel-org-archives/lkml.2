Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab2IFPYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:24:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62616 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab2IFPYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:24:19 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/14] drivers/media/v4l2-core/videobuf2-core.c: fix error return code
Date: Thu,  6 Sep 2012 17:23:57 +0200
Message-Id: <1346945041-26676-10-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/v4l2-core/videobuf2-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 4da3df6..f6bc240 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1876,8 +1876,10 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 */
 	for (i = 0; i < q->num_buffers; i++) {
 		fileio->bufs[i].vaddr = vb2_plane_vaddr(q->bufs[i], 0);
-		if (fileio->bufs[i].vaddr == NULL)
+		if (fileio->bufs[i].vaddr == NULL) {
+			ret = -EFAULT;
 			goto err_reqbufs;
+		}
 		fileio->bufs[i].size = vb2_plane_size(q->bufs[i], 0);
 	}
 

