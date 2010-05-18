Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab0ERLNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 07:13:01 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:60285 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0ERLM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 07:12:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=CoZdXezqbxYCOkT0+XUhPMaTFgEGTme+2yYFtSO56UAmYQgjmqYdtzn33H2imQgOOm
         DZbr6qfvD+Md5TaDU7ecwoNfAV5+1LLHlNjl1zWFhuD2DtPbA5CcXnn4eI2Ib+Hn7l9X
         2aOdYMVSgawo2t/RUaVNZDD4K20IMA0N5ay78=
From: Alessio Igor Bogani <abogani@texware.it>
To: Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Bill Pemberton <wfp5p@virginia.edu>, Jiri Kosina <jkosina@suse.cz>,
       Javier Martinez Canillas <martinez.javier@gmail.com>,
       Alexander Kurz <linux@kbdbabel.org>
Cc: linux-kernel@vger.kernel.org, Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] Staging: comedi: quatech_daqp_cs.c Replace eos semaphore with a completion.
Date: Tue, 18 May 2010 13:12:32 +0200
Message-Id: <1274181152-25508-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100516134540.7dd69473@infradead.org>
References: <20100516134540.7dd69473@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build tested only.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index 197c302..a91db6c 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -56,6 +56,8 @@ Devices: [Quatech] DAQP-208 (daqp), DAQP-308
 #include <pcmcia/cisreg.h>
 #include <pcmcia/ds.h>
 
+#include <linux/completion.h>
+
 /* Maximum number of separate DAQP devices we'll allow */
 #define MAX_DEV         4
 
@@ -67,7 +69,7 @@ struct local_info_t {
 
 	enum { semaphore, buffer } interrupt_mode;
 
-	struct semaphore eos;
+	struct completion eos;
 
 	struct comedi_device *dev;
 	struct comedi_subdevice *s;
@@ -238,7 +240,7 @@ static int daqp_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 /* Interrupt handler
  *
  * Operates in one of two modes.  If local->interrupt_mode is
- * 'semaphore', just signal the local->eos semaphore and return
+ * 'semaphore', just signal the local->eos completion and return
  * (one-shot mode).  Otherwise (continuous mode), read data in from
  * the card, transfer it to the buffer provided by the higher-level
  * comedi kernel module, and signal various comedi callback routines,
@@ -287,7 +289,7 @@ static enum irqreturn daqp_interrupt(int irq, void *dev_id)
 
 	case semaphore:
 
-		up(&local->eos);
+		complete(&local->eos);
 		break;
 
 	case buffer:
@@ -401,8 +403,7 @@ static int daqp_ai_insn_read(struct comedi_device *dev,
 		return -1;
 	}
 
-	/* Make sure semaphore is blocked */
-	sema_init(&local->eos, 0);
+	init_completion(&local->eos);
 	local->interrupt_mode = semaphore;
 	local->dev = dev;
 	local->s = s;
@@ -413,9 +414,9 @@ static int daqp_ai_insn_read(struct comedi_device *dev,
 		outb(DAQP_COMMAND_ARM | DAQP_COMMAND_FIFO_DATA,
 		     dev->iobase + DAQP_COMMAND);
 
-		/* Wait for interrupt service routine to unblock semaphore */
+		/* Wait for interrupt service routine to unblock completion */
 		/* Maybe could use a timeout here, but it's interruptible */
-		if (down_interruptible(&local->eos))
+		if (wait_for_completion_interruptible(&local->eos))
 			return -EINTR;
 
 		data[i] = inb(dev->iobase + DAQP_FIFO);
-- 
1.7.0.4

