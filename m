Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab0IVWss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 18:48:48 -0400
Received: from nm3-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.55]:36831 "HELO
	nm3-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753220Ab0IVWsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 18:48:46 -0400
X-Yahoo-Newman-Id: 940411.77859.bm@omp1003.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: gzl7dJ4VM1ldUi.TiveBfOK.n7FunBiy4oJ9NBcDvOmWDS_
 .micY8FxoIKYHT3snOby21LvinxMuZOMDJW27VLjXgQtatfvL7p_7KoqZa4J
 FE3mqJ.fq59POqYbG.TRTkRYS9Mwq48TwuUt8uxWXcjUGo7M10XwqdOg1kCP
 TnjFa7nJZcXNEmLpDnycCeC6i4W0anovjl_pKs9c3uvB67lFmjH_XFnJ8Y25
 YczdsQiUNSDND00TzZvh.va8oI6YjI5CPZ3hGjcYxXCErO5dIiL2vFuBcaCE
 _PGqv4YJ9F56kSfoAymKz5URq.W3ip1Ro4FRY3cYyxk67WaOBE1k-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [RFC v2 02/21] tcm: Add ConfigFS extended macro set
Date: Wed, 22 Sep 2010 15:48:41 -0700
Message-Id: <1285195721-11459-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the ConfigFS extended macro set in CONFIGFS_EATTR_*() that are used
by TCM/ConfigFS >= v3.x subsystem backstores and v4 generic fabric configfs infrastructure
and CPP macro set.

Compared to the original configfs macro set in include/linux/configfs.h, the extended macro
set allows for more flexability to handle multiple struct config_groups hanging off a single
parent data structure for more complex consumer logic and with less LOC!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 include/target/configfs_macros.h |  147 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 147 insertions(+), 0 deletions(-)
 create mode 100644 include/target/configfs_macros.h

diff --git a/include/target/configfs_macros.h b/include/target/configfs_macros.h
new file mode 100644
index 0000000..7fe7460
--- /dev/null
+++ b/include/target/configfs_macros.h
@@ -0,0 +1,147 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * configfs_macros.h - extends macros for configfs
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ *
+ * Based on sysfs:
+ * 	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
+ *
+ * Based on kobject.h:
+ *      Copyright (c) 2002-2003	Patrick Mochel
+ *      Copyright (c) 2002-2003	Open Source Development Labs
+ *
+ * configfs Copyright (C) 2005 Oracle.  All rights reserved.
+ *
+ * Added CONFIGFS_EATTR() macros from original configfs.h macros
+ * Copright (C) 2008-2009 Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
+ * Please read Documentation/filesystems/configfs.txt before using the
+ * configfs interface, ESPECIALLY the parts about reference counts and
+ * item destructors.
+ */
+
+#ifndef _CONFIGFS_MACROS_H_
+#define _CONFIGFS_MACROS_H_
+
+#include <linux/configfs.h>
+
+/*
+ * Users often need to create attribute structures for their configurable
+ * attributes, containing a configfs_attribute member and function pointers
+ * for the show() and store() operations on that attribute. If they don't
+ * need anything else on the extended attribute structure, they can use
+ * this macro to define it.  The argument _name isends up as
+ * 'struct _name_attribute, as well as names of to CONFIGFS_ATTR_OPS() below.
+ * The argument _item is the name of the structure containing the
+ * struct config_item or struct config_group structure members
+ */
+#define CONFIGFS_EATTR_STRUCT(_name, _item)				\
+struct _name##_attribute {						\
+	struct configfs_attribute attr;					\
+	ssize_t (*show)(struct _item *, char *);			\
+	ssize_t (*store)(struct _item *, const char *, size_t);		\
+}
+
+/*
+ * With the extended attribute structure, users can use this macro
+ * (similar to sysfs' __ATTR) to make defining attributes easier.
+ * An example:
+ * #define MYITEM_EATTR(_name, _mode, _show, _store)	\
+ * struct myitem_attribute childless_attr_##_name =	\
+ *         __CONFIGFS_EATTR(_name, _mode, _show, _store)
+ */
+#define __CONFIGFS_EATTR(_name, _mode, _show, _store)			\
+{									\
+	.attr	= {							\
+			.ca_name = __stringify(_name),			\
+			.ca_mode = _mode,				\
+			.ca_owner = THIS_MODULE,			\
+	},								\
+	.show	= _show,						\
+	.store	= _store,						\
+}
+/* Here is a readonly version, only requiring a show() operation */
+#define __CONFIGFS_EATTR_RO(_name, _show)				\
+{									\
+	.attr	= {							\
+			.ca_name = __stringify(_name),			\
+			.ca_mode = 0444,				\
+			.ca_owner = THIS_MODULE,			\
+	},								\
+	.show	= _show,						\
+}
+
+/*
+ * With these extended attributes, the simple show_attribute() and
+ * store_attribute() operations need to call the show() and store() of the
+ * attributes.  This is a common pattern, so we provide a macro to define
+ * them.  The argument _name is the name of the attribute defined by
+ * CONFIGFS_ATTR_STRUCT(). The argument _item is the name of the structure
+ * containing the struct config_item or struct config_group structure member.
+ * The argument _item_member is the actual name of the struct config_* struct
+ * in your _item structure.  Meaning  my_structure->some_config_group.
+ *		                      ^^_item^^^^^  ^^_item_member^^^
+ * This macro expects the attributes to be named "struct <name>_attribute".
+ */
+#define CONFIGFS_EATTR_OPS_TO_FUNC(_name, _item, _item_member)		\
+static struct _item *to_##_name(struct config_item *ci)			\
+{									\
+	return (ci) ? container_of(to_config_group(ci), struct _item,	\
+		_item_member) : NULL;					\
+}
+
+#define CONFIGFS_EATTR_OPS_SHOW(_name, _item)				\
+static ssize_t _name##_attr_show(struct config_item *item,		\
+				 struct configfs_attribute *attr,	\
+				 char *page)				\
+{									\
+	struct _item *_item = to_##_name(item);				\
+	struct _name##_attribute * _name##_attr =			\
+		container_of(attr, struct _name##_attribute, attr);	\
+	ssize_t ret = 0;						\
+									\
+	if (_name##_attr->show)						\
+		ret = _name##_attr->show(_item, page);			\
+	return ret;							\
+}
+
+#define CONFIGFS_EATTR_OPS_STORE(_name, _item)				\
+static ssize_t _name##_attr_store(struct config_item *item,		\
+				  struct configfs_attribute *attr,	\
+				  const char *page, size_t count)	\
+{									\
+	struct _item *_item = to_##_name(item);				\
+	struct _name##_attribute * _name##_attr =			\
+		container_of(attr, struct _name##_attribute, attr);	\
+	ssize_t ret = -EINVAL;						\
+									\
+	if (_name##_attr->store)					\
+		ret = _name##_attr->store(_item, page, count);		\
+	return ret;							\
+}
+
+#define CONFIGFS_EATTR_OPS(_name, _item, _item_member)			\
+	CONFIGFS_EATTR_OPS_TO_FUNC(_name, _item, _item_member);		\
+	CONFIGFS_EATTR_OPS_SHOW(_name, _item);				\
+	CONFIGFS_EATTR_OPS_STORE(_name, _item);
+
+#define CONFIGFS_EATTR_OPS_RO(_name, _item, _item_member)		\
+	CONFIGFS_EATTR_OPS_TO_FUNC(_name, _item, _item_member);		\
+	CONFIGFS_EATTR_OPS_SHOW(_name, _item);
+
+#endif /* _CONFIGFS_MACROS_H_ */
-- 
1.7.3

