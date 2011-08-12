Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab1HLHBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 03:01:30 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:52671 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1HLHB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 03:01:29 -0400
Date: Fri, 12 Aug 2011 15:01:11 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Bjorn Helgaas <bhelgaas@google.com>
cc: Andrey Panin <pazke@centrinvest.ru>, lkml <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: How to access serial port that is set in BIOS as OS Controlled
Message-ID: <Pine.LNX.4.64.1108121443200.26481@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Aug 12, 2011 at 5:49 AM, Bjorn Helgaas <bhelgaas@google.com> 
wrote:

> Oops, my mistake.  You now need "pnp.debug=1" to turn the extra debug

Now, I do see more messages and "resources" show "active" ...


# dmesg
pnp 00:00: parse allocated resources
pnp 00:01: parse allocated resources
pnp 00:01: PNP0c02: calling 0xc11c8a0c
pnp 00:02: parse allocated resources
pnp 00:02: PNP0c02: calling 0xc11c8a0c
pnp 00:03: parse allocated resources
pnp 00:04: parse allocated resources
pnp 00:05: parse allocated resources
pnp 00:06: parse allocated resources
pnp 00:07: parse allocated resources
pnp 00:08: parse resource options
pnp 00:08:   dependent set 0 (acceptable) io  min 0x3f8 max 0x3f8 align 
1 size 8 flags 0x1
pnp 00:08:   dependent set 0 (acceptable) irq 4 flags 0x1
pnp 00:08: parse allocated resources
pnp 00:08: set resources
pnp 00:09: parse resource options
pnp 00:09:   dependent set 0 (acceptable) io  min 0x2f8 max 0x2f8 align 
1 size 8 flags 0x1
pnp 00:09:   dependent set 0 (acceptable) irq 3 flags 0x1
pnp 00:09: parse allocated resources
pnp 00:09: set resources
pnp 00:0a: parse resource options
pnp 00:0a:   dependent set 0 (acceptable) io  min 0x3e8 max 0x3e8 align 
pnp 00:0a:   dependent set 0 (acceptable) irq 6 flags 0x1
pnp 00:0a: pnp_assign_resources, try dependent set 0
pnp 00:0a: pnp_assign_resources succeeded: current resources:
pnp 00:0a: [io  0x03e8-0x03ef flags 0x40000101]
pnp 00:0a:   dependent set 0 (acceptable) irq 6 flags 0x1
pnp 00:0a: pnp_assign_resources, try dependent set 0
pnp 00:0a: pnp_assign_resources succeeded: current resources:
pnp 00:0a: [io  0x03e8-0x03ef flags 0x40000101]
pnp 00:0a: [irq 6 flags 0x40000401]
pnp 00:0a: set resources
pnp 00:0b: parse resource options
pnp 00:0b:   dependent set 0 (acceptable) io  min 0x2e8 max 0x2e8 align 
1 size 8 flags 0x1
pnp 00:0b:   dependent set 0 (acceptable) irq 12 flags 0x1
pnp 00:0b: parse allocated resources
pnp 00:0b: set resources
serial 00:0a: pnp_assign_resources, try dependent set 0
serial 00:0a: pnp_assign_resources succeeded: current resources:
serial 00:0a: [io  0x03e8-0x03ef flags 0x40000101]
serial 00:0a: [irq 6 flags 0x40000401]
serial 00:0a: pnp_start_dev: current resources:
serial 00:0a: [io  0x03e8-0x03ef flags 0x40000101]
serial 00:0a: [irq 6 flags 0x40000401]
serial 00:0a: set resources
serial 00:0a: encode 2 resources
serial 00:0a:   encode io 0x3e8-0x3ef decode 0x1
serial 00:0a:   encode irq 6 edge high exclusive (2-byte descriptor)


# cat /sys/bus/pnp/devices/00:0a/resources
state = active
io 0x3e8-0x3ef
irq 6


# setserial /dev/ttyS2
/dev/ttyS2, UART: 16550A, Port: 0x03e8, IRQ: 6


# echo activate > /sys/bus/pnp/devices/00:0a/resources
-bash: echo: write error: Device or resource busy

# dmesg
serial 00:0a: in use; can't configure
serial 00:0a: in use; can't configure


# echo disable > /sys/bus/pnp/devices/00:0a/resources
-bash: echo: write error: Device or resource busy

# dmesg
serial 00:0a: in use; can't configure
serial 00:0a: in use; can't configure


> This *should* work.  My guess is that it's failing because the I/O ports 
> at 0x3e8 are still reserved.  The PNP core doesn't actually reserve 
> anything, so it would have to be the 8250 driver.  It doesn't mention 
> those ports in dmesg, so maybe they get reserved when you do the 
> "setserial."

It's working better now. But, the port is now always active and can't be 
disabled.


> The 8250 driver has no idea that you disabled the PNP device, so it 
> would never release them.  Then when you try to activate it again, 
> they're still in use.  You can test this idea a little bit by looking at 
> /proc/ioports (1) immediately after boot, (2) before "setserial", (3) 
> after "setserial", and (4) after you disable the PNP device.

It always shows the same info, except I can't disable the port.

# cat /proc/ioports
   03e8-03ef : serial


Thanks,
Jeff
