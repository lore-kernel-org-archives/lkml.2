Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab2HLX4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 19:56:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65260 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab2HLX4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 19:56:42 -0400
Message-ID: <50282141.2010408@landley.net>
Date: Sun, 12 Aug 2012 16:33:53 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Fun with mount flags.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Way back when I rewrote busybox mount 3 times, and now I'm writing 
a mount implementation for toybox, and this  means I'm going through 
the list of VFS flags in include/linux/fs.h and trying to figure out
what they all _do_.

I _think_ there are three flags missing from the list filtered out in 
fs/namespace.c function do_mount(), specifically:

diff --git a/fs/namespace.c b/fs/namespace.c
index 1e4a5fe..83c9c49 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2175,7 +2175,7 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_BORN |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
-		   MS_STRICTATIME);
+		   MS_STRICTATIME | MS_NOSEC | MS_NOUSER | MS_POSIXACL);
 
 	if (flags & MS_REMOUNT)
 		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,

"MS_NOUSER" tells attempts to mount this filesystem to fail (for pipefs
and such) and you can set it yourself, meaning the attempt to mount
will always fail. Not a big problem but: dude? (This is not the
same thing as user/nouser in fstab, that's internal to the userspace
mount command.)

MS_POSIXACL tells the VFS layer the filesystem wants it to track extended
attributes. The flag is set by each filesystem as appropriate, and most
of them clear it first but SOME DON'T. (What happens if you pass MS_POSIXACL
to mount when mounting jffs2 with access control list support disabled in
the filesystem but enabled in the VFS? Beats me.)

MS_NOSEC is... weird. It's unconditionally set in fs/super.c function
mount_bdev() on first mount, and then cleared again by various things that
change attributes. It seems to fast-path some security checks. According
to git annotate of Al Viro added it in commit 9e1f1de0 the description
of which boils down to "found another way in which NFS sucks, try to work
around it".

(By the way, MS_RELATIME as supplied from userspace is a complete NOP.
Read do_mount() if you don't believe me: it's never used before it's
cleared.)

Anyway, it might be a good janitor project to zap these in do_mount and
then grep for the various redundant clearing of them elsewhere, and
clean up the duplication.

(I realize not a lot of people ever write mount implementations, but
this is the second time _I've_ done it, and there's still no
documentation on this, which means I need to write some...)

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
