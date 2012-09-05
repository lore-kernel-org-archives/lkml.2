Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab2IEUJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 16:09:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48834 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab2IEUJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:09:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120905055218.GA24715@core.coreip.homeip.net>
References: <1344895914-32127-1-git-send-email-vbocek@gmail.com>
	<20120905055218.GA24715@core.coreip.homeip.net>
Date: Wed, 5 Sep 2012 22:09:57 +0200
Message-ID: <CAOeGmboLCan-fX4sPPxS5jkyepxLTSnRgvdHJ0-edcH8UCQg+w@mail.gmail.com>
Subject: Re: [PATCH 1/1] Input: joydev - fix axes values sent in initial js_event
From: =?ISO-8859-2?Q?Vojt=ECch_Bo=E8ek?= <vbocek@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012/9/5 Dmitry Torokhov <dmitry.torokhov@gmail.com>
> So what guarantees that joystick events will arrive in time, before
> joydev_generate_startup_event() is called? It looks like your solution
> is racy...
>
> I wonder if we should not generate the startup event until we have seen
> at least one EV_SYN, i.e. entire device state has been transmitted to
> us.

I just tried to delay read() until first EV_SYN arrives as you suggested,
but that was not the problem, at least not the main one. First joystick
input events arrives immediately after it is plugged in and driver is loaded,
but when that happens, joydev may not be (and most likely is not)
opened yet, which means the events will never reach joydev because of
"if (!handle->open)" check in input_pass_event.

I wonder how to handle this. Is "if(!handle->open)" valid check? I think so,
my guess is that joydev is the only handler with internal buffer, and it
is useless to update that buffer when the device is not opened.
I think reloading abs values on joydev open should be okay.

I suppose that if we reload abs values on joydev open, waiting for first
sync is not needed, yes?

So the patch could look like this:

---
 drivers/input/joydev.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 26043cc..22a166c 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -158,6 +158,20 @@ static void joydev_event(struct input_handle *handle,
 	wake_up_interruptible(&joydev->wait);
 }

+/* joydev must be locked */
+static void joydev_reload_abs(struct joydev *joydev)
+{
+	int i, j, abs;
+	struct input_dev *input = joydev->handle.dev;
+
+	for (i = 0; i < joydev->nabs; ++i) {
+		j = joydev->abspam[i];
+		abs = input_abs_get_val(input, j);
+
+		joydev->abs[i] = joydev_correct(abs, &joydev->corr[i]);
+	}
+}
+
 static int joydev_fasync(int fd, struct file *file, int on)
 {
 	struct joydev_client *client = file->private_data;
@@ -202,8 +216,11 @@ static int joydev_open_device(struct joydev *joydev)
 		retval = -ENODEV;
 	else if (!joydev->open++) {
 		retval = input_open_device(&joydev->handle);
-		if (retval)
+		if (!retval)
+			joydev_reload_abs(joydev);
+		else
 			joydev->open--;
+		
 	}

 	mutex_unlock(&joydev->mutex);
-- 
1.7.10.4
