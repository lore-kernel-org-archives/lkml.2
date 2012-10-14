Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab2JNOwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:52:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46655 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932272Ab2JNOnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:49 -0400
Message-Id: <20121014143541.317293712@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Sebastian Gottschall (DD-WRT)" <s.gottschall@dd-wrt.com>
Subject: [ 055/147] usb: host: xhci: Fix Null pointer dereferencing with 71c731a for
 non-x86 systems
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivek Gautam <gautam.vivek@samsung.com>

commit 457a73d346187c2cc5d599072f38676f18f130e0 upstream.

In 71c731a: usb: host: xhci: Fix Compliance Mode on SN65LVPE502CP Hardware
when extracting DMI strings (vendor or product_name) to mark them as quirk
we may get NULL pointer in case of non-x86 systems which won't define
CONFIG_DMI. Hence susbsequent strstr() calls crash while driver probing.

So, returning 'false' here in case we get a NULL vendor or product_name.

This is tested with ARM (exynos) system.

This patch should be backported to stable kernels as old as 3.6, that
contain the commit 71c731a296f1b08a3724bd1b514b64f1bda87a23 "usb: host:
xhci: Fix Compliance Mode on SN65LVPE502CP Hardware"

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Sebastian Gottschall (DD-WRT) <s.gottschall@dd-wrt.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 52b04b0..8d7fcbb 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -471,6 +471,8 @@ static bool compliance_mode_recovery_timer_quirk_check(void)
 
 	dmi_product_name = dmi_get_system_info(DMI_PRODUCT_NAME);
 	dmi_sys_vendor = dmi_get_system_info(DMI_SYS_VENDOR);
+	if (!dmi_product_name || !dmi_sys_vendor)
+		return false;
 
 	if (!(strstr(dmi_sys_vendor, "Hewlett-Packard")))
 		return false;


