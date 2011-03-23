Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1CWBEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 21:04:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59781 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1CWBEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 21:04:20 -0400
From: Jeff Brown <jeffbrown@android.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Brown <jeffbrown@android.com>
Subject: [PATCH 4/4] input: evdev: only wake poll on EV_SYN
Date: Tue, 22 Mar 2011 18:04:04 -0700
Message-Id: <1300842244-42723-5-git-send-email-jeffbrown@android.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
References: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On SMP systems, it is possible for an evdev client blocked on poll()
to wake up and read events from the evdev ring buffer at the same
rate as they are enqueued.  This can result in high CPU usage,
particularly for MT devices, because the client ends up reading
events one at a time instead of reading complete packets.  This patch
ensures that the client only wakes from poll() when a complete packet
is ready to be read.

Signed-off-by: jeffbrown@android.com
---
 drivers/input/evdev.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 203ed70..7b6770d 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -73,7 +73,7 @@ static void evdev_pass_event(struct evdev_client *client,
 	}
 	spin_unlock(&client->buffer_lock);
 
-	if (event->type == EV_SYN)
+	if (event->type == EV_SYN && event->code != SYN_MT_REPORT)
 		kill_fasync(&client->fasync, SIGIO, POLL_IN);
 }
 
@@ -103,7 +103,8 @@ static void evdev_event(struct input_handle *handle,
 
 	rcu_read_unlock();
 
-	wake_up_interruptible(&evdev->wait);
+	if (type == EV_SYN && code != SYN_MT_REPORT)
+		wake_up_interruptible(&evdev->wait);
 }
 
 static int evdev_fasync(int fd, struct file *file, int on)
-- 
1.7.0.4

