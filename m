Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab0EOVkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:40:25 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:45644 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab0EOVkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:40:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=azopTElKxuGVFuJLNpA0bF9zDtoU0461cTJ9Fq6V4/yhyEIeAHNL7RgVm9/TSFcVjl
         TQwjQEsxRST9YMOK4RL/omOvMl30Y0hb4C44O3ILSgeLhFqjSQiIXWV8RYSQA6qDgHiU
         jpCmWociN0xDfX+oCJSrs6QTUWVsQUFNzKC70=
From: Alessio Igor Bogani <abogani@texware.it>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Bill Pemberton <wfp5p@virginia.edu>, Jiri Kosina <jkosina@suse.cz>,
       Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] Staging: quatech_usb2: Convert eos semaphore to mutex
Date: Sat, 15 May 2010 23:40:02 +0200
Message-Id: <1273959602-15465-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The eos semaphore is used as a mutex so replace it with a real mutex.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index 6e9f482..3076666 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -67,7 +67,7 @@ struct local_info_t {
 
 	enum { semaphore, buffer } interrupt_mode;
 
-	struct semaphore eos;
+	struct mutex eos;
 
 	struct comedi_device *dev;
 	struct comedi_subdevice *s;
@@ -238,7 +238,7 @@ static int daqp_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 /* Interrupt handler
  *
  * Operates in one of two modes.  If local->interrupt_mode is
- * 'semaphore', just signal the local->eos semaphore and return
+ * 'semaphore', just signal the local->eos mutex and return
  * (one-shot mode).  Otherwise (continuous mode), read data in from
  * the card, transfer it to the buffer provided by the higher-level
  * comedi kernel module, and signal various comedi callback routines,
@@ -287,7 +287,7 @@ static enum irqreturn daqp_interrupt(int irq, void *dev_id)
 
 	case semaphore:
 
-		up(&local->eos);
+		mutex_unlock(&local->eos);
 		break;
 
 	case buffer:
@@ -401,8 +401,9 @@ static int daqp_ai_insn_read(struct comedi_device *dev,
 		return -1;
 	}
 
-	/* Make sure semaphore is blocked */
-	sema_init(&local->eos, 0);
+	mutex_init(&local->eos);
+	/* Make sure mutex is blocked */
+	mutex_lock(&local->eos);
 	local->interrupt_mode = semaphore;
 	local->dev = dev;
 	local->s = s;
@@ -413,9 +414,9 @@ static int daqp_ai_insn_read(struct comedi_device *dev,
 		outb(DAQP_COMMAND_ARM | DAQP_COMMAND_FIFO_DATA,
 		     dev->iobase + DAQP_COMMAND);
 
-		/* Wait for interrupt service routine to unblock semaphore */
+		/* Wait for interrupt service routine to unblock mutex */
 		/* Maybe could use a timeout here, but it's interruptible */
-		if (down_interruptible(&local->eos))
+		if (mutex_lock_interruptible(&local->eos))
 			return -EINTR;
 
 		data[i] = inb(dev->iobase + DAQP_FIFO);
-- 
1.7.0.4

