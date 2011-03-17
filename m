Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1CQKqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:46:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54532 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753766Ab1CQKqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:46:09 -0400
Date: Thu, 17 Mar 2011 10:46:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@suse.de>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Subject: Re: serial167 (was: Re: [RFC 0/5] tty: move stuff around)
Message-ID: <20110317104618.095f16ba@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=+ckqwFUH-4U3hyj=FDM7oNtBO9TOPTT3MAwDC@mail.gmail.com>
References: <AANLkTi=+ckqwFUH-4U3hyj=FDM7oNtBO9TOPTT3MAwDC@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As serial167 is now in staging in Linus tree...
> 
> It still builds in 2.6.38. What is unsecure about it? If nothing,
> please move it back,
> as the whole MVME167 platform is pretty useless without its console driver.

It has no reference counting and it doesn't use tty_port objects.

The former has been required for many releases otherwise your tty objects
are going to vanish under you and stuff, the latter is now used by all
'active' drivers and once we have total coverage will allow a lot of
simplification as it will mean a lot of structures that belong to the
physical port lifetime can be put there - like the tty input buffers.

You have other problems too - eg startup and shutdown depend upon the big
kernel lock - which is now gone from those areas.

The tty_port helpers now in the kernel will do a lot of the work for you.
They are designed to do all the locking and nastiness around
open/close/hangup and provide you with serialized simple handling for
startup/shutdown.

At minimum you want to add tty refcounting and tty port objects. If you
use the tty_port helpers for open/close/hangup and rip out all but the
tiny core bits of startup/shutdown etc that should also sort out the main
other problems.

Going via info->tty can be done via tty_port_tty_get() but in this driver
you can probably prove it's safe to take a kref when you assign the
port->tty field and drop it on shutdown at least for the IRQ paths, for
some of the none IRQ paths it looks like tty should be passed down. I am
not sure about user triggered vhangup() being ok to just keep the single
ref. tty_port_tty_get() at the start of the IRQ handler, passing the
tty reference around and putting the kref at the end would be a fraction
heavier but should be bulletproof.

Bringing it up to the 21st century might not be a bad idea either -
consts, platform device, no hardcoded board specific hackery, not
essential but if the rest of the driver is getting a much needed service
perhaps it's worth treating as it was a new submission and giving it a
full review and cleanup to modern spec ? We wouldn't accept the existing
driver as a submission today.

Alan
