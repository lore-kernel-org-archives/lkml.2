Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab2EHHoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:44:00 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:48821
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367Ab2EHHn6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:43:58 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VPS-11(zz9371Ic89bh1432N98dK1447Izz1202hzz8275bh8275dhz2dh668h839h93fhd25h)
X-WSS-ID: 0M3P1H4-01-0VU-02
X-M-MSG: 
Date: Tue, 8 May 2012 09:43:48 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/2][RESEND] x86/pci/amd: Restore
 early_fill_mp_bus_to_node
Message-ID: <20120508074348.GC26061@alberich.amd.com>
References: <20120427143410.GB27535@alberich.amd.com>
 <20120427143621.GC27535@alberich.amd.com>
 <CAErSpo7gkkqZgR0TZ5Xx162pLN9ZaYVhMmyHn+H8Lqr1CBSXXQ@mail.gmail.com>
 <20120504130332.GC12199@alberich.amd.com>
 <CAErSpo5_ZB=ggNDGM5N8Rt1TtW8DQQm1k2s9FBwFHjh7nFA4hw@mail.gmail.com>
 <20120507073547.GE10668@alberich.amd.com>
 <CAErSpo7-PBOsTiM37f6PFjfeJ=QrLiu1DCFesquWMctLbwirAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CAErSpo7-PBOsTiM37f6PFjfeJ=QrLiu1DCFesquWMctLbwirAA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 09:44:16AM -0700, Bjorn Helgaas wrote:
> On Mon, May 7, 2012 at 12:35 AM, Andreas Herrmann
> <andreas.herrmann3@amd.com> wrote:
> > On Fri, May 04, 2012 at 10:35:05AM -0600, Bjorn Helgaas wrote:
> >> On Fri, May 4, 2012 at 7:03 AM, Andreas Herrmann
> >> <andreas.herrmann3@amd.com> wrote:
> >> > On Wed, May 02, 2012 at 11:33:17AM -0600, Bjorn Helgaas wrote:
> >> >> On Fri, Apr 27, 2012 at 8:36 AM, Andreas Herrmann
> >> >> <andreas.herrmann3@amd.com> wrote:
> >> >> >
> >> >> > Once upon a time this function was overloaded with quirky stuff to fix
> >> >> > resource detection on systems w/ _CRS defects (seems that some Sun and
> >> >> > HP systems were affected).
> >> >> >
> >> >> > See commit 30a18d6c3f1e774de656ebd8ff219d53e2ba4029
> >> >> > (x86: multi pci root bus with different io resource range, on 64-bit)
> >> >> >
> >> >> > Restore the old function and thus decouple it from the quirk that is
> >> >> > CPU family specific (e.g. it won't work on AMD family 15h CPUs). BTW,
> >> >> > I assume that the _CRS stuff is working on current systems.
> >> >> >
> >> >> > This is required to properly initilize the numa_node information of
> >> >> > existing PCI busses and associated devices.
> >> >>
> >> >> I applied some of Yinghai's patches that also touch this area.  Can
> >> >> you refresh these so they apply on top of my "next" branch
> >> >> (git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git next)?
> >> >
> >> > Arrgh, will adapt my patch and resend it (asap).
> >> >
> >> >> Can you also be more specific about what these patches fix?
> >> >
> >> >> My understanding is that amd_bus.c (1) sets NUMA info with
> >> >> set_mp_bus_to_node() and (2) figures out MMIO and I/O port apertures,
> >> >> which are only used when blind probing and when ignoring _CRS.
> >> >>
> >> >> It seems like the main change in this patch is that we skip (2)
> >> >> completely when family >= 0x11, and I don't understand what that could
> >> >> fix.
> >> >
> >> > The patch restores a very old function that was used to detect the
> >> > nearest node for a PCI bus, so yes it's used to do (1). IMHO this
> >> > function was totally screwed up with Yinghai's code to do (2). It
> >> > seems that Sun has (had?) some systems where (2) was req'd. I don't
> >> > care about this part. But I'd like to do (1) on all AMD CPU NUMA
> >> > systems.
> >>
> >> Thanks for the explanation.  But I'm afraid I'm still confused.
> >>
> >> First, it sounds like you're trying to change the way we do part (1),
> >> i.e., the set_mp_bus_to_node() calls, but I think the effect of your
> >> patch is to stop doing part (2) in some cases.
> >>
> >> Second, I am pretty sure that the current early_fill_mp_bus_info()
> >> (before your patch) does the exact same set_mp_bus_to_node() calls as
> >> your early_fill_mp_bus_to_node() does.
> >
> >
> > I want to do (1) on all AMD CPUs that might be used in NUMA systems.
> >
> > What's done for (2) is very specific to certain AMD CPU families --
> > some of the register accesses are wrong/incomplete for newer AMD
> > CPUs. Furhtermore _CRS should provide the required info. I really
> > don't want to extend all the quirky stuff in (2) for future AMD CPUs.
> 
> I'm all in favor of limiting part (2) to older AMD CPUs.  I certainly
> don't want to maintain it for future CPUs.
> 
> >> Finally, on all systems with ACPI, the set_mp_bus_to_node() call in
> >> pci_acpi_scan_root() should be doing what you need.  In fact, that
> >> call happens later, so it should be overwriting the information filled
> >> in by amd_bus.c.  If there's something wrong in this ACPI path, the
> >> most likely cause is a BIOS defect, such as  a missing _PXM method on
> >> the PNP0A03/0A08 host bridge device.
> >
> > Good point. I'll check what's wrong in this ACPI path.
> 
> I hope you find something, especially if it's a bug in the Linux code
> that interprets  the NUMA info.  Then we could fix that and limit both
> parts to older CPUs.

Simply, there is no _PXM object for the host bridge devices. At least
on the systems that I checked.

I'll try to find out whether this is sort of "common BIOS practice" on
AMD boxes and how to avoid that in the future.

However it seems that a fix in Linux is appropriate for existing
systems.


Andreas


