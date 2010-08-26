Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab0ICVtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:49:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52205 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757683Ab0ICVtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:49:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hID1v2Uu4wlUHccQBeONbPxfqYCBDvALcJGVM0alFaExipfeTYoaTnB70bwfEmZ9vs
         +a6KvyHIovRLKnBioiQsop9svIp0VIclBv8Pjzc3O3neU1hp1/VZtefyUH1ftshSX4xA
         kyM/vtuJ1Ws57LmlWhxSUQ6TRVsF+AmgYf+ns=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH v2 4/6] ARM: pxa27x_keypad: added wakeup event handler for keypad interrupts
Date: Thu, 26 Aug 2010 11:27:35 -0400
Message-Id: <1282836457-5651-5-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282836457-5651-1-git-send-email-mark.brown314@gmail.com>
References: <1282836457-5651-1-git-send-email-mark.brown314@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mach-mmp needs to clear wake event in order to clear the keypad interrupt

Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
---
 arch/arm/plat-pxa/include/plat/pxa27x_keypad.h |    1 +
 drivers/input/keyboard/pxa27x_keypad.c         |   10 ++++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h b/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
index 7b4eadc..73dacda 100644
--- a/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
+++ b/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
@@ -52,6 +52,7 @@ struct pxa27x_keypad_platform_data {
 
 	/* key debounce interval */
 	unsigned int	debounce_interval;
+	void		(*clear_wakeup_event)(void);
 };
 
 extern void pxa_set_keypad_info(struct pxa27x_keypad_platform_data *info);
diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index 0610d10..b36d2be 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -330,11 +330,21 @@ static void pxa27x_keypad_scan_direct(struct pxa27x_keypad *keypad)
 	keypad->direct_key_state = new_state;
 }
 
+static void clear_wakeup_event(struct pxa27x_keypad *keypad)
+{
+	struct pxa27x_keypad_platform_data *pdata = keypad->pdata;
+
+	if (pdata->clear_wakeup_event)
+		(pdata->clear_wakeup_event)();
+}
+
 static irqreturn_t pxa27x_keypad_irq_handler(int irq, void *dev_id)
 {
 	struct pxa27x_keypad *keypad = dev_id;
 	unsigned long kpc = keypad_readl(KPC);
 
+	clear_wakeup_event(keypad);
+
 	if (kpc & KPC_DI)
 		pxa27x_keypad_scan_direct(keypad);
 
-- 
1.7.0.4

