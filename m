Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930Ab2J0Bjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 21:39:40 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:51672 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758290Ab2J0Bjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 21:39:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6ozXuJcca0piSuoQwHJ3LfxTw8nsy+8oa=QmJ98_Ofug@mail.gmail.com>
References: <CADCVGbTDD-4WOVJWwaGBvay5=of=3VKBCVacrrW-z12BYZ1xbQ@mail.gmail.com>
	<CAErSpo7mcDkWUhUBvnZ6P+5TOYsE=j6zB7MHqfY1wvqyyE1CBQ@mail.gmail.com>
	<508A9974.2090403@tilera.com>
	<CAErSpo6ozXuJcca0piSuoQwHJ3LfxTw8nsy+8oa=QmJ98_Ofug@mail.gmail.com>
Date: Sat, 27 Oct 2012 09:39:37 +0800
Message-ID: <CADCVGbSph2X7T3cTiVW3TdDwvRhOY+k7XYoz=Sxu1CC58yVhWQ@mail.gmail.com>
Subject: Re: PCIe IO space support on Tilera GX: Is there any one who can
 confirm my modification to fix it is OK?
From: Cyberman Wu <cypher.w@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 12:28 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Oct 26, 2012 at 8:08 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>
>> Cyberman: it seems like your bias hack is working for you.  But, as Bjorn
>> says, this sounds like a driver bug.  What happens if you just revert your
>> changes, but then in mvsas.c change the "if (!res_start || !res_len)" to
>> just say "if (!res_len)"?  That seems like the true error test.  If that
>> works, you should submit that change to the community.
>
> I don't *think* that is going to be enough, even with the kernel that
> has some I/O space support, because both devices are assigned
> identical resources:
>
>   pci 0000:01:00.0: BAR 2: assigned [io  0x0000-0x007f]
>   pci 0001:01:00.0: BAR 2: assigned [io  0x0000-0x007f]
>
> The I/O space support that's there is broken because we think the same
> I/O range is available on both root buses, which is probably not the
> case:
>
>   pci_bus 0000:00: resource 0 [io  0x0000-0xffffffff]
>   pci_bus 0001:00: resource 0 [io  0x0000-0xffffffff]
>
That's the problem I want to confirm what I've changed is correct. I've split
the two RootComplex using separate I/O range, it seems works on our device,
but since I'm not very clear about Linux kernel, I want some some to check it.
For mvsas, I've already modified it some thing like Chris said when I began
using MDE-4.0.0 GA release. I bring it out to see if there have some ideas
about that issue.

> If mvsas really doesn't need the I/O BAR, I think it's likely that
> making it use pci_enable_device_mem() will make both devices work even
> without I/O space support in the kernel.
>
>> Bjorn et al: does it seem reasonable to add a bias to the mappings so that
>> we never report a zero value as valid?  This may be sufficiently defensive
>> programming that it's just the right thing to do regardless of whether
>> drivers are technically at fault or not.  If so, what's a good bias?  (I'm
>> inclined to think 64K rather than 4K.)
>
> I/O space is very limited to begin with (many architectures only
> *have* 64K), so I hesitate to add a bias in the PCI core.  But we do
> something similar in arch_remove_reservations(), and I think you could
> implement it that way if you wanted to.
>
> Bjorn



-- 
Cyberman Wu
