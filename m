Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab2KZQmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:42:16 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53368 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab2KZQmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:42:09 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: Have of_device_add call platform_device_add rather than device_add
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
In-Reply-To: <20121122173020.GA8473@obsidianresearch.com>
References: <20121121072448.GG19837@obsidianresearch.com> <20121121155104.726B83E0AE2@localhost> <20121121174453.GD6406@obsidianresearch.com> <CACxGe6u2Kfm+x5KsFzNPt7voyeD0x_4V6EO4add=tBwMKJ6VWQ@mail.gmail.com> <20121121181430.GE6406@obsidianresearch.com> <20121122153621.452CA3E129E@localhost> <20121122173020.GA8473@obsidianresearch.com>
Date: Mon, 26 Nov 2012 14:30:02 +0000
Message-Id: <20121126143002.121FF3E1A11@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2012 10:30:20 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> On Thu, Nov 22, 2012 at 03:36:21PM +0000, Grant Likely wrote:
> 
> > Hmm... I've not tried it with assigned-address. I tried with two sibling
> > platform devices using just the 'reg' property. That the kernel will
> > complain about. For powerpc-only, the patch I posted allows the device
> > to get registered anyway even though the range incorrectly overlaps.
> 
> My second example was done with the reg property..
> 
>                 gpio0: gpio@10100 {
>                         compatible = "marvell,orion-gpio";
>                         #gpio-cells = <2>;
>                         gpio-controller;
>                         reg = <0x10100 0x40>;
>                 }
>                 chip_cfg@0 {
>                         compatible = "orc,chip_config";
>                         // Doubles up on gpio0
>                         reg = <0x10100 0x4>;
>                 };
> 
> 
> f1010100-f101013f : /internal@f1000000/gpio@10100
>   f1010100-f1010103 : /internal@f1000000/chip_cfg@0
> 
> What did you try? Maybe order matters?

It might. I tried on qemu with versatile. I've written a new test block
with different overlaps. Here's the block and the results:

     dummy@10201000 {
             compatible = "acme,test";
             reg = <0x10201000 0x1000>;
     };

     overlap@10200800 {
             compatible = "acme,test";
             reg = <0x10200800 0x1000>;
     };

     overlap@10201800 {
             compatible = "acme,test";
             reg = <0x10201800 0x1000>;
     };

     overlap@10201400 {
             compatible = "acme,test";
             reg = <0x10201400 0x800>;
     };

     overlap@10200c00 {
             compatible = "acme,test";
             reg = <0x10200c00 0x1800>;
     };

>From the kernel log:
10200800.overlap: failed to claim resource 0
10201800.overlap: failed to claim resource 0

# ls /sys/bus/platform/devices/
10002000.i2c      10010000.net      10201000.dummy    alarmtimer
10003000.intc     10140000.intc     10201400.overlap  amba.0
10008000.lcd      10200c00.overlap  34000000.flash    fpga.1

So, overlaps that are completely inside or completely outside the
already registered range don't appear to be detected. That may be a bug
(unless it is designed to work that way)

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
