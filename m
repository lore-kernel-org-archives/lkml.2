Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab0DHNEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 09:04:22 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:7215 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758649Ab0DHNES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 09:04:18 -0400
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
	as x86_32
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai <yinghai.lu@oracle.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, linux-pci@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Andy Isaacson <adi@hexapodia.org>, Thomas Renninger <trenn@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <4BBD5EA4.3080908@zytor.com>
References: <20100407210628.28364.96982.stgit@bob.kio>
	 <4BBD0B0A.3090702@oracle.com> <201004071705.07176.bjorn.helgaas@hp.com>
	 <4BBD13C3.2060404@oracle.com> <1270697054.25226.16.camel@dc7800.home>
	 <4BBD5EA4.3080908@zytor.com>
Content-Type: text/plain
Date: Thu, 08 Apr 2010 07:04:05 -0600
Message-Id: <1270731845.26244.20.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-07 at 21:42 -0700, H. Peter Anvin wrote:
> On 04/07/2010 08:24 PM, Bjorn Helgaas wrote:
> > 
> > I actually did propose doing something in pci_setup_device(), similar to
> > what we already do for legacy IDE resources, but HPA thought it should
> > be done in the arch code instead, again for reasons I don't completely
> > understand.

> "Non-PCI devices" is hard to understand?

I understand that part, and the patch I posted is for the arch code, as
you suggested.

I just thought you were suggesting an x86 change *instead* of something
in PCI, even though it seems like the PCI spec does mention that devices
with VGA class code respond at 0xa0000.  Or maybe you were just
suggesting that we should do something in *both* PCI and in the arch
code?

Of course, the PCI part might be complicated by the VGA arbiter,
although I would think that if the system contains at least one VGA
device, reserving the 0xa0000 region once would solve 99% of the
problem.  If the arbiter changes the actual device that responds there,
the reservation will be for the wrong device, but we still want to avoid
putting anything else there.

Honestly, I don't know enough about x86_32 vs x86_64 to understand
Yinghai's objection.  Is there some platform architecture difference
that means x86_64 can reliably determine whether a non-PCI VGA device is
present, when x86_32 can't?  Unless there's a real difference, we ought
to handle them both the same, as my patch does.

Yinghai mentioned a box with no VGA and another device using 0xa0000.
Unless there's some x86_64-specific spec or convention that addresses
this, maybe we could handle that by (1) doing the legacy reservation as
in this patch, and (2) special-casing the PCI device setup so that if we
find a BAR set to that area, we undo the legacy reservation.  Or maybe
we just leave the legacy reservation unused and relocate the device that
BIOS left there.

Bjorn


