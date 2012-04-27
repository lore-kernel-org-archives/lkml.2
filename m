Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305Ab2D0OtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:49:20 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58837 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837Ab2D0OtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:49:19 -0400
Date: Fri, 27 Apr 2012 15:51:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Chen, Bo" <Bo.Chen@atmel.com>
Cc: "alan@linux.intel.com" <alan@linux.intel.com>,
        "rick@efn.org" <rick@efn.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Query] serial: AT91:  Add SIM Driver
Message-ID: <20120427155143.6b9720a3@pyramind.ukuu.org.uk>
In-Reply-To: <7AD597EA49E297498E79AFA326C986BB0D31A5CE@penmbx02>
References: <7AD597EA49E297498E79AFA326C986BB0D317277@penmbx01>
	<20120423115440.5bb1c7eb@pyramind.ukuu.org.uk>
	<7AD597EA49E297498E79AFA326C986BB0D31A5CE@penmbx02>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012 11:19:18 +0000
"Chen, Bo" <Bo.Chen@atmel.com> wrote:

> Hi Alan,
> 
> > One way would be to make ISO7816 a line discipline (the layer which sits about the tty).
> 
> >Your user space interface would then be
> 
> >	int ldisc = N_ISO7816;
> >	ioctl(tty_fd, TIOCSETD, &ldisc);
> 
> Make ISO7816 a line discipline would register it in driver(atmel_serial.c or a new named driver) via tty_register_ldisc(N_ISO7816, &tty_ldisc_ops)

Yes

> If I use ioctl(tty_fd, TIOCSETD, &ldisc), it will close current line discipline and open a new line discipline related to ISO7816 (tty_register_ldisc(N_ISO7816, &tty_ldisc_ops))?

Yes

> > at which point the read/write/ioctl etc calls on your tty will also be    > routed via your ldisc so you can manage them and provide ISO7816 sensible > interfaces
> 
> Does it mean when I call read/write/ioctl in user space, it will call tty_ldisc_ops functions (ISO7816 line discipline has been opened) such as gsmld_read/gsmld_write/gsmld_ioctl in N_gsm.c? What I need to do is to implement the interface in tty_ldisc_ops?

Yes. The read and write methods get called with the user buffer and size
requested being passed. The ioctl handler is called as well as part of the
standard tty handlers so that a line discipline can implement its own
ioctls.

> What is the reasonable way to add this line discipline, in atmel_serial.c or create a new driver (build as a module and dynamically load)? Would it be accepted by kernel mainline?

Probably as a separate driver. That makes it easier to test and to review.

Alan
