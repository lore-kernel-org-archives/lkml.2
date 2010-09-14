Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab0INOSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:18:03 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:4163 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab0INOR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:17:59 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Simon Arlott" <simon@fire.lp0.eu>, Jordan Crouse <jcrouse@codeaurora.org>
Subject: Re: GA-MA69VM-S2 requires pci=nocrs with 2.6.35.4
Date: Tue, 14 Sep 2010 08:17:16 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
References: <de55082de958760245f23930b79ab42b7c54c838@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid> <201009131716.18197.bjorn.helgaas@hp.com> <f041c95ed553edce2bb319fd31a9dc5402863437@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
In-Reply-To: <f041c95ed553edce2bb319fd31a9dc5402863437@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009140817.18988.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 14, 2010 05:38:49 am Simon Arlott wrote:
> On Tue, September 14, 2010 00:16, Bjorn Helgaas wrote:
> > On Thursday, September 09, 2010 06:16:33 am Simon Arlott wrote:
> >> With a Gigabyte GA-MA69VM-S2 690V motherboard, it stalls in
> >> qurk_usb_early_handoff unless pci=nocrs is used:
> >
> > Huh.  It looks like the HPET appears as a PCI device, in addition to
> > being described in the HPET table (and possibly in the ACPI namespace):
> >
> > [    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
> > [    0.454232] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> > [    0.461348] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
> > [    0.468004] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
> > [    0.474004] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
> > [    0.481004] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
> > [    0.489004] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xfebfffff]
> > [    1.034049] pci 0000:00:14.0: no compatible bridge window for [mem 0xfed00000-0xfed003ff]
> > [    1.651998] pci 0000:00:14.0: BAR 1: assigned [mem 0x80000000-0x800003ff]
> >
> > Since the 00:14.0 BAR looks invalid (it's outside all the host bridge
> > windows), we moved it to 0x80000000, and that probably broke the HPET
> > driver, which still thinks it's at 0xfed00000.
> >
> > I've heard about this problem, but I haven't ever looked into it in
> > detail.  The best way to handle this would be to figure out why Windows
> > doesn't have this problem, since it also moves PCI devices in this
> > situation.
> 
> You're assuming Windows works on this hardware.

Yes, that's true.  I found this user manual:
http://download.gigabyte.eu/FileList/Manual/motherboard_manual_ga-ma69vm-s2_e.pdf
which claims Windows 2000/XP/Vista support, but if you have
evidence that Windows does not work, that would be good to know.

> > Simon, if you have a way to boot Windows, the output of Everest (free
> > trial at http://www.lavalys.com/) would be a great help.
> 
> Windows would take too long to install to try this.
> 
> > I can see from the stalled.txt log that we did call sb600_disable_hpet_bar(),
> > and it *looks* like that should have disabled BAR 1.  But apparently it
> > didn't.  Would you mind collecting another log with the patch below?
> 
> Whenever I next need to reboot, I can try the patch, but that won't be soon...

OK.  Just let me know if/when you have any more information.  I opened
this bugzilla for this problem:

  https://bugzilla.kernel.org/show_bug.cgi?id=18482

Bjorn
