Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab0KVTes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 14:34:48 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:41767 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab0KVTeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 14:34:46 -0500
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH] ide: fix use after free in ide-acpi
Date: Mon, 22 Nov 2010 20:34:38 +0100
Message-Id: <1290454478-5443-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: git-send-email 1.7.0.4
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on
	Spam=No score=-1.4 bayes=0.5
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

out_obj points to kfreed memory and we dereference that pointer in
DEBPRINT/printk.

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
---
 drivers/ide/ide-acpi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index c26c119..2af8cb4 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -416,21 +416,21 @@ void ide_acpi_get_timing(ide_hwif_t *hwif)
 
 	out_obj = output.pointer;
 	if (out_obj->type != ACPI_TYPE_BUFFER) {
-		kfree(output.pointer);
 		DEBPRINT("Run _GTM: error: "
 		       "expected object type of ACPI_TYPE_BUFFER, "
 		       "got 0x%x\n", out_obj->type);
+		kfree(output.pointer);
 		return;
 	}
 
 	if (!out_obj->buffer.length || !out_obj->buffer.pointer ||
 	    out_obj->buffer.length != sizeof(struct GTM_buffer)) {
-		kfree(output.pointer);
 		printk(KERN_ERR
 			"%s: unexpected _GTM length (0x%x)[should be 0x%zx] or "
 			"addr (0x%p)\n",
 			__func__, out_obj->buffer.length,
 			sizeof(struct GTM_buffer), out_obj->buffer.pointer);
+		kfree(output.pointer);
 		return;
 	}
 
-- 
1.7.0.4

