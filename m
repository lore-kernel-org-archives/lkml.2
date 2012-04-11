Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965220Ab2DKXo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:44:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58738 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965172Ab2DKXWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:22:41 -0400
Message-Id: <20120411231038.192309058@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yinghai Lu <yinghai@kernel.org>,
        Len Brown <len.brown@intel.com>
Subject: [ 16/59] PNPACPI: Fix device ref leaking in acpi_pnp_match
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 89e96ada572fb216e582dbe3f64e1a6939a37f74 upstream.

During testing pci root bus removal, found some root bus bridge is not freed.
If booting with pnpacpi=off, those hostbridge could be freed without problem.
It turns out that some devices reference are not released during acpi_pnp_match.
that match should not hold one device ref during every calling.
Add pu_device calling before returning.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pnp/pnpacpi/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -321,9 +321,14 @@ static int __init acpi_pnp_match(struct
 {
 	struct acpi_device *acpi = to_acpi_device(dev);
 	struct pnp_dev *pnp = _pnp;
+	struct device *physical_device;
+
+	physical_device = acpi_get_physical_device(acpi->handle);
+	if (physical_device)
+		put_device(physical_device);
 
 	/* true means it matched */
-	return !acpi_get_physical_device(acpi->handle)
+	return !physical_device
 	    && compare_pnp_id(pnp->id, acpi_device_hid(acpi));
 }
 


