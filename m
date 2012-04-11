Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965841Ab2DKX3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:29:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45547 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965804Ab2DKX3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:29:41 -0400
Message-Id: <20120411231314.589486719@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:13:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, James Morris <james.l.morris@oracle.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 41/42] TOMOYO: Fix mount flags checking order.
In-Reply-To: <20120411231443.GA808@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/tomoyo/mount.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/security/tomoyo/mount.c
+++ b/security/tomoyo/mount.c
@@ -205,30 +205,32 @@ int tomoyo_mount_permission(char *dev_na
 	if (flags & MS_REMOUNT) {
 		type = TOMOYO_MOUNT_REMOUNT_KEYWORD;
 		flags &= ~MS_REMOUNT;
-	}
-	if (flags & MS_MOVE) {
-		type = TOMOYO_MOUNT_MOVE_KEYWORD;
-		flags &= ~MS_MOVE;
-	}
-	if (flags & MS_BIND) {
+	} else if (flags & MS_BIND) {
 		type = TOMOYO_MOUNT_BIND_KEYWORD;
 		flags &= ~MS_BIND;
-	}
-	if (flags & MS_UNBINDABLE) {
-		type = TOMOYO_MOUNT_MAKE_UNBINDABLE_KEYWORD;
-		flags &= ~MS_UNBINDABLE;
-	}
-	if (flags & MS_PRIVATE) {
+	} else if (flags & MS_SHARED) {
+		if (flags & (MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
+			return -EINVAL;
+		type = TOMOYO_MOUNT_MAKE_SHARED_KEYWORD;
+		flags &= ~MS_SHARED;
+	} else if (flags & MS_PRIVATE) {
+		if (flags & (MS_SHARED | MS_SLAVE | MS_UNBINDABLE))
+			return -EINVAL;
 		type = TOMOYO_MOUNT_MAKE_PRIVATE_KEYWORD;
 		flags &= ~MS_PRIVATE;
-	}
-	if (flags & MS_SLAVE) {
+	} else if (flags & MS_SLAVE) {
+		if (flags & (MS_SHARED | MS_PRIVATE | MS_UNBINDABLE))
+			return -EINVAL;
 		type = TOMOYO_MOUNT_MAKE_SLAVE_KEYWORD;
 		flags &= ~MS_SLAVE;
-	}
-	if (flags & MS_SHARED) {
-		type = TOMOYO_MOUNT_MAKE_SHARED_KEYWORD;
-		flags &= ~MS_SHARED;
+	} else if (flags & MS_UNBINDABLE) {
+		if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE))
+			return -EINVAL;
+		type = TOMOYO_MOUNT_MAKE_UNBINDABLE_KEYWORD;
+		flags &= ~MS_UNBINDABLE;
+	} else if (flags & MS_MOVE) {
+		type = TOMOYO_MOUNT_MOVE_KEYWORD;
+		flags &= ~MS_MOVE;
 	}
 	if (!type)
 		type = "<NULL>";


