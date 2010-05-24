Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199Ab0EXXNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:13:00 -0400
Received: from kroah.org ([198.145.64.141]:36446 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758995Ab0EXXJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:09:28 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:03:50 2010
Message-Id: <20100524230350.865962981@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 15:59:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Pavel Emelyanov <xemul@openvz.org>, Eric Paris <eparis@redhat.com>
Subject: [17/34] inotify: dont leak user struct on inotify release
In-Reply-To: <20100524230418.GA12770@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pavel Emelyanov <xemul@openvz.org>

commit b3b38d842fa367d862b83e7670af4e0fd6a80fc0 upstream.

inotify_new_group() receives a get_uid-ed user_struct and saves the
reference on group->inotify_data.user.  The problem is that free_uid() is
never called on it.

Issue seem to be introduced by 63c882a0 (inotify: reimplement inotify
using fsnotify) after 2.6.30.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Eric Paris <eparis@parisplace.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/notify/inotify/inotify_fsnotify.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -28,6 +28,7 @@
 #include <linux/path.h> /* struct path */
 #include <linux/slab.h> /* kmem_* */
 #include <linux/types.h>
+#include <linux/sched.h>
 
 #include "inotify.h"
 
@@ -146,6 +147,7 @@ static void inotify_free_group_priv(stru
 	idr_for_each(&group->inotify_data.idr, idr_callback, group);
 	idr_remove_all(&group->inotify_data.idr);
 	idr_destroy(&group->inotify_data.idr);
+	free_uid(group->inotify_data.user);
 }
 
 void inotify_free_event_priv(struct fsnotify_event_private_data *fsn_event_priv)


