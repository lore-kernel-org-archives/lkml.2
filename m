Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab0HHQQi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 12:16:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61708 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab0HHQQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 12:16:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RoGfKiaFMdqyyu+vn5orWdn0q9CVpS/3GDmd0CF5dblzsm++W4sKUwSvjhqtePlsL2
         n/MLqkcbXA56VZ/vzWok/p5PAcSOQOgp43/yryAlkEdhljW13vlil/tQED4DI20iWtft
         MrmcRapz9gLpFlgBWM4FWooeT7t1Za9Ve0uVY=
Date: Sun, 8 Aug 2010 18:10:22 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Douglas Schilling Landgraf <dougsland@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Roel Kluin <roel.kluin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dvb: siano: free spinlock before schedule()
Message-ID: <20100808161022.GB5594@linux-m68k.org>
References: <1280256161-7971-1-git-send-email-segooon@gmail.com> <4C4F5CA7.1030706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4F5CA7.1030706@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 12:24:39AM +0200, Jiri Slaby wrote:

sorry for seeing this so late, was flooded with email lately.

> There is a better fix (which fixes the potential NULL dereference):
> http://lkml.org/lkml/2010/6/7/175

> Richard, could you address the comments there and resend?

I am running this patch since many weeks (after fixing the compile error obviously). 
Did not implement your beautification suggestion yet, was doing all kinds of experiments
with IR and had plenty of unrelated issues.

Richard


--- linux-2.6.34/drivers/media/dvb/siano/smscoreapi.c.rz	2010-06-03 21:58:11.000000000 +0200
+++ linux-2.6.34/drivers/media/dvb/siano/smscoreapi.c	2010-06-07 14:32:06.000000000 +0200
@@ -1100,31 +1100,26 @@
  *
  * @return pointer to descriptor on success, NULL on error.
  */
-struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev)
+
+struct smscore_buffer_t *get_entry(struct smscore_device_t *coredev)
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
+	wait_event(coredev->buffer_mng_waitq, (cb = get_entry(coredev)));
 
 	return cb;
 }


