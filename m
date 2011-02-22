Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab1BVWb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:31:28 -0500
Received: from kroah.org ([198.145.64.141]:46716 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab1BVWVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:44 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:40 2011
Message-Id: <20110222221840.062978046@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Morris <jmorris@namei.org>, Dave Airlie <airlied@gmail.com>,
        Alex Riesen <raa.lkml@gmail.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        Chris Wright <chrisw@sous-sol.org>
Subject: [30/70] pci: use security_capable() when checking capablities during config space read
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wright <chrisw@sous-sol.org>

commit a628e7b87e100befac9702aa0c3b9848a7685e49 upstream.

This reintroduces commit 47970b1b which was subsequently reverted
as f00eaeea.  The original change was broken and caused X startup
failures and generally made privileged processes incapable of reading
device dependent config space.  The normal capable() interface returns
true on success, but the LSM interface returns 0 on success.  This thinko
is now fixed in this patch, and has been confirmed to work properly.

So, once again...Eric Paris noted that commit de139a3 ("pci: check caps
from sysfs file open to read device dependent config space") caused the
capability check to bypass security modules and potentially auditing.
Rectify this by calling security_capable() when checking the open file's
capabilities for config space reads.

Reported-by: Eric Paris <eparis@redhat.com>
Tested-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: James Morris <jmorris@namei.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Alex Riesen <raa.lkml@gmail.com>
Cc: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci-sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -23,6 +23,7 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/capability.h>
+#include <linux/security.h>
 #include <linux/pci-aspm.h>
 #include <linux/slab.h>
 #include "pci.h"
@@ -368,7 +369,7 @@ pci_read_config(struct file *filp, struc
 	u8 *data = (u8*) buf;
 
 	/* Several chips lock up trying to read undefined config space */
-	if (cap_raised(filp->f_cred->cap_effective, CAP_SYS_ADMIN)) {
+	if (security_capable(filp->f_cred, CAP_SYS_ADMIN) == 0) {
 		size = dev->cfg_size;
 	} else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
 		size = 128;


