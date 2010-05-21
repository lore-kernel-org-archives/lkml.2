Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab0EUQ5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:57:43 -0400
Received: from kroah.org ([198.145.64.141]:39162 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934267Ab0EUQyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 30/38] pci: check caps from sysfs file open to read device dependent config space
Date: Fri, 21 May 2010 09:54:00 -0700
Message-Id: <1274460848-11377-30-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

The PCI config space bin_attr read handler has a hardcoded CAP_SYS_ADMIN
check to verify privileges before allowing a user to read device
dependent config space.  This is meant to protect from an unprivileged
user potentially locking up the box.

When assigning a PCI device directly to a guest with libvirt and KVM,
the sysfs config space file is chown'd to the unprivileged user that
the KVM guest will run as.  The guest needs to have full access to the
device's config space since it's responsible for driving the device.
However, despite being the owner of the sysfs file, the CAP_SYS_ADMIN
check will not allow read access beyond the config header.

With this patch we check privileges against the capabilities used when
openining the sysfs file.  The allows a privileged process to open the
file and hand it to an unprivileged process, and the unprivileged process
can still read all of the config space.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/pci-sysfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index ad44557..6309c5a 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -21,6 +21,7 @@
 #include <linux/stat.h>
 #include <linux/topology.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/capability.h>
 #include <linux/pci-aspm.h>
 #include <linux/slab.h>
@@ -367,7 +368,7 @@ pci_read_config(struct file *filp, struct kobject *kobj,
 	u8 *data = (u8*) buf;
 
 	/* Several chips lock up trying to read undefined config space */
-	if (capable(CAP_SYS_ADMIN)) {
+	if (cap_raised(filp->f_cred->cap_effective, CAP_SYS_ADMIN)) {
 		size = dev->cfg_size;
 	} else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
 		size = 128;
-- 
1.7.0.3

