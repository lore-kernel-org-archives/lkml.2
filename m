Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab3AIUhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:37:31 -0500
Received: from mail.kernel.org ([198.145.19.201]:41494 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933021Ab3AIUh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Peter Popovec <popovec@fei.tuke.sk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 24/47] Input: walkera0701 - fix crash on startup
Date: Wed,  9 Jan 2013 12:35:19 -0800
Message-Id: <20130109201732.288985773@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Popovec <popovec@oko.fei.tuke.sk>

commit a455e2985f57e2a71566bb8850094af38b2c932d upstream.

The driver's timer must be set up before enabling IRQ handler, otherwise
bad things may happen.

Reported-and-tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Popovec <popovec@fei.tuke.sk>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/joystick/walkera0701.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/input/joystick/walkera0701.c
+++ b/drivers/input/joystick/walkera0701.c
@@ -196,6 +196,7 @@ static void walkera0701_close(struct inp
 	struct walkera_dev *w = input_get_drvdata(dev);
 
 	parport_disable_irq(w->parport);
+	hrtimer_cancel(&w->timer);
 }
 
 static int walkera0701_connect(struct walkera_dev *w, int parport)
@@ -224,6 +225,9 @@ static int walkera0701_connect(struct wa
 	if (parport_claim(w->pardevice))
 		goto init_err1;
 
+	hrtimer_init(&w->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	w->timer.function = timer_handler;
+
 	w->input_dev = input_allocate_device();
 	if (!w->input_dev)
 		goto init_err2;
@@ -254,8 +258,6 @@ static int walkera0701_connect(struct wa
 	if (err)
 		goto init_err3;
 
-	hrtimer_init(&w->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	w->timer.function = timer_handler;
 	return 0;
 
  init_err3:
@@ -271,7 +273,6 @@ static int walkera0701_connect(struct wa
 
 static void walkera0701_disconnect(struct walkera_dev *w)
 {
-	hrtimer_cancel(&w->timer);
 	input_unregister_device(w->input_dev);
 	parport_release(w->pardevice);
 	parport_unregister_device(w->pardevice);


