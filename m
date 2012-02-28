Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965410Ab2B1BTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:19:24 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50099 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965409Ab2B1BTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:19:21 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.72.138 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010429.839754043@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, garyhade@us.ibm.com,
        Yinghai Lu <yinghai.lu@oracle.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 05/72] PCI: workaround hard-wired bus number V2
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai.lu@oracle.com>

commit 71f6bd4a23130cd2f4b036010c5790b1295290b9 upstream.

Fixes PCI device detection on IBM xSeries IBM 3850 M2 / x3950 M2
when using ACPI resources (_CRS).
This is default, a manual workaround (without this patch)
would be pci=nocrs boot param.

V2: Add dev_warn if the workaround is hit. This should reveal
how common such setups are (via google) and point to possible
problems if things are still not working as expected.
-> Suggested by Jan Beulich.

Tested-by: garyhade@us.ibm.com
Signed-off-by: Yinghai Lu <yinghai.lu@oracle.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/probe.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -651,6 +651,11 @@ int __devinit pci_scan_bridge(struct pci
 	dev_dbg(&dev->dev, "scanning [bus %02x-%02x] behind bridge, pass %d\n",
 		secondary, subordinate, pass);
 
+	if (!primary && (primary != bus->number) && secondary && subordinate) {
+		dev_warn(&dev->dev, "Primary bus is hard wired to 0\n");
+		primary = bus->number;
+	}
+
 	/* Check if setup is sensible at all */
 	if (!pass &&
 	    (primary != bus->number || secondary <= bus->number)) {


