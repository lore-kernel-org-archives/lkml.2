Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab0IPRFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:05:00 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:47456 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab0IPRE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:04:58 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/3] PCI: allocate bus resources from the top down
Date: Thu, 16 Sep 2010 11:04:14 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
References: <20100915210818.12365.58732.stgit@bob.kio> <201009151644.38563.bjorn.helgaas@hp.com> <4C915AB2.9090203@zytor.com>
In-Reply-To: <4C915AB2.9090203@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009161104.15665.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 15, 2010 05:45:54 pm H. Peter Anvin wrote:
> On 09/15/2010 03:44 PM, Bjorn Helgaas wrote:
> > 
> > I'd like to do that, but I don't see a good way to do it yet.
> > 
> > We saw the problem on a T3500, a T3400, and a T4500, and I'm sure there
> > are others.  So I don't know how to identify the affected machines.
> > 
> > And I don't know how to identify the invalid ranges, because I suspect
> > it depends on the memory size.  I think it would be quite unusual for
> > a window to start 1MB under the nice 256MB boundary, but I'm not sure
> > I'm ready to say that's always illegal.
> > 
> > On these machines, the [mem 0xbff00000-0xbfffffff] area is actually
> > reported as reserved in the E820 map, and I first thought we could
> > simply rely on that.  But I'm not really comfortable with that either,
> > because I don't think there's a dependable relationship between those
> > E820 entries and ACPI and PCI devices.  For one thing, I experimented
> > with Windows, and it happily places PCI devices in reserved areas,
> > and I think we're likely to trip over more BIOS bugs if we rely on
> > something Windows doesn't.
> > 
> > I suspect Windows would blow up, too, if we could somehow fill up the
> > rest of the window and force it to allocate the bottom.  But since
> > it's only a 1MB area, I think that would be very difficult to do
> > unless there's some way to tweak PCI BARs before booting Windows.
> 
> If we put PCI devices in E820 RESERVED areas that's a bug, plain and
> simple.  We should absolutely not doing so!
> 
> To some degree I don't care if Windows does or not ... that is the
> documented mechanism for reserving address space, and we should respect
> that.  Furthermore, we use the same mechanism internally for reserving
> address space.

It does seem like we should do *something* with E820 reserved areas, but
I'm not 100% convinced we should be more strict than Windows.  If we
pay attention to things Windows doesn't test, I think we're likely to
trip over even more BIOS bugs.

Linux does avoid putting PCI devices in E820 reserved areas ... in
some cases.  In this Dell case, the reserved area conflicts with a
host bridge window, so we expand the reserved area and insert it as
the *parent* of the window.  Since it's the parent, it has no effect
on allocations from the window, so we end up putting devices in the
reserved area.

I think the problem is that E820 reservations fundamentally don't
fit well with the Linux resource manager.  We manage resources as
a strict hierarchy of non-overlapping regions, but there's no
requirement that E820 reservations have any relationship with actual
devices that we discover via ACPI, PCI, etc.

We've been kludging around this with a collection of hacks like
reserve_region_with_split() and insert_resource_expand_to_fit(),
but I think we're just making an unmaintainable mess.  We should
take a step back and think about how to do this cleanly.

Bjorn
