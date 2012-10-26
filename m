Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965944Ab2JZSu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:50:27 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39176 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab2JZSuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:50:23 -0400
Date: Fri, 26 Oct 2012 11:50:21 -0700
From: Kees Cook <keescook@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] VFS: add config options to enable link restrictions
Message-ID: <20121026185021.GA1960@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are situations where devices running without initrds may need
very early protection from link vulnerabilities, so make these sysctls
configurable at build time, since 561ec64ae67e ("VFS: don't do protected
{sym,hard}links by default") has disabled the protections by default.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/Kconfig |   39 +++++++++++++++++++++++++++++++++++++++
 fs/namei.c |    6 ++++--
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index f95ae3a..46ae2dc 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -276,4 +276,43 @@ endif # NETWORK_FILESYSTEMS
 source "fs/nls/Kconfig"
 source "fs/dlm/Kconfig"
 
+config PROTECTED_SYMLINKS
+	bool "Protect symlink following in sticky world-writable dirs"
+	default n
+	help
+	  Solve the class of ToCToU symlink race vulnerabilities by
+	  permitting symlinks to be followed only when outside a sticky
+	  world-writable directory, or when the uid of the symlink and
+	  follower match, or when the directory and symlink owners match.
+
+	  When PROC_SYSCTL is enabled, this setting can also be controlled
+	  via /proc/sys/kernel/protected_symlinks.
+
+	  See Documentation/sysctl/fs.txt for details.
+
+config PROTECTED_SYMLINKS_SYSCTL
+	int
+	default "1" if PROTECTED_SYMLINKS
+	default "0"
+
+config PROTECTED_HARDLINKS
+	bool "Protect hardlink creation to non-accessible files"
+	default n
+	help
+	  Solve the class of ToCToU hardlink race vulnerabilities by
+	  permitting hardlinks to be created only when to a regular file
+	  that is owned by the user, or is readable and writable by the
+	  user. Also blocks users from "pinning" vulnerable setuid/setgid
+	  programs from being upgraded by the administrator.
+
+	  When PROC_SYSCTL is enabled, this setting can also be controlled
+	  via /proc/sys/kernel/protected_hardlinks.
+
+	  See Documentation/sysctl/fs.txt for details.
+
+config PROTECTED_HARDLINKS_SYSCTL
+	int
+	default "1" if PROTECTED_HARDLINKS
+	default "0"
+
 endmenu
diff --git a/fs/namei.c b/fs/namei.c
index 937f9d5..21854df 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -705,8 +705,10 @@ static inline void put_link(struct nameidata *nd, struct path *link, void *cooki
 	path_put(link);
 }
 
-int sysctl_protected_symlinks __read_mostly = 0;
-int sysctl_protected_hardlinks __read_mostly = 0;
+int sysctl_protected_symlinks __read_mostly =
+	CONFIG_PROTECTED_SYMLINKS_SYSCTL;
+int sysctl_protected_hardlinks __read_mostly =
+	CONFIG_PROTECTED_HARDLINKS_SYSCTL;
 
 /**
  * may_follow_link - Check symlink following for unsafe situations
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
