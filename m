Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab0JYTtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:49:21 -0400
Received: from mxout5.netvision.net.il ([194.90.9.29]:48124 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab0JYTtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:49:20 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Message-id: <4CC5DF22.6020203@nolaviz.org>
Date: Mon, 25 Oct 2010 21:48:50 +0200
From: Alon Ziv <alon@nolaviz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14)
 Gecko/20101006 Lightning/1.0b1 Thunderbird/3.0.9
To: Johan Hovold <jhovold@gmail.com>
Cc: Alon Ziv <alon+git@nolaviz.org>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] opticon: use generic code where possible
References: <1287859409-13810-1-git-send-email-alon-git@nolaviz.org>
 <1287859409-13810-3-git-send-email-alon-git@nolaviz.org>
 <20101025111126.GA4046@localhost>
In-reply-to: <20101025111126.GA4046@localhost>
X-Enigmail-Version: 1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,


Thanks for the review.

Please see my replies below.


On 10/25/2010 01:11 PM, Johan Hovold wrote:

>>  
>>  /* max number of write urbs in flight */
>>  #define URB_UPPER_LIMIT	4
>
> This one is no longer needed.
>
Removed.
>
> [...]
>
> Here it seems you're turning write into a blocking function if you have
> no bulk-out end-point. I'm not sure that is desired.
>

Right...
I considered doing it differently (which would require more code--I
would need to track the outstanding control URBs, and would need a
callback to free the kmalloc()ed setup packet). In the end, I left it as
blocking because the actual protocol used by the OPN2001 is very light
on writes (in fact, it never writes anything without waiting for a
response, and its longest outgoing message is
limited to 70 bytes).

>>  }
>>  
>>  static int opticon_write_room(struct tty_struct *tty)
>>  {
>>  	struct usb_serial_port *port = tty->driver_data;
>> -	struct opticon_private *priv = usb_get_serial_data(port->serial);
>> -	unsigned long flags;
>> -
>> -	dbg("%s - port %d", __func__, port->number);
>> -
>> -	/*
>> -	 * We really can take almost anything the user throws at us
>> -	 * but let's pick a nice big number to tell the tty
>> -	 * layer that we have lots of free space, unless we don't.
>> -	 */
>> -	spin_lock_irqsave(&priv->lock, flags);
>> -	if (priv->outstanding_urbs > URB_UPPER_LIMIT * 2 / 3) {
>> -		spin_unlock_irqrestore(&priv->lock, flags);
>> -		dbg("%s - write limit hit", __func__);
>> -		return 0;
>> -	}
>> -	spin_unlock_irqrestore(&priv->lock, flags);
>> -
>> -	return 2048;
>> +	if (port->bulk_out_endpointAddress)
>> +		return usb_serial_generic_write_room(tty);
>> +	else
>> +		return 64;
>
> Why limit to 64b in the no-bulk-out case when driver used to report and
> use 2048b (which matches tty-layers partitioning)?
>
Good question, actually...
(I remembered a control packet cannot transfer more than 64B, but my
memory was wrong)
 
>>  }
>>  
>>  static void opticon_throttle(struct tty_struct *tty)
>>  {
>> -	struct usb_serial_port *port = tty->driver_data;
>> -	struct opticon_private *priv = usb_get_serial_data(port->serial);
>> -	unsigned long flags;
>> -
>> -	dbg("%s - port %d", __func__, port->number);
>> -	spin_lock_irqsave(&priv->lock, flags);
>> -	priv->throttled = true;
>> -	spin_unlock_irqrestore(&priv->lock, flags);
>> +	usb_serial_generic_throttle(tty);
>>  }
>
> You should remove this function and set the throttle field to
> usb_serial_generic_throttle in opticon_device instead.
>
Will do.
>>  static void opticon_unthrottle(struct tty_struct *tty)
>>  {
>> -	struct usb_serial_port *port = tty->driver_data;
>> -	struct opticon_private *priv = usb_get_serial_data(port->serial);
>> -	unsigned long flags;
>> -	int result, was_throttled;
>> -
>> -	dbg("%s - port %d", __func__, port->number);
>> -
>> -	spin_lock_irqsave(&priv->lock, flags);
>> -	priv->throttled = false;
>> -	was_throttled = priv->actually_throttled;
>> -	priv->actually_throttled = false;
>> -	spin_unlock_irqrestore(&priv->lock, flags);
>> -
>> -	priv->bulk_read_urb->dev = port->serial->dev;
>> -	if (was_throttled) {
>> -		result = usb_submit_urb(priv->bulk_read_urb, GFP_ATOMIC);
>> -		if (result)
>> -			dev_err(&port->dev,
>> -				"%s - failed submitting read urb, error %d\n",
>> -							__func__, result);
>> -	}
>> +	usb_serial_generic_unthrottle(tty);
>>  }
>
> You should remove this function and set the unthrottle field in
> opticon_device instead.
>   
Ditto.

>>  static int opticon_tiocmget(struct tty_struct *tty, struct file *file)
>>  {
>>  	struct usb_serial_port *port = tty->driver_data;
>>  	struct opticon_private *priv = usb_get_serial_data(port->serial);
>> -	unsigned long flags;
>>  	int result = 0;
>>  
>>  	dbg("%s - port %d", __func__, port->number);
>>  
>> -	spin_lock_irqsave(&priv->lock, flags);
>>  	if (priv->rts)
>>  		result = TIOCM_RTS;
>> -	spin_unlock_irqrestore(&priv->lock, flags);
>>  
>>  	dbg("%s - %x", __func__, result);
>>  	return result;
>>  }
>
> Locking no longer needed?
>
It was never really there...
The old code used to set rts without the lock, and only read with the
lock--quite meaningless. And since there is only a single writer and a
single reader (and the data type is inherently atomic), I see no reason
for locking.
>
>>  
>>  static struct usb_serial_driver opticon_device = {
>> @@ -545,16 +223,15 @@ static struct usb_serial_driver opticon_device = {
>>  		.name =		"opticon",
>>  	},
>>  	.id_table =		id_table,
>> -	.usb_driver = 		&opticon_driver,
>> +	.usb_driver =		&opticon_driver,
>>  	.num_ports =		1,
>> -	.attach =		opticon_startup,
>> -	.open =			opticon_open,
>> -	.close =		opticon_close,
>> +	.bulk_out_size =	1024,
>
> This is a fairly large value. Have you made any benchmarking to
> determine it? 256b have otherwise proven to be a good trade-off value
> for several drivers. (In particular, having a too large buffer size
> implied a great penalty on some embedded system I used for
> benchmarking.)
>
Actually--no, I did not benchmark. I just looked at various other
drivers, saw the numbers are all over the map, and pulled a number out
of my (metaphorical) hat.
And anyway--the actual device I am using (OPN2001) does not use the
bulk-out at all.
So I'll change to 256, but I still won't be able to prove it right (or
wrong).

Thanks again,
-az
