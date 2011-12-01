Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab1LAWsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:48:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55468 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab1LAWsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:48:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arch@vger.kernel.org, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxin B. John" <maxin.john@gmail.com>, Tejun Heo <tj@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] lib/devres.c: allow specifying NO_IOPORT while using PCI
Date: Thu, 01 Dec 2011 23:47:43 +0100
Message-ID: <1616727.0BYPKXtoA0@wuerfel>
User-Agent: KMail/4.7.2 (Linux/3.1.0-rc8nosema+; KDE/4.7.2; x86_64; ; )
In-Reply-To: <201112011815.pB1IFGZe004948@farm-0002.internal.tilera.com>
References: <cover.1322592494.git.mst@redhat.com> <201111301549.57430.arnd@arndb.de> <201112011815.pB1IFGZe004948@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Cv2UxT6t9IYsHUMtbqynimr4bhUz83NiYfOFPMNATgs
 VuY+PR8+vRE8FNnzYjJrc6mwJjQaqDF1VTnHghPXtxtJLKreTg
 I/JyTVDR81hVJO1DG2ADPoZSLvNsPxtYS0CeY93F1VxoZzl+Dj
 H64TnWKe59Y82/ch4FpguOltAb0a0Rv+IaLs7fs2vTZ8TRXp7c
 OuLs6pI/fl4GI1GyZhcAjWvzqKfxkeIjaKfG8qVJyXs5G/AQvq
 FgotvWnUg6ACkMbPLZO60EWVA7GXujeW2BrnmwUROCwI1vxPGl
 Ze9b8mXJa81ECBgM9g6SUz4GRhAYT+2z4ZfrY8SZeN5NTmjTEN
 Z6vvn4roDuA9LjEONr44=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 December 2011 12:59:19 Chris Metcalf wrote:
> The tile architecture does not support IOPORT, but it does support
> PCI and IOMEM.  We were not specifying NO_IOPORT, though, because it
> was causing a couple of functions (pcim_iomap_regions and pcim_iomap_table)
> that are needed to not get provided.  Moving the #ifdef fixes this
> so that those functions and some related ones are now always provided
> if CONFIG_PCI is true.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Hmm, I'm sure that Al Viro intentionally did it the way it is, but I'm
not sure exactly why that would be.

Any driver using the functions you now expose for NO_IOPORT is probably
prepared to handle both MMIO and PIO BARs on PCI, which you can consider
broken in the case where a card actually requires PIO.

On tile, it would be just as broken as other drivers that directly use
inb/outb to do the port access, but on platforms that actually have
PIO but are not able to map them (like arm/mach-rpc), you would now
enable people to write silently broken drivers.

However, assuming they check the return value of the *iomap, the
drivers could still easily detect this case at runtime. Also, at
least on tile, you already provide a pci_iomap function, which
has the exact same problem as the devres functions.

One area where your patch might actually break existing code is
architectures that allow the devres functions to be built *and*
have PCI support but don't provide a pci_iomap function, because
they do not support mapping the PIO range into addresses. I'm
not sure if that's actually still the case anywhere after Michael's
recent patches, but it used to be the case on RPC and probably others.

	Arnd
