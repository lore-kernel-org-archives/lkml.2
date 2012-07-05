Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab2GEUIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:08:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56805 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab2GEUIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:08:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo619=HTLeAtBPQMYeRkpcmZSa=bmHAMLVjA94SfiZc5sQ@mail.gmail.com>
References: <20120427143410.GB27535@alberich.amd.com> <20120427143621.GC27535@alberich.amd.com>
 <CAErSpo7gkkqZgR0TZ5Xx162pLN9ZaYVhMmyHn+H8Lqr1CBSXXQ@mail.gmail.com>
 <20120504130332.GC12199@alberich.amd.com> <CAErSpo5_ZB=ggNDGM5N8Rt1TtW8DQQm1k2s9FBwFHjh7nFA4hw@mail.gmail.com>
 <20120507073547.GE10668@alberich.amd.com> <CAErSpo7-PBOsTiM37f6PFjfeJ=QrLiu1DCFesquWMctLbwirAA@mail.gmail.com>
 <20120508074348.GC26061@alberich.amd.com> <CAErSpo5M9g9UyW_Xc4EtPg-vWf1fOHF+KoSFkmYScXSvi9h5_w@mail.gmail.com>
 <CAErSpo619=HTLeAtBPQMYeRkpcmZSa=bmHAMLVjA94SfiZc5sQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 5 Jul 2012 14:07:41 -0600
Message-ID: <CAErSpo42dxkwN4qopZgGzO-fWc6MUkLEBfF77eDJgdDoq5sjjg@mail.gmail.com>
Subject: Re: [PATCH 1/2][RESEND] x86/pci/amd: Restore early_fill_mp_bus_to_node
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 5:09 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> On Tue, May 8, 2012 at 10:02 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Tue, May 8, 2012 at 12:43 AM, Andreas Herrmann
> > <andreas.herrmann3@amd.com> wrote:
> >> On Mon, May 07, 2012 at 09:44:16AM -0700, Bjorn Helgaas wrote:
> >>> On Mon, May 7, 2012 at 12:35 AM, Andreas Herrmann
> >>> <andreas.herrmann3@amd.com> wrote:
> >>> > On Fri, May 04, 2012 at 10:35:05AM -0600, Bjorn Helgaas wrote:
> >>> >> On Fri, May 4, 2012 at 7:03 AM, Andreas Herrmann
> >>> >> <andreas.herrmann3@amd.com> wrote:
> >>> >> > On Wed, May 02, 2012 at 11:33:17AM -0600, Bjorn Helgaas wrote:
> >>> >> >> On Fri, Apr 27, 2012 at 8:36 AM, Andreas Herrmann
> >>> >> >> <andreas.herrmann3@amd.com> wrote:
> >>> >> >> >
> >>> >> >> > Once upon a time this function was overloaded with quirky stuff to fix
> >>> >> >> > resource detection on systems w/ _CRS defects (seems that some Sun and
> >>> >> >> > HP systems were affected).
> >>> >> >> >
> >>> >> >> > See commit 30a18d6c3f1e774de656ebd8ff219d53e2ba4029
> >>> >> >> > (x86: multi pci root bus with different io resource range, on 64-bit)
> >>> >> >> >
> >>> >> >> > Restore the old function and thus decouple it from the quirk that is
> >>> >> >> > CPU family specific (e.g. it won't work on AMD family 15h CPUs). BTW,
> >>> >> >> > I assume that the _CRS stuff is working on current systems.
> >>> >> >> >
> >>> >> >> > This is required to properly initilize the numa_node information of
> >>> >> >> > existing PCI busses and associated devices.
> >>> >> >>
> >>> >> >> I applied some of Yinghai's patches that also touch this area.  Can
> >>> >> >> you refresh these so they apply on top of my "next" branch
> >>> >> >> (git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git next)?
> >>> >> >
> >>> >> > Arrgh, will adapt my patch and resend it (asap).
> >>> >> >
> >>> >> >> Can you also be more specific about what these patches fix?
> >>> >> >
> >>> >> >> My understanding is that amd_bus.c (1) sets NUMA info with
> >>> >> >> set_mp_bus_to_node() and (2) figures out MMIO and I/O port apertures,
> >>> >> >> which are only used when blind probing and when ignoring _CRS.
> >>> >> >>
> >>> >> >> It seems like the main change in this patch is that we skip (2)
> >>> >> >> completely when family >= 0x11, and I don't understand what that could
> >>> >> >> fix.
> >>> >> >
> >>> >> > The patch restores a very old function that was used to detect the
> >>> >> > nearest node for a PCI bus, so yes it's used to do (1). IMHO this
> >>> >> > function was totally screwed up with Yinghai's code to do (2). It
> >>> >> > seems that Sun has (had?) some systems where (2) was req'd. I don't
> >>> >> > care about this part. But I'd like to do (1) on all AMD CPU NUMA
> >>> >> > systems.
> >>> >>
> >>> >> Thanks for the explanation.  But I'm afraid I'm still confused.
> >>> >>
> >>> >> First, it sounds like you're trying to change the way we do part (1),
> >>> >> i.e., the set_mp_bus_to_node() calls, but I think the effect of your
> >>> >> patch is to stop doing part (2) in some cases.
> >>> >>
> >>> >> Second, I am pretty sure that the current early_fill_mp_bus_info()
> >>> >> (before your patch) does the exact same set_mp_bus_to_node() calls as
> >>> >> your early_fill_mp_bus_to_node() does.
> >>> >
> >>> >
> >>> > I want to do (1) on all AMD CPUs that might be used in NUMA systems.
> >>> >
> >>> > What's done for (2) is very specific to certain AMD CPU families --
> >>> > some of the register accesses are wrong/incomplete for newer AMD
> >>> > CPUs. Furhtermore _CRS should provide the required info. I really
> >>> > don't want to extend all the quirky stuff in (2) for future AMD CPUs.
> >>>
> >>> I'm all in favor of limiting part (2) to older AMD CPUs.  I certainly
> >>> don't want to maintain it for future CPUs.
> >>>
> >>> >> Finally, on all systems with ACPI, the set_mp_bus_to_node() call in
> >>> >> pci_acpi_scan_root() should be doing what you need.  In fact, that
> >>> >> call happens later, so it should be overwriting the information filled
> >>> >> in by amd_bus.c.  If there's something wrong in this ACPI path, the
> >>> >> most likely cause is a BIOS defect, such as  a missing _PXM method on
> >>> >> the PNP0A03/0A08 host bridge device.
> >>> >
> >>> > Good point. I'll check what's wrong in this ACPI path.
> >>>
> >>> I hope you find something, especially if it's a bug in the Linux code
> >>> that interprets  the NUMA info.  Then we could fix that and limit both
> >>> parts to older CPUs.
> >>
> >> Simply, there is no _PXM object for the host bridge devices. At least
> >> on the systems that I checked.
> >>
> >> I'll try to find out whether this is sort of "common BIOS practice" on
> >> AMD boxes and how to avoid that in the future.
> >
> > _PXM can also be attached to any parent of the host bridge, since
> > devices default to the domain of their parents.  It looks like
> > acpi_get_pxm() should already handle that correctly, so I assume these
> > systems just don't have any _PXM anywhere in the path between the host
> > bridge and the root.
> >
> > If these are just old machines with BIOS bugs, I guess I'm OK with
> > doing a Linux fix along the lines of your patch.  What I don't like is
> > just silently covering up BIOS bugs in new platforms by keeping this
> > CPU-specific code when we have a perfectly good generic mechanism for
> > doing proximity.  That's a maintenance problem, as you pointed out for
> > the aperture code (part (2)).
>
> I think we still need to do something here, don't we?
>
> I'm expecting we'll end up with at least two patches: one to keep us
> from looking at MSRs on future CPUs where they might be different from
> current CPUs, and another to work around BIOS defects (missing _PXM
> methods) on some systems.  I'm guessing the second should be somehow
> limited to certain CPU families and possibly BIOS dates.
>
> Bjorn

[resending as plain text, sorry for the duplication]

Do we need to do anything here?
