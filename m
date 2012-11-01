Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935101Ab2KAQrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 12:47:13 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40767 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934991Ab2KAQrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 12:47:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAOeGmbp9MYNnXn0RYdsR4cLSV-3KhDjVzRQnL0mKTrQG1_j9GQ@mail.gmail.com>
References: <1344895914-32127-1-git-send-email-vbocek@gmail.com>
	<20120905055218.GA24715@core.coreip.homeip.net>
	<CAOeGmboLCan-fX4sPPxS5jkyepxLTSnRgvdHJ0-edcH8UCQg+w@mail.gmail.com>
	<20120913045206.GB17105@core.coreip.homeip.net>
	<CAOeGmbp9MYNnXn0RYdsR4cLSV-3KhDjVzRQnL0mKTrQG1_j9GQ@mail.gmail.com>
Date: Thu, 1 Nov 2012 17:47:07 +0100
Message-ID: <CAOeGmboymjw=s5Z4DbgC8EzcYoDVeJqxvAqyy40f57AVYSMZ6g@mail.gmail.com>
Subject: Re: [PATCH 1/1] Input: joydev - fix axes values sent in initial js_event
From: Vojtech Bocek <vbocek@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
sorry for the impatience, but it's been nearly two months since
your last response, and I, trying to send patch to Linux for
the first time, simply don't know if should I just wait more or not.
Is the patch wrong/ugly, or are you simply too busy?

Patch for current linux-next attached.

=====================
>From be5bbc627e5c8ccfea240deef6a68b10f7f1ff40 Mon Sep 17 00:00:00 2001
From: Vojtech Bocek <vbocek@gmail.com>
Date: Thu, 1 Nov 2012 17:34:34 +0100
Subject: [PATCH 1/1] Input: joydev - fix axes values sent in initial js_event

Initial input ABS events can't reach joydev because it is not
opened yet.
This patch makes joydev reload ABS values on joydev_open_device.

Signed-off-by: Vojtech Bocek <vbocek@gmail.com>
---
 drivers/input/joydev.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index f362883..f53a7b1 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -156,6 +156,18 @@ static void joydev_event(struct input_handle *handle,
 	wake_up_interruptible(&joydev->wait);
 }

+/* joydev must be locked */
+static void joydev_reload_abs(struct joydev *joydev)
+{
+	int i, abs;
+	struct input_dev *input = joydev->handle.dev;
+
+	for (i = 0; i < joydev->nabs; ++i) {
+		abs = input_abs_get_val(input, joydev->abspam[i]);
+		joydev->abs[i] = joydev_correct(abs, &joydev->corr[i]);
+	}
+}
+
 static int joydev_fasync(int fd, struct file *file, int on)
 {
 	struct joydev_client *client = file->private_data;
@@ -200,7 +212,9 @@ static int joydev_open_device(struct joydev *joydev)
 		retval = -ENODEV;
 	else if (!joydev->open++) {
 		retval = input_open_device(&joydev->handle);
-		if (retval)
+		if (!retval)
+			joydev_reload_abs(joydev);
+		else
 			joydev->open--;
 	}

-- 
1.7.10.4
