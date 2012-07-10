Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab2GJFt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 01:49:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33452 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab2GJFtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 01:49:25 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Teddy Wang <teddy.wang@siliconmotion.com.cn>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 2/2] staging/sm7xxfb: return a proper err for smtc_alloc_fb_info failure
Date: Tue, 10 Jul 2012 11:19:15 +0530
Message-Id: <1341899355-17387-2-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341899355-17387-1-git-send-email-devendra.aaru@gmail.com>
References: <1341899355-17387-1-git-send-email-devendra.aaru@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as smtc_alloc_fb_info can fail, but we are returning the 0,
how? because the pci_enable_device succeeded, which makes the probe
return 0, and may cause panics or some strange problems at remove
when driver unloaded by modprobe -r.

so return err properly as smtc_alloc_fb_info is doing kzallocs its
good to do -ENOMEM

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 0c0b603..7395196 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -808,8 +808,10 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 
 	sfb = smtc_alloc_fb_info(pdev, name);
 
-	if (!sfb)
+	if (!sfb) {
+		err = -ENOMEM;
 		goto failed_free;
+	}
 
 	sfb->chip_id = ent->device;
 	sprintf(name, "sm%Xfb", sfb->chip_id);
-- 
1.7.9.5

