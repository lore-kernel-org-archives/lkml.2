Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab2LRQZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:25:49 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:49768 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab2LRQZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:25:47 -0500
X-Greylist: delayed 1556 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 11:25:47 EST
From: Daniel J Blueman <daniel@quora.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Daniel J Blueman <daniel@quora.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] HDA: Fix sound resume hang
Date: Tue, 18 Dec 2012 23:59:33 +0800
Message-Id: <1355846373-3057-1-git-send-email-daniel@quora.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resuming a switcheroo'd HDA controller hangs since the completion
is one-shot (thus works the first time). Fix by using completions
that explictly need rearming, so remain fired before.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 sound/pci/hda/hda_intel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 22ecadc..e12b939 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2856,7 +2856,7 @@ static int azx_free(struct azx *chip)
 	azx_notifier_unregister(chip);
 
 	chip->init_failed = 1; /* to be sure */
-	complete(&chip->probe_wait);
+	complete_all(&chip->probe_wait);
 
 	if (use_vga_switcheroo(chip)) {
 		if (chip->disabled && chip->bus)
@@ -3482,7 +3482,7 @@ static int __devinit azx_probe(struct pci_dev *pci,
 		pm_runtime_put_noidle(&pci->dev);
 
 	dev++;
-	complete(&chip->probe_wait);
+	complete_all(&chip->probe_wait);
 	return 0;
 
 out_free:
-- 
1.7.10.4

