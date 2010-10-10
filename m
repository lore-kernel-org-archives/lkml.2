Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab0JJMeW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 08:34:22 -0400
Received: from kroah.org ([198.145.64.141]:43664 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096Ab0JJMeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 08:34:21 -0400
Date: Sun, 10 Oct 2010 05:34:53 -0700
From: Greg KH <greg@kroah.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Alon Ziv <alon+git@nolaviz.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Add Opticon OPN2001 write support
Message-ID: <20101010123453.GA21060@kroah.com>
References: <1286692340-18639-1-git-send-email-alon-git@nolaviz.org> <1286692340-18639-3-git-send-email-alon-git@nolaviz.org> <4CB19B1F.9000300@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB19B1F.9000300@ru.mvista.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 02:53:19PM +0400, Sergei Shtylyov wrote:
> Hello.
>
> On 10-10-2010 10:32, Alon Ziv wrote:
>
>> OPN2001 expects write operations to arrive as a vendor-specific command
>> through the control pipe (instead of using a separate bulk-out pipe).
>
>> Signed-off-by: Alon Ziv<alon-git@nolaviz.org>
>> ---
>>   drivers/usb/serial/opticon.c |   30 ++++++++++++++++++++++++++----
>>   1 files changed, 26 insertions(+), 4 deletions(-)
>
>> diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
>> index 9ff19c8..4fe7c3d 100644
>> --- a/drivers/usb/serial/opticon.c
>> +++ b/drivers/usb/serial/opticon.c
> [...]
>> @@ -237,10 +240,29 @@ static int opticon_write(struct tty_struct *tty, struct usb_serial_port *port,
>>
>>   	usb_serial_debug_data(debug,&port->dev, __func__, count, buffer);
>>
>> -	usb_fill_bulk_urb(urb, serial->dev,
>> -			  usb_sndbulkpipe(serial->dev,
>> -					  port->bulk_out_endpointAddress),
>> -			  buffer, count, opticon_write_bulk_callback, priv);
>> +	if (port->bulk_out_endpointAddress) {
>> +		usb_fill_bulk_urb(urb, serial->dev,
>> +				  usb_sndbulkpipe(serial->dev,
>> +						  port->bulk_out_endpointAddress),
>> +				  buffer, count, opticon_write_bulk_callback, priv);
>
>    Please align all follow-up lines uniformly.

Not a big deal.

>> +	} else {
>> +		struct usb_ctrlrequest *dr;
>> +
>> +		dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
>
>    sizeof(*dr) is a preferred form.

No, people disagree on this, there is no 'preferred' form, you are free
to use either way.

>> +		usb_fill_control_urb(urb, serial->dev,
>> +			usb_sndctrlpipe(serial->dev, 0),
>> +			(unsigned char *)dr, buffer, count,
>> +			opticon_write_bulk_callback, priv);
>
>    More tabs needed for alignment, I think...

It's fine, not a big deal.

thanks,

greg k-h
