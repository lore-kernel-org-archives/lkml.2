Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab0GFMka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 08:40:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63656 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab0GFMk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 08:40:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Z08UdThxnhyR9aoItFR1wo0YxoPmPIC/OjIxcJd+gom3wNNlcTvWUgB7bBpoTbxvMZ
         I8/+a0sWFczuhZbAuaQfKa/+YOnZ8Phspkv8V7IhwhDQrWIDnQW9l84C9qAV4mzh/O0D
         JxCjVSRQ6+Ya1dSU6oGAZQOlkydbfmu0S/I2Q=
Message-ID: <4C33243D.1070107@gmail.com>
Date: Tue, 06 Jul 2010 09:40:29 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100628 Red Hat/3.1-1.el6 Lightning/1.0b2 Thunderbird/3.1
MIME-Version: 1.0
To: Richard Zidlicky <rz@linux-m68k.org>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 2.6.34] schedule inside spin_lock_irqsave
References: <20100530145240.GA21559@linux-m68k.org> <4C028336.8030704@gmail.com> <20100606124302.GA10119@linux-m68k.org> <4C0BE03C.8000709@gmail.com> <20100607130048.GA6857@linux-m68k.org>
In-Reply-To: <20100607130048.GA6857@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 07-06-2010 10:00, Richard Zidlicky escreveu:
> On Sun, Jun 06, 2010 at 07:51:56PM +0200, Jiri Slaby wrote:
>> On 06/06/2010 02:43 PM, Richard Zidlicky wrote:
>>> Hi,
>>>
>>> I have done a minimaly invasive patch for the stable 2.6.34 kernel and stress-tested 
>>> it for many hours, definitely seems to improve the behaviour.
>>>
>>> I have left out your beautification suggestion for now, want to do more playing with
>>> other aspects of the driver. There still seem to be issues when the device is unplugged 
>>> while in use and such.
>>>
>>> --- linux-2.6.34/drivers/media/dvb/siano/smscoreapi.c.rz	2010-06-03 21:58:11.000000000 +0200
>>> +++ linux-2.6.34/drivers/media/dvb/siano/smscoreapi.c	2010-06-04 23:00:35.000000000 +0200
>>> @@ -1100,31 +1100,26 @@
>>>   *
>>>   * @return pointer to descriptor on success, NULL on error.
>>>   */
>>> -struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev)
>>> +
>>> +struct smscore_buffer_t *get_entry(void)
>>>  {
>>>  	struct smscore_buffer_t *cb = NULL;
>>>  	unsigned long flags;
>>>  
>>> -	DEFINE_WAIT(wait);
>>> -
>>>  	spin_lock_irqsave(&coredev->bufferslock, flags);
>>
>> Sorry, maybe I'm just blind, but where is 'coredev' defined in this
>> scope? You probably forgot to pass it to get_entry?
>>
>> How could this be compiled? Is there coredev defined globally?
> 
> good catch. I think it failed and despite a different kernel id the old module was
> loaded.
> 
> Here is the new version, this time lightly tested

Could you please fix the indentation and send your SOB for this patch?

Cheers,
Mauro.
> 
> --- linux-2.6.34/drivers/media/dvb/siano/smscoreapi.c.rz	2010-06-03 21:58:11.000000000 +0200
> +++ linux-2.6.34/drivers/media/dvb/siano/smscoreapi.c	2010-06-07 14:32:06.000000000 +0200
> @@ -1100,31 +1100,26 @@
>   *
>   * @return pointer to descriptor on success, NULL on error.
>   */
> -struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev)
> +
> +struct smscore_buffer_t *get_entry(struct smscore_device_t *coredev)
>  {
>  	struct smscore_buffer_t *cb = NULL;
>  	unsigned long flags;
>  
> -	DEFINE_WAIT(wait);
> -
>  	spin_lock_irqsave(&coredev->bufferslock, flags);
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
> +	wait_event(coredev->buffer_mng_waitq, (cb = get_entry(coredev)));
>  
>  	return cb;
>  }
> 
> 
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

