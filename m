Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab0IVVxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:53:19 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:43240 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab0IVVxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:53:18 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, HPET: ignore any PCI BARs that match an HPET we already know about
Date: Wed, 22 Sep 2010 15:52:20 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: Venkatesh Pallipadi <venki@google.com>,
        Prarit Bhargava <prarit@redhat.com>, Simon Arlott <simon@fire.lp0.eu>,
        x86@kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        linux-kernel@vger.kernel.org, Marc Jones <marcj303@gmail.com>,
        Jordan Crouse <jcrouse@codeaurora.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20100922201547.3197.33702.stgit@bob.kio> <4C9A6534.3060800@zytor.com> <4C9A6D83.6090301@zytor.com>
In-Reply-To: <4C9A6D83.6090301@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009221552.21896.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 22, 2010 02:56:35 pm H. Peter Anvin wrote:
> On 09/22/2010 01:21 PM, H. Peter Anvin wrote:
> > On 09/22/2010 01:19 PM, Bjorn Helgaas wrote:
> >> On Wednesday, September 22, 2010 02:15:47 pm Bjorn Helgaas wrote:
> >>>
> >>> We often discover the HPET early, via the static ACPI HPET table, before
> >>> enumerating PCI devices.  If the HPET is implemented as a PCI function,
> >>> we will discover it again during PCI device enumeration.  We must ignore
> >>> the PCI function so we don't inadvertently move it out from under the
> >>> driver.
> >>>
> >>> I think it's better to ignore *any* PCI BAR that matches a previously
> >>> discovered HPET; that way we don't need platform-specific knowledge,
> >>> and we won't have to add more quirks for future machines.
> >>>
> >>> This is for a regression from 2.6.34, but the reporter has been
> >>> unable to test it yet.
> >>>
> >>> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=18482
> >>
> >> I've tried hard to find somebody who can test this, but nobody who
> >> can reproduce the original failure has been able to test it.  I
> >> propose that we put it in linux-next and see what happens there.
> > 
> > Makes sense to me.
> 
> Actually, this ties into something that I have pointed out in the past:
> there will be devices used by the firmware or the platform that has
> corresponding PCI BARs. Most of them can be spotted by being a PCI BAR
> pointing into reserved memory.
> 
> When we find a PCI BAR pointing into reserved memory it really should be
> considered a fixed resource, period, full stop.  This is critical for
> the proper operation of the platform.

Yes, I like that idea a lot.  It would save us from the current HPET
bug, where we have this situation:

   BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
  ACPI: HPET id: 0x10b9a201 base: 0xfed00000
  pci 0000:00:14.0: no compatible bridge window for [mem 0xfed00000-0xfed003ff]
  pci 0000:00:14.0: BAR 1: assigned [mem 0x80000000-0x800003ff]

The only thing I *don't* like is that Windows doesn't work that way.
I set up this scenario in qemu (this is with a VGA device, not an
HPET device):

   BIOS-e820: [mem 0x00000000e8000000-0x00000000f1ffffff] reserved
  pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xefffffff]
  pci 0000:00:02.0: BAR 0: [mem 0xf0000000-0xf1ffffff pref]

According to E820, BAR 0 is in a reserved area, but Windows 7 still
moved it to [mem 0xec000000-0xedffffff].  Windows moved it because
it was outside the host bridge window (same reason Linux moved the
HPET in the original bug).  There was plenty of space available
that's *not* reserved (0xe0000000-0xe7ffffff), but for whatever
reason, Windows put it in the reserved part of the window.

We don't necessarily need to slavishly copy what Windows does, but
I'd feel better if we understood how it avoided the problem on the
Gigabyte board so we could make a more informed decision.

It really doesn't look like Windows, and therefore BIOS writers,
share your expectations about PCI BARs in E820 reserved areas.
It's likely still *safe* to make them fixed resources, but we might
be able to fix more issues if we knew how Windows avoids the problem.

Bjorn
