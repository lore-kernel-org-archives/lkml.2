Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0E3PYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 11:24:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33336 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab0E3PYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 11:24:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=IjHFfFLKCLfiYo3h2yXuCZnw6eRUbO0WkPdfDvi2VaVI66jF1lhyGlNjSWW0rU0smA
         7tnls10fsjv9v/dbNFE0rymfWxCBKaHvcqxj/vlwOsVw4fNrskHt3e1XtlAdEIGm3Bbt
         R2yVffjK+WblWOa0ZUcZ+sViWy5ODE7iyuBOw=
Message-ID: <4C028336.8030704@gmail.com>
Date: Sun, 30 May 2010 17:24:38 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100522 SUSE/3.1rc1-2.1 Thunderbird/3.1
MIME-Version: 1.0
To: Richard Zidlicky <rz@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: schedule inside spin_lock_irqsave?
References: <20100530145240.GA21559@linux-m68k.org>
In-Reply-To: <20100530145240.GA21559@linux-m68k.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2010 04:52 PM, Richard Zidlicky wrote:
> Hi,
> 
> came across following snippet of code (2.6.34:drivers/media/dvb/siano/smscoreapi.c) and 
> since prepare_to_wait is new for me I am wondering if this is can work?
> 
> struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev)
> {
> 	struct smscore_buffer_t *cb = NULL;
> 	unsigned long flags;
> 
> 	DEFINE_WAIT(wait);
> 
> 	spin_lock_irqsave(&coredev->bufferslock, flags);
> 
> 	/* This function must return a valid buffer, since the buffer list is
> 	 * finite, we check that there is an available buffer, if not, we wait
> 	 * until such buffer become available.
> 	 */
> 
> 	prepare_to_wait(&coredev->buffer_mng_waitq, &wait, TASK_INTERRUPTIBLE);
> 
> 	if (list_empty(&coredev->buffers))
> 		schedule();
> 
> 	finish_wait(&coredev->buffer_mng_waitq, &wait);
> 
> 	cb = (struct smscore_buffer_t *) coredev->buffers.next;
> 	list_del(&cb->entry);
> 
> 	spin_unlock_irqrestore(&coredev->bufferslock, flags);


Yep, that's a double bug.
1) If the waiting is interrupted, it will die because the list is still
empty.
2) If there is no entry in the list, it will deadlock at least on UP.
This should be
wait_event(&coredev->buffer_mng_waitq, cb = get_entry());
with get_entry like:
struct smscore_buffer_t *get_entry(void)
{
  struct smscore_buffer_t *cb = NULL;
  spin_lock_irqsave(&coredev->bufferslock, flags);
  if (!list_empty(&coredev->buffers)) {
    cb = (struct smscore_buffer_t *) coredev->buffers.next;
    list_del(&cb->entry);
  }
  spin_unlock_irqrestore(&coredev->bufferslock, flags);
  return cb;
}

regards,
-- 
js
