Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034Ab0GVWKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:10:11 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2527 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab0GVWJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:09:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6051"; a="48209973"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 4/6] Driver core: Fix memory leak on sysdev_class_register error path
Date: Thu, 22 Jul 2010 15:09:04 -0700
Message-Id: <1279836546-26913-5-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
References: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This leak is the same as the bus path; cls->kset.kobj.name is
set, but kset_register fails, thus nothing will ever call
kset_unregister and name will be leaked

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 drivers/base/sys.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 9354dc1..e5deab1 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -22,6 +22,7 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/interrupt.h>
+#include <linux/slab.h>
 
 #include "base.h"
 
@@ -148,6 +149,8 @@ int sysdev_class_register(struct sysdev_class *cls)
 	if (!retval && cls->attrs)
 		retval = sysfs_create_files(&cls->kset.kobj,
 					    (const struct attribute **)cls->attrs);
+	else
+		kfree(cls->kset.kobj.name);
 	return retval;
 }
 
-- 
1.7.2

