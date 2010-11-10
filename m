Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab0KJT3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:29:45 -0500
Received: from kroah.org ([198.145.64.141]:43462 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756386Ab0KJT3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:29:43 -0500
Date: Wed, 10 Nov 2010 11:29:49 -0800
From: Greg KH <greg@kroah.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Martin Wilck <martin.wilck@ts.fujitsu.com>, gerhard.wichert@ts.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] fix size checks for mmap() on /proc/bus/pci files
	(updated)
Message-ID: <20101110192949.GB16140@kroah.com>
References: <20101109084206.1b6ac66a@jbarnes-desktop> <1289383401-1357-1-git-send-email-martin.wilck@ts.fujitsu.com> <20101110104434.6ed20d33@jbarnes-x201>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110104434.6ed20d33@jbarnes-x201>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 10:44:34AM -0800, Jesse Barnes wrote:
> On Wed, 10 Nov 2010 11:03:21 +0100
> Martin Wilck <martin.wilck@ts.fujitsu.com> wrote:
> 
> > The checks for valid mmaps of PCI resources made
> > through /proc/bus/pci files that were introduced in
> > 9eff02e2042f96fb2aedd02e032eca1c5333d767 have several problems:
> > 
> > 1. mmap() calls on /proc/bus/pci files are made with real file
> > offsets > 0, whereas under /sys/bus/pci/devices, the start of the
> > resource corresponds to offset 0. This may lead to false negatives in
> > pci_mmap_fits(), which implicitly assumes the /sys/bus/pci/devices
> > layout.
> > 
> > 2. The loop in proc_bus_pci_mmap doesn't skip empty resouces. This
> > leads to false positives, because pci_mmap_fits() doesn't treat empty
> > resources correctly (the calculated size is 1 <<
> > (8*sizeof(resource_size_t)-PAGE_SHIFT) in this case!).
> > 
> > 3. If a user maps resources with BAR > 0, pci_mmap_fits will emit
> > bogus WARNINGS for the first resources that don't fit until the
> > correct one is found.
> > 
> > On many controllers the first 2-4 BARs are used, and the others are
> > empty. In this case, an mmap attempt will first fail on the non-empty
> > BARs (including the "right" BAR because of 1.) and emit bogus
> > WARNINGS because of 3., and finally succeed on the first empty BAR
> > because of 2. This is certainly not the intended behaviour.
> > 
> > This patch addresses all 3 issues.
> > Updated with an enum type for the additional parameter for
> > pci_mmap_fits().
> > 
> > Signed-off-by: Martin Wilck <martin.wilck@ts.fujitsu.com>
> 
> Thanks Martin, I'll push this into my for-linus branch for 2.6.37; may
> as well cc: stable as well, since this is a long standing bug.

Please cc: stable, as it is something that -stable releases cares about.

thanks,

greg k-h
