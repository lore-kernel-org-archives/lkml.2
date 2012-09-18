Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab2IRSv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:51:59 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60422 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751658Ab2IRSv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:51:57 -0400
Message-ID: <1347994314.9011.1.camel@joe2Laptop>
Subject: [PATCH] pci: Convert pci_resource_<foo> macros to static inlines
From: Joe Perches <joe@perches.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 18 Sep 2012 11:51:54 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get the compiler to verify the argument type of struct pci_dev *.

Signed-off-by: Joe Perches <joe@perches.com>
---

Another possible improvement is to range check index.

 include/linux/pci.h |   36 ++++++++++++++++++++++++++----------
 1 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5faa831..971d0e9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1396,16 +1396,32 @@ static inline struct pci_dev *pci_dev_get(struct pci_dev *dev)
 
 /* these helpers provide future and backwards compatibility
  * for accessing popular PCI BAR info */
-#define pci_resource_start(dev, bar)	((dev)->resource[(bar)].start)
-#define pci_resource_end(dev, bar)	((dev)->resource[(bar)].end)
-#define pci_resource_flags(dev, bar)	((dev)->resource[(bar)].flags)
-#define pci_resource_len(dev,bar) \
-	((pci_resource_start((dev), (bar)) == 0 &&	\
-	  pci_resource_end((dev), (bar)) ==		\
-	  pci_resource_start((dev), (bar))) ? 0 :	\
-							\
-	 (pci_resource_end((dev), (bar)) -		\
-	  pci_resource_start((dev), (bar)) + 1))
+static inline resource_size_t
+pci_resource_start(const struct pci_dev *dev, int index)
+{
+	return dev->resource[index].start;
+}
+
+static inline resource_size_t
+pci_resource_end(const struct pci_dev *dev, int index)
+{
+	return dev->resource[index].end;
+}
+
+static inline unsigned long
+pci_resource_flags(const struct pci_dev *dev, int index)
+{
+	return dev->resource[index].flags;
+}
+
+static inline resource_size_t
+pci_resource_len(const struct pci_dev *dev, int index)
+{
+	if (pci_resource_start(dev, index) == 0 &&
+	    pci_resource_end(dev, index) == 0)
+		return 0;
+	return resource_size(&dev->resource[index]);
+}
 
 /* Similar to the helpers above, these manipulate per-pci_dev
  * driver-specific data.  They are really just a wrapper around



