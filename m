Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0IUMbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 08:31:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:53835 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622Ab0IUMbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 08:31:23 -0400
Date: Tue, 21 Sep 2010 14:31:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Phil Turmel <philip@turmel.org>
Cc: Mat <jackdachef@gmail.com>, Guillaume Chazarain <guichaz@gmail.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Alan Ott <alan@signal11.us>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Andreas Bombe <aeb@debian.org>, Alex Riesen <raa.lkml@gmail.com>,
        Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st insert,
 ignored on 2nd insert, lsusb stuck at usbdev_open
In-Reply-To: <4C979C79.9090901@turmel.org>
Message-ID: <alpine.LNX.2.00.1009211156520.26813@pobox.suse.cz>
References: <4C96B9DB.8030403@turmel.org> <AANLkTi=1zh4hD-1uzpgjAsnKZBE=qi_ZAX-ug=2XMkW0@mail.gmail.com> <alpine.LNX.2.00.1009201440140.26813@pobox.suse.cz> <4C975F79.9060609@turmel.org> <alpine.LNX.2.00.1009201524340.26813@pobox.suse.cz>
 <AANLkTim6PBGEBz8_PVpK2YajgtejsbAgL11i+DMN-7jh@mail.gmail.com> <alpine.LNX.2.00.1009201708340.26813@pobox.suse.cz> <4C979C79.9090901@turmel.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Phil Turmel wrote:

> dmesg attached.  Note: the timestamp of the BUG corresponds to hal 
> startup when the external mouse is plugged in before booting.

Mat, Phil, Gabriel,

thanks for providing the dmesg with the debugging patch in place. Here we 
go:

[snip]
> [    3.268784] HID debug: usbhid_probe() -- set intfdata(ffff880137d0ac00, ffff88013a7c0000)
> [    3.278462] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input6
> [    3.285212] HID debug: hid_connect() -- hid: ffff88013a7c0000
> [    3.286141] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input7
> [    3.287413] generic-usb 0003:046D:C51B.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1/input0

hid device pointer 0xffff88013a7c0000, usb_interface pointer 
0xffff880137d0ac00. This interface doesn't get registered with hiddev.

> [    3.288338] HID debug: usbhid_probe() -- set intfdata(ffff880137d0a400, ffff880138344000)
> [    3.303524] HID debug: hid_connect() -- hid: ffff880138344000
> [    3.304424] HID debug: hiddev_connect() -- hid: ffff880138344000, hiddev: ffff880137ce9f00, intf: ffff880137d0a400
> [    3.305678] HID debug: hid_connect() -- after hiddev_connect(), hid: ffff880138344000, hiddev: ffff880137ce9f00
> [    3.306609] generic-usb 0003:046D:C51B.0002: hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1/input1

hid device pointer 0xffff880138344000, usb_interface pointer 
0xffff880137d0a400. This interface does get registered with hiddev 
(allocated at 0xffff880137ce9f00), doesn't get registered with input. So 
far so good.

[snip]
> [   22.705849] HID debug: hiddev_open(): hid: ffff88013a7c0000, hiddev: (null), intf: ffff880137d0ac00

hiddev_open() has been called. usb_find_interface(&hid_driver, minor) 
returned interface pointer 0xffff880137d0ac00. Which is bogus! Interface 
0xffff880137d0ac00 is not registered with hiddev at all, we should have 
received 0xffff880137d0a400.

We currently register minors only for those usbhid devices (through 
usb_register_dev() in hiddev_connect()) which are going to be claimed by 
hiddev. It doesn't seem to be problematic to me, and I don't undersntand 
why usb_find_interface() returns wrong interface.

I have just found out that it's actually CONFIG_USB_DYNAMIC_MINORS which 
makes the difference. When unset, the problem doesn't trigger, and 
usb_find_interface() always returns the proper interface. When 
CONFIG_USB_DYNAMIC_MINORS is being used, the oops happen.

I'll look into that.

> [   22.705859] BUG: unable to handle kernel NULL pointer dereference at (null)

This is then immediate consequence, as that device has nothing associated 
in its hiddev pointer of course.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
