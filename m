Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab0IMKLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:11:12 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:60366 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab0IMKLK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Mon, 13 Sep 2010 06:11:10 -0400
Message-Id: <4C8E14D90200007800015AAE@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 13 Sep 2010 11:11:05 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <khali@linux-fr.org>
Cc: <fenghua.yu@intel.com>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/hwmon: avoid deadlock on CPU removal in pkgtemp
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pkgtemp_device_remove(), holding the list protecting mutex, calls
pkgtemp_device_add(), which itself wants to acquire the same mutex.
Holding the mutex over the entire loop body in pkgtemp_device_remove()
isn't really necessary, as long as the loop gets exited after
processing the matched CPU.

Once exiting the loop after removing an eventual match, there's no
need for using the "safe" list iterator anymore.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>

---
 drivers/hwmon/pkgtemp.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-2.6.36-rc4/drivers/hwmon/pkgtemp.c	2010-09-13 08:45:03.000000000 +0200
+++ 2.6.36-rc4-x86-pkgtemp-remove-deadlock/drivers/hwmon/pkgtemp.c	2010-09-03 17:54:30.000000000 +0200
@@ -339,17 +339,18 @@ exit:
 #ifdef CONFIG_HOTPLUG_CPU
 static void pkgtemp_device_remove(unsigned int cpu)
 {
-	struct pdev_entry *p, *n;
+	struct pdev_entry *p;
 	unsigned int i;
 	int err;
 
 	mutex_lock(&pdev_list_mutex);
-	list_for_each_entry_safe(p, n, &pdev_list, list) {
+	list_for_each_entry(p, &pdev_list, list) {
 		if (p->cpu != cpu)
 			continue;
 
 		platform_device_unregister(p->pdev);
 		list_del(&p->list);
+		mutex_unlock(&pdev_list_mutex);
 		kfree(p);
 		for_each_cpu(i, cpu_core_mask(cpu)) {
 			if (i != cpu) {
@@ -358,7 +359,7 @@ static void pkgtemp_device_remove(unsign
 					break;
 			}
 		}
-		break;
+		return;
 	}
 	mutex_unlock(&pdev_list_mutex);
 }



