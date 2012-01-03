Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab2ACAS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 19:18:26 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33078 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab2ACASX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 19:18:23 -0500
Date: Tue, 3 Jan 2012 00:18:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Matthew Garrett <mjg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120103001851.3530f99d@pyramind.ukuu.org.uk>
In-Reply-To: <4F023E6B.2020307@fastmail.fm>
References: <4F02165C.1060400@fastmail.fm>
	<CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
	<20120102211904.GA15316@srcf.ucam.org>
	<CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com>
	<20120102215028.GA15701@srcf.ucam.org>
	<CA+55aFz73GuHiOW1NoAuJLea_GKLepiZjrnrgpOKdQizPgnhoA@mail.gmail.com>
	<20120102221235.GA16012@srcf.ucam.org>
	<CA+55aFyHvmvast_kuNddU3iotReR1mOpKM4HGAw80ma8kn+2-g@mail.gmail.com>
	<20120102222920.GA16160@srcf.ucam.org>
	<CA+55aFyUK6X7ip2UXV9iT07=qezXfbw82wn6UKAN8JFQtYNs5Q@mail.gmail.com>
	<20120102230037.GA16458@srcf.ucam.org>
	<4F023E6B.2020307@fastmail.fm>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You mensioned earlier about not being able to tell the difference
> between a device that needs firmware and one that needs flash (e.g. they
> use exactly the same ids). It doesn't really matter - we just assume
> that it might need firmware and load it anyway. It uses more memory but
> is robust.

We only need to do that for the devices where order and not blocking
matters. There are a few (and some are video) where the firmware sizes is
megabytes, which on an embedded controlling device is not acceptable. I
don't believe any of them are things where simply delaying the
restoration will cause problems however - its video, and DVB and the like
not wireless or serial.

Thankfully most of the firmwares for controllers like wireless are in the
Kb range although this is going to change dramatically as people start
putting things with more brains than an 8051 or AVR into their devices.

And there an awful lot of devices with tiny 8K or so firmware where if we
have get/put firmware nobody is going to *care* if we just cache it on
module load. 40K driver, 16K of buffers, 2K firmware.... 

> Also, as Linus mensioned, for some devices we just don't care. For
> example, if we drop a video call over suspend it's not ideal but it
> doesn't prevent the system from resuming.

Doesn't work generically though. Some ARM platforms (and Moorestown in the
x86 world) can suspend/resume as a power state. So while it's probably
true for USB it's not generically a property of suspend/resume that you
can assume in any kind of firmware and ordering model.

The world is heading this way more and more. It's moving from the old PC
model of 'user closes lid, clunk for 15 seconds, enter suspend, user
opens lid, churn churn, video, churn clunk. resume' to suspend/resume
being so fast it happens between keystrokes.

(There is a whole other can of pending worms there where 'suspend' isn't
 a single state as Linux and ACPI like to pretend. There are devices that
 can show the display while the machine is "suspended", devices that can
 play back mp3 files while the machine is "suspended" and so on. Imagine
 a world where you are listening to music on your phone without
 interruption, typing on the display which is showing all the time, and
 with the CPU and at the Linux level your device is suspended between
 keystrokes)

> Lets concentrate on fixing all the cases that could prevent resume (the "99%")
> and fix the other devices later.

The rules on regressions as stated by Linus are clear - no regressions. So
we need to make it work again, then fix it nicely.

Quite honestly the ugly cases with massive firmware files and the like
really want deferring, and some do that anyway with a userspace loader
for obvious reasons. Request_firmware really isn't very good for
'request bits of firmware one by one' either. Thankfully there are not
many of them.

Alan
