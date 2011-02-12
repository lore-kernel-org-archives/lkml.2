Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab1BLTlH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 14:41:07 -0500
Received: from smtp-out-246.synserver.de ([212.40.185.246]:1103 "HELO
	smtp-out-246.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752690Ab1BLTjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 14:39:42 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24377
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 14/14] Ignore -ENODATA errors when generating a uevent
Date: Sat, 12 Feb 2011 20:39:14 +0100
Message-Id: <1297539554-13957-16-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297539554-13957-1-git-send-email-lars@metafoo.de>
References: <1297539554-13957-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes a driver can not report a meaningful value for a certain property
and returns -ENODATA.

Currently when generating a uevent and a property return -ENODATA it is
treated as an error an no uevent is generated at all. This is not an
desirable behavior.

This patch adds a special case for -ENODATA and ignores properties which
return this error code when generating the uevent.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/power_supply_sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index cd1f907..605514a 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -270,7 +270,7 @@ int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 		attr = &power_supply_attrs[psy->properties[j]];
 
 		ret = power_supply_show_property(dev, attr, prop_buf);
-		if (ret == -ENODEV) {
+		if (ret == -ENODEV || ret == -ENODATA) {
 			/* When a battery is absent, we expect -ENODEV. Don't abort;
 			   send the uevent with at least the the PRESENT=0 property */
 			ret = 0;
-- 
1.7.2.3

