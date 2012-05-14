Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab2ENUVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:21:50 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:38043 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757640Ab2ENUVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:21:48 -0400
Date: Mon, 14 May 2012 14:21:47 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Myron Stowe <mstowe@redhat.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: x86: runtime waring in pcibios_fwaddrmap_lookup
Message-ID: <20120514202147.GA20652@google.com>
References: <alpine.SOC.1.00.1204122238400.16365@math.ut.ee>
 <CAErSpo6YnzywdjTTVdVEHj_E-B0ARBpZ+fiy29Rv==fO6m9-FA@mail.gmail.com>
 <1335557685.2386.62.camel@zim.stowe>
 <alpine.SOC.1.00.1204280819270.14507@math.ut.ee>
 <1335905694.2386.138.camel@zim.stowe>
 <1336430699.2427.117.camel@zim.stowe>
 <alpine.SOC.1.00.1205131811590.7097@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1205131811590.7097@math.ut.ee>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 06:15:18PM +0300, Meelis Roos wrote:
> > > Thanks for the quick response Meelis (unlike myself; I've been consumed
> > > with a hard deadline task recently - sorry).
> 
> Not so quick this time - I had to replace the HDD and then recreate the 
> failing config. Took 2.4-rc7 as a base. This gives us another data point 
> - it does not warn on SMP but warns only on UP.

I think that's the critical point; thanks for mentioning it :)

The following patch should fix it.  Can you confirm?

commit d7d1398aa087445ce04a1b1d45c4de7485590f57
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Mon May 14 12:01:26 2012 -0600

    x86/PCI: only check for spinlock being held in SMP kernels
    
    spin_is_locked() is always false on UP kernels: spin_lock_irqsave() does no
    locking, so we can't tell whether the lock is held or not.  Therefore,
    this warning is only valid for SMP kernels.
    
    Reported-and-tested-by: Meelis Roos <mroos@linux.ee>
    CC: Myron Stowe <myron.stowe@redhat.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 831971e..dd8ca6f 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -57,7 +57,7 @@ static struct pcibios_fwaddrmap *pcibios_fwaddrmap_lookup(struct pci_dev *dev)
 {
 	struct pcibios_fwaddrmap *map;
 
-	WARN_ON(!spin_is_locked(&pcibios_fwaddrmap_lock));
+	WARN_ON_SMP(!spin_is_locked(&pcibios_fwaddrmap_lock));
 
 	list_for_each_entry(map, &pcibios_fwaddrmappings, list)
 		if (map->dev == dev)
