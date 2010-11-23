Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab0KWN5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:57:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59819 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751721Ab0KWN53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:57:29 -0500
Date: Tue, 23 Nov 2010 13:56:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Timur Tabi <timur@freescale.com>
Cc: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101123135621.5d100e81@lxorguk.ukuu.org.uk>
In-Reply-To: <4CEA9B00.1000804@freescale.com>
References: <20101118163321.GA2723@suse.de>
	<4CE5562B.8080604@freescale.com>
	<20101118165136.GA3103@suse.de>
	<4CE55ACB.80207@freescale.com>
	<20101118171856.GA4283@suse.de>
	<4CE5647F.5000203@freescale.com>
	<20101118175832.GA4931@suse.de>
	<4CE58005.7040308@freescale.com>
	<20101118200230.GA25715@suse.de>
	<4CE58736.4090703@freescale.com>
	<20101118201035.GA26287@suse.de>
	<4CE58FE5.3010502@freescale.com>
	<20101118205647.677404ec@lxorguk.ukuu.org.uk>
	<4CEA9B00.1000804@freescale.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You can - provide the required method in your console driver and it'll
> > get used by /dev/console. Funnily enough a lot of other platform and
> > consoles need that too.
> 
> Can you elaborate on that?  What is the "required method"?  My driver is mostly
> working now, but I have to supply the command-line "console=ttyEHV73" in order
> for the login prompt to show up.  Unfortunately, there's no way for the boot
> loader to know that the primary byte channel for stdout is #73, so I need a way
> for the driver to tell the kernel this.

Your console driver provides a device method (see kernel/printk.c).
When /dev/console is opened the kernel iterates the console list looking
for one with ->device and then calls that method. On success it expects
the passed int * to contain the minor number to use.

I suspect in your case you probably want to attach the primary byte
channel to minor 0 in the driver (and reserve it for that), or some
similar rule.

> Also, if I have a /dev/ttyEHV76 entry for a byte channel that's not the primary
> stdout tty, is the following supposed to work:
> 
> 	cat > /dev/ttyEHV76
> 
> That is, should I be able to use a TTY device as a normal character device,
> where I can just write and read characters?

Sort of - processing gets done but you can disable the processing easily
enough. If you have channels that are not tty related you may want to tap
them directly to avoid the overhead of the tty layer if they are high
data rate.

Alan
