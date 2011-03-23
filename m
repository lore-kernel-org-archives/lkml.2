Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1CWBFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 21:05:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59781 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab1CWBET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 21:04:19 -0400
From: Jeff Brown <jeffbrown@android.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Brown <jeffbrown@google.com>,
        jeffbrown@android.com
Subject: [PATCH 3/4] input: evdev: Indicate buffer overrun with SYN_DROPPED.
Date: Tue, 22 Mar 2011 18:04:03 -0700
Message-Id: <1300842244-42723-4-git-send-email-jeffbrown@android.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
References: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Brown <jeffbrown@google.com>

Add a new EV_SYN code, SYN_DROPPED, to inform the client when input
events have been dropped from the evdev input buffer due to a
buffer overrun.  The client should use this event as a hint to
reset its state or ignore all following events until the next
packet begins.

Signed-off-by: jeffbrown@android.com
---
 drivers/input/evdev.c |   18 ++++++++++++------
 include/linux/input.h |    1 +
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 7f42d3a..203ed70 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -57,14 +57,20 @@ static void evdev_pass_event(struct evdev_client *client,
 {
 	/*
 	 * Interrupts are disabled, just acquire the lock.
-	 * Make sure we don't leave with the client buffer
-	 * "empty" by having client->head == client->tail.
+	 * When the client buffer is full, replace the tail with SYN_DROPPED
+	 * to let the client know that events were dropped.  Ensure that the
+	 * head and tail never coincide so the buffer does not appear "empty".
 	 */
 	spin_lock(&client->buffer_lock);
-	do {
-		client->buffer[client->head++] = *event;
-		client->head &= client->bufsize - 1;
-	} while (client->head == client->tail);
+	client->buffer[client->head++] = *event;
+	client->head &= client->bufsize - 1;
+	if (client->head == client->tail) {
+		client->tail = (client->tail + 1) & (client->bufsize - 1);
+		client->buffer[client->tail].time = event->time;
+		client->buffer[client->tail].type = EV_SYN;
+		client->buffer[client->tail].code = SYN_DROPPED;
+		client->buffer[client->tail].value = 0;
+	}
 	spin_unlock(&client->buffer_lock);
 
 	if (event->type == EV_SYN)
diff --git a/include/linux/input.h b/include/linux/input.h
index 056ae8a..65d253e 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -167,6 +167,7 @@ struct input_keymap_entry {
 #define SYN_REPORT		0
 #define SYN_CONFIG		1
 #define SYN_MT_REPORT		2
+#define SYN_DROPPED		3
 
 /*
  * Keys and buttons
-- 
1.7.0.4

