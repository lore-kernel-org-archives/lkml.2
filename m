Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab2DCJHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 05:07:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62592 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2DCJHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 05:07:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kyungmin Park <kmpark@infradead.org>
Subject: Re: Linux 3.4-rc1
Date: Tue, 3 Apr 2012 09:07:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        vdumpa@nvidia.com, hdoyu@nvidia.com, konrad.wilk@oracle.com
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com> <CAH9JG2Wha0+6BwGW0APtEX2KACyR1+9fdKpJkM+iOU1m8N6d4w@mail.gmail.com>
In-Reply-To: <CAH9JG2Wha0+6BwGW0APtEX2KACyR1+9fdKpJkM+iOU1m8N6d4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204030907.29306.arnd@arndb.de>
X-Provags-ID: V02:K0:mxQwxbAk7YwcxurVc5+fWpG22iIjFDtKXj4z4LV1bd5
 NzfZB/KeMHfHrTT2HtaWsFtRhPXpNh7Zo+E3++L4BvjgEJIS1q
 ZoRbMLRHjRG0n7vTlFHRRS3UfWzNhpYuucN0LU4ygHYmcn+vyl
 v4+YPO103n8yKiSOvqU4Dhxo8rHdOaVM1H2QU88VRrfg6NI3IV
 FRMfgGSFeObGu/DzrXa4bD+OzYf1pT9PPpCkiy+QSm7oNDfxPB
 +ifwPN4L32ph9RCeDXcTEb/U8yJ0FJjgPUvw7NkYt8WD+tJfi0
 LcOSGOV0DUCQlLcA3UrMuZz84ylqcnF2CwV++7qXoFEZU2Gdwz
 lsJChnsktfW+c5+FHxAc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 April 2012, Kyungmin Park wrote:
> >
> >  - DMA-mapping framework. The tree now has a few more acks from
> > people, and it's largely in the same situation as HSI is: I'll
> > probably pull, but I really wanted the users who are impacted to
> > actually talk to me about it.
> >
> Hi,
> 
> Now Marek and Nvidia persons are used it for DMA mapping based IOMMU.
> 
> Are there other person who help to merge it?
> (+CC related persons).

I can give a little more background information.

We used to have separate implementations of dma_map_ops for each
architecture that had the need to abstract dma_alloc_coherent
and dma_map_* across both IOMMU and linear (virt_to_bus style)
mappings and/or swiotlb. Those dma_map_ops imlpementations were
already merged before the start of the git history and subsequently
got used on powerpc, ia64, x86_64, sparc, alpha, mips, unicore32
and hexagon, roughly in that order.

We are seeing lots of IOMMUs come up on ARM now, but unfortunately
the existing dma_map_ops do not cover the need on ARM to have
two different kind of coherent memory (write-combine and not
write-combine) that we have traditionally abstracted using
the dma_alloc_coherent and dma_alloc_writecombine functions on both
arm and avr32. In order to support IOMMUs on ARM using the same
API as everyone else, I've asked Marek to use dma_map_ops on
ARM, which requires slightly extending the include/linux/dma-mapping.h
interfaces so they cover this variation.

The actually interesting work to implement a better abstraction for
IOMMUs, building the dma-mapping.h API on top of the iommu.h API
in an architecture independent way has also been implemented but
requires these changes as a prerequisite.

	Arnd
