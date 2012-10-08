Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab2JHIKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 04:10:06 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36137 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab2JHIJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 04:09:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Huang Ying <ying.huang@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Jean Pihet <j-pihet@ti.com>, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] PM / Domains: Check device PM QoS flags in pm_genpd_poweroff()
Date: Mon, 08 Oct 2012 10:08:39 +0200
Message-ID: <3595636.rclQsqiayj@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.0-2.10-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1413438.1MkXj8vjQK@vostro.rjw.lan>
References: <201209282351.10663.rjw@sisk.pl> <1413438.1MkXj8vjQK@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make the generic PM domains pm_genpd_poweroff() function take
device PM QoS flags into account when deciding whether or not to
remove power from the domain.

After this change the routine will return -EBUSY without executing
the domain's .power_off() callback if there is at least one PM QoS
flags request for at least one device in the domain and at least of
those request has at least one of the NO_POWER_OFF and REMOTE_WAKEUP
flags set.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Jean Pihet <j-pihet@ti.com>
---
 drivers/base/power/domain.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -470,10 +470,19 @@ static int pm_genpd_poweroff(struct gene
 		return -EBUSY;
 
 	not_suspended = 0;
-	list_for_each_entry(pdd, &genpd->dev_list, list_node)
+	list_for_each_entry(pdd, &genpd->dev_list, list_node) {
+		enum pm_qos_flags_status stat;
+
+		stat = dev_pm_qos_flags(pdd->dev,
+					PM_QOS_FLAG_NO_POWER_OFF
+						| PM_QOS_FLAG_REMOTE_WAKEUP);
+		if (stat > PM_QOS_FLAGS_NONE)
+			return -EBUSY;
+
 		if (pdd->dev->driver && (!pm_runtime_suspended(pdd->dev)
 		    || pdd->dev->power.irq_safe))
 			not_suspended++;
+	}
 
 	if (not_suspended > genpd->in_progress)
 		return -EBUSY;

