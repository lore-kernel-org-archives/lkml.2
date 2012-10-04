Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161Ab2JDVXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:23:54 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:50177 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934147Ab2JDVXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:23:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Sebastian Gottschall (DD-WRT)" <s.gottschall@dd-wrt.com>
Subject: [ 09/52] usb: host: xhci: Fix Null pointer dereferencing with 71c731a for non-x86 systems
Date: Thu,  4 Oct 2012 14:21:00 -0700
Message-Id: <20121004210636.507224878@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -470,6 +470,8 @@ static bool compliance_mode_recovery_tim
 
 	dmi_product_name = dmi_get_system_info(DMI_PRODUCT_NAME);
 	dmi_sys_vendor = dmi_get_system_info(DMI_SYS_VENDOR);
+	if (!dmi_product_name || !dmi_sys_vendor)
+		return false;
 
 	if (!(strstr(dmi_sys_vendor, "Hewlett-Packard")))
 		return false;


