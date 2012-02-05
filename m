Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2BEG7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 01:59:23 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:41873 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2BEG7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 01:59:18 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/24] PCI: add /proc/iobusn
Date: Sat,  4 Feb 2012 22:57:49 -0800
Message-Id: <1328425088-6562-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F2E28BD.003A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

May help debug purpose.

need to fill root buses name.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |    3 +++
 kernel/resource.c   |   42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8d4de5e..fabf9d0 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1594,6 +1594,8 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 
 	b->number = b->secondary = bus;
 
+	sprintf(b->name, "PCI Bus %04x:%02x", pci_domain_nr(b), b->number);
+
 	/* Add initial resources to the bus */
 	list_for_each_entry_safe(bus_res, n, resources, list)
 		list_move_tail(&bus_res->list, &b->resources);
@@ -1631,6 +1633,7 @@ void pci_bus_insert_busn_res(struct pci_bus *b, int bus, int bus_max)
 	res->start = busn(pci_domain_nr(b), bus);
 	res->end = busn(pci_domain_nr(b), bus_max);
 	res->flags = IORESOURCE_BUS;
+	res->name = b->name;
 
 	if (!pci_is_root_bus(b))
 		parent_res = &b->parent->busn_res;
diff --git a/kernel/resource.c b/kernel/resource.c
index 53b42f0..1a73a81 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -113,6 +113,30 @@ static const struct seq_operations resource_op = {
 	.show	= r_show,
 };
 
+static int busn_r_show(struct seq_file *m, void *v)
+{
+	struct resource *root = m->private;
+	struct resource *r = v, *p;
+	int depth;
+
+	for (depth = 0, p = r; depth < MAX_IORES_LEVEL; depth++, p = p->parent)
+		if (p->parent == root)
+			break;
+	seq_printf(m, "%*s%04x:%02x-%04x:%02x : %s\n",
+			depth * 2, "",
+			busn_domain_nr(r->start), busn_bus_nr(r->start),
+			busn_domain_nr(r->end), busn_bus_nr(r->end),
+			r->name ? r->name : "<BAD>");
+	return 0;
+}
+
+static const struct seq_operations busn_resource_op = {
+	.start	= r_start,
+	.next	= r_next,
+	.stop	= r_stop,
+	.show	= busn_r_show,
+};
+
 static int ioports_open(struct inode *inode, struct file *file)
 {
 	int res = seq_open(file, &resource_op);
@@ -133,6 +157,16 @@ static int iomem_open(struct inode *inode, struct file *file)
 	return res;
 }
 
+static int iobusn_open(struct inode *inode, struct file *file)
+{
+	int res = seq_open(file, &busn_resource_op);
+	if (!res) {
+		struct seq_file *m = file->private_data;
+		m->private = &iobusn_resource;
+	}
+	return res;
+}
+
 static const struct file_operations proc_ioports_operations = {
 	.open		= ioports_open,
 	.read		= seq_read,
@@ -147,10 +181,18 @@ static const struct file_operations proc_iomem_operations = {
 	.release	= seq_release,
 };
 
+static const struct file_operations proc_iobusn_operations = {
+	.open		= iobusn_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static int __init ioresources_init(void)
 {
 	proc_create("ioports", 0, NULL, &proc_ioports_operations);
 	proc_create("iomem", 0, NULL, &proc_iomem_operations);
+	proc_create("iobusn", 0, NULL, &proc_iobusn_operations);
 	return 0;
 }
 __initcall(ioresources_init);
-- 
1.7.7

