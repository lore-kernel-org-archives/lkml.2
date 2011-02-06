Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab1BFOYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 09:24:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47855 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704Ab1BFOYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 09:24:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [Updated][PATCH 1/2] ACPI / Wakeup: Enable button GPEs unconditionally during initialization
Date: Sun, 6 Feb 2011 15:24:08 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Ferenc =?utf-8?q?W=C3=A1gner?= <wferi@niif.hu>
References: <201102061418.56202.rjw@sisk.pl> <201102061420.17431.rjw@sisk.pl>
In-Reply-To: <201102061420.17431.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102061524.08578.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ACPI / Wakeup: Enable button GPEs unconditionally during initialization

Commit 9630bdd (ACPI: Use GPE reference counting to support shared
GPEs) introduced a suspend regression where boxes resume immediately
after being suspended due to the lid or sleep button wakeup status
not being cleared properly.  This happens if the GPEs corresponding
to those devices are not enabled all the time, which apparently is
expected by some BIOSes.

To fix this problem, enable button and lid GPEs unconditionally
during initialization and keep them enabled all the time, regardless
of whether or not the ACPI button driver is used.

References: https://bugzilla.kernel.org/show_bug.cgi?id=27372
Reported-and-tested-by: Ferenc Wágner <wferi@niif.hu>
Cc: stable@kernel.org
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Hi,

This time with the correct diffstat.

Thanks,
Rafael

---
 drivers/acpi/wakeup.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/acpi/wakeup.c
+++ linux-2.6/drivers/acpi/wakeup.c
@@ -86,8 +86,12 @@ int __init acpi_wakeup_device_init(void)
 		struct acpi_device *dev = container_of(node,
 						       struct acpi_device,
 						       wakeup_list);
-		if (device_can_wakeup(&dev->dev))
+		if (device_can_wakeup(&dev->dev)) {
+			/* Button GPEs are supposed to be always enabled. */
+			acpi_enable_gpe(dev->wakeup.gpe_device,
+					dev->wakeup.gpe_number);
 			device_set_wakeup_enable(&dev->dev, true);
+		}
 	}
 	mutex_unlock(&acpi_device_lock);
 	return 0;
