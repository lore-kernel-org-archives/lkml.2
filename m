Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934386Ab2J0DFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 23:05:21 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49965 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964866Ab2J0DFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 23:05:19 -0400
MIME-Version: 1.0
In-Reply-To: <CADCVGbSph2X7T3cTiVW3TdDwvRhOY+k7XYoz=Sxu1CC58yVhWQ@mail.gmail.com>
References: <CADCVGbTDD-4WOVJWwaGBvay5=of=3VKBCVacrrW-z12BYZ1xbQ@mail.gmail.com>
 <CAErSpo7mcDkWUhUBvnZ6P+5TOYsE=j6zB7MHqfY1wvqyyE1CBQ@mail.gmail.com>
 <508A9974.2090403@tilera.com> <CAErSpo6ozXuJcca0piSuoQwHJ3LfxTw8nsy+8oa=QmJ98_Ofug@mail.gmail.com>
 <CADCVGbSph2X7T3cTiVW3TdDwvRhOY+k7XYoz=Sxu1CC58yVhWQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 26 Oct 2012 21:04:57 -0600
Message-ID: <CAErSpo4aoHdSHp4+WWiSxDPmr5L_jSESm8ikdUxC_7tv99p1Bw@mail.gmail.com>
Subject: Re: PCIe IO space support on Tilera GX: Is there any one who can
 confirm my modification to fix it is OK?
To: Cyberman Wu <cypher.w@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 7:39 PM, Cyberman Wu <cypher.w@gmail.com> wrote:
> On Sat, Oct 27, 2012 at 12:28 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Fri, Oct 26, 2012 at 8:08 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>>
>>> Cyberman: it seems like your bias hack is working for you.  But, as Bjorn
>>> says, this sounds like a driver bug.  What happens if you just revert your
>>> changes, but then in mvsas.c change the "if (!res_start || !res_len)" to
>>> just say "if (!res_len)"?  That seems like the true error test.  If that
>>> works, you should submit that change to the community.
>>
>> I don't *think* that is going to be enough, even with the kernel that
>> has some I/O space support, because both devices are assigned
>> identical resources:
>>
>>   pci 0000:01:00.0: BAR 2: assigned [io  0x0000-0x007f]
>>   pci 0001:01:00.0: BAR 2: assigned [io  0x0000-0x007f]
>>
>> The I/O space support that's there is broken because we think the same
>> I/O range is available on both root buses, which is probably not the
>> case:
>>
>>   pci_bus 0000:00: resource 0 [io  0x0000-0xffffffff]
>>   pci_bus 0001:00: resource 0 [io  0x0000-0xffffffff]
>>
> That's the problem I want to confirm what I've changed is correct. I've split
> the two RootComplex using separate I/O range, it seems works on our device,
> but since I'm not very clear about Linux kernel, I want some some to check it.
> For mvsas, I've already modified it some thing like Chris said when I began
> using MDE-4.0.0 GA release. I bring it out to see if there have some ideas
> about that issue.

Some architectures do implement multiple I/O ranges.  Typical HP
parisc and ia64 boxes have a PCI host bridge for every slot, so each
slot can be in a separate PCI domain, and each host bridge can support
a separate 64KB I/O port space for its slot.  In that case, the values
in the struct resource will be different from the actual addresses
that appear on the PCI buses.

For example, you might have bridge A leading to bus 0000:00 with [io
0x0000-0xffff] and bridge B leading to bus 0001:00 with [io
0x10000-0x1ffff].  The I/O port addresses used by drivers don't
overlap, and there's no ambiguity, but if you put an analyzer on bus
0001:00, you'd see port addresses in the 0x0000-0xffff range.  If you
moved the analyzer to bus 0000:00, you'd see the same 0x0000-0xffff
range of port addresses.  It's up to the architecture implementation
of inb()/outb()/etc. to map an I/O resource address to a host bridge
and a bus port address behind that bridge.

The bottom line is that what you want to do seems possible and makes
some sense.  Of course, the diff you posted is useless for upstream
Linux because it's all entangled with MDE and it reverts a lot of the
recent Linux work.  But what you want to do is possible in principle.
It's up to you and Chris to figure out whether and how to rework the
changes to add this functionality cleanly.

Bjorn
