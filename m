Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab0IOWpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 18:45:24 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:7072 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab0IOWpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 18:45:21 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/3] PCI: allocate bus resources from the top down
Date: Wed, 15 Sep 2010 16:44:37 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
References: <20100915210818.12365.58732.stgit@bob.kio> <20100915210912.12365.78836.stgit@bob.kio> <4C913F96.4020106@zytor.com>
In-Reply-To: <4C913F96.4020106@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009151644.38563.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 15, 2010 03:50:14 pm H. Peter Anvin wrote:
> On 09/15/2010 02:09 PM, Bjorn Helgaas wrote:
> > 
> > On the machine above (a Dell T3500), the [mem 0xbff00000-0xbfffffff] region
> > doesn't actually work and is likely a BIOS defect.  The symptom is that we
> > move the AHCI controller to 0xbff00000, which leads to "Boot has failed,
> > sleeping forever," a BUG in ahci_stop_engine(), or some other boot failure.
> > 
> 
> Acked-by: H. Peter Anvin <hpa@zytor.com>
> 
> ... for the patch in general, but I would like to *also* request a DMA
> or PCI quirk to explicitly reserve the above range on the affected Dell
> machines.

I'd like to do that, but I don't see a good way to do it yet.

We saw the problem on a T3500, a T3400, and a T4500, and I'm sure there
are others.  So I don't know how to identify the affected machines.

And I don't know how to identify the invalid ranges, because I suspect
it depends on the memory size.  I think it would be quite unusual for
a window to start 1MB under the nice 256MB boundary, but I'm not sure
I'm ready to say that's always illegal.

On these machines, the [mem 0xbff00000-0xbfffffff] area is actually
reported as reserved in the E820 map, and I first thought we could
simply rely on that.  But I'm not really comfortable with that either,
because I don't think there's a dependable relationship between those
E820 entries and ACPI and PCI devices.  For one thing, I experimented
with Windows, and it happily places PCI devices in reserved areas,
and I think we're likely to trip over more BIOS bugs if we rely on
something Windows doesn't.

I suspect Windows would blow up, too, if we could somehow fill up the
rest of the window and force it to allocate the bottom.  But since
it's only a 1MB area, I think that would be very difficult to do
unless there's some way to tweak PCI BARs before booting Windows.

Bjorn
