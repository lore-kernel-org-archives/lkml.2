Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab2LPLXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 06:23:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:46370 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab2LPLXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 06:23:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,294,1355126400"; 
   d="scan'208";a="232205103"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org, hdegoede@redhat.com, wim@iguana.be
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Jerry Snitselaar <jerry.snitselaar@oracle.com>
Subject: [char-misc for 3.8] mei: avoid oops in watchdog unregister code path
Date: Sun, 16 Dec 2012 13:23:17 +0200
Message-Id: <1355656997-30659-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With commit c7d3df3 "mei: use internal watchdog device registration
tracking" will crash the kernel on shutdown path on systems
where ME watchdog is not present.
Since the watchdog was never initialized in such case
the WDOG_UNREGISTERED bit is never set and the system
crashes on access to uninitialized variables down the path.

To solve the issue we query for NULL on watchdog driver driver_data
to check whether the device is registered. This is handled in the
driver and doesn't depend on watchdog core internals.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/wd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 636409f..9299a8c 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -370,7 +370,7 @@ void mei_watchdog_register(struct mei_device *dev)
 
 void mei_watchdog_unregister(struct mei_device *dev)
 {
-	if (test_bit(WDOG_UNREGISTERED, &amt_wd_dev.status))
+	if (watchdog_get_drvdata(&amt_wd_dev) == NULL)
 		return;
 
 	watchdog_set_drvdata(&amt_wd_dev, NULL);
-- 
1.7.4.4

