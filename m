Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab0JLPwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:52:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32136 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862Ab0JLPwW (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Oct 2010 11:52:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org
Subject: [PATCH 15/23] msi: Introduce default_[teardown|setup]_msi_irqs with fallback.
Date: Tue, 12 Oct 2010 11:44:23 -0400
Message-Id: <1286898271-32018-16-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Introduce an override for the arch_[teardown|setup]_msi_irqs
that can be utilized to fallback to the default arch_* code.

If a platform wants to utilize the code paths defined
in driver/pci/msi.c it has to define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
or HAVE_DEFAULT_MSI_SETUP_IRQS. Otherwise the old mechanism
of over-ridding the arch_* works fine.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: x86@kernel.org
---
 drivers/pci/msi.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 69b7be3..e57bfa9 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -35,7 +35,12 @@ int arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
 #endif
 
 #ifndef arch_setup_msi_irqs
-int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+# define arch_setup_msi_irqs default_setup_msi_irqs
+# define HAVE_DEFAULT_MSI_SETUP_IRQS
+#endif
+
+#ifdef HAVE_DEFAULT_MSI_SETUP_IRQS
+int default_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	struct msi_desc *entry;
 	int ret;
@@ -60,7 +65,12 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 #endif
 
 #ifndef arch_teardown_msi_irqs
-void arch_teardown_msi_irqs(struct pci_dev *dev)
+# define arch_teardown_msi_irqs default_teardown_msi_irqs
+# define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
+#endif
+
+#ifdef HAVE_DEFAULT_MSI_TEARDOWN_IRQS
+void default_teardown_msi_irqs(struct pci_dev *dev)
 {
 	struct msi_desc *entry;
 
-- 
1.7.0.4

