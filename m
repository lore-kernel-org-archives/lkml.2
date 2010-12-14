Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133Ab0LNVRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:17:15 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61441 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab0LNVRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:17:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:organization:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=JzZ8iZA2C90Md/BcTgsFEdusWvEY8+Xz7F1+WhgOq6WIEENl6+biSz+goWtOoJWTmQ
         B2FvgWNvKewrQmLTINVNmlNiZHFuN5IxzYx38unZJA7tcsV/y3fsShUNdMnhFEu4PiSF
         h1kiST620We8VVMEdkIpRR1uOgjBVDSxLmkGU=
From: Florian Fainelli <florian@openwrt.org>
To: linux-kernel@vger.kernel.org, Dirk Brandewie <dirk.brandewie@gmail.com>,
        sodaville@linutronix.de, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH] coretemp: fix junction temperature for Intel CE4100
Date: Tue, 14 Dec 2010 22:17:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; x86_64; ; )
Organization: Freebox
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012142217.07194.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <ffainelli@freebox.fr>

The Intel CE4100 System-on-a-Chip has a slightly higher junction temperature
(110 degrees Celsius) than other Atom-based hardware.

Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: sodaville@linutronix.de
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
---
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 42de98d..e47b405 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -178,12 +178,23 @@ static int __devinit adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *
 
 		host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
 
-		if (host_bridge && host_bridge->vendor == PCI_VENDOR_ID_INTEL
-		    && (host_bridge->device == 0xa000	/* NM10 based nettop */
-		    || host_bridge->device == 0xa010))	/* NM10 based netbook */
-			tjmax = 100000;
-		else
-			tjmax = 90000;
+		if (host_bridge && host_bridge->vendor == PCI_VENDOR_ID_INTEL) {
+			switch (host_bridge->device) {
+			/* NM10 based nettop */
+			case 0xa000:
+			/* NM10 based netbook */
+			case 0xa010:
+				tjmax = 100000;
+				break;
+			/* IntelCE Sodaville (CE4100) */
+			case 0x0708:
+				tjmax = 110000;
+				break;
+			default:
+				tjmax = 90000;
+				break;
+			}
+		}
 
 		pci_dev_put(host_bridge);
 	}
-- 
1.7.1

