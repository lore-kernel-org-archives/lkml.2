Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2JOLgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:36:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:6779 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab2JOLgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:36:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,587,1344236400"; 
   d="scan'208";a="156285270"
From: dragos.tatulea@intel.com
To: cbouatmailru@gmail.com, linux-kernel@vger.kernel.org
Cc: adrian.hunter@intel.com, octavian.purdila@intel.com
Subject: [PATCH 2/8] pstore: add debugfs support for causing dumps and panics
Date: Mon, 15 Oct 2012 14:38:51 +0300
Message-Id: <1350301137-16912-3-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350301137-16912-1-git-send-email-dragos.tatulea@intel.com>
References: <1350301137-16912-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

There are 2 debugfs files:

	pstore/dump	writing a kmsg dump reason code
			will cause a dump to persistent
			storage

	pstore/panic	writing anything will cause
			a panic

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
--
 fs/pstore/platform.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index c4ea778..9d65723 100644
-- a/fs/pstore/platform.c
++ b/fs/pstore/platform.c
@@ -33,6 +33,7 @@
 #include <linux/hardirq.h>
 #include <linux/jiffies.h>
 #include <linux/workqueue.h>
#include <linux/debugfs.h>
 
 #include "internal.h"
 
@@ -206,6 +207,54 @@ static int pstore_write_compat(enum pstore_type_id type,
 	return psi->write_buf(type, reason, id, part, psinfo->buf, size, psi);
 }
 
#ifdef CONFIG_DEBUG_FS

static DEFINE_SPINLOCK(dbg_lock);

static int dbg_dump(void *data, u64 val)
{
	unsigned long flags;

	switch (val) {
	case KMSG_DUMP_PANIC:
	case KMSG_DUMP_OOPS:
	case KMSG_DUMP_EMERG:
	case KMSG_DUMP_RESTART:
	case KMSG_DUMP_HALT:
	case KMSG_DUMP_POWEROFF:
		spin_lock_irqsave(&dbg_lock, flags);
		kmsg_dump(val);
		spin_unlock_irqrestore(&dbg_lock, flags);
		return 0;
	}
	return -EINVAL;
}
DEFINE_SIMPLE_ATTRIBUTE(dbg_dump_fops, NULL, dbg_dump, "%llu\n");

static int dbg_panic(void *data, u64 val)
{
	panic(KERN_EMERG "pstore debugging panic!\n");
	return 0;
}
DEFINE_SIMPLE_ATTRIBUTE(dbg_panic_fops, NULL, dbg_panic, "%llu\n");

static void pstore_debugfs_init(void)
{
	struct dentry *root;

	root = debugfs_create_dir("pstore", NULL);
	debugfs_create_file("dump", S_IWUSR, root, NULL, &dbg_dump_fops);
	debugfs_create_file("panic", S_IWUSR, root, NULL, &dbg_panic_fops);
}

#else

static inline void pstore_debugfs_init(void)
{
}

#endif

 /*
  * platform specific persistent storage driver registers with
  * us here. If pstore is already mounted, call the platform
@@ -257,6 +306,8 @@ int pstore_register(struct pstore_info *psi)
 		add_timer(&pstore_timer);
 	}
 
	pstore_debugfs_init();

 	return 0;
 }
 EXPORT_SYMBOL_GPL(pstore_register);
- 
1.7.9.5

