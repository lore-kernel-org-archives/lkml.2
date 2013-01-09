Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab3AIWK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:10:59 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57688 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab3AIWK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 17:10:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Date: Wed, 9 Jan 2013 22:10:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <201301092119.57067.arnd@arndb.de> <20130109215428.GA13648@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130109215428.GA13648@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301092210.49452.arnd@arndb.de>
X-Provags-ID: V02:K0:lnZuufGrKHWySZhPl1YJjUhwiuAIQrfKDf1XjiaOGX0
 MvkPEGX73Tc11ZRWJusuKlLj9KhhM/OA/N2hlQwcxp9kjBILmT
 iN6hucjDcDypsVTJ3eTZok4bK7e+AAg79uG5BD8QHm2wHNG5ad
 uHrjqrCDlF4avjSUCGXe6ctAUveyzYqGa1uTH1d9nS6vFHaHr2
 LlChKHCxkyivVKMdmQk3FJ5BqZWIeNxh8RzFalVTjusTshHvQ0
 13euIIVEqLJbNzghMkEG53dFCmKlNuPEqomkCs9MQNO/145NrX
 JSW0Y435G2/iwBINuUDissb2Q7JKvooYNSuVF2R5GS0cKHhSIA
 npbWSELVPiHWmbd5uKXk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013, Thierry Reding wrote:
> What happens on Tegra is that we need to map 256 MiB of physical memory
> to access all the PCIe extended configuration space. However, ioremap()
> on such a large region fails if not enough vmalloc() space is available.
> 
> This was observed when somebody tested this on CardHu which has a 1 GiB
> of RAM and therefore remapping the full 256 MiB fails.

Hmm, config space accesses are fairly rare and generally not expected
to be fast, and 256 MB is really a huge waste of virtual address space,
so I agree that just ioremapping the entire space is not a good
solution.

However, it's not clear that a cache is necessary. Have you measured
a significant performance benefit of this implementation over just
iorempping and unmapping a single page for every config space access?
Have you checked if the hardware supports an alternative config
space access mechanism that does not depend on a huge address range?
A lot of them provide an index/data register pair somewhere, as the
original PC implementation did.

Even if we actually want a cache, how about a private implementation
that just remembers a single page in LRU? I doubt that there are
more drivers that would benefit from a generalized version that you
provide.

	Arnd
