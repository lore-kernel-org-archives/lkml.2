Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab2KJQeM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 11:34:12 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43209 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab2KJQeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 11:34:09 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org, Chuansheng Liu <chuansheng.liu@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [REGRESSION] 3.7-rc3+git hard lockup on CPU after inserting/removing USB stick
Date: Sat, 10 Nov 2012 17:34:06 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.0-tp520; KDE/4.8.4; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <201211071501.38288.Martin@lichtvoll.de> <20121107143800.GA14146@kroah.com> <201211071952.24509.Martin@lichtvoll.de> (sfid-20121107_195431_785653_5B4780C0)
In-Reply-To: <201211071952.24509.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201211101734.07084.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC´d bad patch author Chuansheng as well as Ingo and Thomas as the
issue seems to be thread irqs related.

Am Mittwoch, 7. November 2012 schrieb Martin Steigerwald:
> Am Mittwoch, 7. November 2012 schrieb Greg Kroah-Hartman:
> > On Wed, Nov 07, 2012 at 03:01:38PM +0100, Martin Steigerwald wrote:
> > > Hi!
> > > 
> > > I had this with something in between 3.7-rc3 und 3.7-rc4 after
> > > inserting and removing an USB stick. This example is with a kernel
> > > + f2fs patches v3, but I had this with 3.7-rc3 as well.
> > 
> > Ok, so it's not a new thing introduced in 3.7-rc4 (which is good, as
> > there wasn't any USB patches added between -rc3 and -rc4.)
> > 
> > Does it also happen on -rc2?  Anything older?  Can you run 'git
> > bisect' to try to track it down?
> 
> It appears to be worse with 3.7-rc1. The machine basically locked up a
> few moments after inserting the stick.
> 
> First time I was on some tty and I saw lots of backtraces flowing by
> the process of which the BTRFS on /, which resides on an unrelated
> internal Intel SSD 320, was switched to read only. There have been
> pauses between backtraces. Second I was in KDE session which basically
> locked up soon as well. No mouse pointer movements where possible, no
> switching to tty1.
> 
> I only have the last part of the backtrace of the first occurence as
> photo.
> 
> Nothing was saved on SSD.
> 
> I do not want to go an earlier 3.7 version than rc1 on this production
> machine.

I bisected this after having made a backup:

martin@merkaba:~[…]/linux-2.6> git bisect log
# bad: [ddffeb8c4d0331609ef2581d84de4d763607bd37] Linux 3.7-rc1
# good: [a0d271cbfed1dd50278c6b06bead3d00ba0a88f9] Linux 3.6
git bisect start 'v3.7-rc1' 'v3.6'
# bad: [24d7b40a60cf19008334bcbcbd98da374d4d9c64] ARM: OMAP2+: PM: MPU DVFS: use generic CPU device for MPU-SS
git bisect bad 24d7b40a60cf19008334bcbcbd98da374d4d9c64
# skip: [d9a807461fc8cc0d6ba589ea0730d139122af012] Merge tag 'usb-3.6' of 
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
git bisect skip d9a807461fc8cc0d6ba589ea0730d139122af012
# good: [832defbb58061fedb7a5c43aab7d762afaac2cc9] staging: comedi: s626: remove boardinfo
git bisect good 832defbb58061fedb7a5c43aab7d762afaac2cc9
# skip: [6d55d5968a8622f3ea20ec40737aea1cfba6438c] Merge branch 'next/soc' into HEAD
git bisect skip 6d55d5968a8622f3ea20ec40737aea1cfba6438c
# good: [b64365a52625e6ec5cf05dd984fba0fa69b24623] drivers/misc/ti-st: chip_disable on timeout
git bisect good b64365a52625e6ec5cf05dd984fba0fa69b24623
# bad: [186f3812f5005d3d5435f69f672971afdae3e732] USB: serial: ssu100.c: remove debug module parameter
git bisect bad 186f3812f5005d3d5435f69f672971afdae3e732
# bad: [7135f08e47de094f8748507806efa8d7ba27a964] Merge tag 'gadget-for-v3.7' of 
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-next
git bisect bad 7135f08e47de094f8748507806efa8d7ba27a964
# good: [3a22b872e923954853cabd5a18f41da1846bccdb] usb: Fail a get config when the port is powered off.
git bisect good 3a22b872e923954853cabd5a18f41da1846bccdb
# good: [c2ec75c25112c9e0d9053f55ba8cf0a358d4a354] usb: gadget: push all usb_composite_driver structs into __refdata
git bisect good c2ec75c25112c9e0d9053f55ba8cf0a358d4a354
# good: [7d16e8d3eb704f5f6eb5a271d5758b495634e8e6] usb: gadget: push VID/PID/USB BCD module option into gadgets
git bisect good 7d16e8d3eb704f5f6eb5a271d5758b495634e8e6
# good: [162ca3ca613e02e115ec9c5273f94bd22dad0af2] usb: gadget: at91_udc: move the dereference below the NULL test
git bisect good 162ca3ca613e02e115ec9c5273f94bd22dad0af2
# good: [5c4d46eb89fe99011a02048533857345d9e8b506] usb: gadget serial: don't shift bcd version left by 16
git bisect good 5c4d46eb89fe99011a02048533857345d9e8b506
# good: [ca3c1539adfe9c1b86f16faf314b3bf54c3b5389] usb: add little-endian transform for DeviceRemovable of usb3.0 hub
git bisect good ca3c1539adfe9c1b86f16faf314b3bf54c3b5389
# bad: [73d4066055e0e2830533041f4b91df8e6e5976ff] USB/host: Cleanup unneccessary irq disable code
git bisect bad 73d4066055e0e2830533041f4b91df8e6e5976ff


The first one I skipped was having these issues on boot already. The
second one I skipped was just a few commits after the first one, I didn´t
test the second skip.

I removed USB mouse in order to avoid having any removable USB devices
attached during testing.


The first bad commit is:

commit 73d4066055e0e2830533041f4b91df8e6e5976ff
Author: Chuansheng Liu <chuansheng.liu@intel.com>
Date:   Tue Sep 11 16:00:30 2012 +0800

    USB/host: Cleanup unneccessary irq disable code
    
    Because the IRQF_DISABLED as the flag is now a NOOP and has been
    deprecated and in hardirq context the interrupt is disabled.
    
    so in usb/host code:
    Removing the usage of flag IRQF_DISABLED;
    Removing the calling local_irq save/restore actions in irq
    handler usb_hcd_irq();
    
    Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
    Acked-by: Alan Stern <stern@rowland.harvard.edu>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


But:

This ony happens with threadirqs option!

When I remove threadirqs from kernel command line and reboot with this
last bisect kernel USB sticks work.

That may explain why nobody else has seen this.

So I will try a 3.7-rc4 now, but without threadirqs enabled.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
