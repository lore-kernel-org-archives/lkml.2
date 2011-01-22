Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab1AVUAX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 15:00:23 -0500
Received: from smtp-out11.han.skanova.net ([195.67.226.200]:60850 "EHLO
	smtp-out11.han.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820Ab1AVUAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 15:00:22 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 22 Jan 2011 21:00:02 +0100
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.38-rc1/-2: applesmc lockdep warning
Message-ID: <20110122200002.GA1677@polaris.bitmath.org>
References: <20110122134513.1e1d512a@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110122134513.1e1d512a@stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BUG: key f4891a1c not in .data!
[...]
> Any ideas where this may come from?

The patch below seems to fix the problem, but a verification would be most
welcome. Gunther, do you want to take it, or should it route it through
my tree?

Thanks,
Henrik

>From 8a7a0641dfe08d3450695552e628a1c2f81b4050 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Sat, 22 Jan 2011 20:55:39 +0100
Subject: [PATCH] hwmon: (applesmc) Properly initialize lockdep attributes

The switch to dynamically allocated sysfs attributes left the
internal lockdep members uninitialized, causing a formal bug.
This patch adds sysfs_attr_init() to the node creation function,
remedying the problem.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index ce0372f..4c07436 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -1072,6 +1072,7 @@ static int applesmc_create_nodes(struct applesmc_node_group *groups, int num)
 			node->sda.dev_attr.show = grp->show;
 			node->sda.dev_attr.store = grp->store;
 			attr = &node->sda.dev_attr.attr;
+			sysfs_attr_init(attr);
 			attr->name = node->name;
 			attr->mode = S_IRUGO | (grp->store ? S_IWUSR : 0);
 			ret = sysfs_create_file(&pdev->dev.kobj, attr);
-- 
1.7.2.3

