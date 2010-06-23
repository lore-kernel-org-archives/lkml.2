Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0FWLSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 07:18:09 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:44481 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988Ab0FWLSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 07:18:07 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pingc@wacom.com>,
       Benjamin Tissoires <tissoire@cena.fr>,
       Chase Douglas <chase.douglas@canonical.com>,
       Rafi Rubin <rafi@seas.upenn.edu>, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 5/5] input: evdev: Never leave the client buffer empty after write
Date: Wed, 23 Jun 2010 13:14:46 +0200
Message-Id: <1277291686-7153-6-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1277291686-7153-5-git-send-email-rydberg@euromail.se>
References: <1277291686-7153-1-git-send-email-rydberg@euromail.se>
 <1277291686-7153-2-git-send-email-rydberg@euromail.se>
 <1277291686-7153-3-git-send-email-rydberg@euromail.se>
 <1277291686-7153-4-git-send-email-rydberg@euromail.se>
 <1277291686-7153-5-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1ORNvG-0007cS-9d.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1ORNvG-0007cS-9d 19c01e7921f15d0338c206fc1643ab47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the client buffer is very small and wraps around a lot, it may
well be that a write increases the head such that head == tail. If
this happens between the point where a poll is triggered and the
actual data is being read, there will be no data to read. This is
confusing to applications, which might end up closing the file.

This patch solves the problem by making sure the client buffer is
never empty after writing to it.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/evdev.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 728802f..45eae19 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -62,10 +62,13 @@ static void evdev_pass_event(struct evdev_client *client,
 {
 	/*
 	 * Interrupts are disabled, just acquire the lock
+	 * Never leave the client buffer empty
 	 */
 	spin_lock(&client->buffer_lock);
-	client->buffer[client->head++] = *event;
-	client->head &= client->bufsize - 1;
+	do {
+		client->buffer[client->head++] = *event;
+		client->head &= client->bufsize - 1;
+	} while (client->head == client->tail);
 	spin_unlock(&client->buffer_lock);
 
 	if (event->type == EV_SYN)
-- 
1.6.3.3

