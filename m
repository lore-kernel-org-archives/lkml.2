Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1JXTcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 15:32:46 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:53329 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab1JXTcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 15:32:45 -0400
Message-ID: <B10F15EA8AB74E698DC0D94563A30BE7@samsungnetbook>
From: "Roland Kletzing" <devzero@web.de>
To: "Willy Tarreau" <w@1wt.eu>
Cc: <linux-kernel@vger.kernel.org>, <adrian.hunter@intel.com>,
        <Artem.Bityutskiy@nokia.com>
References: <69501156.1798237.1319395066798.JavaMail.fmail@mwmweb003> <20111024055705.GA4020@1wt.eu>
In-Reply-To: <20111024055705.GA4020@1wt.eu>
Subject: [BUG] Re: mtd_stresstest module bricked my dockstar
Date: Mon, 24 Oct 2011 21:32:42 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8064.206
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8064.206
X-Provags-ID: V01U2FsdGVkX18UC6y4ytM6KkVbxY7ZSnkCf9iXQFTIcujewzGA
	2UZNWUdc28bi9Ir6rwUnX57TVbbL2vBtbL3BE8vqpSo2gnJSDh
	RdO8xl6zc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

cc`ing correct email of Adrian Hunter and i found that mtd_torturetest (and 
the
other modules) have the same issue and there is another author i could find 
the
email for.

> If you can't restore it with JTAG, it means the hardware is really dead.
> JTAG is used when you blank the flash, and is supposed to work. I don't
> know what the module does, but I fail to see how to could wear the flash
> that fast. At worst it could have wiped it, or the flash was already bad.

Yes, i think accidentally insmodding  "mtd_stresstest" has just wiped it, 
not killed.
The problem is, that it is important stuff for booting and you can`t pull it 
out and
re-write externally, like a disk. Sorry, i that was probably not clearly 
stated.

Anyway - what would people think if linux had a kernel module  which wipes
/dev/sda1 when loaded ? :)

> I got one Iomega Iconnect with a faulty flash that I got replaced for a
> good one, so it's more likely the case here.

Yes, i could give debricking with JTAG a try. But what about the cost for 
the JTAG
and the work to be spent with it? I could buy another Dockstar for that.....

> I agree with you. I remember the very old ISA NE2000 driver who used to
> scan various addresses to find a NIC, causing some of them to reconfigure
> their address to *none* and definitely stop responding on the bus to any
> reconfiguration request. That was pretty annoying too. After killing a
> few, I stopped using Linux on a machine with such a NIC for a long time!

Oh, that could be an explanation why i had 2 broken NE2000 NICs in the 
nineties.. ;)

> You should keep it and retry the JTAG adapter. You just need a boot loader
> so if you manage to find a usable memory location that you can select by
> soldering two pins together, you could manage to store it and bood from
> another device.

I`m sure debricking with JTAG is possible and it would be an interesting 
task.
Maybe i like to spend some money and time with this one day. For now i 
don`t.

In the meantime i`d rather being interested in what can be done to add more
safety to the mtd tests.

By writing these lines and looking into the source, i started getting 
curious -  i
see there is dev param with that module(s), but i did not pass a device 
number,
nor did i pass anything to it.

in

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=drivers/mtd/tests/mtd_stresstest.c;h=63920476b57a24c7e61563303eb3abb773b73fdf;hb=7163cea15f7b362795b858e7c130cd617aecc0aa

i see:

static int dev;   <-!
module_param(dev, int, S_IRUGO);
MODULE_PARM_DESC(dev, "MTD device number to use");

static int count = 10000;
module_param(count, int, S_IRUGO);
MODULE_PARM_DESC(count, "Number of operations to do (default is 10000)");

and then

static int __init mtd_stresstest_init(void)
{
	int err;
	int i, op;
	uint64_t tmp;

	printk(KERN_INFO "\n");
	printk(KERN_INFO "=================================================\n");
	printk(PRINT_PREF "MTD device: %d\n", dev);

	mtd = get_mtd_device(NULL, dev);
	if (IS_ERR(mtd)) {
		err = PTR_ERR(mtd);
		printk(PRINT_PREF "error: cannot get MTD device\n");
		return err;
	}



My kernel log showed:

mtd_stresstest: MTD device: 0
mtd_stresstest: MTD device size 1048576 etc...

So, apparenly the module accidentally picked mtd0 instead of exiting cleanly 
(as
i did not pass a device number)

I`m not a programmer, but doesn`t look that like an "unitialized variable" 
issue ?

If yes, then i would call my Dockstar "victim of a bug".

regards
Roland 

