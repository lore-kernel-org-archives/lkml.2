Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab2JOLlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:41:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:6779 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab2JOLgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:36:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,587,1344236400"; 
   d="scan'208";a="156285279"
From: dragos.tatulea@intel.com
To: cbouatmailru@gmail.com, linux-kernel@vger.kernel.org
Cc: adrian.hunter@intel.com, octavian.purdila@intel.com
Subject: [PATCH 3/8] pstore: add support for external writers
Date: Mon, 15 Oct 2012 14:38:52 +0300
Message-Id: <1350301137-16912-4-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350301137-16912-1-git-send-email-dragos.tatulea@intel.com>
References: <1350301137-16912-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Other modules that may wish to write to persistent storage
are supported by adding a notifier and write function.

The notifier has 3 events: PSTORE_BEGIN, PSTORE_DUMP and
PSTORE_END.  External writers use the PSTORE_DUMP event
whereas the PSTORE_BEGIN and PSTORE_END can be used by
platform code to ensure the back end is powered up.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
--
 fs/pstore/platform.c   |   88 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pstore.h |   43 +++++++++++++++++++----
 2 files changed, 124 insertions(+), 7 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 9d65723..63ff377 100644
-- a/fs/pstore/platform.c
++ b/fs/pstore/platform.c
@@ -34,6 +34,7 @@
 #include <linux/jiffies.h>
 #include <linux/workqueue.h>
 #include <linux/debugfs.h>
#include <linux/notifier.h>
 
 #include "internal.h"
 
@@ -74,6 +75,20 @@ void pstore_set_kmsg_bytes(int bytes)
 	kmsg_bytes = bytes;
 }
 
static ATOMIC_NOTIFIER_HEAD(pstore_notifiers);

int pstore_notifier_register(struct notifier_block *n)
{
	return atomic_notifier_chain_register(&pstore_notifiers, n);
}
EXPORT_SYMBOL_GPL(pstore_notifier_register);

int pstore_notifier_unregister(struct notifier_block *n)
{
	return atomic_notifier_chain_unregister(&pstore_notifiers, n);
}
EXPORT_SYMBOL_GPL(pstore_notifier_unregister);

 /* Tag each group of saved records with a sequence number */
 static int	oopscount;
 
@@ -97,6 +112,26 @@ static const char *get_reason_str(enum kmsg_dump_reason reason)
 	}
 }
 
static int pstore_ext_flush(void)
{
	int ret;

	if (!psinfo->ext_len)
		return 0;

	ret = psinfo->write(psinfo->ext_type, psinfo->ext_reason,
			    &psinfo->ext_id, psinfo->ext_part++,
			    psinfo->ext_len, psinfo);

	if (ret == 0 && psinfo->ext_reason == KMSG_DUMP_OOPS &&
	    pstore_is_mounted())
		pstore_new_entry = 1;

	psinfo->ext_len = 0;

	return ret;
}

 /*
  * callback from kmsg_dump. (s2,l2) has the most recently
  * written bytes, older bytes are in (s1,l1). Save as much
@@ -122,6 +157,15 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	} else
 		spin_lock_irqsave(&psinfo->buf_lock, flags);
 	oopscount++;

	psinfo->ext_id = 0;
	psinfo->ext_len = 0;
	psinfo->ext_part = 0;
	psinfo->ext_type = PSTORE_TYPE_UNKNOWN;
	psinfo->ext_reason = reason;

	atomic_notifier_call_chain(&pstore_notifiers, PSTORE_BEGIN, psinfo);

 	while (total < kmsg_bytes) {
 		char *dst;
 		unsigned long size;
@@ -148,6 +192,13 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		total += hsize + len;
 		part++;
 	}

	atomic_notifier_call_chain(&pstore_notifiers, PSTORE_DUMP, psinfo);

	pstore_ext_flush();

	atomic_notifier_call_chain(&pstore_notifiers, PSTORE_END, psinfo);

 	if (in_nmi()) {
 		if (is_locked)
 			spin_unlock(&psinfo->buf_lock);
@@ -368,5 +419,42 @@ static void pstore_timefunc(unsigned long dummy)
 	mod_timer(&pstore_timer, jiffies + msecs_to_jiffies(pstore_update_ms));
 }
 
/* pstore_write must only be called from PSTORE_DUMP notifier callbacks */
int pstore_write(enum pstore_type_id type, const char *buf, size_t size)
{
	size_t len;
	int err = 0, err2;

	if (!psinfo)
		return -ENODEV;

	/*
	 * No locking is needed because pstore_write is called only from
	 * PSTORE_DUMP notifier callbacks.
	 */

	if (type != psinfo->ext_type) {
		err = pstore_ext_flush();
		psinfo->ext_type = type;
		psinfo->ext_part = 1;
	}

	while (size) {
		len = min(size, psinfo->bufsize - psinfo->ext_len);
		memcpy(psinfo->buf + psinfo->ext_len, buf, len);
		psinfo->ext_len += len;
		buf += len;
		size -= len;
		if (psinfo->ext_len == psinfo->bufsize) {
			err2 = pstore_ext_flush();
			if (err2 && !err)
				err = err2;
		}
	}

	return err;
}
EXPORT_SYMBOL_GPL(pstore_write);

 module_param(backend, charp, 0444);
 MODULE_PARM_DESC(backend, "Pstore backend to use");
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 55ab23f..1bf7f4b 100644
-- a/include/linux/pstore.h
++ b/include/linux/pstore.h
@@ -40,17 +40,27 @@ enum pstore_type_id {
 
 struct module;
 
/* Notifier events */
#define PSTORE_BEGIN		1
#define PSTORE_DUMP		2
#define PSTORE_END		3

 #define PSTORE_NO_HEADINGS	BIT(0)
 #define PSTORE_MAX_KMSG_BYTES	BIT(1)
 
 struct pstore_info {
	struct module	*owner;
	char		*name;
	unsigned int	flags;
	spinlock_t	buf_lock;	/* serialize access to 'buf' */
	char		*buf;
	size_t		bufsize;
	struct mutex	read_mutex;	/* serialize open/read/close */
	struct module		*owner;
	char			*name;
	unsigned int		flags;
	spinlock_t		buf_lock;	/* serialize access to 'buf' */
	char			*buf;
	size_t			bufsize;
	struct mutex		read_mutex;	/* serialize open/read/close */
	u64			ext_id;
	size_t			ext_len;
	unsigned int		ext_part;
	enum pstore_type_id	ext_type;
	enum kmsg_dump_reason	ext_reason;
 	int		(*open)(struct pstore_info *psi);
 	int		(*close)(struct pstore_info *psi);
 	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
@@ -70,12 +80,31 @@ struct pstore_info {
 
 #ifdef CONFIG_PSTORE
 extern int pstore_register(struct pstore_info *);
extern int pstore_notifier_register(struct notifier_block *n);
extern int pstore_notifier_unregister(struct notifier_block *n);
/* pstore_write must only be called from PSTORE_DUMP notifier callbacks */
extern int pstore_write(enum pstore_type_id type, const char *buf, size_t size);
 #else
 static inline int
 pstore_register(struct pstore_info *psi)
 {
 	return -ENODEV;
 }
static inline int
pstore_notifier_register(struct notifier_block *n)
{
	return 0;
}
static inline int
pstore_notifier_unregister(struct notifier_block *n)
{
	return 0;
}
static inline int
pstore_write(enum pstore_type_id type, const char *buf, size_t size)
{
	return 0;
}
 #endif
 
 #endif /*_LINUX_PSTORE_H*/
- 
1.7.9.5

