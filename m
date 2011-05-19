Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934797Ab1ESVBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:01:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46288 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933993Ab1ESVBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:01:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ZUUXLGxEn//6ttsQkxTUGAg0cRr/1YE06iS45cfbgxpb7BmUjsFFUyg1MvkP290y/u
         i8p6J7BBqaJe2Pw2SUO0642sSq5karVvlVnQt8Or273u4zgEQXfeGTxnPynWIjFzApH0
         nRpHzKTL0VHNLcqTmUkjP8mWXVP04oqc5SCzw=
Subject: [PATCH] eisa: do not force probe if cannot allocate resource on
 mainboard
From: Eduardo Silva <edsiper@gmail.com>
To: Marc Zyngier <maz@wild-wind.fr.eu.org>, Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 16:52:36 -0400
Message-ID: <1305838356.5272.5.camel@monotop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if the eisa_probe() function fails to allocate resource for the
mainboard in question, it performs a force probe over the available
slots and print all fails in the logs. e.g:

[    1.264550] EISA: Cannot allocate resource for mainboard
[    1.264552] Cannot allocate resource for EISA slot 1
[    1.264554] Cannot allocate resource for EISA slot 2
[    1.264556] Cannot allocate resource for EISA slot 3
[    1.264557] Cannot allocate resource for EISA slot 4
[    1.264559] Cannot allocate resource for EISA slot 5
[    1.264561] Cannot allocate resource for EISA slot 6
[    1.264563] Cannot allocate resource for EISA slot 7
[    1.264564] Cannot allocate resource for EISA slot 8
[    1.264566] EISA: Detected 0 cards.

The force probe for this specific condition always fails. The
patch make it to skip the force probe and print a more detailed ending
message to the log adding the number available slots:

[    1.264550] EISA: Cannot allocate resource for mainboard
[    1.264566] EISA: Detected 0 cards in 8 slots.

Signed-off-by: Eduardo Silva <edsiper@gmail.com>
---
 drivers/eisa/eisa-bus.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/eisa/eisa-bus.c b/drivers/eisa/eisa-bus.c
index 806c77b..1cf37e0 100644
--- a/drivers/eisa/eisa-bus.c
+++ b/drivers/eisa/eisa-bus.c
@@ -312,7 +312,7 @@ static void __init eisa_release_resources(struct eisa_device *edev)
 
 static int __init eisa_probe(struct eisa_root_device *root)
 {
-        int i, c;
+        int i, c = 0;
 	struct eisa_device *edev;
 
 	printk(KERN_INFO "EISA: Probing bus %d at %s\n",
@@ -333,7 +333,7 @@ static int __init eisa_probe(struct eisa_root_device *root)
 		kfree(edev);
 		if (!root->force_probe)
 			return -EBUSY;
-		goto force_probe;
+		goto out;
 	}
 
 	if (eisa_init_device(root, edev, 0)) {
@@ -355,7 +355,7 @@ static int __init eisa_probe(struct eisa_root_device *root)
 	
  force_probe:
 	
-        for (c = 0, i = 1; i <= root->slots; i++) {
+        for (i = 1; i <= root->slots; i++) {
 		edev = kzalloc(sizeof(*edev), GFP_KERNEL);
 		if (!edev) {
 			printk(KERN_ERR "EISA: Out of memory for slot %d\n", i);
@@ -405,7 +405,9 @@ static int __init eisa_probe(struct eisa_root_device *root)
 		}
         }
 
-	printk(KERN_INFO "EISA: Detected %d card%s.\n", c, c == 1 ? "" : "s");
+ out:
+	printk(KERN_INFO "EISA: Detected %d card%s in %d slots.\n", c,
+	       c == 1 ? "" : "s", root->slots);
 
 	return 0;
 }
-- 
1.7.4.1




