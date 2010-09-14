Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab0INTkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:40:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56313 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab0INTkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:40:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 02/18] proc/pci: kill BKL
Date: Tue, 14 Sep 2010 21:40:06 +0200
Message-Id: <1284493213-7263-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284493139-7233-1-git-send-email-arnd@arndb.de>
References: <1284493139-7233-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:53alOBG1lKsOVtJTYus+LzzOSVlM4Ei4QK5bAJYOGQy
 2qjF6Vo4Wz6KDyzONcZB3lJNDcuPKLzEjgfDmxwbNbpo5p6Ik/
 waj/PJCo7RkQWHHEeaVaaqerouAoRmsHy2g3FgaAPMs++oG1dp
 6FykkQp+OGICLA3hv9VofDvwjCAJwHLgvaxWzQQfIoN38ATB9i
 +Yfkqmng2Gbb3vu7caliA==
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
index 01f0306..297b72c 100644
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

