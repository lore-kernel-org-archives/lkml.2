Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab2D3Xbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 19:31:35 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54151 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab2D3Xbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 19:31:34 -0400
Date: Tue, 1 May 2012 00:34:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: NeilBrown <neilb@suse.de>, linux-serial@vger.kernel.org,
        linux-pm@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Question:  How to power-manage UART-attached devices.
Message-ID: <20120501003420.028b57ec@pyramind.ukuu.org.uk>
In-Reply-To: <4F9F178F.3030408@zytor.com>
References: <20120501082209.0b560708@notabene.brown>
	<4F9F178F.3030408@zytor.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2012 15:51:59 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 04/30/2012 03:22 PM, NeilBrown wrote:
> > 
> > What I would really like is to integrate it closely with the state
> > of the UART.  i.e. if the /dev/ttyO1 device is open, then the GPS
> > is "on".  If not then it is "off".  Similarly if /dev/tty/O0 is
> > open, bluetooth is "on", else "off". However I cannot find any way
> > to "plug in" to the tty or serial drivers to perform an arbitrary
> > action on first-open or last-close.  Is something like that
> > possible? If not, is it a reasonable thing to ask? Any suggests
> > about where to put such a hook?
> > 
> 
> I don't think that's the right interface.  Just because the port is
> currently open doesn't mean the device is active, nor vice versa.  ALL
> it means is that someone currently has an access handle to it.
> 
> Since a serial port models, well, a *port*, it is logical to think of
> a (hypothetical) socket containing an RS-232 connector as well as a
> power outlet.  Given that, it would be logical to drive the "power
> connector" using the same type of interface used for the other parts
> of an RS-232 control, meaning either with termios flags or via a
> dedicated control ioctl (TIOCPOWER?).

Actually several of our virtual tty interfaces treat open as meaning
powered up. It's a fairly logical power management model. A lot of our
real tty ports do the same as well and kill power on the last close.

At the tty layer the tty_port helper callbacks port->activate() and
port->shutdown() provide the needed functionality.

You don't however want to be "hooking" this - your platform needs to
provide its own versions of the relevant operations in the OMAP serial
driver.

Alan
