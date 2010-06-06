Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab0FFMjm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 08:39:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36355 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab0FFMjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 08:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U3wOPWfmHmB7xrrMFfv3UbumggBjjRhD95O9Y3nctSWe+OTrZGiMH/rYPrV2QawaMz
         UIV0RmfiwwCh46C/85+yrCBNoYtjC1knyh0FSUPNXKWIrV9feY2mXr/ZourwcRZ7TguQ
         mTWKb1ZNecMsjsXiKZiZjnEKMUyjsygHsgDms=
Date: Sun, 6 Jun 2010 14:43:02 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 2.6.34] schedule inside spin_lock_irqsave
Message-ID: <20100606124302.GA10119@linux-m68k.org>
References: <20100530145240.GA21559@linux-m68k.org> <4C028336.8030704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C028336.8030704@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have done a minimaly invasive patch for the stable 2.6.34 kernel and stress-tested 
it for many hours, definitely seems to improve the behaviour.

I have left out your beautification suggestion for now, want to do more playing with
other aspects of the driver. There still seem to be issues when the device is unplugged 
while in use and such.

--- linux-2.6.34/drivers/media/dvb/siano/smscoreapi.c.rz	2010-06-03 21:58:11.000000000 +0200
+++ linux-2.6.34/drivers/media/dvb/siano/smscoreapi.c	2010-06-04 23:00:35.000000000 +0200
@@ -1100,31 +1100,26 @@
  *
  * @return pointer to descriptor on success, NULL on error.
  */
-struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev)
+
+struct smscore_buffer_t *get_entry(void)
 {
 	struct smscore_buffer_t *cb = NULL;
 	unsigned long flags;
 
-	DEFINE_WAIT(wait);
-
 	spin_lock_irqsave(&coredev->bufferslock, flags);
-
-	/* This function must return a valid buffer, since the buffer list is
-	 * finite, we check that there is an available buffer, if not, we wait
-	 * until such buffer become available.
-	 */
-
-	prepare_to_wait(&coredev->buffer_mng_waitq, &wait, TASK_INTERRUPTIBLE);
-
-	if (list_empty(&coredev->buffers))
-		schedule();
-
-	finish_wait(&coredev->buffer_mng_waitq, &wait);
-
+	if (!list_empty(&coredev->buffers)) {
 	cb = (struct smscore_buffer_t *) coredev->buffers.next;
 	list_del(&cb->entry);
-
+	}
 	spin_unlock_irqrestore(&coredev->bufferslock, flags);
+	return cb;
+}
+
+struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev)
+{
+	struct smscore_buffer_t *cb = NULL;
+
+	wait_event(coredev->buffer_mng_waitq, (cb = get_entry()));
 
 	return cb;
 }


Richard
