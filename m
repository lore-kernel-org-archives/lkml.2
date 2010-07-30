Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab0G3Re4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:34:56 -0400
Received: from kroah.org ([198.145.64.141]:35515 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758816Ab0G3ReE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:04 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:04 2010
Message-Id: <20100730173104.315234043@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:29:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>, Huaxu Wan <huaxu.wan@intel.com>
Subject: [017/140] hwmon: (coretemp) Skip duplicate CPU entries
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit d883b9f0977269d519469da72faec6a7f72cb489 upstream.

On hyper-threaded CPUs, each core appears twice in the CPU list. Skip
the second entry to avoid duplicate sensors.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Huaxu Wan <huaxu.wan@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/coretemp.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -356,6 +356,10 @@ struct pdev_entry {
 	struct list_head list;
 	struct platform_device *pdev;
 	unsigned int cpu;
+#ifdef CONFIG_SMP
+	u16 phys_proc_id;
+	u16 cpu_core_id;
+#endif
 };
 
 static LIST_HEAD(pdev_list);
@@ -366,6 +370,22 @@ static int __cpuinit coretemp_device_add
 	int err;
 	struct platform_device *pdev;
 	struct pdev_entry *pdev_entry;
+#ifdef CONFIG_SMP
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+#endif
+
+	mutex_lock(&pdev_list_mutex);
+
+#ifdef CONFIG_SMP
+	/* Skip second HT entry of each core */
+	list_for_each_entry(pdev_entry, &pdev_list, list) {
+		if (c->phys_proc_id == pdev_entry->phys_proc_id &&
+		    c->cpu_core_id == pdev_entry->cpu_core_id) {
+			err = 0;	/* Not an error */
+			goto exit;
+		}
+	}
+#endif
 
 	pdev = platform_device_alloc(DRVNAME, cpu);
 	if (!pdev) {
@@ -389,7 +409,10 @@ static int __cpuinit coretemp_device_add
 
 	pdev_entry->pdev = pdev;
 	pdev_entry->cpu = cpu;
-	mutex_lock(&pdev_list_mutex);
+#ifdef CONFIG_SMP
+	pdev_entry->phys_proc_id = c->phys_proc_id;
+	pdev_entry->cpu_core_id = c->cpu_core_id;
+#endif
 	list_add_tail(&pdev_entry->list, &pdev_list);
 	mutex_unlock(&pdev_list_mutex);
 
@@ -400,6 +423,7 @@ exit_device_free:
 exit_device_put:
 	platform_device_put(pdev);
 exit:
+	mutex_unlock(&pdev_list_mutex);
 	return err;
 }
 


