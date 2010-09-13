Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab0IMKXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:23:10 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:50425 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0IMKXJ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Mon, 13 Sep 2010 06:23:09 -0400
Message-Id: <4C8E17A90200007800015AE6@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 13 Sep 2010 11:23:05 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <fenghua.yu@intel.com>, <khali@linux-fr.org>
Cc: <r.marek@assembler.cz>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/hwmon: register alternate sibling upon CPU removal
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like pkgtemp registers another core of the same package when one
gets removed, coretemp should register another hyperthread (if
available) in that situation.

As pointed out in the patch fixing the respective code in pkgtemp, the
list protectng mutex must be dropped before calling
coretemp_device_add(), and due to the restructured loop (including an
explicit return) the "safe" variant of the list iterator isn't needed
anymore.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Rudolf Marek <r.marek@assembler.cz>

---
 drivers/hwmon/coretemp.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- linux-2.6.36-rc4/drivers/hwmon/coretemp.c	2010-09-13 08:45:02.000000000 +0200
+++ 2.6.36-rc4-x86-coretemp-remove-deadlock/drivers/hwmon/coretemp.c	2010-09-03 17:54:14.000000000 +0200
@@ -482,14 +482,22 @@ exit:
 
 static void coretemp_device_remove(unsigned int cpu)
 {
-	struct pdev_entry *p, *n;
+	struct pdev_entry *p;
+	unsigned int i;
+
 	mutex_lock(&pdev_list_mutex);
-	list_for_each_entry_safe(p, n, &pdev_list, list) {
-		if (p->cpu == cpu) {
-			platform_device_unregister(p->pdev);
-			list_del(&p->list);
-			kfree(p);
-		}
+	list_for_each_entry(p, &pdev_list, list) {
+		if (p->cpu != cpu)
+			continue;
+
+		platform_device_unregister(p->pdev);
+		list_del(&p->list);
+		mutex_unlock(&pdev_list_mutex);
+		kfree(p);
+		for_each_cpu(i, cpu_sibling_mask(cpu))
+			if (i != cpu && !coretemp_device_add(i))
+				break;
+		return;
 	}
 	mutex_unlock(&pdev_list_mutex);
 }



