Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965355Ab2JZQ3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 12:29:16 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58927 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965257Ab2JZQ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 12:29:13 -0400
MIME-Version: 1.0
In-Reply-To: <508A9974.2090403@tilera.com>
References: <CADCVGbTDD-4WOVJWwaGBvay5=of=3VKBCVacrrW-z12BYZ1xbQ@mail.gmail.com>
 <CAErSpo7mcDkWUhUBvnZ6P+5TOYsE=j6zB7MHqfY1wvqyyE1CBQ@mail.gmail.com> <508A9974.2090403@tilera.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 26 Oct 2012 10:28:52 -0600
Message-ID: <CAErSpo6ozXuJcca0piSuoQwHJ3LfxTw8nsy+8oa=QmJ98_Ofug@mail.gmail.com>
Subject: Re: PCIe IO space support on Tilera GX: Is there any one who can
 confirm my modification to fix it is OK?
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Cyberman Wu <cypher.w@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 8:08 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:

> Cyberman: it seems like your bias hack is working for you.  But, as Bjorn
> says, this sounds like a driver bug.  What happens if you just revert your
> changes, but then in mvsas.c change the "if (!res_start || !res_len)" to
> just say "if (!res_len)"?  That seems like the true error test.  If that
> works, you should submit that change to the community.

I don't *think* that is going to be enough, even with the kernel that
has some I/O space support, because both devices are assigned
identical resources:

  pci 0000:01:00.0: BAR 2: assigned [io  0x0000-0x007f]
  pci 0001:01:00.0: BAR 2: assigned [io  0x0000-0x007f]

The I/O space support that's there is broken because we think the same
I/O range is available on both root buses, which is probably not the
case:

  pci_bus 0000:00: resource 0 [io  0x0000-0xffffffff]
  pci_bus 0001:00: resource 0 [io  0x0000-0xffffffff]

If mvsas really doesn't need the I/O BAR, I think it's likely that
making it use pci_enable_device_mem() will make both devices work even
without I/O space support in the kernel.

> Bjorn et al: does it seem reasonable to add a bias to the mappings so that
> we never report a zero value as valid?  This may be sufficiently defensive
> programming that it's just the right thing to do regardless of whether
> drivers are technically at fault or not.  If so, what's a good bias?  (I'm
> inclined to think 64K rather than 4K.)

I/O space is very limited to begin with (many architectures only
*have* 64K), so I hesitate to add a bias in the PCI core.  But we do
something similar in arch_remove_reservations(), and I think you could
implement it that way if you wanted to.

Bjorn
