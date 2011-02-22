Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1BVWVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:21:48 -0500
Received: from kroah.org ([198.145.64.141]:46723 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab1BVWVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:40 2011
Message-Id: <20110222221840.149753645@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [31/70] ACPI / Wakeup: Enable button GPEs unconditionally during initialization
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Rafael J. Wysocki <rjw@sisk.pl>

This is a backport of mainline kernel commit
2a5d24286e8bdafdc272b37ec5bdd9e977b3767c.

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
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/wakeup.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/acpi/wakeup.c
+++ b/drivers/acpi/wakeup.c
@@ -84,8 +84,12 @@ int __init acpi_wakeup_device_init(void)
 		struct acpi_device *dev = container_of(node,
 						       struct acpi_device,
 						       wakeup_list);
-		if (dev->wakeup.flags.always_enabled)
+		if (dev->wakeup.flags.always_enabled) {
+			/* Button GPEs are supposed to be always enabled. */
+			acpi_enable_gpe(dev->wakeup.gpe_device,
+					dev->wakeup.gpe_number);
 			dev->wakeup.state.enabled = 1;
+		}
 	}
 	mutex_unlock(&acpi_device_lock);
 	return 0;


