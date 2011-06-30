Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1F3SZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 14:25:12 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:58384 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1F3SZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:25:09 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 3.0rc3-rc5: usb stops working after resume from suspend
Date: Thu, 30 Jun 2011 20:25:04 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc3-00205-gdd34739; KDE/4.6.4; x86_64; ; )
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.1106301158310.1957-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106301158310.1957-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106302025.04722.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 of June 2011, Alan Stern wrote:
> On Thu, 30 Jun 2011, Arkadiusz Miskiewicz wrote:
> > > Actually bisection might end up being quicker.  This looks like a
> > > pretty tricky problem.  Maybe you should start a bisection while I look
> > > at this stuff; you'll probably reach an answer before I do!
> > 
> > Looks tricky indeed. There seem to be two related problems actually. I'm
> > bisecting between rc3 (good) and rc5 (bad).
> 
> These are separate problems, not related.

Ok.

> 
> > At 3.0.0-rc4-00059-g143e859 usb auto-suspend suspends my mouse usb port
> > after like 4 seconds when I don't move mouse. That's not a problem. The
> > problem is that resume takes like 1-2seconds and in that time mouse
> > cursor doesn't move when I move mouse of course.
> 
> For the record, the log you posted shows that autoresuming the mouse
> takes less than 60 ms.  If it seems longer, it may be that the mouse
> doesn't send a wakeup request as soon as you move it or press a
> button.

One new info. suspend/resume from ram is not needed. Fresh boot, I'm running 
on battery, plug power, unplug power and these weird thing start to happen 
with mouse unsuspend delay.

Unfortunately turns out that this behaviour is also seen on my rc3 but laptop 
has to run on battery. So not a regression.

Example (on 3.0.0-rc3-00205-gdd34739)

[ 1155.447146] hub 3-0:1.0: port 1, status 0103, change 0004, 12 Mb/s
[ 1165.970079] uhci_hcd 0000:00:1a.0: release dev 2 ep82-INT, period 2, phase 
1, 17 us
[ 1165.971071] uhci_hcd 0000:00:1a.0: release dev 2 ep81-INT, period 8, phase 
4, 17 us

mouse works but I don't move it, so it suspends

[ 1165.973074] usb 3-1: usb auto-suspend

now from this moment until...

[ 1167.988114] hub 3-0:1.0: hub_suspend
[ 1167.988132] usb usb3: bus auto-suspend
[ 1167.988138] usb usb3: suspend_rh
[ 1167.988169] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[ 1167.988191] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[ 1167.988197] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_suspend: 0
[ 1167.988351] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3

untill this moment every my mouse move causes nothing but after some delay it 
resumes

[ 1170.545790] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1170.545801] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1170.545946] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1170.545954] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1170.545971] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[ 1170.545986] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[ 1170.545995] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[ 1170.546041] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_resume: 0
[ 1170.546052] usb usb3: usb wakeup-resume
[ 1170.546061] usb usb3: usb auto-resume
[ 1170.546066] usb usb3: wakeup_rh
[ 1170.588078] hub 3-0:1.0: hub_resume
[ 1170.588097] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[ 1170.588108] hub 3-0:1.0: port 1: status 0103 change 0004
[ 1170.588169] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[ 1170.588188] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[ 1170.604114] usb 3-1: usb wakeup-resume
[ 1170.604133] usb 3-1: finish resume
[ 1170.607134] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 
4, 17 us
[ 1170.607150] uhci_hcd 0000:00:1a.0: reserve dev 2 ep82-INT, period 2, phase 
1, 17 us
[ 1170.607162] hub 3-0:1.0: resume on port 1, status 0
[ 1170.607169] hub 3-0:1.0: port 1, status 0103, change 0004, 12 Mb/s

and is working fine until another suspend.

Another example on the same kernel as above:

Jun 30 19:30:28 localhost kernel: [ 1344.451124] hub 3-0:1.0: port 1, status 
0103, change 0004, 12 Mb/s
Jun 30 19:30:33 localhost kernel: [ 1348.822094] uhci_hcd 0000:00:1a.0: 
release dev 2 ep82-INT, period 2, phase 1, 17 us
Jun 30 19:30:33 localhost kernel: [ 1348.823082] uhci_hcd 0000:00:1a.0: 
release dev 2 ep81-INT, period 8, phase 4, 17 us

mouse suspends

Jun 30 19:30:33 localhost kernel: [ 1348.825086] usb 3-1: usb auto-suspend

but I don't move it

Jun 30 19:30:35 localhost kernel: [ 1350.840096] hub 3-0:1.0: hub_suspend
Jun 30 19:30:35 localhost kernel: [ 1350.840113] usb usb3: bus auto-suspend
Jun 30 19:30:35 localhost kernel: [ 1350.840119] usb usb3: suspend_rh
Jun 30 19:30:35 localhost kernel: [ 1350.840150] uhci_hcd 0000:00:1a.0: 
uhci_pci_suspend
Jun 30 19:30:35 localhost kernel: [ 1350.840172] uhci_hcd 0000:00:1a.0: PCI 
INT A disabled
Jun 30 19:30:35 localhost kernel: [ 1350.840178] uhci_hcd 0000:00:1a.0: 
hcd_pci_runtime_suspend: 0

I wait for this to show:

Jun 30 19:30:35 localhost kernel: [ 1350.840332] uhci_hcd 0000:00:1a.0: power 
state changed by ACPI to D3

and then start moving mouse, after short while 

Jun 30 19:30:38 localhost kernel: [ 1354.037335] uhci_hcd 0000:00:1a.0: power 
state changed by ACPI to D0
Jun 30 19:30:38 localhost kernel: [ 1354.037346] uhci_hcd 0000:00:1a.0: power 
state changed by ACPI to D0
Jun 30 19:30:38 localhost kernel: [ 1354.037495] uhci_hcd 0000:00:1a.0: power 
state changed by ACPI to D0
Jun 30 19:30:38 localhost kernel: [ 1354.037504] uhci_hcd 0000:00:1a.0: power 
state changed by ACPI to D0
Jun 30 19:30:38 localhost kernel: [ 1354.037521] uhci_hcd 0000:00:1a.0: PCI 
INT A -> GSI 20 (level, low) -> IRQ 20
Jun 30 19:30:38 localhost kernel: [ 1354.037535] uhci_hcd 0000:00:1a.0: 
setting latency timer to 64
Jun 30 19:30:38 localhost kernel: [ 1354.037544] uhci_hcd 0000:00:1a.0: 
uhci_pci_resume
Jun 30 19:30:38 localhost kernel: [ 1354.037593] uhci_hcd 0000:00:1a.0: 
hcd_pci_runtime_resume: 0
Jun 30 19:30:38 localhost kernel: [ 1354.037604] usb usb3: usb wakeup-resume
Jun 30 19:30:38 localhost kernel: [ 1354.037612] usb usb3: usb auto-resume
Jun 30 19:30:38 localhost kernel: [ 1354.037618] usb usb3: wakeup_rh
Jun 30 19:30:38 localhost kernel: [ 1354.076034] hub 3-0:1.0: hub_resume
Jun 30 19:30:38 localhost kernel: [ 1354.076054] uhci_hcd 0000:00:1a.0: port 1 
portsc 0095,01
Jun 30 19:30:38 localhost kernel: [ 1354.076065] hub 3-0:1.0: port 1: status 
0103 change 0004
Jun 30 19:30:38 localhost kernel: [ 1354.076111] hub 3-0:1.0: state 7 ports 2 
chg 0002 evt 0000
Jun 30 19:30:38 localhost kernel: [ 1354.076130] uhci_hcd 0000:00:1a.0: port 1 
portsc 0095,01
Jun 30 19:30:38 localhost kernel: [ 1354.092045] usb 3-1: usb wakeup-resume
Jun 30 19:30:38 localhost kernel: [ 1354.092065] usb 3-1: finish resume
Jun 30 19:30:38 localhost kernel: [ 1354.095086] uhci_hcd 0000:00:1a.0: 
reserve dev 2 ep81-INT, period 8, phase 4, 17 us
Jun 30 19:30:38 localhost kernel: [ 1354.095101] uhci_hcd 0000:00:1a.0: 
reserve dev 2 ep82-INT, period 2, phase 1, 17 us
Jun 30 19:30:38 localhost kernel: [ 1354.095115] hub 3-0:1.0: resume on port 
1, status 0
Jun 30 19:30:38 localhost kernel: [ 1354.095122] hub 3-0:1.0: port 1, status 
0103, change 0004, 12 Mb/s

it is useable again until new suspend happens. So mouse recovers quicker but 
only after "power state changed by ACPI to D3" happens.

Summary: not a regression, unfortunately feature unusable with this mouse on 
this laptop.

> On the other hand, the log shows that the mouse does work properly
> following system suspend.  Part of the problem here seems to be the
> Logitech receiver; even 130 ms after the USB bus was reset, the
> receiver still had not reconnected itself electrically to the bus.
> 
> With 3.0-rc4 that's okay, because the receiver is rediscovered after
> the resume and it starts working again.  With 3.5-rc5 the rediscovery
> doesn't occur, apparently because the khubd thread is hung.
> 
> > With previous kernel (rc5) the problem become worse as I described in
> > previous emails.
> 
> And now you know why, more or less -- we still have to figure out the
> reason for the hang.  Probably something goes wrong when cdc-ether is
> unbound from the wireless device.

If cdc-ether is not loaded at all then usb works fine after resume from ram on 
rc5.

> It's not even clear that autosuspend is a problem.  Doesn't 3.0-rc3
> also autosuspend the mouse?

The problem with usb not working if cdc-ether is used happens when also  on 
external power and afaik autosuspend doesn't kick-in in such case, right?

> If not, have you compared the contents of
> /sys/bus/usb/devices/3-1/power/control under the various kernels?

It's auto.

> 
> The fact is, some mice are very slow and non-responsive while waking up
> from suspend.  There's not much we can do about that except to avoid
> autosuspending them -- which you do by making sure the power/control
> file contains "on".

I'll disable usb autosuspend - it's better when off than having to configure 
every usb device I plug in ;/

> Alan Stern

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
