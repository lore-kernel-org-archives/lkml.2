Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab1K3RXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 12:23:11 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:43190 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982Ab1K3RVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 12:21:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ke.yu@intel.com, kevin.tian@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad@kernel.org,
        stefan.bader@canonical.com, Ian.Campbell@citrix.com,
        mike.mcclurg@citrix.com, liang.tang@oracle.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 8/8] ACPI: xen processor: set ignore_ppc to handle PPC event for Xen vcpu.
Date: Wed, 30 Nov 2011 12:21:04 -0500
Message-Id: <1322673664-14642-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4ED66624.008E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Tian <kevin.tian@intel.com>

Xen acpi processor does not CPUFREQ_START, hence we we need to set
ignore_ppc to handle PPC events.

Signed-off-by: Yu Ke <ke.yu@intel.com>
Signed-off-by: Tian Kevin <kevin.tian@intel.com>
Signed-off-by: Tang Liang <liang.tang@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/acpi/processor_perflib.c |    2 +-
 drivers/acpi/processor_xen.c     |    2 ++
 include/acpi/processor.h         |    1 +
 3 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 22c6195..e622a0d 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -65,7 +65,7 @@ static DEFINE_MUTEX(performance_mutex);
  *  0 -> cpufreq low level drivers initialized -> consider _PPC values
  *  1 -> ignore _PPC totally -> forced by user through boot param
  */
-static int ignore_ppc = -1;
+int ignore_ppc = -1;
 module_param(ignore_ppc, int, 0644);
 MODULE_PARM_DESC(ignore_ppc, "If the frequency of your machine gets wrongly" \
 		 "limited by BIOS, this should help");
diff --git a/drivers/acpi/processor_xen.c b/drivers/acpi/processor_xen.c
index fc3cc0b..a87b222 100644
--- a/drivers/acpi/processor_xen.c
+++ b/drivers/acpi/processor_xen.c
@@ -217,12 +217,14 @@ int xen_acpi_processor_init(void)
 	if (result < 0)
 		return result;
 		/* mark ready for handling ppc */
+	ignore_ppc = 0;
 
 	return 0;
 }
 
 void xen_acpi_processor_exit(void)
 {
+	ignore_ppc = -1;
 
 	acpi_bus_unregister_driver(&xen_acpi_processor_driver);
 }
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index cf53ed8..1380bb7 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -290,6 +290,7 @@ extern void xen_processor_driver_register(void);
 /* in processor_perflib.c */
 
 #ifdef CONFIG_CPU_FREQ
+extern int ignore_ppc;
 void acpi_processor_ppc_init(void);
 void acpi_processor_ppc_exit(void);
 int acpi_processor_ppc_has_changed(struct acpi_processor *pr, int event_flag);
-- 
1.7.7.3

