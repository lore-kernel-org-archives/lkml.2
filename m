Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466Ab2JKVwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 17:52:20 -0400
Received: from mail-fa0-f74.google.com ([209.85.161.74]:65486 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759454Ab2JKVwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 17:52:16 -0400
From: Derek Basehore <dbasehore@chromium.org>
To: axboe@kernel.dk
Cc: msb@chromium.org, spang@chromium.org, bfreed@chromium.org,
        arscott@chromium.org, linux-kernel@vger.kernel.org,
        Derek Basehore <dbasehore@chromium.org>
Subject: [PATCH] block: Remove deadlock in disk_clear_events
Date: Thu, 11 Oct 2012 14:52:07 -0700
Message-Id: <1349992327-9747-1-git-send-email-dbasehore@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In disk_clear_events, do not put work on system_nrt_freezable_wq. Instead, put
it on system_nrt_wq.

There is a race between probing a usb and suspending the device. Since probing a
usb calls disk_clear_events, which puts work on a frozen workqueue, probing
cannot finish after the workqueue is frozen. However, suspending cannot finish
until the usb probe is finished, so we get a deadlock.

Change-Id: I05bc8f608f1c86b7efaca5c12e544dbd08dfaba4
Signed-off-by: Derek Basehore <dbasehore@chromium.org>
---
 block/genhd.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 6cace66..4e700ee 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1571,7 +1571,13 @@ unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
 
 	/* uncondtionally schedule event check and wait for it to finish */
 	disk_block_events(disk);
-	queue_delayed_work(system_freezable_wq, &ev->dwork, 0);
+	/* We need to put the work on system_nrt_wq here since there is a
+	 * deadlock that happens while probing a usb device while suspending. If
+	 * we put work on a freezable worqueue here, a usb probe will wait here
+	 * until the workqueue is unfrozen during suspend. Since suspend waits
+	 * on all probes to complete, we have a deadlock
+	 */
+	queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
 	flush_delayed_work(&ev->dwork);
 	__disk_unblock_events(disk, false);
 
-- 
1.7.7.3

