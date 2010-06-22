Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab0FVOtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 10:49:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44414 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754366Ab0FVOtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 10:49:32 -0400
Date: Tue, 22 Jun 2010 10:49:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
cc: linux-kernel@vger.kernel.org, <gregkh@suse.de>, <rjw@sisk.pl>
Subject: Re: [BISECTED] Suspend regression in v2.6.31 with Lenovo 3000 v200
In-Reply-To: <201006221209.26044.ozan@pardus.org.tr>
Message-ID: <Pine.LNX.4.44L0.1006221039530.1631-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jun 2010, Ozan [utf-8] Çağlayan wrote:

> Here's the debugged dmesg output. The second dmesg output is quiet similar to this, it's port 5
> which causes the suspend to fail. I'll try to give you more details in case you want,

> [    2.450062] usb 2-5: new high speed USB device using ehci_hcd and address 3
> [    2.502338] ehci_hcd 0000:00:1d.7: port 5 high speed
> [    2.502351] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
> [    2.572163] usb 2-5: default language 0x0409
> [    2.573479] usb 2-5: udev 3, busnum 2, minor = 130
> [    2.573487] usb 2-5: New USB device found, idVendor=0402, idProduct=5602
> [    2.573493] usb 2-5: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> [    2.573499] usb 2-5: Product: USB2.0 Camera
> [    2.573631] usb 2-5: uevent
> [    2.573662] usb 2-5: usb_probe_device
> [    2.573669] usb 2-5: configuration #1 chosen from 1 choice
> [    2.573759] usb 2-5: adding 2-5:1.0 (config #1, interface 0)

> [    9.838986] ALi m5602 2-5:1.0: usb_probe_interface
> [    9.838989] ALi m5602 2-5:1.0: usb_probe_interface - got id
> [    9.838992] gspca: probing 0402:5602
> [    9.838995] ALi m5602: Probing for a po1030 sensor
> [    9.852853] ALi m5602: Probing for a mt9m111 sensor
> [    9.869979] ALi m5602: Probing for a s5k4aa sensor
> [    9.897729] ALi m5602: Detected a s5k4aa sensor

> [   80.547050] usb usb2: bus suspend
> [   80.547051] ehci_hcd 0000:00:1d.7: suspend root hub
> [   80.547053] ehci_hcd 0000:00:1d.7: suspend failed because port 5 is resuming
> [   80.547055] usb usb2: bus suspend fail, err -16

Okay, the bus is usb2, the device attached to port 5 is a USB camera, 
and it uses the Ali m5602 driver.  I have seen similar reports before, 
but they involved a webcam using the uvcvideo driver.

Anyway, the problem is that the camera sends a wakeup request, which
causes the suspend to be aborted.  I can't imagine why a camera would
want to send a wakeup request -- probably it's a bug in the firmware.
You can work around it by manually (or in a udev script) disabling
wakeup on the camera:

	echo disabled >/sys/bus/usb/devices/2-5/power/wakeup

Or you can back-port the patch that fixed the problem, commit 
7aba8d014341341590ecb64050b7a026642a62eb (USB: don't enable remote 
wakeup by default).

Alan Stern


