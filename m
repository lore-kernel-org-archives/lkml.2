Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965386Ab2DKXXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:23:53 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51108 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965357Ab2DKXXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:23:49 -0400
Message-Id: <20120411231043.623008526@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        James Morris <james.l.morris@oracle.com>
Subject: [ 48/59] TOMOYO: Fix mount flags checking order.
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit df91e49477a9be15921cb2854e1d12a3bdb5e425 upstream.

Userspace can pass in arbitrary combinations of MS_* flags to mount().

If both MS_BIND and one of MS_SHARED/MS_PRIVATE/MS_SLAVE/MS_UNBINDABLE are
passed, device name which should be checked for MS_BIND was not checked because
MS_SHARED/MS_PRIVATE/MS_SLAVE/MS_UNBINDABLE had higher priority than MS_BIND.

If both one of MS_BIND/MS_MOVE and MS_REMOUNT are passed, device name which
should not be checked for MS_REMOUNT was checked because MS_BIND/MS_MOVE had
higher priority than MS_REMOUNT.

Fix these bugs by changing priority to MS_REMOUNT -> MS_BIND ->
MS_SHARED/MS_PRIVATE/MS_SLAVE/MS_UNBINDABLE -> MS_MOVE as with do_mount() does.

Also, unconditionally return -EINVAL if more than one of
MS_SHARED/MS_PRIVATE/MS_SLAVE/MS_UNBINDABLE is passed so that TOMOYO will not
generate inaccurate audit logs, for commit 7a2e8a8f "VFS: Sanity check mount
flags passed to change_mnt_propagation()" clarified that these flags must be
exclusively passed.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/tomoyo/mount.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/security/tomoyo/mount.c
+++ b/security/tomoyo/mount.c
@@ -199,30 +199,32 @@ int tomoyo_mount_permission(char *dev_na
 	if (flags & MS_REMOUNT) {
 		type = tomoyo_mounts[TOMOYO_MOUNT_REMOUNT];
 		flags &= ~MS_REMOUNT;
-	}
-	if (flags & MS_MOVE) {
-		type = tomoyo_mounts[TOMOYO_MOUNT_MOVE];
-		flags &= ~MS_MOVE;
-	}
-	if (flags & MS_BIND) {
+	} else if (flags & MS_BIND) {
 		type = tomoyo_mounts[TOMOYO_MOUNT_BIND];
 		flags &= ~MS_BIND;
-	}
-	if (flags & MS_UNBINDABLE) {
-		type = tomoyo_mounts[TOMOYO_MOUNT_MAKE_UNBINDABLE];
-		flags &= ~MS_UNBINDABLE;
-	}
-	if (flags & MS_PRIVATE) {
+	} else if (flags & MS_SHARED) {
+		if (flags & (MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
+			return -EINVAL;
+		type = tomoyo_mounts[TOMOYO_MOUNT_MAKE_SHARED];
+		flags &= ~MS_SHARED;
+	} else if (flags & MS_PRIVATE) {
+		if (flags & (MS_SHARED | MS_SLAVE | MS_UNBINDABLE))
+			return -EINVAL;
 		type = tomoyo_mounts[TOMOYO_MOUNT_MAKE_PRIVATE];
 		flags &= ~MS_PRIVATE;
-	}
-	if (flags & MS_SLAVE) {
+	} else if (flags & MS_SLAVE) {
+		if (flags & (MS_SHARED | MS_PRIVATE | MS_UNBINDABLE))
+			return -EINVAL;
 		type = tomoyo_mounts[TOMOYO_MOUNT_MAKE_SLAVE];
 		flags &= ~MS_SLAVE;
-	}
-	if (flags & MS_SHARED) {
-		type = tomoyo_mounts[TOMOYO_MOUNT_MAKE_SHARED];
-		flags &= ~MS_SHARED;
+	} else if (flags & MS_UNBINDABLE) {
+		if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE))
+			return -EINVAL;
+		type = tomoyo_mounts[TOMOYO_MOUNT_MAKE_UNBINDABLE];
+		flags &= ~MS_UNBINDABLE;
+	} else if (flags & MS_MOVE) {
+		type = tomoyo_mounts[TOMOYO_MOUNT_MOVE];
+		flags &= ~MS_MOVE;
 	}
 	if (!type)
 		type = "<NULL>";


