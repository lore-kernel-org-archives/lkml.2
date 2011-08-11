Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1HKPZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:25:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47489 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752238Ab1HKPZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:25:16 -0400
Date: Thu, 11 Aug 2011 16:25:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Hans de Goede <hdegoede@redhat.com>,
        Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
Message-ID: <20110811162530.5d1c6455@lxorguk.ukuu.org.uk>
In-Reply-To: <4E43F17F.6030604@infradead.org>
References: <Pine.LNX.4.44L0.1108111037240.1958-100000@iolanthe.rowland.org>
	<4E43F17F.6030604@infradead.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Between two or more kernel drivers, a resource locking mechanism like the one 
> you've proposed works fine, but, when the driver is on userspace, there's one
> additional issue that needs to be addressed: What happens if, for example,
> if a camera application using libgphoto2 crashes? The lock will be enabled, and
> the V4L driver will be locked forever. Also, if the lock is made generic enough
> to protect between two different userspace applications, re-starting the
> camera application won't get the control back.

Actually there are more issues than that - you've also got to worry about
a security/permission model, and that is hard to get right, especially if
you are not very careful that anything that can be retrieved which might
violate the security model (eg the last frame on the capture) has been
blanked before handover etc.

> To avoid such risk, kernel might need to implement some ugly hacks to detect
> when the application was killed, and put the device into a sane state, if this
> happens.

At which point history says it's easier to do the job right, once, in the
kernel.

> Again, applications that won't implement this control will take the lock forever.

And applications that are touching both video (even indirectly) and still
camera may get surprise deadlocks if they accidentally reference both the
still and video device even via some library or service.

> > Well, a user program can assume that the kernel driver left the device
> > in a clean state.  The reverse isn't always true, however -- it's one

Not it cannot - the user program doesn't know

a) if the kernel driver has ever been loaded
b) the values the kernel driver leaves set (and those will change no
doubt at times)
c) if the camera has been plugged and unplugged and not yet had the
kernel driver loaded

To me it sounds like a recipe for disaster. For those tiny number of
devices involved just use V4L and if need be some small V4L tweaks to
handle still mode. In most cases the interface is basically identical and
I'd bet much of the code is identical too.

Alan
