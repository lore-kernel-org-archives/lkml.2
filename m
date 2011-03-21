Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab1CUQz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:55:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43786 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752220Ab1CUQzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:55:54 -0400
Date: Mon, 21 Mar 2011 16:56:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Toby Gray <toby.gray@realvnc.com>
Cc: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: cdc-acm: Prevent data loss when filling tty
 buffer.
Message-ID: <20110321165612.0f764046@lxorguk.ukuu.org.uk>
In-Reply-To: <1300722745-2404-1-git-send-email-toby.gray@realvnc.com>
References: <1300722745-2404-1-git-send-email-toby.gray@realvnc.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Mar 2011 15:52:25 +0000
Toby Gray <toby.gray@realvnc.com> wrote:

> When sending large quantities of data through a CDC ACM channel it is possible
> for data to be lost when attempting to copy the data to the tty buffer. This
> occurs due to the return value from tty_insert_flip_string not being checked.

For a tty that is normally the right thing to do - no flow control was
asserted and the internal 64K of buffering was overrun so discard.

> This patch adds checking for how many bytes have been inserted into the tty
> buffer and returns any remaining bytes back to the filled read buffer list.

How does ACM handle flow control - is the expectation that it gets flow
controlled in hardware by not having the opportunity to send bits
to the host end ? If so this seems to make sense.


> +	copied = 0;

Surely copied = buf->size is the no tty assumption "we had the lot and
discarded it"

>  	if (tty) {
>  		spin_lock_irqsave(&acm->throttle_lock, flags);
>  		throttled = acm->throttle;
>  		spin_unlock_irqrestore(&acm->throttle_lock, flags);
>  		if (!throttled) {
> -			tty_insert_flip_string(tty, buf->base, buf->size);
> +			copied = tty_insert_flip_string(tty,
> +							buf->base, buf->size);
>  			tty_flip_buffer_push(tty);
>  		} else {
>  			tty_kref_put(tty);
> @@ -440,9 +443,26 @@ next_buffer:
>  		}
>  	}
>  
> -	spin_lock_irqsave(&acm->read_lock, flags);
> -	list_add(&buf->list, &acm->spare_read_bufs);
> -	spin_unlock_irqrestore(&acm->read_lock, flags);
> +	if (copied == buf->size || !tty) {

Which would simplify this lot

> +		spin_lock_irqsave(&acm->read_lock, flags);
> +		list_add(&buf->list, &acm->spare_read_bufs);
> +		spin_unlock_irqrestore(&acm->read_lock, flags);
> +	} else {
> +		tty_kref_put(tty);
> +		dbg("Partial buffer fill");
> +		if (copied > 0) {
> +			memmove(buf->base,
> +				buf->base + copied,
> +				buf->size - copied);
> +			buf->size -= copied;
> +		}

Would it not be cleaner to add a buf->head pointer that could simply be
advanced so the code would become

	buf->head += copied;
	buf->size -= copied;
	if (buf->size != 0)
		list_add(&buf->list, &acm->filled_read_bufs);

instead of all the memmove uglies ?


