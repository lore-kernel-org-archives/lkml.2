Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab1GXTGC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 15:06:02 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:56433 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751516Ab1GXTF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 15:05:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Z2G2n/x9e8RWcyexcLJs8yaAWPiAAzE9GNFeR071tRXfNpMwQ8EBk6X9cow0ryfq4R5Z5b0wgtRq/gl9l5SrrkaalVzG1nXT8xUO0ib3inUobGt/Hv/r0T/jI0fFbL3E;
Date: Sun, 24 Jul 2011 11:39:14 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jonas Bonn <jonas@southpole.se>, torvalds <torvalds@linux-foundation.org>
Subject: Re: iomap: make IOPORT/PCI mapping functions conditional
Message-Id: <20110724113914.5e0f36a4.rdunlap@xenotime.net>
In-Reply-To: <201107241801.p6OI17O2009446@hera.kernel.org>
References: <201107241801.p6OI17O2009446@hera.kernel.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jul 2011 18:01:07 GMT Linux Kernel Mailing List wrote:

> Gitweb:     http://git.kernel.org/linus/82ed223c264def2b15ee4bec2e8c3048092ceb5f
> Commit:     82ed223c264def2b15ee4bec2e8c3048092ceb5f
> Parent:     f1ecc69838a2d7c8a3e1909f637d4083c071777d
> Author:     Jonas Bonn <jonas@southpole.se>
> AuthorDate: Sat Jul 2 17:23:29 2011 +0200
> Committer:  Jonas Bonn <jonas@southpole.se>
> CommitDate: Fri Jul 22 18:46:26 2011 +0200
> 
>     iomap: make IOPORT/PCI mapping functions conditional
>     
>     Use the CONFIG_HAS_IOPORT and CONFIG_PCI options to decide whether or
>     not functions for mapping these areas are provided.
>     
>     Signed-off-by: Jonas Bonn <jonas@southpole.se>
>     Acked-by: Arnd Bergmann <arnd@arndb.de>

This patch caused a randconfig build error when CONFIG_EISA=y and CONFIG_PCI=n,
as reported on 2011-JULY-18.  My patch from that email is repeated below
(with Andrew's S-O-B since he merged it into his tree).


---
From: Randy Dunlap <rdunlap@xenotime.net>

When CONFIG_PCI is not enabled, CONFIG_EISA=y, and CONFIG_GENERIC_IOMAP=y,
drivers/net/3c59x.c build fails due to a recent small change to
<asm-generic/iomap.h> that surrounds pci_iomap() and pci_iounmap()
with #ifdef CONFIG_PCI/#endif.  Since that patch to iomap.h looks
correct, add stubs for pci_iomap() and pci_iounmap() with CONFIG_PCI
is not enabled to fix the build errors.

drivers/net/3c59x.c:1026: error: implicit declaration of function 'pci_iomap'
drivers/net/3c59x.c:1038: error: implicit declaration of function 'pci_iounmap'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 include/asm-generic/iomap.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-next-20110718.orig/include/asm-generic/iomap.h
+++ linux-next-20110718/include/asm-generic/iomap.h
@@ -71,6 +71,14 @@ extern void ioport_unmap(void __iomem *)
 struct pci_dev;
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
+#else
+struct pci_dev;
+static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
+{
+	return NULL;
+}
+static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr)
+{ }
 #endif
 
 #endif
