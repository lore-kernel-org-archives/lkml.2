Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab1BJX7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:59:23 -0500
Received: from sous-sol.org ([216.99.217.87]:34639 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757328Ab1BJX7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:59:21 -0500
Date: Thu, 10 Feb 2011 15:58:56 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eric Paris <eparis@redhat.com>, Don Dutile <ddutile@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org
Subject: [PATCH 2/2 v2] pci: use security_capable() when checking capablities
 during config space read
Message-ID: <20110210235856.GD9869@sequoia.sous-sol.org>
References: <1297318312-14309-1-git-send-email-chrisw@sous-sol.org>
 <1297318312-14309-3-git-send-email-chrisw@sous-sol.org>
 <alpine.LRH.2.00.1102101915000.20298@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1102101915000.20298@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* James Morris (jmorris@namei.org) wrote:
> What about these other users of cap_raised?
> 
> drivers/block/drbd/drbd_nl.c:   if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN)) {
> drivers/md/dm-log-userspace-transfer.c: if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))
> drivers/staging/pohmelfs/config.c:      if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))
> drivers/video/uvesafb.c:        if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))

Those are a security_netlink_recv() variant.  They should be converted
although makes sense as a different patchset.

> Also, should this have a reported-by for Eric ?

Yes it should, thanks.  Below is patch with Reported-by added (seemed
overkill to respin the series; holler if that's perferred).

thanks,
-chris
---

From: Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 2/2 v2] pci: use security_capable() when checking capablities during config space read

Eric Paris noted that commit de139a3 ("pci: check caps from sysfs file
open to read device dependent config space") caused the capability check
to bypass security modules and potentially auditing.  Rectify this by
calling security_capable() when checking the open file's capabilities
for config space reads.

Reported-by: Eric Paris <eparis@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/pci/pci-sysfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 8ecaac9..f7771f3 100644
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
+	if (security_capable(filp->f_cred, CAP_SYS_ADMIN)) {
 		size = dev->cfg_size;
 	} else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
 		size = 128;
