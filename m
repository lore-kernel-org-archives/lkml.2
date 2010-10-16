Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0JPToU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 15:44:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47960 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab0JPToT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 15:44:19 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CBA0089.2060700@s5r6.in-berlin.de>
Date: Sat, 16 Oct 2010 21:44:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: David Brownell <david-b@pacbell.net>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36-rc7: NULL pointer dereference in ehci_clear_tt_buffer_complete
References: <Pine.LNX.4.44L0.1010141016540.1645-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1010141016540.1645-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 14 Oct 2010, Stefan Richter wrote:
> 
>> Alan Stern wrote:
>>> Stefan, is it possible for you to tell whether this really does work?
>> That will be hard.  So far I was unable to reproduce the oops; still running
>> unmodified 2.6.36-rc7.
> 
> Was this on an SMP machine?

Yes.

> If yes, the untested patch below may help
> trigger the oops.  To use it, insert (but don't mount) a memory card
> into the card reader, and use dd to copy a large amount of data from
> the card to /dev/null.  While that's running, unplug either the monitor
> or the card reader.  You may want to do this at a VT console so you can
> see directly when the delay occurs.
> 
> Alan Stern
> 
> 
> 
> Index: usb-2.6/drivers/usb/core/message.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/core/message.c
> +++ usb-2.6/drivers/usb/core/message.c
> @@ -323,8 +323,13 @@ static void sg_complete(struct urb *urb)
>  	/* on the last completion, signal usb_sg_wait() */
>  	io->bytes += urb->actual_length;
>  	io->count--;
> -	if (!io->count)
> +	if (!io->count) {
> +		if (status == -ECONNRESET) {
> +			printk(KERN_ERR "Delaying for test\n");
> +			mdelay(600);
> +		}
>  		complete(&io->complete);
> +	}
>  
>  	spin_unlock(&io->lock);
>  }
> 

I did so today on 2.6.36-rc8, without your other patch.  I was still unable to
reproduce the bug.  Forget the whole thing as unreproducible?
-- 
Stefan Richter
-=====-==-=- =-=- =----
http://arcgraph.de/sr/
