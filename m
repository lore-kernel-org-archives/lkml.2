Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab2EGUgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:36:22 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18422 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab2EGUaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:30:23 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/21] PCI: Add busn_res for pci domain.
Date: Mon,  7 May 2012 13:29:49 -0700
Message-Id: <1336422606-4244-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci root bus busn_res will be registered under that.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 651b096..674a477 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -20,6 +20,36 @@
 LIST_HEAD(pci_root_buses);
 EXPORT_SYMBOL(pci_root_buses);
 
+static LIST_HEAD(pci_domain_busn_res_list);
+
+struct pci_domain_busn_res {
+	struct list_head list;
+	struct resource res;
+	int domain_nr;
+};
+
+static struct resource *get_pci_domain_busn_res(int domain_nr)
+{
+	struct pci_domain_busn_res *r;
+
+	list_for_each_entry(r, &pci_domain_busn_res_list, list)
+		if (r->domain_nr == domain_nr)
+			return &r->res;
+
+	r = kzalloc(sizeof(*r), GFP_KERNEL);
+	if (!r)
+		return NULL;
+
+	r->domain_nr = domain_nr;
+	r->res.start = 0;
+	r->res.end = 0xff;
+	r->res.flags = IORESOURCE_BUS | IORESOURCE_PCI_FIXED;
+
+	list_add_tail(&r->list, &pci_domain_busn_res_list);
+
+	return &r->res;
+}
+
 static int find_anything(struct device *dev, void *data)
 {
 	return 1;
-- 
1.7.7

