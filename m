Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab1GGLxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:53:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50713 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab1GGLxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 07:53:47 -0400
MIME-Version: 1.0
Date: Thu, 7 Jul 2011 13:53:46 +0200
Message-ID: <CACTFLANCYMXH=z+NxEF0aqpMGZp21Q16_uB=J3rndM3pW74qeA@mail.gmail.com>
Subject: Allocating buffers for USB transfers (again)
From: Daniel Mack <zonque@gmail.com>
To: linux-usb@vger.kernel.org, alsa-devel@alsa-project.org
Cc: Takashi Iwai <tiwai@suse.de>, Clemens Ladisch <clemens@ladisch.de>,
        florian@mickler.org, pedrib@gmail.com, William Light <wrl@illest.net>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have to revisit an issue we've discussed in length around a year ago
and which still remains unsolved. I've been getting feedback from more
users of my driver snd-usb-caiaq who report the issue found in bug
#15580 in the kernel bugzilla:
https://bugzilla.kernel.org/show_bug.cgi?id=15580

Let me quickly summarize the current state of this issue as I see it.

The problem seems to be that certain 64bit chipsets can't deal with
the fact that an URB's transfer_buffer is allocated with
kmalloc(GFP_KERNEL). The effect is that kmalloc() is very likely to
hand out memory which is not addressable by devices that are connected
via 32bit PCI busses, such as EHCI controllers. In theory, DMA bounce
buffers should be installed in such cases, or the IOMMU would be in
charge to re-map these buffers to suitable locations, but for at least
two people who have reported the issue, this obviously fails.

So my approach was to force the driver using memory that is DMA
coherent, which leads to 32bit addressable memory if the device's
DMA_MASK is set accordingly. Other drivers do the same, and the patch
for doing this is found here: http://lkml.org/lkml/2010/5/7/61. Users
that see the bug all report that this patch fixes their problem with
my driver. However, it was rejected back then as other developers said
it was fixing the wrong end, and that the driver doesn't necessarily
need coherent memory.

Takashi recently posted a patch to the bugzilla entry which uses a
different approach: it introduces a function to determine suitable GFP
flags for USB devices, and passes __DMA32 to kmalloc() eventually.
However, using this flags directly with the SLUB allocator is illegal
and causes a BUG() in mm/slub.c, cache_grow().

The question now is how to proceed. I see three possible ways.

1. Find a way to allocate 32bit-aware memory with kmalloc(), following
Takashi's idea
2. Find out exactly why these machines fail to install bounce buffers
or set up their IOMMU correctly
3. re-activate the currently disabled functions
usb_buffer_{map,unmap,sync} functions and let the USB stack do the
memory mapping

I'm not really deep into all the memory management code and even less
into how the IOMMU and bounce buffers work, so I need some help here.
Can anyone elaborate what would be the best option? I really want to
get this fixed now, and provide a driver that works for everyone.

What really puzzles me is that this doesn't hit a lot more people with
other drivers.


Thanks,
Daniel
