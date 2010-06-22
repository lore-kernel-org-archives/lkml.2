Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab0FVRrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:47:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52019 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756211Ab0FVRrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:47:13 -0400
Date: Tue, 22 Jun 2010 13:47:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
cc: linux-kernel@vger.kernel.org, <gregkh@suse.de>, <rjw@sisk.pl>
Subject: Re: [BISECTED] Suspend regression in v2.6.31 with Lenovo 3000 v200
In-Reply-To: <4C20EA74.6090109@pardus.org.tr>
Message-ID: <Pine.LNX.4.44L0.1006221327010.1322-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jun 2010, [UTF-8] Ozan Çağlayan wrote:

> Alan Stern wrote:
> 
> > Okay, the bus is usb2, the device attached to port 5 is a USB camera, 
> > and it uses the Ali m5602 driver.  I have seen similar reports before, 
> > but they involved a webcam using the uvcvideo driver.
> > 
> > Anyway, the problem is that the camera sends a wakeup request, which
> > causes the suspend to be aborted.  I can't imagine why a camera would
> > want to send a wakeup request -- probably it's a bug in the firmware.
> > You can work around it by manually (or in a udev script) disabling
> > wakeup on the camera:
> > 
> > 	echo disabled >/sys/bus/usb/devices/2-5/power/wakeup
> > 
> > Or you can back-port the patch that fixed the problem, commit 
> > 7aba8d014341341590ecb64050b7a026642a62eb (USB: don't enable remote 
> > wakeup by default).
> > 
> > Alan Stern
> 
> Thank you very much for your help but it seems that core/hub.c in 2.6.31.13
> doesn't even include device_set_wakeup_enable() call that the commit you've
> mentioned removes. There are 2 calls in core/hcd.c and 1 in core/hcd-pci.c
> which at a quick glance still exists in the current master.
> 
> Should I disable the the remote wakeup in somewhere else or does that commit
> doesn't really fix the issue?

Sorry about that; a couple of changes have been made in that area since
2.6.31 was released.

Here's what you need to do: In 2.6.31's hub.c there are two calls to 
device_init_wakeup(), both inside usb_set_device_state().  Change both 
of them into calls to device_set_wakeup_capable() and that should fix 
the problem.  This is what the first part of commit 
16985408b5c48585762ec3b9b7bae1dec4ad7437 does (but the second half of 
that commit will reintroduce the problem, so don't apply it).

You can verify the result by checking the contents of 
/sys/bus/usb/devices/2-5/power/wakeup (replace the 2-5 with the correct 
path for the camera device).  With the current code it will say 
"enabled", but after the change it should say "disabled".

Alan Stern

