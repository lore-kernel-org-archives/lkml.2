Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab0G0WYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 18:24:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64388 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab0G0WYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 18:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=u9tpM6luEq2m6JUFMU9CTf7SWmCa0qZXmSAoY1/FGXVBuqUGEHG483kCX7O0OPy1VX
         VUKsfYuqiv4QzvFaTm88L9Uq1PtEuJQ941AGZravz7rDnGa6HloobqN3tbAfVKH0ro8+
         W/QIm94Bu4MyCUnakIk3GAIl4mjeTEeijxiC0=
Message-ID: <4C4F5CA7.1030706@gmail.com>
Date: Wed, 28 Jul 2010 00:24:39 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Douglas Schilling Landgraf <dougsland@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Roel Kluin <roel.kluin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Zidlicky <rz@linux-m68k.org>
Subject: Re: [PATCH] dvb: siano: free spinlock before schedule()
References: <1280256161-7971-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1280256161-7971-1-git-send-email-segooon@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 08:42 PM, Kulikov Vasiliy wrote:
> Calling schedule() holding spinlock with disables irqs is improper. As
> spinlock protects list coredev->buffers, it can be unlocked untill wakeup.
> This bug was introduced in a9349315f65cd6a16e8fab1f6cf0fd40f379c4db.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/media/dvb/siano/smscoreapi.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/dvb/siano/smscoreapi.c b/drivers/media/dvb/siano/smscoreapi.c
> index 7f2c94a..d93468c 100644
> --- a/drivers/media/dvb/siano/smscoreapi.c
> +++ b/drivers/media/dvb/siano/smscoreapi.c
> @@ -1113,9 +1113,11 @@ struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev)
>  	 */
>  
>  	prepare_to_wait(&coredev->buffer_mng_waitq, &wait, TASK_INTERRUPTIBLE);
> -
> -	if (list_empty(&coredev->buffers))
> +	if (list_empty(&coredev->buffers)) {
> +		spin_unlock_irqrestore(&coredev->bufferslock, flags);
>  		schedule();
> +		spin_lock_irqsave(&coredev->bufferslock, flags);
> +	}
>  
>  	finish_wait(&coredev->buffer_mng_waitq, &wait);

There is a better fix (which fixes the potential NULL dereference):
http://lkml.org/lkml/2010/6/7/175

Richard, could you address the comments there and resend?

regards,
-- 
js
