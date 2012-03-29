Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512Ab2C2QcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 12:32:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51801 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758430Ab2C2QcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 12:32:17 -0400
Date: Thu, 29 Mar 2012 11:32:06 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Garrett <mjg@redhat.com>, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        stable@vger.kernel.org, Romain Francoise <romain@orebokech.com>,
        Chris Holland <bandidoirlandes@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Hatem Masmoudi <hatem.masmoudi@gmail.com>, janek <jan0x6c@gmail.com>
Subject: [PATCH resend] ASPM: Fix pcie devices with non-pcie children
Message-ID: <20120329163206.GA3480@burratino>
References: <1332857861-11562-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332857861-11562-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>
Date: Tue, 27 Mar 2012 10:17:41 -0400

Since 3.2.12 and 3.3, some systems are failing to boot with a BUG_ON.
Some other systems using the pata_jmicron driver fail to boot because
no disks are detected.  Passing pcie_aspm=force on the kernel command
line works around it.

The cause: commit 4949be16822e ("PCI: ignore pre-1.1 ASPM quirking
when ASPM is disabled") changed the behaviour of
pcie_aspm_sanity_check() to always return 0 if aspm is disabled, in
order to avoid cases where we changed ASPM state on pre-PCIe 1.1
devices.  This skipped the secondary function of
pcie_aspm_sanity_check which was to avoid us enabling ASPM on devices
that had non-PCIe children, causing trouble later on.  Move the
aspm_disabled check so we continue to honour that scenario.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=42979 and
          http://bugs.debian.org/665420

[jn: with more symptoms in log message]

Reported-by: Romain Francoise <romain@orebokech.com> # kernel panic
Reported-by: Chris Holland <bandidoirlandes@gmail.com> # disk detection trouble
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: stable@vger.kernel.org
Tested-by: Hatem Masmoudi <hatem.masmoudi@gmail.com> # Dell Latitude E5520
Tested-by: janek <jan0x6c@gmail.com> # pata_jmicron with JMB362/JMB363
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Hi Andrew,

This patch only appeared a couple of days ago[1], but it fixes a
noticeable regression so I would like to make sure the patch becomes
part of mainline and the 3.2.y- and 3.3.y-stable trees soon.  Could
you pick it up for linux-next until it makes its way to the PCI tree?

Regression was introduced between 3.3-rc7 and 3.3 and between 3.2.11
and 3.2.12.  Prevents boot on affected machines, though there is a
workaround.  Details about the symptoms and fix are above.

Thanks,
Jonathan

[1] http://thread.gmane.org/gmane.linux.kernel.pci/14503

 drivers/pci/pcie/aspm.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 4bdef24cd412..b500840a143b 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -508,9 +508,6 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 	int pos;
 	u32 reg32;
 
-	if (aspm_disabled)
-		return 0;
-
 	/*
 	 * Some functions in a slot might not all be PCIe functions,
 	 * very strange. Disable ASPM for the whole slot
@@ -519,6 +516,16 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 		pos = pci_pcie_cap(child);
 		if (!pos)
 			return -EINVAL;
+
+		/*
+		 * If ASPM is disabled then we're not going to change
+		 * the BIOS state. It's safe to continue even if it's a
+		 * pre-1.1 device
+		 */
+
+		if (aspm_disabled)
+			continue;
+
 		/*
 		 * Disable ASPM for pre-1.1 PCIe device, we follow MS to use
 		 * RBER bit to determine if a function is 1.1 version device
-- 
1.7.10.rc1

