Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab2JOLgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:36:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:6779 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab2JOLgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:36:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,587,1344236400"; 
   d="scan'208";a="156285297"
From: dragos.tatulea@intel.com
To: cbouatmailru@gmail.com, linux-kernel@vger.kernel.org
Cc: adrian.hunter@intel.com, octavian.purdila@intel.com,
        Dragos Tatulea <dragos.tatulea@intel.com>
Subject: [PATCH 5/8] pstore: add task list dumper
Date: Mon, 15 Oct 2012 14:38:54 +0300
Message-Id: <1350301137-16912-6-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350301137-16912-1-git-send-email-dragos.tatulea@intel.com>
References: <1350301137-16912-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dragos Tatulea <dragos.tatulea@intel.com>

The task dumper can dump task information during a panic.
This is equivalent to a magic sysrq 't' command but
the result is captured from the console and written
to persistent storage.  Note that this happens after
pstore dumps kernel messages because the task dump will
overwrite other kernel messages.

There is a single module parameter "enabled" which must
be used to enable task dumping.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Dragos Tatulea <dragos.tatulea@intel.com>
--
 fs/pstore/Kconfig      |   12 ++++++
 fs/pstore/Makefile     |    1 +
 fs/pstore/dump_tasks.c |  107 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/pstore/inode.c      |    3 ++
 include/linux/pstore.h |    1 +
 5 files changed, 124 insertions(+)
 create mode 100644 fs/pstore/dump_tasks.c

diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
index ca71db6..ee967c5 100644
-- a/fs/pstore/Kconfig
++ b/fs/pstore/Kconfig
@@ -48,3 +48,15 @@ config PSTORE_RAM
 	  "ramoops.ko".
 
 	  For more information, see Documentation/ramoops.txt.

config PSTORE_DUMP_TASKS
	bool "Dump task information"
	default n
	depends on PSTORE
	help
	  This option allows a dump of task information during a
	  panic.  This is equivalent to a magic sysrq 't' command
	  but the result is captured from the console and written
	  to persistent storage.  Note that this happens after
	  pstore dumps kernel messages because the task dump will
	  overwrite other kernel messages.
diff --git a/fs/pstore/Makefile b/fs/pstore/Makefile
index 4c9095c..14b5c83 100644
-- a/fs/pstore/Makefile
++ b/fs/pstore/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_PSTORE_FTRACE)	+= ftrace.o
 
 ramoops-objs += ram.o ram_core.o
 obj-$(CONFIG_PSTORE_RAM)	+= ramoops.o
obj-$(CONFIG_PSTORE_DUMP_TASKS)	+= dump_tasks.o
diff --git a/fs/pstore/dump_tasks.c b/fs/pstore/dump_tasks.c
new file mode 100644
index 0000000..b010b35
-- /dev/null
++ b/fs/pstore/dump_tasks.c
@@ -0,0 +1,107 @@
/*
 * Persistent Storage task dumper
 *
 * Copyright (C) 2012 Intel Corporation
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License version 2 as
 *  published by the Free Software Foundation.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <linux/module.h>
#include <linux/console.h>
#include <linux/sched.h>
#include <linux/hardirq.h>
#include <linux/delay.h>
#include <linux/pstore.h>

static int enabled;

static void pstore_dump_tasks(struct console *console, const char *s,
			      unsigned int count)
{
	pstore_write(PSTORE_TYPE_TASK_DUMP, s, count);
}

static struct console pstore_dump_tasks_console = {
	.name	= "dump_tasks",
	.write	= pstore_dump_tasks,
	.flags	= CON_ANYTIME | CON_ENABLED,
	.index	= -1,
};

static int pstore_notifier_cb(struct notifier_block *nb, unsigned long event,
			      void *_psinfo)
{
	struct pstore_info *psinfo = _psinfo;
	int retry;

	if (psinfo->ext_reason != KMSG_DUMP_PANIC || !enabled)
		return NOTIFY_DONE;

	switch (event) {
	case PSTORE_DUMP:
		pstore_dump_tasks_console.flags |= CON_ENABLED;
		show_state();

		/* Make sure data gets pushed to console drivers.
		 * Yes, can take a long time to write everything,
		 * shortening the length increases the chances of
		 * ending up with an incomplete log.
		 */
		retry = 100;
		while (retry) {
			if (console_trylock()) {
				console_unlock();
				break;
			} else {
				mdelay(100);
				retry--;
			}
		}

		break;
	case PSTORE_END:
		pstore_dump_tasks_console.flags &= ~CON_ENABLED;
	}

	return NOTIFY_DONE;
}

static struct notifier_block pstore_notifier = {
	.notifier_call = pstore_notifier_cb,
	/* Leave other dumpers do their job. This one can take longer. */
	.priority = -1,
};

static int __init pstore_dump_tasks_init(void)
{
	register_console(&pstore_dump_tasks_console);
	console_stop(&pstore_dump_tasks_console);
	pstore_notifier_register(&pstore_notifier);
	return 0;
}
module_init(pstore_dump_tasks_init);

static void __exit pstore_dump_tasks_exit(void)
{
	pstore_notifier_unregister(&pstore_notifier);
	unregister_console(&pstore_dump_tasks_console);
}
module_exit(pstore_dump_tasks_exit);

module_param(enabled, int,  S_IRUSR | S_IWUSR);
MODULE_PARM_DESC(enabled, "set to 1 to enable task dump, 0 to disable (default 0)");

MODULE_LICENSE("GPL v2");
MODULE_AUTHOR("Adrian Hunter");
MODULE_DESCRIPTION("Persistent Storage task dumper");
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 4ab572e..4800c09 100644
-- a/fs/pstore/inode.c
++ b/fs/pstore/inode.c
@@ -321,6 +321,9 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id,
 	case PSTORE_TYPE_MCE:
 		sprintf(name, "mce-%s-%lld", psname, id);
 		break;
	case PSTORE_TYPE_TASK_DUMP:
		sprintf(name, "tasks-%s-%lld", psname, id);
		break;
 	case PSTORE_TYPE_UNKNOWN:
 		sprintf(name, "unknown-%s-%lld", psname, id);
 		break;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 1bf7f4b..48dcafb 100644
-- a/include/linux/pstore.h
++ b/include/linux/pstore.h
@@ -35,6 +35,7 @@ enum pstore_type_id {
 	PSTORE_TYPE_MCE		= 1,
 	PSTORE_TYPE_CONSOLE	= 2,
 	PSTORE_TYPE_FTRACE	= 3,
	PSTORE_TYPE_TASK_DUMP	= 4,
 	PSTORE_TYPE_UNKNOWN	= 255
 };
 
- 
1.7.9.5

