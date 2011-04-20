Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1DTNWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:22:18 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:56211 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1DTNWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UabVHeDckZHxo32yE6LneSqp03jmmtdzqdf//2iOdero3FqhBCYLSTZclnZ2RpCKyT
         wv2Scxa8fAn3hv2Xi/sS+b+QLgsVKzX4jwFA1qLnD9gldJWHR8JuGqM2V1TX/QYYpRuk
         RORN0sNKUtd+Y1EzReZL2IPUHPDDAuw9D4E0c=
From: Liu Yuan <namei.unix@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] driver, virtio: Modify the err hanlding logic
Date: Wed, 20 Apr 2011 21:21:59 +0800
Message-Id: <1303305719-4475-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

In the function vp_request_msix_vectors(), when
pci_enable_msix() returns 0, there will be
redundant double checks for 'err'. This patch
fixes it to avoid the unnecessary check.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 drivers/virtio/virtio_pci.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 4fb5b2b..2c05376 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -298,10 +298,11 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
 
 	/* pci_enable_msix returns positive if we can't get this many. */
 	err = pci_enable_msix(vp_dev->pci_dev, vp_dev->msix_entries, nvectors);
-	if (err > 0)
-		err = -ENOSPC;
-	if (err)
+	if (err) {
+		if (err > 0)
+			err = -ENOSPC;
 		goto error;
+	}
 	vp_dev->msix_vectors = nvectors;
 	vp_dev->msix_enabled = 1;
 
-- 
1.7.1

