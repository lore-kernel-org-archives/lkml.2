Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab2KJAtB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 19:49:01 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41577 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab2KJAs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 19:48:57 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6891"; a="5753877"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [RFC] dt/platform: Use cell-index for device naming if available
Date: Fri,  9 Nov 2012 16:48:52 -0800
Message-Id: <1352508532-19241-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the cell-index property to construct names for platform
devices, falling back on the existing scheme of using the
device register address if cell-index is not specified.

The cell-index property is a more useful device identifier,
especially in systems containing several numbered instances
of a particular hardware block, since it more easily
illustrates how devices relate to each other.

Additionally, userspace software may rely on the classic
<name>.<id> naming scheme to access device attributes in
sysfs, without having to know the physical addresses of
that device on every platform the userspace software may
support. Using cell-index for device naming allows the
device addresses to be hidden from userspace and to be
exposed by logical device number without having to rely on
auxdata to perform name overrides. This allows userspace to
make assumptions about which sysfs nodes map to which
logical instance of a specific hardware block.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
I had also considered using something like the linux,label property to allow
custom names for platform devices without resorting to auxdata, but the
cell-index approach seems more in line with what cell-index was intended for
and with what the pre-DT platform device naming scheme used to be. Please let
me know if you think there is a better way to accomplish this.

This is just being sent out as an RFC for now. If there are no objections, I
will send this out as an official patch, along with (or combined with) a patch
to fix up the device names in things like clock tables of any affected
platforms.

 drivers/of/platform.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 343ad29..472e374 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -77,8 +77,9 @@ void of_device_make_bus_id(struct device *dev)
 	static atomic_t bus_no_reg_magic;
 	struct device_node *node = dev->of_node;
 	const u32 *reg;
+	u32 cell_index;
 	u64 addr;
-	int magic;
+	int magic, ret;

 #ifdef CONFIG_PPC_DCR
 	/*
@@ -101,6 +102,16 @@ void of_device_make_bus_id(struct device *dev)
 #endif /* CONFIG_PPC_DCR */

 	/*
+	 * For devices with a specified cell-index, use the traditional
+	 * naming scheme of <name>.<id>
+	 */
+	ret = of_property_read_u32(node, "cell-index", &cell_index);
+	if (ret == 0) {
+		dev_set_name(dev, "%s.%d", node->name, cell_index);
+		return;
+	}
+
+	/*
 	 * For MMIO, get the physical address
 	 */
 	reg = of_get_property(node, "reg", NULL);
--
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

