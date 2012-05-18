Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965873Ab2ERLFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 07:05:35 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60817 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2ERLFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 07:05:34 -0400
MIME-Version: 1.0
From: Rabin Vincent <rabin@rab.in>
Date: Fri, 18 May 2012 16:34:53 +0530
X-Google-Sender-Auth: QaD_ZTn2OkvOKTaenNM5VyWlAyw
Message-ID: <CAH+eYFAm-bp5nRgK4mBJa4CSoXw3V4wNvCUbnB+A8Ywvs3=M1w@mail.gmail.com>
Subject: Race in vt_event_wait() during suspend/resume
To: alan@linux.intel.com, gregkh@linuxfoundation.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm_restore_console() is called from the suspend/resume path,
this calls vt_move_to_console(), which calls vt_event_wait().

There's a race in this path which causes the process
which requests the suspend to sleep indefinitely waiting
for an event which already happened:

P1					P2
 vt_move_to_console()
   set_console()
     schedule_console_callback()
   vt_waitactive()
     check n == fg_console +1
					console_callback()
					  switch_screen()
					  vt_event_post() // no waiters

     vt_event_wait() // forever

I think the following should fix it.  Comments?

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index ede2ef1..1d02e32 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -110,16 +110,7 @@ void vt_event_post(unsigned int event, unsigned
int old, unsigned int new)
 		wake_up_interruptible(&vt_event_waitqueue);
 }

-/**
- *	vt_event_wait		-	wait for an event
- *	@vw: our event
- *
- *	Waits for an event to occur which completes our vt_event_wait
- *	structure. On return the structure has wv->done set to 1 for success
- *	or 0 if some event such as a signal ended the wait.
- */
-
-static void vt_event_wait(struct vt_event_wait *vw)
+static void __vt_event_queue(struct vt_event_wait *vw)
 {
 	unsigned long flags;
 	/* Prepare the event */
@@ -129,8 +120,18 @@ static void vt_event_wait(struct vt_event_wait *vw)
 	spin_lock_irqsave(&vt_event_lock, flags);
 	list_add(&vw->list, &vt_events);
 	spin_unlock_irqrestore(&vt_event_lock, flags);
+}
+
+static void __vt_event_wait(struct vt_event_wait *vw)
+{
 	/* Wait for it to pass */
 	wait_event_interruptible(vt_event_waitqueue, vw->done);
+}
+
+static void __vt_event_dequeue(struct vt_event_wait *vw)
+{
+	unsigned long flags;
+
 	/* Dequeue it */
 	spin_lock_irqsave(&vt_event_lock, flags);
 	list_del(&vw->list);
@@ -138,6 +139,22 @@ static void vt_event_wait(struct vt_event_wait *vw)
 }

 /**
+ *	vt_event_wait		-	wait for an event
+ *	@vw: our event
+ *
+ *	Waits for an event to occur which completes our vt_event_wait
+ *	structure. On return the structure has wv->done set to 1 for success
+ *	or 0 if some event such as a signal ended the wait.
+ */
+
+static void vt_event_wait(struct vt_event_wait *vw)
+{
+	__vt_event_queue(vw);
+	__vt_event_wait(vw);
+	__vt_event_dequeue(vw);
+}
+
+/**
  *	vt_event_wait_ioctl	-	event ioctl handler
  *	@arg: argument to ioctl
  *
@@ -177,10 +194,14 @@ int vt_waitactive(int n)
 {
 	struct vt_event_wait vw;
 	do {
-		if (n == fg_console + 1)
-			break;
 		vw.event.event = VT_EVENT_SWITCH;
-		vt_event_wait(&vw);
+		__vt_event_queue(&vw);
+		if (n == fg_console + 1) {
+			__vt_event_dequeue(&vw);
+			break;
+		}
+		__vt_event_wait(&vw);
+		__vt_event_dequeue(&vw);
 		if (vw.done == 0)
 			return -EINTR;
 	} while (vw.event.newev != n);
