Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab2KKMf4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:35:56 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:37302 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab2KKMfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:35:53 -0500
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, Ming Lei <ming.lei@canonical.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Decotigny <david.decotigny@google.com>,
        Tom Herbert <therbert@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v5 4/6] net/core: apply pm_runtime_set_memalloc_noio on network devices
Date: Sun, 11 Nov 2012 20:34:36 +0800
Message-Id: <1352637278-19968-5-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352637278-19968-1-git-send-email-ming.lei@canonical.com>
References: <1352637278-19968-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deadlock might be caused by allocating memory with GFP_KERNEL in
runtime_resume and runtime_suspend callback of network devices in
iSCSI situation, so mark network devices and its ancestor as
'memalloc_noio' with the introduced pm_runtime_set_memalloc_noio().

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Decotigny <david.decotigny@google.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
v4:
	 - call pm_runtime_set_memalloc_noio(ddev, true) after
	   device_add
---
 net/core/net-sysfs.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index bcf02f6..a55d255 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -22,6 +22,7 @@
 #include <linux/vmalloc.h>
 #include <linux/export.h>
 #include <linux/jiffies.h>
+#include <linux/pm_runtime.h>
 #include <net/wext.h>
 
 #include "net-sysfs.h"
@@ -1386,6 +1387,8 @@ void netdev_unregister_kobject(struct net_device * net)
 
 	remove_queue_kobjects(net);
 
+	pm_runtime_set_memalloc_noio(dev, false);
+
 	device_del(dev);
 }
 
@@ -1421,6 +1424,8 @@ int netdev_register_kobject(struct net_device *net)
 		return error;
 	}
 
+	pm_runtime_set_memalloc_noio(dev, true);
+
 	return error;
 }
 
-- 
1.7.9.5

