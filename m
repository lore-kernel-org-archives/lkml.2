Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab0GCWDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:03:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59182 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab0GCWCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:02:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Tejun Heo <tj@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH 4/8] proc/pci: kill BKL
Date: Sun,  4 Jul 2010 00:02:28 +0200
Message-Id: <1278194552-24943-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278194552-24943-1-git-send-email-arnd@arndb.de>
References: <1278194552-24943-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:IJl/6Ww5z3cj8juC4XHa00Syv8qaNiIU/1aMGfSNWFS
 esY0lK56wTSmJhGuM0WwWQQgU0j0EfXkPabWXHK5GA0CY86IV2
 iekZDB1kmWu87Oy6bNbGFdA17P3GHSR6jCBIxYmr2j1i+F+Xxl
 aP3cOBkHl9ZRxY+tYHEQMv4BGsXhaV0u4WjdPFaebTuR77Fu/n
 Cw7k0gnQmm3MkmnbZphRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All operations in the pci procfs ioctl functions are
atomic, so no lock is needed here.

Also add a compat_ioctl method, since all the commands
are compatible in 32 bit mode.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/proc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 449e890..35b80c7 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -212,8 +212,6 @@ static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd,
 #endif /* HAVE_PCI_MMAP */
 	int ret = 0;
 
-	lock_kernel();
-
 	switch (cmd) {
 	case PCIIOC_CONTROLLER:
 		ret = pci_domain_nr(dev->bus);
@@ -242,7 +240,6 @@ static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd,
 		break;
 	};
 
-	unlock_kernel();
 	return ret;
 }
 
@@ -306,6 +303,7 @@ static const struct file_operations proc_bus_pci_operations = {
 	.read		= proc_bus_pci_read,
 	.write		= proc_bus_pci_write,
 	.unlocked_ioctl	= proc_bus_pci_ioctl,
+	.compat_ioctl	= proc_bus_pci_ioctl,
 #ifdef HAVE_PCI_MMAP
 	.open		= proc_bus_pci_open,
 	.release	= proc_bus_pci_release,
-- 
1.7.1

