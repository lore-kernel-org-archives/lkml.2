Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab1DYLju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 07:39:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37519 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932199Ab1DYLjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 07:39:49 -0400
Date: Mon, 25 Apr 2011 12:40:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jimmy Chen (=?big5?B?s6+lw7lG?=) <jimmy.chen@moxa.com>
Cc: <linux-kernel@vger.kernel.org>, <gregkh@suse.de>
Subject: Re: [PATCH 2/2] misc: add real function open/read/write/ioctl/close
 for moxa_serial_io driver
Message-ID: <20110425124049.0a852385@lxorguk.ukuu.org.uk>
In-Reply-To: <ECB3782BB8F03341905DD923270296115D5AC2@mhqms01.moxa.com>
References: <ECB3782BB8F03341905DD923270296115D5ABC@mhqms01.moxa.com>
	<ECB3782BB8F03341905DD923270296115D5AC2@mhqms01.moxa.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add real function and GPL license.

We really don't need an entire extra copy of the GPL. There is one in the
source tree already to which you can refer!

In code terms:
	- We have an expected interface for RS485/RS232 switching which
	  is in the serial drivers. So the functionality is good but it
	  really wants connecting to the serial driver.



> -/* write function called when to /dev/mxsio is written */
> -static ssize_t io_write (struct file *file, const char *buf,
> -		size_t count, loff_t *ppos) {
> -	int err;
> -	err = copy_from_user(string,buf,count);
> -
> -	if(count < 3)
> -		return -EINVAL;
> -	if (err != 0)
> -		return -EFAULT;
> -
> -	outb((unsigned char)string[2], (((unsigned short)string[0])<<8)|((unsigned short)string[1]));

This can access anything so is entirely unsafe and unsuitable. Also you
have no locking but use static buffers.

> -		outb(do_state_keep,BASEPORT+5);

BASEPORT appears to be a magic constant - where does it come from given
0x8000 is usually in PCI space ?

> -	outb(do_state_keep, BASEPORT+5);
> -	outb(0x00, BASEPORT);
> -	
> -	/* set default serial mode to RS232 */
> -	outb(0x88, BASEPORT+4);

No checks to see if the relevant hardware is really present - so it will
crash other systems

> -void superio_enter_config(void) {
> -#if defined(DA681)
> -	outb (0x87, SUPERIO_CONFIG_PORT);
> -	outb(0x80, 0xeb); // a Small delay
> -	outb (0x87, SUPERIO_CONFIG_PORT);
> -	outb(0x80, 0xeb); // a Small delay
> -#elif defined(V21XX)
> -	outb (0x87, SUPERIO_CONFIG_PORT);
> -	outb (0x01, SUPERIO_CONFIG_PORT);
> -	outb (0x55, SUPERIO_CONFIG_PORT);
> -	outb (0x55, SUPERIO_CONFIG_PORT);
> -#endif

And what if a kernel is being built for two different configs at once ?

> -}
> -
> -void superio_exit_config(void) {
> -	outb(0x02, SUPERIO_CONFIG_PORT);
> -        outb( 0x80, 0xeb); // a Small delay

Use outb_p()

the kernel then will figure out the right way to do the delay. Poking
random I/O ports won't do what you want on some systems and may even
crash them.
