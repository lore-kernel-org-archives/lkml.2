Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab2BJWnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:43:04 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681Ab2BJWm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:58 -0500
MIME-Version: 1.0
Message-Id: <20120210222947.720668767@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Venkatesh Pallipadi <venki@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 30/86] PM / QoS: CPU C-state breakage with PM Qos change
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkatesh Pallipadi <venki@google.com>

commit d020283dc694c9ec31b410f522252f7a8397e67d upstream.

Looks like change "PM QoS: Move and rename the implementation files"
merged during the 3.2 development cycle made PM QoS depend on
CONFIG_PM which depends on (PM_SLEEP || PM_RUNTIME).

That breaks CPU C-states with kernels not having these CONFIGs, causing CPUs
to spend time in Polling loop idle instead of going into deep C-states,
consuming way way more power. This is with either acpi idle or intel idle
enabled.

Either CONFIG_PM should be enabled with any pm_qos users or
the !CONFIG_PM pm_qos_request() should return sane defaults not to break
the existing users. Here's is the patch for the latter option.

[rjw: Modified the changelog slightly.]

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/pm_qos.h |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -107,7 +107,19 @@ static inline void pm_qos_remove_request
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


