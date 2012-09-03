Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab2ICNNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 09:13:06 -0400
Received: from pequod.mess.org ([93.97.41.153]:50775 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab2ICNNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 09:13:04 -0400
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Sep 2012 09:13:04 EDT
Date: Mon, 3 Sep 2012 14:03:57 +0100
From: Sean Young <sean@mess.org>
To: "Du, Changbin" <changbin.du@gmail.com>
Cc: mchehab@infradead.org, paul.gortmaker@windriver.com, sfr@canb.auug.org.au,
        srinivas.kandagatla@st.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] [media] rc: filter out not allowed protocols when
 decoding
Message-ID: <20120903130357.GA7403@pequod.mess.org>
References: <1346464629-22458-1-git-send-email-changbin.du@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346464629-22458-1-git-send-email-changbin.du@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 09:57:09AM +0800, Du, Changbin wrote:
> From: "Du, Changbin" <changbin.du@gmail.com>
> 
> Each rc-raw device has a property "allowed_protos" stored in structure
> ir_raw_event_ctrl. But it didn't work because all decoders would be
> called when decoding. This path makes only allowed protocol decoders
> been invoked.
> 
> Signed-off-by: Du, Changbin <changbin.du@gmail.com>
> ---
>  drivers/media/rc/ir-raw.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
> index a820251..198b6d8 100644
> --- a/drivers/media/rc/ir-raw.c
> +++ b/drivers/media/rc/ir-raw.c
> @@ -63,8 +63,12 @@ static int ir_raw_event_thread(void *data)
>  		spin_unlock_irq(&raw->lock);
>  
>  		mutex_lock(&ir_raw_handler_lock);
> -		list_for_each_entry(handler, &ir_raw_handler_list, list)
> -			handler->decode(raw->dev, ev);
> +		list_for_each_entry(handler, &ir_raw_handler_list, list) {
> +			/* use all protocol by default */
> +			if (raw->dev->allowed_protos == RC_TYPE_UNKNOWN ||
> +			    raw->dev->allowed_protos & handler->protocols)
> +				handler->decode(raw->dev, ev);
> +		}

Each IR protocol decoder already checks whether it is enabled or not; 
should it not be so that only allowed protocols can be enabled rather 
than checking both enabled_protocols and allowed_protocols?

Just from reading store_protocols it looks like decoders which aren't
in allowed_protocols can be enabled, which makes no sense. Also 
ir_raw_event_register all protocols are enabled rather than the 
allowed ones.

Lastely I don't know why raw ir drivers should dictate which protocols
can be enabled. Would it not be better to remove it entirely?


>  		raw->prev_ev = ev;
>  		mutex_unlock(&ir_raw_handler_lock);
>  	}
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
