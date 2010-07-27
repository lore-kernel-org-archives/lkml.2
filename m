Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab0G0E7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 00:59:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28840 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0G0E7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 00:59:37 -0400
Message-ID: <4C4E674A.2040605@kernel.org>
Date: Mon, 26 Jul 2010 21:57:46 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Myron Stowe <myron.stowe@hp.com>
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ipmi: Fix memleaking for add_smi when duplicating happen
References: <4C4E3575.3020203@kernel.org>
In-Reply-To: <4C4E3575.3020203@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C4E679B.014D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

need free the temp info struct when we have duplicated ones

-v2: seperate printing change to another patch

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/char/ipmi/ipmi_si_intf.c |   35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
@@ -1804,9 +1804,12 @@ static int hotmod_handler(const char *va
 				info->irq_setup = std_irq_setup;
 			info->slave_addr = ipmb;
 
-			if (!add_smi(info))
+			if (!add_smi(info)) {
 				if (try_smi_init(info))
 					cleanup_one_si(info);
+			} else {
+				kfree(info);
+			}
 		} else {
 			/* remove */
 			struct smi_info *e, *tmp_e;
@@ -1890,9 +1893,12 @@ static __devinit void hardcode_find_bmc(
 			info->irq_setup = std_irq_setup;
 		info->slave_addr = slave_addrs[i];
 
-		if (!add_smi(info))
+		if (!add_smi(info)) {
 			if (try_smi_init(info))
 				cleanup_one_si(info);
+		} else {
+			kfree(info);
+		}
 	}
 }
 
@@ -2088,7 +2094,8 @@ static __devinit int try_init_spmi(struc
 	}
 	info->io.addr_data = spmi->addr.address;
 
-	add_smi(info);
+	if (add_smi(info))
+		kfree(info);
 
 	return 0;
 }
@@ -2204,7 +2211,10 @@ static int __devinit ipmi_pnp_probe(stru
 		 res, info->io.regsize, info->io.regspacing,
 		 info->irq);
 
-	return add_smi(info);
+	if (add_smi(info))
+		goto err_free;
+
+	return 0;
 
 err_free:
 	kfree(info);
@@ -2362,7 +2372,8 @@ static __devinit void try_init_dmi(struc
 	if (info->irq)
 		info->irq_setup = std_irq_setup;
 
-	add_smi(info);
+	if (add_smi(info))
+		kfree(info);
 }
 
 static void __devinit dmi_find_bmc(void)
@@ -2468,7 +2479,10 @@ static int __devinit ipmi_pci_probe(stru
 		&pdev->resource[0], info->io.regsize, info->io.regspacing,
 		info->irq);
 
-	return add_smi(info);
+	if (add_smi(info))
+		kfree(info);
+
+	return 0;
 }
 
 static void __devexit ipmi_pci_remove(struct pci_dev *pdev)
@@ -2581,7 +2595,12 @@ static int __devinit ipmi_of_probe(struc
 
 	dev_set_drvdata(&dev->dev, info);
 
-	return add_smi(info);
+	if (add_smi(info)) {
+		kfree(info);
+		return -EBUSY;
+	}
+
+	return 0;
 }
 
 static int __devexit ipmi_of_remove(struct of_device *dev)
@@ -3018,6 +3037,8 @@ static __devinit void default_find_bmc(v
 				info->io.addr_data);
 			} else
 				cleanup_one_si(info);
+		} else {
+			kfree(info);
 		}
 	}
 }
