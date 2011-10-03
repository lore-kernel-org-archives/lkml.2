Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab1JCGng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 02:43:36 -0400
Received: from smtp-out.google.com ([74.125.121.67]:15920 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1JCGn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 02:43:28 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH] Input: evdev - use monotonic clock for event timestamps
Date: Mon,  3 Oct 2011 14:43:20 +0800
Message-Id: <1317624200-9762-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using wallclock time for event timestamps subjects inter-event timing to
ntp and other clock adjustments.  This complicates userspace drivers
that use these timestamps to calculate velocities, or while processing
state transitions.

Instead, use the kernel monotonic clock for event timestamps, which is
at least guaranteed never to go backwards.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/evdev.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 4cf2534..118f936 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -94,8 +94,11 @@ static void evdev_event(struct input_handle *handle,
 	struct evdev *evdev = handle->private;
 	struct evdev_client *client;
 	struct input_event event;
+	struct timespec now;
 
-	do_gettimeofday(&event.time);
+	getrawmonotonic(&now);
+	event.time.tv_sec = now.tv_sec;
+	event.time.tv_usec = now.tv_nsec/1000;
 	event.type = type;
 	event.code = code;
 	event.value = value;
-- 
1.7.3.1

