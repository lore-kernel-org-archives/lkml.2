Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab1KWTdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:33:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:14258 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab1KWTdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:33:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,560,1315206000"; 
   d="scan'208";a="88611635"
Date: Wed, 23 Nov 2011 19:44:23 +0000
From: Alan Cox <alan@linux.intel.com>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC] cdc-acm: Fix potential deadlock (lockdep warning)
Message-ID: <20111123194423.158002cf@bob.linux.org.uk>
In-Reply-To: <CAFQmdRYh3vSz4s-ks5dbz7bXJx-EZNHEGzsr5bcpEYquXmB6Fg@mail.gmail.com>
References: <CAFQmdRbkYiOArK09smfMvf2DJ8h-bYvKyXRN_nmX-bPG8ENmjA@mail.gmail.com>
	<1322074412-10873-1-git-send-email-hskinnemoen@google.com>
	<20111123192233.44f512b7@bob.linux.org.uk>
	<CAFQmdRYh3vSz4s-ks5dbz7bXJx-EZNHEGzsr5bcpEYquXmB6Fg@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, by USB side kref do you mean the tty_port_get/put calls I
> introduced in this patch, or a kref associated with the USB device
> itself?

The USB serial driver krefs its USB related objects too

> Ok, so the basic idea is:
>   * USB side: tty_port_get() in probe, tty_port_put() in disconnect
>   * TTY side: tty_port_get() in install, tty_port_put() in remove
> 
> And I need to check if the device is properly marked as disconnected,
> switch to vhangup, and possibly reorder things a bit as well. Right?

You shouldn't need to do the port_get in the probe or the put in the
disconnect path. The install/remove one is sufficient for all the
tty_port data because the only way a new open can occur is if the
install succeeds. So providing install and remove are suitably locked
(see the usb_serial.c code) the other cases shouldn't matter.

Any data owned by the USB part needs to be handled by the USB driver.
In the case of usb-serial it keeps its own krefs for that because the
lifetime of the port/USB serial data is not the same as the lifetime of
the tty itself.

The lifetime model is intended to be

object discovered
	Port created

	one or more iterations of
	{
		tty_install (refcounts the port and USB data)
		tty opened
		tty created

		[activity]

		tty closed final time
		tty destroyed (drops a reference on the port and USB
		data)
	}

	Port destroyed

and if the object is destroyed while the tty is opened tty_vhangup
ensures that all the linkages are broken and the port itself can be
destroyed after the last user.

That is tty_struct has a lifetime of open - close (plus a bit for any
active receive etc) while the tty_port is usually embedded in the USB
related material and has a life time of object creation to the point
that the object has gone away AND there are no ttys in existence using
it, hung up or otherwise. The tty "cleanup" hook may be useful for
that. It is called asynchronously as part of the the destructor for the
tty object.

In some ways its easier to read usb-serial.c than describe it



