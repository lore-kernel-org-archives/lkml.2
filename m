Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab2D2Ujg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 16:39:36 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44489 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab2D2Uje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 16:39:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI / PCI: Make _SxD/_SxW check follow ACPI 4.0a spec
Date: Sun, 29 Apr 2012 22:44:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-pci@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        "Oleksij Rempel (fishor)" <bug-track@fisher-privat.net>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204292244.16467.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleksij Rempel <bug-track@fisher-privat.net>

This patch makes _SxD/_SxW check follow the ACPI 4.0a specification
more closely and fixes suspend bug found on ASUS Zenbook UX31E.

Some OEM use _SxD fileds do blacklist brocken Dx states.
If _SxD/_SxW return values are check before suspend as appropriate,
some nasty suspend/resume issues may be avoided.

References: https://bugzilla.kernel.org/show_bug.cgi?id=42728
Signed-off-by: Oleksij Rempel <bug-track@fisher-privat.net>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Bjorn, Len,

This is -stable material and therefore v3.4 as well, IMO.  Please let me
know if one of you can take it or whether you want me to handle it all the
way to Linus.

Thanks,
Rafael

---
 drivers/acpi/sleep.c |   22 +++++++++++++++++++++-
 drivers/pci/pci.c    |   12 +++++++++++-
 2 files changed, 32 insertions(+), 2 deletions(-)

Index: linux/drivers/acpi/sleep.c
===================================================================
--- linux.orig/drivers/acpi/sleep.c
+++ linux/drivers/acpi/sleep.c
@@ -714,10 +714,30 @@ int acpi_pm_device_sleep_state(struct de
 	 *
 	 * NOTE: We rely on acpi_evaluate_integer() not clobbering the integer
 	 * provided -- that's our fault recovery, we ignore retval.
+	 *
+	 * According to ACPI 4.0a (April 5, 2010), page 294,
+	 * Table 7-7 S3 Action / Result Table, we need to evaluate _SxW in
+	 * addition to _SxD if the device is configured for wakeup:
+	 * Desired Action    | _S3D | _PRW | _S3W | Resultant D-state
+	 * Enter S3          |  N/A |  D/C |  N/A | OSPM decides
+	 * Enter S3, No Wake |   2  |  D/C |  D/C | Enter D2 or D3
+	 * Enter S3, Wake    |   2  |   3  |  N/A | Enter D2
+	 * Enter S3, Wake    |   2  |   3  |   3  | Enter D2 or D3
+	 * Enter S3, Wake    |  N/A |   3  |   2  | Enter D0, D1 or D2
 	 */
-	if (acpi_target_sleep_state > ACPI_STATE_S0)
+	if (acpi_target_sleep_state > ACPI_STATE_S0) {
+		acpi_status status;
+
 		acpi_evaluate_integer(handle, acpi_method, NULL, &d_min);
 
+		if (device_may_wakeup(dev)) {
+			acpi_method[3] = 'W';
+			status = acpi_evaluate_integer(handle, acpi_method,
+						       NULL, &d_max);
+			if (ACPI_FAILURE(status))
+				d_max = d_min;
+		}
+	}
 	/*
 	 * If _PRW says we can wake up the system from the target sleep state,
 	 * the D-state returned by _SxD is sufficient for that (we assume a
Index: linux/drivers/pci/pci.c
===================================================================
--- linux.orig/drivers/pci/pci.c
+++ linux/drivers/pci/pci.c
@@ -1691,10 +1691,20 @@ pci_power_t pci_target_state(struct pci_
 {
 	pci_power_t target_state = PCI_D3hot;
 
-	if (platform_pci_power_manageable(dev)) {
+	/*
+	 * According to ACPI 4.0a,7.2 Device Power Management Objects, device
+	 * with wake capability should have _PRW or _PSW object and can have
+	 * _SxD or _SxW object.
+	 * It looks like some OEMs use this fields to avoid buggy Dx states
+	 * of devices, so we need to check for _PRW or _PSW and see if _SxD or
+	 * _SxW indicate to overwrite Dx.
+	 */
+	if (platform_pci_power_manageable(dev)
+	    || platform_pci_can_wakeup(dev)) {
 		/*
 		 * Call the platform to choose the target state of the device
 		 * and enable wake-up from this state if supported.
+		 * (Check _SxD and _SxW)
 		 */
 		pci_power_t state = platform_pci_choose_state(dev);
 
