Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab2LDVsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 16:48:17 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47151 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab2LDVsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 16:48:16 -0500
Date: Wed, 5 Dec 2012 01:48:12 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Oleg Nesterov <oleg@redhat.com>, Andrey Vagin <avagin@openvz.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Subject: [PATCH -mm] fs, fanotify: Add missing pieses in fdinfo for ability
 to call fanotify_init
Message-ID: <20121204214812.GL22545@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While been restoring fanotify objects I discovered that the minimum
information we provide now is enough to restore notification marks
but still a bit incomplete for fanotify_init system call (the @flags
and @event-flags are unknown). This patch adds missing bits into fdinfo
output.

An example of output is below

 | pos:	0
 | flags:	04002
 | fanotify flags:10 event-flags:0
 | fanotify mnt_id:12 mask:3b ignored_mask:0
 | fanotify ino:50205 sdev:800013 mask:3b ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:05020500fb1d47e7

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Andrey Vagin <avagin@openvz.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Matthew Helsley <matt.helsley@gmail.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
---
 fs/notify/fdinfo.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

Index: linux-2.6.git/fs/notify/fdinfo.c
===================================================================
--- linux-2.6.git.orig/fs/notify/fdinfo.c
+++ linux-2.6.git/fs/notify/fdinfo.c
@@ -4,6 +4,7 @@
 #include <linux/idr.h>
 #include <linux/init.h>
 #include <linux/inotify.h>
+#include <linux/fanotify.h>
 #include <linux/kernel.h>
 #include <linux/namei.h>
 #include <linux/sched.h>
@@ -140,6 +141,30 @@ out:
 
 int fanotify_show_fdinfo(struct seq_file *m, struct file *f)
 {
+	struct fsnotify_group *group = f->private_data;
+	unsigned int flags = 0;
+
+	switch (group->priority) {
+	case FS_PRIO_0:
+		flags |= FAN_CLASS_NOTIF;
+		break;
+	case FS_PRIO_1:
+		flags |= FAN_CLASS_CONTENT;
+		break;
+	case FS_PRIO_2:
+		flags |= FAN_CLASS_PRE_CONTENT;
+		break;
+	}
+
+	if (group->max_events == UINT_MAX)
+		flags |= FAN_UNLIMITED_QUEUE;
+
+	if (group->fanotify_data.max_marks == UINT_MAX)
+		flags |= FAN_UNLIMITED_MARKS;
+
+	seq_printf(m, "fanotify flags:%x event-flags:%x\n",
+		   flags, group->fanotify_data.f_flags);
+
 	return show_fdinfo(m, f, fanotify_fdinfo);
 }
 
