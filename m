Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361Ab1KWAlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:41:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759346Ab1KWAl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:41:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:05 2011
Message-Id: <20111123002404.983321912@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Vasily Averin <vvs@sw.ru>,
        Matthew Garrett <mjg@redhat.com>,
        Achim Leubner <Achim_Leubner@pmc-sierra.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [04/53] [SCSI] aacraid: controller hangs if kernel uses non-default ASPM policy
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Averin <vvs@parallels.com>

commit cf16123c9c8e346ed1dd171295a678d77648d7f8 upstream.

Aacraid controller can hang on some nodes if kernel uses non-default
(powersave) ASPM policy.  Controller hangs shortly after successful load and
hardware detection. Scsi error handler detects this hang and tries to restart
hardware but it does not help.

Initially it was noticed on RHEL6-based openVZ kernel after backporting
aacraid driver from mainline (RHEL6 kernel with original driver works well)
http://bugzilla.openvz.org/show_bug.cgi?id=2043

This issue happens because default ASPM policy was changed in Red Hat
kernels. Therefore guys from Red Hat have noticed this problem long time ago:
on Fedora 12
 https://bugzilla.redhat.com/show_bug.cgi?id=540478
on Fedora 14
 https://bugzilla.redhat.com/show_bug.cgi?id=679385

In RHEL6 kernel this issue was fixed, ASPM was disabled in aacraid driver. In
kernel changelog I've found that seems it was done by Matthew Garrett: -
[scsi] aacraid: Disable ASPM by default (Matthew Garrett) [599735]

However seems this patch was not submitted to mainline. I've reproduced this
issue on vanilla 3.1.0 kernel booted with "pcie_aspm.policy=powersave" option,
So I believe it makes sense to do it now.

Signed-off-by:	Vasily Averin <vvs@sw.ru>
[mjg: Checking the Windows drivers indicates that they disable ASPM under all
circumstances, so:]
Acked-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Achim Leubner <Achim_Leubner@pmc-sierra.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/aacraid/linit.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -38,6 +38,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
@@ -1108,6 +1109,9 @@ static int __devinit aac_probe_one(struc
 		unique_id++;
 	}
 
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+			       PCIE_LINK_STATE_CLKPM);
+
 	error = pci_enable_device(pdev);
 	if (error)
 		goto out;


