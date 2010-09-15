Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0IOVJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:09:07 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:1229 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab0IOVJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:09:04 -0400
Subject: [PATCH 1/3] x86/PCI: allocate space from the end of a region,
	not the beginning
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Wed, 15 Sep 2010 15:09:02 -0600
Message-ID: <20100915210902.12365.19911.stgit@bob.kio>
In-Reply-To: <20100915210818.12365.58732.stgit@bob.kio>
References: <20100915210818.12365.58732.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Allocate from the end of a region, not the beginning.

For example, if we need to allocate 0x800 bytes for a device on bus
0000:00 given these resources:

    [mem 0xbff00000-0xdfffffff] PCI Bus 0000:00
      [mem 0xc0000000-0xdfffffff] PCI Bus 0000:02

the available space at [mem 0xbff00000-0xbfffffff] is passed to the
alignment callback (pcibios_align_resource()).  Prior to this patch, we
would put the new 0x800 byte resource at the beginning of that available
space, i.e., at [mem 0xbff00000-0xbff007ff].

With this patch, we put it at the end, at [mem 0xbffff800-0xbfffffff].

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=16228#c41
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/pci/i386.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)


diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5525309..1ff3e9f 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -65,7 +65,10 @@ pcibios_align_resource(void *data, const struct resource *res,
 			resource_size_t size, resource_size_t align)
 {
 	struct pci_dev *dev = data;
-	resource_size_t start = res->start;
+	resource_size_t start = ALIGN(res->end - size + 1, align);
+
+	if (start < res->start)
+		start = res->start;
 
 	if (res->flags & IORESOURCE_IO) {
 		if (skip_isa_ioresource_align(dev))

