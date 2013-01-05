Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab3AECfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 21:35:07 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35286 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab3AECfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 21:35:04 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Ming Lei <ming.lei@canonical.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Decotigny <david.decotigny@google.com>,
        Tom Herbert <therbert@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v7 4/6] net/core: apply pm_runtime_set_memalloc_noio on network devices
Date: Sat,  5 Jan 2013 10:25:42 +0800
Message-Id: <1357352744-8138-5-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357352744-8138-1-git-send-email-ming.lei@canonical.com>
References: <1357352744-8138-1-git-send-email-ming.lei@canonical.com>
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
--
v7:
	- rebase on v3.8-rc2-next-20130104

v4:
	- call pm_runtime_set_memalloc_noio(ddev, true) after
	device_add
---
 net/core/net-sysfs.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 29c884a..67e00b2 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -21,6 +21,7 @@
 #include <linux/vmalloc.h>
 #include <linux/export.h>
 #include <linux/jiffies.h>
+#include <linux/pm_runtime.h>
 
 #include "net-sysfs.h"
 
@@ -1409,6 +1410,8 @@ void netdev_unregister_kobject(struct net_device * net)
 
 	remove_queue_kobjects(net);
 
+	pm_runtime_set_memalloc_noio(dev, false);
+
 	device_del(dev);
 }
 
@@ -1453,6 +1456,8 @@ int netdev_register_kobject(struct net_device *net)
 		return error;
 	}
 
+	pm_runtime_set_memalloc_noio(dev, true);
+
 	return error;
 }
 
-- 
1.7.9.5

