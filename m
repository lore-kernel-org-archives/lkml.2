Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2L1Tuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:50:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55101 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754577Ab2L1TRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:46 -0500
Message-Id: <20121228190357.928699673@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Popovec <popovec@oko.fei.tuke.sk>,
        Peter Popovec <popovec@fei.tuke.sk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 136/173] Input: walkera0701 - fix crash on startup
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Popovec <popovec@oko.fei.tuke.sk>

commit a455e2985f57e2a71566bb8850094af38b2c932d upstream.

The driver's timer must be set up before enabling IRQ handler, otherwise
bad things may happen.

Reported-and-tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Popovec <popovec@fei.tuke.sk>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/joystick/walkera0701.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/input/joystick/walkera0701.c b/drivers/input/joystick/walkera0701.c
index 4dfa1ee..f8f892b 100644
--- a/drivers/input/joystick/walkera0701.c
+++ b/drivers/input/joystick/walkera0701.c
@@ -196,6 +196,7 @@ static void walkera0701_close(struct input_dev *dev)
 	struct walkera_dev *w = input_get_drvdata(dev);
 
 	parport_disable_irq(w->parport);
+	hrtimer_cancel(&w->timer);
 }
 
 static int walkera0701_connect(struct walkera_dev *w, int parport)
@@ -224,6 +225,9 @@ static int walkera0701_connect(struct walkera_dev *w, int parport)
 	if (parport_claim(w->pardevice))
 		goto init_err1;
 
+	hrtimer_init(&w->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	w->timer.function = timer_handler;
+
 	w->input_dev = input_allocate_device();
 	if (!w->input_dev)
 		goto init_err2;
@@ -254,8 +258,6 @@ static int walkera0701_connect(struct walkera_dev *w, int parport)
 	if (err)
 		goto init_err3;
 
-	hrtimer_init(&w->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	w->timer.function = timer_handler;
 	return 0;
 
  init_err3:
@@ -271,7 +273,6 @@ static int walkera0701_connect(struct walkera_dev *w, int parport)
 
 static void walkera0701_disconnect(struct walkera_dev *w)
 {
-	hrtimer_cancel(&w->timer);
 	input_unregister_device(w->input_dev);
 	parport_release(w->pardevice);
 	parport_unregister_device(w->pardevice);


