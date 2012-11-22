Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab2KVUOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:14:53 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45940 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab2KVTt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:49:58 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 08/46] staging: line6: change monitor_level type ValueWait -> int
Date: Thu, 22 Nov 2012 20:48:47 +0100
Message-Id: <1353613765-18690-9-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The monitor_level sysfs attr has been dropped and we never need to wait
on the monitor_level value to change.  Switch to a plain int and drop
the wait queue.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 10 +++++-----
 drivers/staging/line6/pod.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 5a941fa..165c7ad 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -245,7 +245,7 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 
 					switch (buf[6]) {
 					case POD_monitor_level:
-						pod->monitor_level.value = value;
+						pod->monitor_level = value;
 						break;
 
 						PROCESS_SYSTEM_PARAM(routing);
@@ -908,7 +908,7 @@ static int snd_pod_control_monitor_get(struct snd_kcontrol *kcontrol,
 {
 	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
 	struct usb_line6_pod *pod = (struct usb_line6_pod *)line6pcm->line6;
-	ucontrol->value.integer.value[0] = pod->monitor_level.value;
+	ucontrol->value.integer.value[0] = pod->monitor_level;
 	return 0;
 }
 
@@ -919,10 +919,10 @@ static int snd_pod_control_monitor_put(struct snd_kcontrol *kcontrol,
 	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
 	struct usb_line6_pod *pod = (struct usb_line6_pod *)line6pcm->line6;
 
-	if (ucontrol->value.integer.value[0] == pod->monitor_level.value)
+	if (ucontrol->value.integer.value[0] == pod->monitor_level)
 		return 0;
 
-	pod->monitor_level.value = ucontrol->value.integer.value[0];
+	pod->monitor_level = ucontrol->value.integer.value[0];
 	pod_set_system_param_int(pod, ucontrol->value.integer.value[0],
 				 POD_monitor_level);
 	return 1;
@@ -1053,7 +1053,7 @@ static int pod_try_init(struct usb_interface *interface,
 	 */
 
 	if (pod->line6.properties->capabilities & LINE6_BIT_CONTROL) {
-		pod->monitor_level.value = POD_system_invalid;
+		pod->monitor_level = POD_system_invalid;
 
 		/* initiate startup procedure: */
 		pod_startup1(pod);
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index b3bf243..d5bbd2f 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -121,7 +121,7 @@ struct usb_line6_pod {
 	/**
 		Instrument monitor level.
 	*/
-	struct ValueWait monitor_level;
+	int monitor_level;
 
 	/**
 		Audio routing mode.
-- 
1.8.0

