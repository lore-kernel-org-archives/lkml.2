Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab0KVXKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 18:10:10 -0500
Received: from smtp-out.google.com ([74.125.121.35]:30105 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab0KVXKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 18:10:08 -0500
From: Duncan Laurie <dlaurie@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Duncan Laurie <dlaurie@chromium.org>
Subject: [PATCH] Input: serio - clear serio event queue after sysfs driver rebind
Date: Mon, 22 Nov 2010 15:09:50 -0800
Message-Id: <1290467390-25302-1-git-send-email-dlaurie@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When rebinding a serio driver via sysfs drvctl interface it is possible for
an interrupt to trigger after the disconnect of the existing driver and
before the binding of the new driver.  This will cause the serio interrupt
handler to queue a rescan event which will disconnect the new driver
immediately after it is attached.

This change clears the serio event queue after processing the drvctl
request but before releasing the serio mutex, which will clear any queued
rescans before they can get processed.

Reproduction involves issuing a rebind of device port from psmouse driver
to serio_raw driver while generating input to trigger interrupts.  Then
checking to see if the corresponding i8042/serio4/driver is correctly
attached to the serio_raw driver instead of psmouse.

Signed-off-by: Duncan Laurie <dlaurie@chromium.org>
---
 drivers/input/serio/serio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index 405bf21..a66307e 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -454,6 +454,7 @@ static ssize_t serio_rebind_driver(struct device *dev, struct device_attribute *
 		serio_disconnect_port(serio);
 		error = serio_bind_driver(serio, to_serio_driver(drv));
 		put_driver(drv);
+		serio_remove_pending_events(serio);
 	} else {
 		error = -EINVAL;
 	}
-- 
1.7.3.1

