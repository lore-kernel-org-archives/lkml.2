Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab2KKOtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 09:49:49 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:40075 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751768Ab2KKOts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 09:49:48 -0500
Message-ID: <1352645365.2320.41.camel@thor>
Subject: Re: [PATCH 4/5] x86: acpi: Print warning for malformed host bridge
 resources
From: Peter Hurley <peter@hurleysoftware.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Date: Sun, 11 Nov 2012 09:49:25 -0500
In-Reply-To: <CAErSpo6DV+HKHX=5mSUzGmbJVbZdDpco7Ct-FeJJcVjCO992bg@mail.gmail.com>
References: <1352343356-4006-1-git-send-email-peter@hurleysoftware.com>
	 <1352343356-4006-5-git-send-email-peter@hurleysoftware.com>
	 <CAErSpo6DV+HKHX=5mSUzGmbJVbZdDpco7Ct-FeJJcVjCO992bg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-11-10 at 14:52 -0700, Bjorn Helgaas wrote:
> On Wed, Nov 7, 2012 at 7:55 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> > An incorrectly specified host bridge window may prevent
> > other devices from claiming assigned resources. For example,
> > this flawed _CRS resource descriptor from a Dell T5400:
> >      DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
> >          0x00000000,         // Granularity
> >          0xF0000000,         // Range Minimum
> >          0xFE000000,         // Range Maximum
> >          0x00000000,         // Translation Offset
> >          0x0E000000,         // Length
> >          ,, , AddressRangeMemory, TypeStatic)
> 
> I think the problem here is that the Range Maximum should be
> 0xFDFFFFFF, not 0xFE000000, right?

I presume so.

> > diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> > index 192397c..3468d16 100644
> > --- a/arch/x86/pci/acpi.c
> > +++ b/arch/x86/pci/acpi.c
> > @@ -298,6 +298,10 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
> >                         "host bridge window [%#llx-%#llx] "
> >                         "([%#llx-%#llx] ignored, not CPU addressable)\n",
> >                         start, orig_end, end + 1, orig_end);
> > +       } else if (flags & IORESOURCE_MEM && (start & 0x0f || ~end & 0x0f)) {
> > +               dev_warn(&info->bridge->dev,
> > +                        "invalid host bridge window [%#llx-%#llx]\n",
> > +                        start, end);
> 
> We didn't actually *fix* anything here, so I guess we're just pointing
> out the reason for a subsequent failure to claim the adjacent
> resource.

Correct. There is no fix; only a diagnostic warning.

The warning is also a 'red flag' that, on this machine, it might be
better to boot the kernel with the "pci=nocrs" option.

> As far as I know, the spec doesn't actually require resources of ACPI
> devices to be non-overlapping.  Windows accepts overlapping resources,
> and I think Linux probably should, too, but right now we trip over
> this.

(note: I included a link below to the defect report which has
the /proc/iomem, dmesg & dmidecode)

The situation is this:

The adjacent resources (northbridge & southbridge) are not defined by
ACPI, but rather reserved with an e820 address descriptor from
[0xfe000000-0xfeffffff], so strictly speaking there is no overlapping
ACPI resource.

The e820 descriptor is bumped out to [0xf0000000-0xfeffffff] and the
malformed host bridge window is reparented to it.

At this point in the boot, there is no resource conflict.

Later in the boot, the i5k_amb driver tries to map
[0xfe000000-0xfe01ffff] which is the FB-DIMM AMB register window on the
Intel 5400 MCH and is rejected. The request is rejected because the
requested range does not map completely to a single parent and this is
not allowed. (The i5k_amb driver exposes the FB-DIMM temperature sensors
through sysfs).

There is no problem in Windows because no driver attempts to allocate
[0xfe000000-0xfe01ffff]. However, I doubt the PNP Manager would allow
another bus pdo to claim an overlapping resource with PCI bus 0. I
suspect the offending device would yellow bang. (That would be an
interesting experiment...)

> In the meantime (until we figure out how to handle overlapping
> resources better), can we do something to actually fix this?  Maybe we
> should truncate the end of the range to 0xFDFFFFFF like we do for
> non-addressable parts of the range?

Auto-fixing this seems problematic because it's essentially impossible
to determine if the resource length or the resource end or both is
wrong.

> Is there a bugzilla or a complete dmesg log to look at?

https://bugzilla.kernel.org/show_bug.cgi?id=50161

Regards,
Peter Hurley



