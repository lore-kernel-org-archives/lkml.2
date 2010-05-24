Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab0EXX2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:28:31 -0400
Received: from kroah.org ([198.145.64.141]:59433 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932557Ab0EXXXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:45 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:15 2010
Message-Id: <20100524231815.356917096@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Paris <eparis@redhat.com>
Subject: [24/39] inotify: race use after free/double free in inotify inode marks
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Paris <eparis@redhat.com>

commit e08733446e72b983fed850fc5d8bd21b386feb29 upstream.

There is a race in the inotify add/rm watch code.  A task can find and
remove a mark which doesn't have all of it's references.  This can
result in a use after free/double free situation.

Task A					Task B
------------				-----------
inotify_new_watch()
 allocate a mark (refcnt == 1)
 add it to the idr
					inotify_rm_watch()
					 inotify_remove_from_idr()
					  fsnotify_put_mark()
					      refcnt hits 0, free
 take reference because we are on idr
 [at this point it is a use after free]
 [time goes on]
 refcnt may hit 0 again, double free

The fix is to take the reference BEFORE the object can be found in the
idr.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/notify/inotify/inotify_user.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -550,21 +550,24 @@ retry:
 	if (unlikely(!idr_pre_get(&group->inotify_data.idr, GFP_KERNEL)))
 		goto out_err;
 
+	/* we are putting the mark on the idr, take a reference */
+	fsnotify_get_mark(&tmp_ientry->fsn_entry);
+
 	spin_lock(&group->inotify_data.idr_lock);
 	ret = idr_get_new_above(&group->inotify_data.idr, &tmp_ientry->fsn_entry,
 				group->inotify_data.last_wd+1,
 				&tmp_ientry->wd);
 	spin_unlock(&group->inotify_data.idr_lock);
 	if (ret) {
+		/* we didn't get on the idr, drop the idr reference */
+		fsnotify_put_mark(&tmp_ientry->fsn_entry);
+
 		/* idr was out of memory allocate and try again */
 		if (ret == -EAGAIN)
 			goto retry;
 		goto out_err;
 	}
 
-	/* we put the mark on the idr, take a reference */
-	fsnotify_get_mark(&tmp_ientry->fsn_entry);
-
 	/* we are on the idr, now get on the inode */
 	ret = fsnotify_add_mark(&tmp_ientry->fsn_entry, group, inode);
 	if (ret) {


