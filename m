Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab2APSLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:11:42 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39738 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755820Ab2APSLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:11:40 -0500
X-Sasl-enc: LbXOW/Ipp330mjcCmenPILorHVoOHCjYW+ZGjRW7/XCC 1326737499
Date: Mon, 16 Jan 2012 09:57:01 -0800
From: "greg@kroah.com" <greg@kroah.com>
To: Preston Fick <Preston.Fick@silabs.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3.2.0] cp210x: Bug fix for CP2104 baudrate usage,
 Bugzilla #42586
Message-ID: <20120116175701.GA23721@kroah.com>
References: <00374F755A5C474884D69FBCA77349D10493F97C2A@EXCAUS002.silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00374F755A5C474884D69FBCA77349D10493F97C2A@EXCAUS002.silabs.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 09:51:56PM -0600, Preston Fick wrote:
> From: Preston Fick <preston.fick@silabs.com>
> 
> This is a patch for the cp210x.ko driver with regards to the following bug report:
> CP2104 Device doesn't respond to baudrate change request
> Bug Report: #42586 in bugzilla.kernel.org: https://bugzilla.kernel.org/show_bug.cgi?id=42586
> 
> OS/Kernel version: GNU/Linux 3.2.0 (Mainline)
> 
> Description:
> This fix changes the way baudrates are set on the CP210x devices from Silicon Labs. The CP2101/2/3 will respond to both a GET/SET_BAUDDIV command, and GET/SET_BAUDRATE command, while CP2104 and higher devices only respond to GET/SET_BAUDRATE. The current cp210x.ko driver in kernel version 3.2.0 only implements the GET/SET_BAUDDIV command.
> 
> This patch implements the two new codes for the GET/SET_BAUDRATE commands. Then there is a change in the way that the baudrate is assigned or retrieved. This is done according to the CP210x USB specification in AN571. This document can be found here: http://www.silabs.com/pages/DownloadDoc.aspx?FILEURL=Support%20Documents/TechnicalDocs/AN571.pdf&src=DocumentationWebPart
> 
> Sections 5.3/5.4 describe the USB packets for the old baudrate method. Sections 5.5/5.6 describe the USB packets for the new method. This patch also implements the new request scheme, and eliminates the unnecessary baudrate calculations since it uses the "actual baudrate" method.
> 
> This patch solves the problem reported for the CP2104 in bug 42586, and also keeps support for all other devices (CP2101/2/3).
> 
> This patchfile is also attached to the bug report on bugzilla.kernel.org. This patch has been developed and test on the 3.2.0 mainline kernel version under Ubuntu 10.11.
> 
> Signed-off-by: Preston Fick <preston.fick@silabs.com>
> 
> ---
> 
> Thank you for the consideration of this patch.
> 
> Kind Regards -
> Preston Fick
> 
> Begin patchfile text:
> 
> diff -uNr linux.vanilla/linux-3.2/drivers/usb/serial/cp210x.c linux.new/linux-3.2/drivers/usb/serial/cp210x.c
> --- linux.vanilla/linux-3.2/drivers/usb/serial/cp210x.c	2012-01-04 17:55:44.000000000 -0600
> +++ linux.new/linux-3.2/drivers/usb/serial/cp210x.c	2012-01-13 11:35:44.031334039 -0600
> @@ -200,6 +200,8 @@
>  #define CP210X_EMBED_EVENTS	0x15
>  #define CP210X_GET_EVENTSTATE	0x16
>  #define CP210X_SET_CHARS	0x19
> +#define CP210X_GET_BAUDRATE	0x1D
> +#define CP210X_SET_BAUDRATE	0x1E
>  
>  /* CP210X_IFC_ENABLE */
>  #define UART_ENABLE		0x0001
> @@ -459,10 +461,7 @@
>  
>  	dbg("%s - port %d", __func__, port->number);
>  
> -	cp210x_get_config(port, CP210X_GET_BAUDDIV, &baud, 2);
> -	/* Convert to baudrate */
> -	if (baud)
> -		baud = cp210x_quantise_baudrate((BAUD_RATE_GEN_FREQ + baud/2)/ baud);
> +	cp210x_get_config(port, CP210X_GET_BAUDDIV, &baud, 4);

Shouldn't this be CP210X_GET_BAUDRATE ?

>  
>  	dbg("%s - baud rate = %d", __func__, baud);
>  	*baudp = baud;
> @@ -597,8 +596,7 @@
>  	if (baud != tty_termios_baud_rate(old_termios) && baud != 0) {
>  		dbg("%s - Setting baud rate to %d baud", __func__,
>  				baud);
> -		if (cp210x_set_config_single(port, CP210X_SET_BAUDDIV,
> -					((BAUD_RATE_GEN_FREQ + baud/2) / baud))) {
> +		if (cp210x_set_config(port, CP210X_SET_BAUDRATE, &baud, 4)) {
>  			dbg("Baud rate requested not supported by device");
>  			baud = tty_termios_baud_rate(old_termios);
>  		}
> This message (including any attachments) is intended only for the use of the individual or entity to which it is addressed and may contain information that is non-public, proprietary, privileged, confidential, and exempt from disclosure under applicable law or may constitute as attorney work product.  If you are not the intended recipient, you are hereby notified that any use, dissemination, distribution, or copying of this communication is strictly prohibited. If you have received this communication in error, notify us immediately by telephone and (i) destroy this message if a facsimile or (ii) delete this message immediately if this is an electronic communication.  

With a footer like this, that directly contridicts the Signed-off-by:
line, which do I believe?  As such, I can't accept patches with this
type of footer, please fix your email client and try again.

Also, how do the other patches sent to this list to solve the problem of
this device look to you?  Do you think yours should be applied instead
of them?

thanks,

greg k-h
