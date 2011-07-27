Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab1G0VyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:54:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:13692 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755724Ab1G0VtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32274808"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: mkubecek@suse.cz, rjw@sisk.pl, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [71/99] PM: Free memory bitmaps if opening /dev/snapshot fails
Message-Id: <20110727214910.91BE82403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Michal Kubecek <mkubecek@suse.cz>

commit 8440f4b19494467883f8541b7aa28c7bbf6ac92b upstream.

When opening /dev/snapshot device, snapshot_open() creates memory
bitmaps which are freed in snapshot_release(). But if any of the
callbacks called by pm_notifier_call_chain() returns NOTIFY_BAD, open()
fails, snapshot_release() is never called and bitmaps are not freed.
Next attempt to open /dev/snapshot then triggers BUG_ON() check in
create_basic_memory_bitmaps(). This happens e.g. when vmwatchdog module
is active on s390x.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/power/user.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/kernel/power/user.c
===================================================================
--- linux-2.6.35.y.orig/kernel/power/user.c
+++ linux-2.6.35.y/kernel/power/user.c
@@ -113,8 +113,10 @@ static int snapshot_open(struct inode *i
 		if (error)
 			pm_notifier_call_chain(PM_POST_RESTORE);
 	}
-	if (error)
+	if (error) {
+		free_basic_memory_bitmaps();
 		atomic_inc(&snapshot_device_available);
+	}
 	data->frozen = 0;
 	data->ready = 0;
 	data->platform_support = 0;
