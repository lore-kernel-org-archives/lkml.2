Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab0DTSlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 14:41:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120Ab0DTSlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 14:41:35 -0400
From: Matthew Garrett <mjg@redhat.com>
To: minyard@acm.org
Cc: openipmi-developer@lists.sourceforge.net, bjorn.helgaas@hp.com,
       linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/3] ipmi: Only register one si per bmc
Date: Tue, 20 Apr 2010 14:40:27 -0400
Message-Id: <1271788828-10231-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1271788828-10231-1-git-send-email-mjg@redhat.com>
References: <1271788828-10231-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only register one si per bmc. Use any user-provided devices first, followed
by the first device with an irq, followed by the first device discovered.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/char/ipmi/ipmi_si_intf.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index d2bdf92..95af023 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -3258,6 +3258,7 @@ static __devinit int init_ipmi_si(void)
 	int  i;
 	char *str;
 	int  rv;
+	struct smi_info *e;
 
 	if (initialized)
 		return 0;
@@ -3292,6 +3293,14 @@ static __devinit int init_ipmi_si(void)
 
 	hardcode_find_bmc();
 
+	/* If the user gave us a device, they presumably want us to use it */
+	mutex_lock(&smi_infos_lock);
+	if (!list_empty(&smi_infos)) {
+		mutex_unlock(&smi_infos_lock);
+		return 0;
+	}
+	mutex_unlock(&smi_infos_lock);
+
 #ifdef CONFIG_DMI
 	dmi_find_bmc();
 #endif
@@ -3315,6 +3324,30 @@ static __devinit int init_ipmi_si(void)
 	of_register_platform_driver(&ipmi_of_platform_driver);
 #endif
 
+	/* Try to register something with interrupts first */
+
+	mutex_lock(&smi_infos_lock);
+	list_for_each_entry(e, &smi_infos, link) {
+		if (e->irq) {
+			if (!try_smi_init(e)) {
+				mutex_unlock(&smi_infos_lock);
+				return 0;
+			}
+		}
+	}
+
+	/* Fall back to the preferred device */
+
+	list_for_each_entry(e, &smi_infos, link) {
+		if (!e->irq) {
+			if (!try_smi_init(e)) {
+				mutex_unlock(&smi_infos_lock);
+				return 0;
+			}
+		}
+	}
+	mutex_unlock(&smi_infos_lock);
+
 	if (si_trydefaults) {
 		mutex_lock(&smi_infos_lock);
 		if (list_empty(&smi_infos)) {
-- 
1.6.5.2

