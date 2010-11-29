Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab0K2Vcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:32:55 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:2656 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab0K2Vcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:32:54 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/PCI: never allocate PCI space from the last 1M below 4G
Date: Mon, 29 Nov 2010 14:32:50 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg@redhat.com>
References: <20101129183009.11256.33739.stgit@bob.kio> <201011291334.52909.bjorn.helgaas@hp.com> <4CF3F62F.2000508@zytor.com>
In-Reply-To: <4CF3F62F.2000508@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011291432.51264.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 29, 2010 11:51:27 am H. Peter Anvin wrote:
> On 11/29/2010 12:34 PM, Bjorn Helgaas wrote:
> > On Monday, November 29, 2010 11:30:09 am Bjorn Helgaas wrote:
> >>
> >> The last 1M before 4G contains the processor restart vector and usually
> >> the system ROM.  We don't know the actual ROM size; I chose 1M because
> >> that's how much Windows 7 appears to avoid.
> >>
> >> Without this check, we can allocate PCI space that will never work.  On
> >> Matthew's HP 2530p, we put the Intel GTT "Flush Page" at the very last
> >> page, which causes a spontaneous power-off:
> >>
> >>   pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xffffffff]
> >>   fffff000-ffffffff : Intel Flush Page (assigned by intel-gtt)
> >>
> >> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=23542
> >> Reported-by: Matthew Garrett <mjg@redhat.com>
> >> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> >> ---
> >>
> >>  arch/x86/include/asm/e820.h |    3 +++
> >>  arch/x86/pci/i386.c         |   10 +++++++++-
> >>  2 files changed, 12 insertions(+), 1 deletions(-)
> >>
> >>
> >> diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
> >> index 5be1542..c1e908f 100644
> >> --- a/arch/x86/include/asm/e820.h
> >> +++ b/arch/x86/include/asm/e820.h
> >> @@ -72,6 +72,9 @@ struct e820map {
> >>  #define BIOS_BEGIN		0x000a0000
> >>  #define BIOS_END		0x00100000
> >>  
> >> +#define BIOS_ROM_BASE		0xfff00000
> >> +#define BIOS_ROM_END		0x100000000ULL
> > 
> > I'm really not thrilled about hard-coding these addresses, so I'd
> > love it if somebody could suggest a way to discover them from the
> > BIOS.
> > 
> > The E820 map doesn't reserve the last page:
> > 
> >   BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
> >   BIOS-e820: 00000000fffa0000 - 00000000fffa7000 (reserved)
> > 
> > and I don't think there's any ACPI device that does either.

Oops, egg on my face.  In this case, there *is* an ACPI INT0800 device
at 0xff000000-0xffffffff, which should prevent us from allocating that
space for anything else.  Only problem is, we IGNORE that useful bit of
information.

> It is certainly reasonable to block off the last chunk of the 32-bit
> address space.  Some systems double-decode it to avoid issues with
> A20M#, so I would argue that we should avoid at least 2 MiB.
> 
> As far as discovering them from the BIOS, there is a way to do it --
> E820.  This is a fallback for the case where the BIOS has plain and
> simply failed to provide it, and so a heuristic is probably the best we
> can do.  Probing is extremely unsafe.

I think it's clearly a bug that Linux ignores ACPI resource information
(except PNP0C01/PNP0C02 motherboard devices).  If we fix that bug, it
will fix Matthew's 2530p.

We might still want a patch like this current one because it could
work around some BIOS defects, and because I think it's too late to
fix the ACPI resource problem for .37.  But I'm not convinced we
should reserve more than Windows does, because that may keep us from
discovering other important Linux problems.

Bjorn
