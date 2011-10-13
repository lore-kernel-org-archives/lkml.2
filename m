Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab1JMNU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:20:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57043 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab1JMNU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:20:56 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: [PATCH v2] ide: fix for ide_timing quantisation errors
Date: Thu, 13 Oct 2011 15:16:03 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131516.03408.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH v2] ide: fix for ide_timing quantisation errors

Based on commit 4f701d1 ("ata_timing: ensure t->cycle is always
correct") for libata.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
v2: fixed comment style

earlier references:
https://lkml.org/lkml/2010/1/18/274

 drivers/ide/ide-timings.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: b/drivers/ide/ide-timings.c
===================================================================
--- a/drivers/ide/ide-timings.c
+++ b/drivers/ide/ide-timings.c
@@ -206,6 +206,14 @@ int ide_timing_compute(ide_drive_t *driv
 		t->recover = t->cycle - t->active;
 	}
 
+	/*
+	 * In a few cases quantisation may produce enough errors to
+	 * leave t->cycle too low for the sum of active and recovery
+	 * if so we must correct this
+	 */
+	if (t->active + t->recover > t->cycle)
+		t->cycle = t->active + t->recover;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ide_timing_compute);
