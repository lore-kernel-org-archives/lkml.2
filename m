Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249Ab0GVLNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:13:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:12712 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758097Ab0GVLNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:13:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,242,1278313200"; 
   d="scan'208";a="640711709"
Subject: [RFC][PATCH v1 06/15] perf: export tracepoint events via sysfs:
 iwlwifi and iwlwifi_io
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Reinette Chatre <reinette.chatre@intel.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
        Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 19:13:50 +0800
Message-ID: <1279797230.20942.87.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iwlwifi and iwlwifi_io tracepoint events are exported like below,

/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/net/wlan0/events/
|-- iwlwifi_dev_hcmd
|   |-- config
|   |-- type
|-- iwlwifi_dev_rx
|   |-- config
|   |-- type
....
....
|-- iwlwifi_dev_ioread32
|   |-- config
|   |-- type
|-- iwlwifi_dev_iowrite32
|   |-- config
|   |-- type
|-- iwlwifi_dev_iowrite8
|   |-- config
|   |-- type
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a27872d..cbcc2bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -41,6 +41,7 @@
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
+#include <linux/perf_event.h>
 
 #include <net/ieee80211_radiotap.h>
 #include <net/mac80211.h>
@@ -3989,6 +3990,18 @@ static int iwl3945_setup_mac(struct iwl_priv *priv)
 	return 0;
 }
 
+static void iwl_sys_add_tp(struct kobject *kobj)
+{
+	struct kobject *events_kobj;
+
+	events_kobj = perf_sys_create_events_dir(kobj);
+	if (!events_kobj)
+		return;
+
+	perf_sys_add_tp_events(events_kobj, "iwlwifi");
+	perf_sys_add_tp_events(events_kobj, "iwlwifi_io");
+}
+
 static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int err = 0;
@@ -4148,6 +4161,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		goto out_release_irq;
 	}
 
+	iwl_sys_add_tp(&pdev->dev.kobj);
+
 	iwl_set_rxon_channel(priv,
 			     &priv->bands[IEEE80211_BAND_2GHZ].channels[5]);
 	iwl3945_setup_deferred_work(priv);



