Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab0EBU4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 16:56:47 -0400
Received: from legolas.restena.lu ([158.64.1.34]:57517 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab0EBU4p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 16:56:45 -0400
Date: Sun, 2 May 2010 22:56:31 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: s2ram slow (radeon) / failing (usb)
Message-ID: <20100502225631.7ce6765b@neptune.home>
In-Reply-To: <201005022216.05641.rjw@sisk.pl>
References: <20100502155653.68fc3643@neptune.home>
	<Pine.LNX.4.44L0.1005021102340.25185-100000@netrider.rowland.org>
	<20100502220628.0728d8d4@neptune.home>
	<201005022216.05641.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 May 2010 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> On Sunday 02 May 2010, Bruno Prémont wrote:
> > On Sun, 02 May 2010 Alan Stern <stern@rowland.harvard.edu> wrote:
> > > On Sun, 2 May 2010, Bruno [UTF-8] Prémont wrote:
> > > > On a IEI Kino 690S1 I'm having a hard time to get s2ram running.
> > > > It freezes during device suspend (unless I rmmod everything USB
> > > > related) - usb fails even in pm_test case 'devices'.
> > > > 
> > > > When the system is able to suspend it takes an eternity (more than 3
> > > > minutes to wake-up, the radeon apparently being responsible for quite
> > > > a big share of that slowness.
> > > > 
> > > > 
> > > > During resume early it looks like every PCI access needs about a second,
> > > > and there are a few cases where during lots of seconds nothing seems to
> > > > happen and the first event following is related to radeon.
> > > > 
> > > > The kernel used is todays Linus's tree at commit be1066bbcd443a65df312fdecea7e4959adedb45
> > > > with Dave's drm-linus and drm-radeon-testing applied on top.
> > > > 
> > > > Note, I've not been able to suspend to RAM properly recently (last one
> > > > that worked correctly but resumed without graphics was some-when during
> > > > 2.6.2x, before KMS)
> > > > Since then the system would either fail suspend or resume.
> > > > 
> > > > Manual changes I applied in order to find out some context information:
> > > > - add a few debugging printk's to ata/ahci as that was the last entry
> > > >   on serial console for freezing suspends (that one succeeded but
> > > >   following step never completed, from suspend_prepare that would have
> > > >   been USB => unload usb before suspend)
> > > > - strip "if EMBEDED" from CONFIG_SERIAL_8250_PNP and disabled it so serial
> > > >   console would continue working as long as possible and output suspend
> > > >   progress (resume output happens only very late)
> > > > 
> > > > Is there some additional information I could gather in order do help
> > > > improving s2ram on this system?
> > > > - get it to suspend with usb loaded (ohci + ehci)
> > > > - get it to resume a reasonable speed
> > > 
> > > There's no way to fix the USB problem without knowing what goes wrong.  
> > > Let's see how far you get before the system freezes on a kernel with 
> > > CONFIG_USB_DEBUG enabled.
> > 
> > Am I missing something?
> > 
> > I've enabled CONFIG_USB_DEBUG but don't see any additional module parameter
> > nor anything extra to toggle and I don't get more output than without it.
> > 
> > Device suspend (pm_test = device) works well when there is no USB device
> > connected, but with USB keyboard I get the freeze (though the keyboard
> > is still usable, e.g. CAPS key works and I can issue SYSRQ commands).
> > 
> > When I issue sysreq-t, I find the following suspicious entry:
> > [  669.112505] usbhid_resume D ffff88007a085fd8     0  1145      2 0x00000000
> > [  669.112505]  ffff88007a085e20 0000000000000046 ffff88007a085fd8 ffff88007c536820
> > [  669.112505]  ffff88007a085fd8 ffff88007a085fd8 00000000000129c0 00000000000129c0
> > [  669.112505]  ffff88007c536820 ffff88007cf3f040 ffff88007a085fd8 ffff88007a085fd8
> > [  669.112505] Call Trace:
> > [  669.112505]  [<ffffffff8105d765>] refrigerator+0x95/0xf0
> > [  669.112505]  [<ffffffff81051a16>] worker_thread+0xc6/0x1e0
> > [  669.112505]  [<ffffffff81055e90>] ? autoremove_wake_function+0x0/0x40
> > [  669.112505]  [<ffffffff81051950>] ? worker_thread+0x0/0x1e0
> > [  669.112505]  [<ffffffff810559be>] kthread+0x8e/0xa0
> > [  669.112505]  [<ffffffff81003a94>] kernel_thread_helper+0x4/0x10
> > [  669.112505]  [<ffffffff81055930>] ? kthread+0x0/0xa0
> > [  669.112505]  [<ffffffff81003a90>] ? kernel_thread_helper+0x0/0x10
> > 
> > Except for that one there are a few async/* tasks waiting.
> 
> It looks like the freezer fails on your system.
> 
> How much time did you wait for the failig "pm_test = device" to recover?

I've given it at least 5 minutes, but didn't check exactly. Is there a
(big) timeout that could happen, if so how long is it?

Thanks,
Bruno


Those async threads looked like:
[  669.112505] async/15      D 0000000000000000     0  2213      2 0x00000000
[  669.112505]  ffff8800797dbc80 0000000000000046 ffff8800797dbfd8 ffff88007aff8820
[  669.112505]  ffff8800797dbfd8 ffff8800797dbfd8 00000000000129c0 00000000000129c0
[  669.112505]  ffff88007aff8820 ffff88007cdf3040 0000000000000002 0000000000000113
[  669.112505] Call Trace:
[  669.112505]  [<ffffffff8146838d>] schedule_timeout+0x19d/0x230
[  669.112505]  [<ffffffff811f661c>] ? acpi_pci_irq_lookup+0x42/0x1b1
[  669.112505]  [<ffffffff811f67ff>] ? acpi_pci_irq_disable+0x74/0x7d
[  669.112505]  [<ffffffff81467961>] wait_for_common+0xe1/0x170
[  669.112505]  [<ffffffff81037620>] ? default_wake_function+0x0/0x10
[  669.112505]  [<ffffffff813092f0>] ? dpm_wait_fn+0x0/0x40
[  669.112505]  [<ffffffff81467a88>] wait_for_completion+0x18/0x20
[  669.112505]  [<ffffffff8130931f>] dpm_wait_fn+0x2f/0x40
[  669.112505]  [<ffffffff81302188>] device_for_each_child+0x48/0x70
[  669.112505]  [<ffffffff81309e68>] __device_suspend+0x38/0x1e0
[  669.112505]  [<ffffffff8130a504>] async_suspend+0x24/0x60
[  669.112505]  [<ffffffff8105c772>] async_thread+0x112/0x280
[  669.112505]  [<ffffffff81037620>] ? default_wake_function+0x0/0x10
[  669.112505]  [<ffffffff8105c660>] ? async_thread+0x0/0x280
[  669.112505]  [<ffffffff810559be>] kthread+0x8e/0xa0
[  669.112505]  [<ffffffff81003a94>] kernel_thread_helper+0x4/0x10
[  669.112505]  [<ffffffff81055930>] ? kthread+0x0/0xa0
[  669.112505]  [<ffffffff81003a90>] ? kernel_thread_helper+0x0/0x10

