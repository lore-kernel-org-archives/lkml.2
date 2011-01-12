Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab1ALMOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 07:14:18 -0500
Received: from mx1.sophos.com ([195.166.81.52]:44476 "EHLO mx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105Ab1ALMOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 07:14:14 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>
Subject: [PATCH] Avoid having to provide a fake/invalid fd and path when flushing marks
Date: Wed, 12 Jan 2011 12:13:57 +0000
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.4; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary-00=_GsZLNsfb1hI7fIt"
Message-ID: <201101121213.58639.tvrtko.ursulin@sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_GsZLNsfb1hI7fIt
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


(Patch also attached in case our outgoing mail servers decide
to munge tabs again.)

Currently for a group to flush marks it has set it needs to
provide a fake or invalid (but resolvable) file descriptor
and path when calling fanotify_mark. This patch pulls the
flush handling a bit up so file descriptor and path are
completely ignored when flushing.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
---
 fanotify_user.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanoti=
fy_user.c
index 8b61220..09504b1 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -824,6 +824,15 @@ SYSCALL_DEFINE(fanotify_mark)(int fanotify_fd, unsigne=
d int flags,
            group->priority =3D=3D FS_PRIO_0)
                goto fput_and_out;

+       if (flags & FAN_MARK_FLUSH) {
+               if (flags & FAN_MARK_MOUNT)
+                       fsnotify_clear_vfsmount_marks_by_group(group);
+               else
+                       fsnotify_clear_inode_marks_by_group(group);
+               ret =3D 0;
+               goto fput_and_out;
+       }
+
        ret =3D fanotify_find_path(dfd, pathname, &path, flags);
        if (ret)
                goto fput_and_out;
@@ -848,12 +857,6 @@ SYSCALL_DEFINE(fanotify_mark)(int fanotify_fd, unsigne=
d int flags,
                else
                        ret =3D fanotify_remove_inode_mark(group, inode, ma=
sk, flags);
                break;
-       case FAN_MARK_FLUSH:
-               if (flags & FAN_MARK_MOUNT)
-                       fsnotify_clear_vfsmount_marks_by_group(group);
-               else
-                       fsnotify_clear_inode_marks_by_group(group);
-               break;
        default:
                ret =3D -EINVAL;
        }

Sophos Limited, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, Un=
ited Kingdom.
Company Reg No 2096520. VAT Reg No GB 991 2418 08.

--Boundary-00=_GsZLNsfb1hI7fIt
Content-Type: text/x-patch; charset="UTF-8";
	name="fanotify-flush-marks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="fanotify-flush-marks.patch"

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 8b61220..09504b1 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -824,6 +824,15 @@ SYSCALL_DEFINE(fanotify_mark)(int fanotify_fd, unsigned int flags,
 	    group->priority == FS_PRIO_0)
 		goto fput_and_out;
 
+	if (flags & FAN_MARK_FLUSH) {
+		if (flags & FAN_MARK_MOUNT)
+			fsnotify_clear_vfsmount_marks_by_group(group);
+		else
+			fsnotify_clear_inode_marks_by_group(group);
+		ret = 0;
+		goto fput_and_out;
+	}
+
 	ret = fanotify_find_path(dfd, pathname, &path, flags);
 	if (ret)
 		goto fput_and_out;
@@ -848,12 +857,6 @@ SYSCALL_DEFINE(fanotify_mark)(int fanotify_fd, unsigned int flags,
 		else
 			ret = fanotify_remove_inode_mark(group, inode, mask, flags);
 		break;
-	case FAN_MARK_FLUSH:
-		if (flags & FAN_MARK_MOUNT)
-			fsnotify_clear_vfsmount_marks_by_group(group);
-		else
-			fsnotify_clear_inode_marks_by_group(group);
-		break;
 	default:
 		ret = -EINVAL;
 	}

--Boundary-00=_GsZLNsfb1hI7fIt--
