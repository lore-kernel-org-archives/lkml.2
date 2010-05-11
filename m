Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab0EKP4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:56:09 -0400
Received: from mail-va3.bigfish.com ([216.32.180.111]:46991 "EHLO
	mail9-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751056Ab0EKP4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:56:06 -0400
X-Greylist: delayed 1193 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 May 2010 11:56:05 EDT
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h2a8h)
X-FB-DOMAIN-IP-MATCH: fail
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0L29HVM-02-LN2-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] x86/amd-iommu: Add amd_iommu=off command line option
Date: Tue, 11 May 2010 17:33:22 +0200
Message-ID: <1273592002-27730-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a command line option to tell the AMD IOMMU
driver to not initialize any IOMMU it finds.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 Documentation/kernel-parameters.txt |    2 ++
 arch/x86/kernel/amd_iommu_init.c    |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 839b21b..0c6c560 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -324,6 +324,8 @@ and is between 256 and 4096 characters. It is defined in the file
 				    they are unmapped. Otherwise they are
 				    flushed before they will be reused, which
 				    is a lot of faster
+			off	  - do not initialize any AMD IOMMU found in
+				    the system
 
 	amijoy.map=	[HW,JOY] Amiga joystick support
 			Map of devices attached to JOY0DAT and JOY1DAT
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 6360abf..3bacb4d 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -120,6 +120,7 @@ struct ivmd_header {
 bool amd_iommu_dump;
 
 static int __initdata amd_iommu_detected;
+static bool __initdata amd_iommu_disabled;
 
 u16 amd_iommu_last_bdf;			/* largest PCI device id we have
 					   to handle */
@@ -1372,6 +1373,9 @@ void __init amd_iommu_detect(void)
 	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
 		return;
 
+	if (amd_iommu_disabled)
+		return;
+
 	if (acpi_table_parse("IVRS", early_amd_iommu_detect) == 0) {
 		iommu_detected = 1;
 		amd_iommu_detected = 1;
@@ -1401,6 +1405,8 @@ static int __init parse_amd_iommu_options(char *str)
 	for (; *str; ++str) {
 		if (strncmp(str, "fullflush", 9) == 0)
 			amd_iommu_unmap_flush = true;
+		if (strncmp(str, "off", 3) == 0)
+			amd_iommu_disabled = true;
 	}
 
 	return 1;
-- 
1.7.1


