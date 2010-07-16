Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355Ab0GPV4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 17:56:44 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:50678 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753742Ab0GPV4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 17:56:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=C3DJjXFSGAAblAWWWV1zL4t77QwdAZlmVkNStZ2o5thdyAS2x41bOnKctkh4IWDW2CVQNofSdPHTVtcz85u0nnx/r0fHXYAD1LZkY4GzdPeBDKgFo9KvvjgdPjKxbYqV;
Date: Fri, 16 Jul 2010 14:56:42 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCI fix
Message-ID: <20100716145642.73398601@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
f469461df6ff822f71b8737bda86eea20f16ff93:

  Merge branch 'perf-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-07-16 11:26:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

This one hasn't gone through linux-next yet, but it has been tested by the
reporter and seems reasonably safe.  As always, the pull decision is yours; I
don't think this will make anything worse though...

Thanks,
Jesse

Bjorn Helgaas (1):
      PCI: fall back to original BIOS BAR addresses

 arch/x86/pci/i386.c     |    1 +
 drivers/pci/setup-res.c |   32 ++++++++++++++++++++++++++++++++
 include/linux/pci.h     |    1 +
 3 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 6fdb3ec..5525309 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -184,6 +184,7 @@ static void __init pcibios_allocate_resources(int pass)
 					idx, r, disabled, pass);
 				if (pci_claim_resource(dev, idx) < 0) {
 					/* We'll assign a new address later */
+					dev->fw_addr[idx] = r->start;
 					r->end -= r->start;
 					r->start = 0;
 				}
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 92379e2..2aaa131 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -156,6 +156,38 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 					     pcibios_align_resource, dev);
 	}
 
+	if (ret < 0 && dev->fw_addr[resno]) {
+		struct resource *root, *conflict;
+		resource_size_t start, end;
+
+		/*
+		 * If we failed to assign anything, let's try the address
+		 * where firmware left it.  That at least has a chance of
+		 * working, which is better than just leaving it disabled.
+		 */
+
+		if (res->flags & IORESOURCE_IO)
+			root = &ioport_resource;
+		else
+			root = &iomem_resource;
+
+		start = res->start;
+		end = res->end;
+		res->start = dev->fw_addr[resno];
+		res->end = res->start + size - 1;
+		dev_info(&dev->dev, "BAR %d: trying firmware assignment %pR\n",
+			 resno, res);
+		conflict = request_resource_conflict(root, res);
+		if (conflict) {
+			dev_info(&dev->dev,
+				 "BAR %d: %pR conflicts with %s %pR\n", resno,
+				 res, conflict->name, conflict);
+			res->start = start;
+			res->end = end;
+		} else
+			ret = 0;
+	}
+
 	if (!ret) {
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		dev_info(&dev->dev, "BAR %d: assigned %pR\n", resno, res);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7cb0084..f26fda7 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -288,6 +288,7 @@ struct pci_dev {
 	 */
 	unsigned int	irq;
 	struct resource resource[DEVICE_COUNT_RESOURCE]; /* I/O and memory regions + expansion ROMs */
+	resource_size_t	fw_addr[DEVICE_COUNT_RESOURCE]; /* FW-assigned addr */
 
 	/* These fields are used by common fixups */
 	unsigned int	transparent:1;	/* Transparent PCI bridge */
