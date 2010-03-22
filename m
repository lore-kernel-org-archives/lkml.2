Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0CVAYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 20:24:34 -0400
Received: from tur.go2.pl ([193.17.41.50]:37112 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab0CVAYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 20:24:33 -0400
From: Zbigniew Luszpinski <zbiggy@go2.pl>
To: linux-kernel@vger.kernel.org
Subject: 2.6.32 help needed with reverting APIC patches.
Date: Mon, 22 Mar 2010 01:23:37 +0100
User-Agent: KMail/1.13.1 (Linux/2.6.32.8; KDE/4.4.1; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003220123.37341.zbiggy@go2.pl>
X-O2-Trust: 2, 69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm investigating why my Nvidia MCP78S chipset needs noapic or acpi=noirq to protect USB OHCI against hanging at random time.
(both kernel parameters turns off APIC and fall back to PIC). Asrock K10N78FullHD-hSLI R3.0 mainboard.
The OHCI USB controller integrated in chipset is the only device which hangs in APIC mode.
The bug does not exist on Windows XP SP3 and OpenSolaris 2009.6 so I'm focused on APIC handling differences between those systems and Linux.

First it looks like those systems use classical handling with interrupt masking. Linux abandoned this between 2.6.20 and 2.6.21:
http://www.mail-archive.com/linux-net@vger.kernel.org/msg01535.html
(the bug described at this link is identical to mine except it talks about network cards not usb ohci)
That is why I would like to revert those patches and do the test.
I tried to revert these 2 patches in vanilla kernel 2.6.32.8 I use but failed because IRQ_DELAYED_DISABLE flag and supporting code vanished away.
It is problematic to reinsert it back because of this:
2.6.20:
#define IRQ_DELAYED_DISABLE    0x00100000      /* IRQ disable (masking) happens delayed. */ 
2.6.32:
#define IRQ_WAKEUP             0x00100000      /* IRQ triggers system wakeup */
I tried to revert these 2 patches and workaround missing IRQ_DELAYED_DISABLE but this resulted in black screen and kernel unable to boot.

So I tried to boot 2.6.20 kernel distro - boot failed because MCP78S AHCI is too new for 2.6.20. Backporting PCI IDs did nothing.
Kernel still can not mount VFS and access SATA hdd or CD - kernel can not correctly talk to AHCI controller.
IDE compatibility mode is even worse. So 2.6.20 or older is not an option for me.

Second they use Level triggered interrupts when Linux uses fasteoi.
AFAIR kernel 2.6.18 uses Level triggered IRQs. It seems RHEL5 still uses kernel 2.6.18 but it is custom patched and will not be reliable for checking.
If someone is APIC guru and would like to make a patch which brings back level triggered IRQs to 2.6.32.8 I would be happy to do the test.

Third: it may be bug in ACPI - Linux uses ACPI to enable APIC.
I browsed the ACPI tables code but did not find any traps prepared for Linux so it looks clean. But to be sure it would be cool to use APIC without ACPI.
If you know how to patch kernel to force APIC use with acpi=off let me know. My mainboard has no MPS tables - everything is done via ACPI.
The ACPI tables in bios are not syntax and hw clean - I fixed all ACPI bugs but this not changed anything.

I believe the #1 solution will be the one I look for without the need for testing solutions #2 and #3.
If someone will help me reverting:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=76d2160147f43f982dfe881404cfde9fd0a9da21
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d7e25f3394ba05a6d64cb2be42c2765fe72ea6b2
in kernel 2.6.32 or 2.6.33 I could start testing and excluding possible bug sources.

Here is my bugreport:
https://bugzilla.kernel.org/show_bug.cgi?id=13405

have a nice day,
Zbigniew Luszpinski
