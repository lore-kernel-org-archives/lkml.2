Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab0FGM5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:57:52 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:50615 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab0FGM5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:57:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i/it+O45Jgp2AcizCsr9ZXnyJr3f55elP0zhtSk5QcGaLsPCd01peilBV55Ziz3TB2
         ZpRXlZ5JQZ0hVkNgPr0pi9MC15tbhVz5gsBjwi2jYihddoceeP4L/gtL2y0QyLg4a1zo
         FAazsNj8tzxxyJUx0FmT27MdXbU3HpdIX7Usc=
Date: Mon, 7 Jun 2010 15:00:48 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2.6.34] schedule inside spin_lock_irqsave
Message-ID: <20100607130048.GA6857@linux-m68k.org>
References: <20100530145240.GA21559@linux-m68k.org> <4C028336.8030704@gmail.com> <20100606124302.GA10119@linux-m68k.org> <4C0BE03C.8000709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0BE03C.8000709@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 06, 2010 at 07:51:56PM +0200, Jiri Slaby wrote:
> On 06/06/2010 02:43 PM, Richard Zidlicky wrote:
> > Hi,
> > 
> > I have done a minimaly invasive patch for the stable 2.6.34 kernel and stress-tested 
> > it for many hours, definitely seems to improve the behaviour.
> > 
> > I have left out your beautification suggestion for now, want to do more playing with
> > other aspects of the driver. There still seem to be issues when the device is unplugged 
> > while in use and such.
> > 
> > --- linux-2.6.34/drivers/media/dvb/siano/smscoreapi.c.rz	2010-06-03 21:58:11.000000000 +0200
> > +++ linux-2.6.34/drivers/media/dvb/siano/smscoreapi.c	2010-06-04 23:00:35.000000000 +0200
> > @@ -1100,31 +1100,26 @@
> >   *
> >   * @return pointer to descriptor on success, NULL on error.
> >   */
> > -struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev)
> > +
> > +struct smscore_buffer_t *get_entry(void)
> >  {
> >  	struct smscore_buffer_t *cb = NULL;
> >  	unsigned long flags;
> >  
> > -	DEFINE_WAIT(wait);
> > -
> >  	spin_lock_irqsave(&coredev->bufferslock, flags);
> 
> Sorry, maybe I'm just blind, but where is 'coredev' defined in this
> scope? You probably forgot to pass it to get_entry?
> 
> How could this be compiled? Is there coredev defined globally?

good catch. I think it failed and despite a different kernel id the old module was
loaded.

Here is the new version, this time lightly tested

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


Richard
