Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab0IXWmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 18:42:33 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:2682 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab0IXWmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 18:42:32 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH v2 0/4] PCI: allocate space top-down, not bottom-up
Date: Fri, 24 Sep 2010 16:41:39 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, stable@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <20100917223109.24687.17697.stgit@bob.kio>
In-Reply-To: <20100917223109.24687.17697.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009241641.40867.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added cc: stable@kernel.org
See:
  https://patchwork.kernel.org/patch/189182/
  https://patchwork.kernel.org/patch/189232/
  https://patchwork.kernel.org/patch/189242/
  https://patchwork.kernel.org/patch/189252/

On Friday, September 17, 2010 04:32:06 pm Bjorn Helgaas wrote:
> When we move PCI devices, we currently allocate space bottom-up, i.e., we look
> at PCI bus resources in the order we found them, we look at gaps between child
> resources bottom-up, and we align the new space at the bottom of an available
> region.
> 
> On x86, we move PCI devices more than we used to because we now pay attention
> to the PCI host bridge windows from ACPI.  For example, when we find a device
> that's outside all the known host bridge windows, we try to move it into a
> window, and we look for space starting at the bottom.
> 
> Windows does similar device moves, but it looks for space top-down rather than
> bottom-up.  Since most machines are better-tested with Windows than Linux, this
> difference means that Linux is more likely to trip over BIOS bugs in the PCI
> host bridge window descriptions than Windows is.
> 
> We've had several reports of Dell machines where the BIOS leaves the AHCI
> controller outside the host bridge windows (BIOS bug #1), *and* the lowest
> host bridge window includes an area that doesn't actually reach PCI (BIOS
> bug #2).  The result is that Windows (which moves AHCI to the top of a window)
> works fine, while Linux (which moves AHCI to the bottom, buggy, area) doesn't
> work.
> 
> These patches change Linux to allocate space more like Windows does:
> 
>     1) The x86 pcibios_align_resource() will choose space from the
>        end of an available area, not the beginning.
> 
>     2) In the generic allocate_resource() path, we'll look for space
>        between existing children from the top, not from the bottom.
> 
>     3) When pci_bus_alloc_resource() looks for available space, it
>        will start from the highest window, not the first one we found.
> 
> This series fixes a 2.6.34 regression that prevents many Dell Precision
> workstations from booting:
> 
>     https://bugzilla.kernel.org/show_bug.cgi?id=16228
> 
> Changes from v1 to v2:
>     - Moved check for allocating before the available area from
>       pcibios_align_resource() to find_resource().  Better to do it
>       after the alignment callback is done, and make it generic.
>     - Fixed pcibios_align_resource() alignment.  If we start from the
>       end of the available area, we must align *downward*, not upward.
>     - Fixed pcibios_align_resource() ISA alias avoidance.  Again, since
>       the starting point is the end of the area, we must align downward
>       when we avoid aliased areas.
> 
> ---
> 
> Bjorn Helgaas (4):
>       resources: ensure alignment callback doesn't allocate below available start
>       x86/PCI: allocate space from the end of a region, not the beginning
>       resources: allocate space within a region from the top down
>       PCI: allocate bus resources from the top down
> 
> 
>  arch/x86/pci/i386.c |   18 ++++++++++++-----
>  drivers/pci/bus.c   |   53 ++++++++++++++++++++++++++++++++++++++++++++++-----
>  kernel/resource.c   |   50 +++++++++++++++++++++++++++++++-----------------
>  3 files changed, 92 insertions(+), 29 deletions(-)
> 
