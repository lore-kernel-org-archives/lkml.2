Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab0HXPxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:53:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61264 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab0HXPxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:53:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZMwDcbbAOH1lc1pvP+Z2QAYZZYvWFyqZOu2DHltgEvaf6X1WelR+m2IXGqscIJoPEB
         rYrhLzwUnVCcimQ/7zesibVdNXibG/Ivrn4AQWqcM88+hxjdpv5lWt7HUBUcvcXJtw+n
         FsERBfvdIEcTt4sgfgomkHc9WluV+fFCTAYH4=
Date: Tue, 24 Aug 2010 17:43:18 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Kulikov Vasiliy <segooon@gmail.com>,
        kernel-janitors@vger.kernel.org,
        Douglas Schilling Landgraf <dougsland@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Roel Kluin <roel.kluin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dvb: siano: free spinlock before schedule()
Message-ID: <20100824154318.GA12175@linux-m68k.org>
References: <1280256161-7971-1-git-send-email-segooon@gmail.com> <4C4F5CA7.1030706@gmail.com> <20100808161022.GB5594@linux-m68k.org> <4C73C094.1000101@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C73C094.1000101@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 09:52:36AM -0300, Mauro Carvalho Chehab wrote:
> Em 08-08-2010 13:10, Richard Zidlicky escreveu:
> > On Wed, Jul 28, 2010 at 12:24:39AM +0200, Jiri Slaby wrote:
> > 
> > sorry for seeing this so late, was flooded with email lately.
> > 
> >> There is a better fix (which fixes the potential NULL dereference):
> >> http://lkml.org/lkml/2010/6/7/175
> > 
> >> Richard, could you address the comments there and resend?
> > 
> > I am running this patch since many weeks (after fixing the compile error obviously). 
> > Did not implement your beautification suggestion yet, was doing all kinds of experiments
> > with IR and had plenty of unrelated issues.
> 
> This patch seems a way better than the previous patch. I've rebased it against
> the current tree (and fixed the identation).

thanks for looking at it.

> The only missing issue on it is the lack of your Signed-off-by. Richard, could you
> please send it to us?


Signed-off-by: Richard Zidlicky <rz@linux-m68k.org>

PS: I will be away for a while.

> 
> ---
>  drivers/media/dvb/siano/smscoreapi.c |   31 +++++++++++++------------------
>  1 file changed, 13 insertions(+), 18 deletions(-)
> 
> --- patchwork.orig/drivers/media/dvb/siano/smscoreapi.c
> +++ patchwork/drivers/media/dvb/siano/smscoreapi.c
> @@ -1098,31 +1098,26 @@ EXPORT_SYMBOL_GPL(smscore_onresponse);
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
> +	if (!list_empty(&coredev->buffers)) {
> +		cb = (struct smscore_buffer_t *) coredev->buffers.next;
> +		list_del(&cb->entry);
> +	}
> +	spin_unlock_irqrestore(&coredev->bufferslock, flags);
> +	return cb;
> +}
>  
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
> -	cb = (struct smscore_buffer_t *) coredev->buffers.next;
> -	list_del(&cb->entry);
> +struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev)
> +{
> +	struct smscore_buffer_t *cb = NULL;
>  
> -	spin_unlock_irqrestore(&coredev->bufferslock, flags);
> +	wait_event(coredev->buffer_mng_waitq, (cb = get_entry(coredev)));
>  
>  	return cb;
>  }
