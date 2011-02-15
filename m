Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1BOB0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:26:55 -0500
Received: from sous-sol.org ([216.99.217.87]:36407 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753262Ab1BOB0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:26:52 -0500
Date: Mon, 14 Feb 2011 17:21:49 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@gmail.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Alex Riesen <raa.lkml@gmail.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        Eric Paris <eparis@redhat.com>
Subject: [PATCH v3] pci: use security_capable() when checking capablities
 during config space read
Message-ID: <20110215012149.GM9869@sequoia.sous-sol.org>
References: <20110213062213.GA2525@darkstar.dhcp.inet.fi>
 <AANLkTimDuYgL2cSR8gE7Wrm9_w7cvG_wuUUsa=8TKs87@mail.gmail.com>
 <AANLkTimxCMgdfht7rrg8QiCppb=D7fvR92eeiewdqCpH@mail.gmail.com>
 <20110214003531.GH9869@sequoia.sous-sol.org>
 <alpine.LRH.2.00.1102141203430.12055@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1102141203430.12055@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
v2: added Reported-by Eric
v3: fix logic screw up

 drivers/pci/pci-sysfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 8ecaac9..ea25e5b 100644
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
@@ -368,7 +369,7 @@ pci_read_config(struct file *filp, struct kobject *kobj,
 	u8 *data = (u8*) buf;
 
 	/* Several chips lock up trying to read undefined config space */
-	if (cap_raised(filp->f_cred->cap_effective, CAP_SYS_ADMIN)) {
+	if (security_capable(filp->f_cred, CAP_SYS_ADMIN) == 0) {
 		size = dev->cfg_size;
 	} else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
 		size = 128;
-- 
1.7.3.4
