Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab0H3R2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:28:00 -0400
Received: from adelie.canonical.com ([91.189.90.139]:47342 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab0H3R17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:27:59 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Julia Lawall <julia@diku.dk>, Dmitry Torokhov <dtor@mail.ru>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: wake up reading tasks when debug event occurs
Date: Mon, 30 Aug 2010 13:27:45 -0400
Message-Id: <1283189265-5015-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chase Douglas <chase.douglas@ubuntu.com>

Some devices poke the hid core in a way that causes hid_debug_event to
be called, while never calling hid_dump_input. Without this wakeup
addition, tasks reading for hid events through debugfs may never see any
events. It may be that a well written driver doesn't cause this, but
then what's the point of debugfs?

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 drivers/hid/hid-debug.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 850d02a..adff4ef 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -570,6 +570,8 @@ void hid_debug_event(struct hid_device *hdev, char *buf)
 				buf[i];
 		list->tail = (list->tail + i) % HID_DEBUG_BUFSIZE;
         }
+
+	wake_up_interruptible(&hdev->debug_wait);
 }
 EXPORT_SYMBOL_GPL(hid_debug_event);
 
-- 
1.7.1

