Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2HMWMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:12:40 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35533 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab2HMWMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:12:37 -0400
From: Vojtech Bocek <vbocek@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vojtech Bocek <vbocek@gmail.com>
Subject: [PATCH 1/1] Input: joydev - fix axes values sent in initial js_event
Date: Tue, 14 Aug 2012 00:11:54 +0200
Message-Id: <1344895914-32127-1-git-send-email-vbocek@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial input event has not yet arrived in joydev_connect()
where values are set, which means default values of input_absinfo
are used for init event, not the actual values from joystick.

Signed-off-by: Vojtech Bocek <vbocek@gmail.com>
---
 drivers/input/joydev.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 26043cc..11f24b4 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -318,9 +318,14 @@ static int joydev_generate_startup_event(struct joydev_client *client,
 			event->value = !!test_bit(joydev->keypam[event->number],
 						  input->key);
 		} else {
+			int evnum = client->startup - joydev->nkey;
+			int val = input_abs_get_val(input, joydev->abspam[evnum]);
+
+			joydev->abs[evnum] = joydev_correct(val, &joydev->corr[evnum]);
+
 			event->type = JS_EVENT_AXIS | JS_EVENT_INIT;
-			event->number = client->startup - joydev->nkey;
-			event->value = joydev->abs[event->number];
+			event->number = evnum;
+			event->value = joydev->abs[evnum];
 		}
 		client->startup++;
 	}
-- 
1.7.10.4

