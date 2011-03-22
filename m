Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1CVKFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:05:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46941 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab1CVKFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:05:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UG6LnN/1EZTB9XINUFHpAt39ziuA5z6ntQvEjv5S6xbvDm8kYkoIX2CkMasjg/0xO2
         5eEmh0xOYix9MIICQkxJjY6DQqePyqo5zdDq6D8syMhoSGj0uU8B7st1S9OabaagRkni
         DtZvbZBG6F1FVrISKZOHluu7xmK4EiK/9GAHI=
Date: Tue, 22 Mar 2011 11:05:26 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Toby Gray <toby.gray@realvnc.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] USB: cdc-acm: Prevent data loss when filling tty
 buffer.
Message-ID: <20110322100526.GB21343@localhost>
References: <1300722745-2404-1-git-send-email-toby.gray@realvnc.com>
 <1300730698-17099-1-git-send-email-toby.gray@realvnc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300730698-17099-1-git-send-email-toby.gray@realvnc.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 06:04:58PM +0000, Toby Gray wrote:
> When sending large quantities of data through a CDC ACM channel it is possible
> for data to be lost when attempting to copy the data to the tty buffer. This
> occurs due to the return value from tty_insert_flip_string not being checked.
> 
> This patch adds checking for how many bytes have been inserted into the tty
> buffer and returns any remaining bytes back to the filled read buffer list.

[...]

> @@ -392,6 +393,7 @@ static void acm_rx_tasklet(unsigned long _acm)

[...]

> -	spin_lock_irqsave(&acm->read_lock, flags);
> -	list_add(&buf->list, &acm->spare_read_bufs);
> -	spin_unlock_irqrestore(&acm->read_lock, flags);
> +	buf->head += copied;
> +	buf->size -= copied;
> +
> +	if (buf->size == 0) {
> +		spin_lock_irqsave(&acm->read_lock, flags);
> +		list_add(&buf->list, &acm->spare_read_bufs);
> +		spin_unlock_irqrestore(&acm->read_lock, flags);
> +	} else {
> +		tty_kref_put(tty);
> +		dbg("Partial buffer fill");
> +		spin_lock_irqsave(&acm->read_lock, flags);
> +		list_add(&buf->list, &acm->filled_read_bufs);
> +		spin_unlock_irqrestore(&acm->read_lock, flags);
> +		return;
> +	}
> +

Say you fill up the tty buffer using the last of the sixteen buffers and
return in the else clause above, how will the tasklet ever get
re-scheduled?

The problem is that the tasklet is only scheduled on urb completion and
unthrottle (after open), and if you return above no urb will get
re-submitted. So the only way this will work is if it can be guaranteed
that the line discipline will throttle and later unthrottle us. I
doubt that is the case, but perhaps Alan can give a more definite
answer?

[By the way, did you see Filippe Balbi's patch posted today claiming to
fix a bug in n_tty which could cause data loss at high speeds?]

I was just about to submit a patch series killing the rx tasklet and
heavily simplifying the cdc-acm driver when you posted last night. I
think that if this mechanism is needed it is more straight-forwardly
implemented on top of those as they removes a lot of complexity and
makes it easier to spot corner cases such as the one pointed out above.

I would also prefer a more generic solution to the problem so that we
don't need to re-introduce driver buffering again. Since we already have
the throttelling mechanism in place, if we could only be notified/find
out that the tty buffers are say half-full, we could throttle (from
within the driver) but still push the remaining buffer still on the wire
as they arrive. It would of course require a guarantee that such a
throttle-is-about-to-happen notification is actually followed by (a
throttle and) unthrottle. Thoughts on that?

Thanks,
Johan
