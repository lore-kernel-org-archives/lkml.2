Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab0ESLwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:52:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab0ESLwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:52:51 -0400
Message-ID: <4BF3D10D.2040902@redhat.com>
Date: Wed, 19 May 2010 13:52:45 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>, Robert Love <rlove@rlove.org>,
       John McCutchan <john@johnmccutchan.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RFC][PATCH] inotify: Fix mask checks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The mask checks in inotify_update_existing_watch() and
inotify_new_watch() are useless because inotify_arg_to_mask() sets
FS_IN_IGNORED and FS_EVENT_ON_CHILD bits anyway. We should either
test that at least one of the user events is set (see the untested
patch below) or remove the test completely if we consider OK to only
watch for the implicit events (IN_UNMOUNT, IN_Q_OVERFLOW and
IN_IGNORED).

Btw, is it necessary to set IN_IGNORED in inotify_arg_to_mask()?
Wouldn't the IN_IGNORED event be send anyway, whatever that bit is set
or not in the mask?

Thanks,
Jerome

---
From: Jerome Marchand <jmarchan@redhat.com>

Currently, the mask checks in inotify_update_existing_watch() and
inotify_new_watch() are useless because inotify_arg_to_mask() sets
FS_IN_IGNORED and FS_EVENT_ON_CHILD bits anyway.

Check that at least one user event is set.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 inotify_user.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index e46ca68..a95ca25 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -467,7 +467,7 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 
 	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
-	if (unlikely(!mask))
+	if (unlikely(!(mask & IN_ALL_EVENTS)))
 		return -EINVAL;
 
 	spin_lock(&inode->i_lock);
@@ -527,7 +527,7 @@ static int inotify_new_watch(struct fsnotify_group *group,
 
 	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
-	if (unlikely(!mask))
+	if (unlikely(!(mask & IN_ALL_EVENTS)))
 		return -EINVAL;
 
 	tmp_ientry = kmem_cache_alloc(inotify_inode_mark_cachep, GFP_KERNEL);
