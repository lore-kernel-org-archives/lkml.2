Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030246Ab2JSC4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:56:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:52464 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757425Ab2JSCtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 60/76] drm/nouveau/bios: fix shadowing of ACPI ROMs larger than 64KiB
Date: Thu, 18 Oct 2012 19:47:24 -0700
Message-Id: <20121019024359.774396402@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 9a334cd0de2f43b29c192548000692bad52edfc6 upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_bios.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_bios.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
@@ -196,24 +196,22 @@ static void
 bios_shadow_acpi(struct nvbios *bios)
 {
 	struct pci_dev *pdev = bios->dev->pdev;
-	int cnt = 65536 / ROM_BIOS_PAGE;
-	int ret;
+	int ret, cnt, i;
+	u8  data[3];
 
 	if (!nouveau_acpi_rom_supported(pdev))
 		return;
 
-	bios->data = kmalloc(cnt * ROM_BIOS_PAGE, GFP_KERNEL);
-	if (!bios->data)
-		return;
-
 	bios->length = 0;
-	while (cnt--) {
-		ret = nouveau_acpi_get_bios_chunk(bios->data, bios->length,
-						  ROM_BIOS_PAGE);
-		if (ret != ROM_BIOS_PAGE)
-			return;
+	if (nouveau_acpi_get_bios_chunk(data, 0, 3) == 3)
+		bios->length = data[2] * 512;
 
-		bios->length += ROM_BIOS_PAGE;
+	bios->data = kmalloc(bios->length, GFP_KERNEL);
+	for (i = 0; bios->data && i < bios->length; i += cnt) {
+		cnt = min((bios->length - i), (u32)4096);
+		ret = nouveau_acpi_get_bios_chunk(bios->data, i, cnt);
+		if (ret != cnt)
+			break;
 	}
 }
 


