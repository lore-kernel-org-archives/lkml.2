Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab0IHIYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:24:15 -0400
Received: from mx4.sophos.com ([74.202.89.161]:37846 "EHLO mx4.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758458Ab0IHIYM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:24:12 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>
Subject: Re: [BUG][PATCH][2.6.36-rc3] fanotify: Do not ignore result of permission decisions
Date: Wed, 8 Sep 2010 09:24:04 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <201009071608.02290.tvrtko.ursulin@sophos.com>
In-Reply-To: <201009071608.02290.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Message-ID: <201009080924.04841.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 08/09/2010 09:24:06,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 08/09/2010 09:24:10,
	Serialize complete at 08/09/2010 09:24:10
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Improved version of the fix which does not include the check
when permission events are not enabled in configuration and
stops processing if no interesting events remain.

Current code ignores access replies to permission decisions so
fix it in a way which will allow all listeners to still receive
non permission events.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
---
 fs/notify/fsnotify.c             |   32 ++++++++++++++++++++++++--------
 include/linux/fsnotify_backend.h |    4 ++++
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 3680242..2350a53 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -224,7 +224,7 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
        struct fsnotify_group *inode_group, *vfsmount_group;
        struct fsnotify_event *event = NULL;
        struct vfsmount *mnt;
-       int idx, ret = 0;
+       int idx, ret = 0, res;
        /* global tests shouldn't care about events on child only the specific event */
        __u32 test_mask = (mask & ~FS_EVENT_ON_CHILD);

@@ -275,20 +275,36 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,

                if (inode_group > vfsmount_group) {
                        /* handle inode */
-                       send_to_group(to_tell, NULL, inode_mark, NULL, mask, data,
-                                     data_is, cookie, file_name, &event);
+                       res = send_to_group(to_tell, NULL, inode_mark, NULL, mask, data,
+                                           data_is, cookie, file_name, &event);
                        /* we didn't use the vfsmount_mark */
                        vfsmount_group = NULL;
                } else if (vfsmount_group > inode_group) {
-                       send_to_group(to_tell, mnt, NULL, vfsmount_mark, mask, data,
-                                     data_is, cookie, file_name, &event);
+                       res = send_to_group(to_tell, mnt, NULL, vfsmount_mark, mask, data,
+                                           data_is, cookie, file_name, &event);
                        inode_group = NULL;
                } else {
-                       send_to_group(to_tell, mnt, inode_mark, vfsmount_mark,
-                                     mask, data, data_is, cookie, file_name,
-                                     &event);
+                       res = send_to_group(to_tell, mnt, inode_mark, vfsmount_mark,
+                                           mask, data, data_is, cookie, file_name,
+                                           &event);
                }

+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+               /* If a listener denied on a permission event we will remember the reason
+                  and run the rest with a non-permission mask only. This allows other
+                  listeners to receive non-permission notifications but we do not care
+                  about further permission checks and want to deny this event. */
+               if (unlikely((res == -EPERM) && (mask & FS_ALL_PERM_EVENTS))) {
+                       mask &= ~FS_ALL_PERM_EVENTS;
+                       ret = res;
+                       /* Stop processing if no interesting events remains. */
+                       if (!(mask & (ALL_FSNOTIFY_EVENTS & ~FS_EVENT_ON_CHILD)))
+                               break;
+               }
+#else
+               (void)res;
+#endif
+
                if (inode_group)
                        inode_node = srcu_dereference(inode_node->next,
                                                      &fsnotify_mark_srcu);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index e40190d..c8aea03 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -64,6 +64,10 @@

 #define FS_MOVE                        (FS_MOVED_FROM | FS_MOVED_TO)

+/* All events which require a permission response from userspace */
+#define FS_ALL_PERM_EVENTS (FS_OPEN_PERM |\
+                           FS_ACCESS_PERM)
+
 #define ALL_FSNOTIFY_EVENTS (FS_ACCESS | FS_MODIFY | FS_ATTRIB | \
                             FS_CLOSE_WRITE | FS_CLOSE_NOWRITE | FS_OPEN | \
                             FS_MOVED_FROM | FS_MOVED_TO | FS_CREATE | \

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
