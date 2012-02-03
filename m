Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab2BCAPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 19:15:01 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32785 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab2BCAPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 19:15:00 -0500
From: Venkatesh Pallipadi <venki@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        markgross <markgross@thegnar.org>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] CPU C-state breakage with PM Qos change
Date: Thu,  2 Feb 2012 16:14:39 -0800
Message-Id: <1328228079-20716-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328227065-22045-1-git-send-email-venki@google.com>
References: <1328227065-22045-1-git-send-email-venki@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like change "PM QoS: Move and rename the implementation files"
made pm_qos depend on CONFIG_PM which depends on
PM_SLEEP || PM_RUNTIME

That breaks CPU C-states with kernels not having these CONFIGs, causing CPUs
to spend time in Polling loop idle instead of going into deep C-states,
consuming way way more power. This is with either acpi idle or intel idle
enabled.

Either CONFIG_PM should be enabled with any pm_qos users or
the !CONFIG_PM pm_qos_request() should return sane defaults not to break
the existing users. Here's is the patch for the latter option.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 include/linux/pm_qos.h |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
index 83b0ea3..8a0ede4 100644
--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -107,7 +107,19 @@ static inline void pm_qos_remove_request(struct pm_qos_request *req)
 			{ return; }
 
 static inline int pm_qos_request(int pm_qos_class)
-			{ return 0; }
+{
+	switch (pm_qos_class) {
+	case PM_QOS_CPU_DMA_LATENCY:
+		return PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE;
+	case PM_QOS_NETWORK_LATENCY:
+		return PM_QOS_NETWORK_LAT_DEFAULT_VALUE;
+	case PM_QOS_NETWORK_THROUGHPUT:
+		return PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE;
+	default:
+		return PM_QOS_DEFAULT_VALUE;
+	}
+}
+
 static inline int pm_qos_add_notifier(int pm_qos_class,
 				      struct notifier_block *notifier)
 			{ return 0; }
-- 
1.7.7.3

