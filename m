Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab1D3OBw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 10:01:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50652 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754622Ab1D3OBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 10:01:46 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+E4vM4x8iEnlwpsPLusatN4zKa1sm2g+EauT8720
	9Ypwzlo/Y8ZdK6
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/3] viafb: try to map less memory in case of failure
Date: Sat, 30 Apr 2011 14:18:05 +0000
Message-Id: <1304173086-3434-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1304173086-3434-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1304173086-3434-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code might result in trying to remap 512MB video ram on
a 32 bit system which is quite likely to fail.
This patch tries to map less of it down to 8MB as this should still
be enough to get a reasonably well working framebuffer. This should
make viafb work for many people without requiring them to manually
allocate more space.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/via-core.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index 5b0129b..eb112b6 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -505,7 +505,14 @@ static int __devinit via_pci_setup_mmio(struct viafb_dev *vdev)
 	ret = vdev->fbmem_len = viafb_get_fb_size_from_pci(vdev->chip_type);
 	if (ret < 0)
 		goto out_unmap;
-	vdev->fbmem = ioremap_wc(vdev->fbmem_start, vdev->fbmem_len);
+
+	/* try to map less memory on failure, 8 MB should be still enough */
+	for (; vdev->fbmem_len >= 8 << 20; vdev->fbmem_len /= 2) {
+		vdev->fbmem = ioremap_wc(vdev->fbmem_start, vdev->fbmem_len);
+		if (vdev->fbmem)
+			break;
+	}
+
 	if (vdev->fbmem == NULL) {
 		ret = -ENOMEM;
 		goto out_unmap;
-- 
1.6.3.2

