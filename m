Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1ASP3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:29:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62919 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab1ASP3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:29:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=YdOBkughnVfzuI1DwrMxS1rEVLYFECzllZB3JbKyJeftOK7LOGkg6Cq2tlAQyI8UMM
         ilPJLm6Kyjp4iXcnfN4B1xvSHr84S6pQez2L2hp7U9oL23p6sVC4MFT/wujWcVz/S1df
         m7MHENEahLGXtW1iITq2R9nFUC2iLdnfv3hPI=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: monstr@monstr.eu
Cc: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Uartlite - ulite_transmit
References: <4D2465E0.2000707@monstr.eu> <4D246672.3070002@monstr.eu>
	<87vd22h3dq.fsf@macbook.be.48ers.dk> <4D257D61.2060400@monstr.eu>
	<87r5cqh0bn.fsf@macbook.be.48ers.dk> <4D25871D.2000408@monstr.eu>
	<87mxnegy4u.fsf@macbook.be.48ers.dk> <4D26C538.3010101@monstr.eu>
	<4D26D79C.8060304@monstr.eu> <4D2D78F3.2040903@monstr.eu>
	<87aaj6zays.fsf@macbook.be.48ers.dk> <4D2D8113.1020504@monstr.eu>
	<8739oyza2n.fsf@macbook.be.48ers.dk> <4D32B5A2.1070508@monstr.eu>
	<87r5cc5zqp.fsf@macbook.be.48ers.dk> <4D345DA3.8020105@monstr.eu>
Date: Wed, 19 Jan 2011 16:27:02 +0100
In-Reply-To: <4D345DA3.8020105@monstr.eu> (Michal Simek's message of "Mon, 17
	Jan 2011 16:17:55 +0100")
Message-ID: <87oc7cgbi1.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Michal" == Michal Simek <monstr@monstr.eu> writes:

Hi,

 >> The problem is the uart_flush_buffer() call we see after uart_open() in
 >> 4. If doesn't seem to come from serial_core (only called from uart_close
 >> / uart_hangup), so presumably it comes from the TTY core or
 >> userspace. Could you add a bit more debug to figure out where exactly it
 >> comes from?

 Michal> Last week I have also implemented simple ioctl function for
 Michal> uartlite - just printk to see what happen. Look at the second
 Michal> log below.

 Michal> uart_open(0) called
 Michal> ulite_ioctl 5401 bff76a18
 Michal> n_tty_ioctl
 Michal> ulite_ioctl 540b 2
 Michal> n_tty_ioctl
 Michal> n_tty_ioctl_helper TCFLSH
 Michal> tty_perform_flush TCIOFLUSH
 Michal> tty_perform_flush TCOFLUSH
 Michal> tty_driver_flush_buffer
 Michal> uart_flush_buffer(0) called

So your userspace is calling tcflush, and serial_core responds by
flushing (dropping) the buffer. That seems like expected behaviour to
me.

This is presumably from the busybox getty applet, which does:

static void termios_init(struct termios *tp, int speed, struct options *op)
{
	speed_t ispeed, ospeed;
	/*
	 * Initial termios settings: 8-bit characters, raw-mode, blocking i/o.
	 * Special characters are set after we have read the login name; all
	 * reads will be done in raw mode anyway. Errors will be dealt with
	 * later on.
	 */
	/* flush input and output queues, important for modems! */
	tcflush(0, TCIOFLUSH);

You could change that to a tcdrain() if that's not what you want.

-- 
Bye, Peter Korsgaard
