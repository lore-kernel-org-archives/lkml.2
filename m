Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab0FFRwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 13:52:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:35927 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab0FFRv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 13:51:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=s6jZLr7IVcR+5J8L7F3+gpdVIbqED9gQbFDbrDgLUcw2rmGYp5d/eVTbL2/BC/A4hm
         n7vRMho9gfD9T1Zn+Jsff4YjiHmpuX00XRogiEMFxmRalcmy8OjyfbFZqrBVDGjDFQM1
         U1SOXNqOR5gf/YpuP29zxi8fADlhhK00ZWFf8=
Message-ID: <4C0BE03C.8000709@gmail.com>
Date: Sun, 06 Jun 2010 19:51:56 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100527 SUSE/3.1rc1-3.3 Thunderbird/3.1
MIME-Version: 1.0
To: Richard Zidlicky <rz@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2.6.34] schedule inside spin_lock_irqsave
References: <20100530145240.GA21559@linux-m68k.org> <4C028336.8030704@gmail.com> <20100606124302.GA10119@linux-m68k.org>
In-Reply-To: <20100606124302.GA10119@linux-m68k.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2010 02:43 PM, Richard Zidlicky wrote:
> Hi,
> 
> I have done a minimaly invasive patch for the stable 2.6.34 kernel and stress-tested 
> it for many hours, definitely seems to improve the behaviour.
> 
> I have left out your beautification suggestion for now, want to do more playing with
> other aspects of the driver. There still seem to be issues when the device is unplugged 
> while in use and such.
> 
> --- linux-2.6.34/drivers/media/dvb/siano/smscoreapi.c.rz	2010-06-03 21:58:11.000000000 +0200
> +++ linux-2.6.34/drivers/media/dvb/siano/smscoreapi.c	2010-06-04 23:00:35.000000000 +0200
> @@ -1100,31 +1100,26 @@
>   *
>   * @return pointer to descriptor on success, NULL on error.
>   */
> -struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev)
> +
> +struct smscore_buffer_t *get_entry(void)
>  {
>  	struct smscore_buffer_t *cb = NULL;
>  	unsigned long flags;
>  
> -	DEFINE_WAIT(wait);
> -
>  	spin_lock_irqsave(&coredev->bufferslock, flags);

Sorry, maybe I'm just blind, but where is 'coredev' defined in this
scope? You probably forgot to pass it to get_entry?

How could this be compiled? Is there coredev defined globally?

> -
> -	/* This function must return a valid buffer, since the buffer list is
> -	 * finite, we check that there is an available buffer, if not, we wait
> -	 * until such buffer become available.
> -	 */
> -
> -	prepare_to_wait(&coredev->buffer_mng_waitq, &wait, TASK_INTERRUPTIBLE);
> -
> -	if (list_empty(&coredev->buffers))
> -		schedule();
> -
> -	finish_wait(&coredev->buffer_mng_waitq, &wait);
> -
> +	if (!list_empty(&coredev->buffers)) {
>  	cb = (struct smscore_buffer_t *) coredev->buffers.next;
>  	list_del(&cb->entry);
> -
> +	}
>  	spin_unlock_irqrestore(&coredev->bufferslock, flags);
> +	return cb;
> +}
> +
> +struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev)
> +{
> +	struct smscore_buffer_t *cb = NULL;
> +
> +	wait_event(coredev->buffer_mng_waitq, (cb = get_entry()));
>  
>  	return cb;
>  }

-- 
js
