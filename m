Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934243Ab2AJXCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:02:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934079Ab2AJXC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:02:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:56:03 2012
Message-Id: <20120110215603.452423766@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:55:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Boaz Harrosh <bharrosh@panasas.com>
Subject: [22/49] ore: FIX breakage when MISC_FILESYSTEMS is not set
In-Reply-To: <20120110215609.GA22505@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit 831c2dc5f47c1dc79c32229d75065ada1dcc66e1 upstream.

As Reported by Randy Dunlap

When MISC_FILESYSTEMS is not enabled and NFS4.1 is:

fs/built-in.o: In function `objio_alloc_io_state':
objio_osd.c:(.text+0xcb525): undefined reference to `ore_get_rw_state'
fs/built-in.o: In function `_write_done':
objio_osd.c:(.text+0xcb58d): undefined reference to `ore_check_io'
fs/built-in.o: In function `_read_done':
...

When MISC_FILESYSTEMS, which is more of a GUI thing then anything else,
is not selected. exofs/Kconfig is never examined during Kconfig,
and it can not do it's magic stuff to automatically select everything
needed.

We must split exofs/Kconfig in two. The ore one is always included.
And the exofs one is left in it's old place in the menu.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/Kconfig           |    2 ++
 fs/exofs/Kconfig     |   11 -----------
 fs/exofs/Kconfig.ore |   12 ++++++++++++
 3 files changed, 14 insertions(+), 11 deletions(-)

--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -218,6 +218,8 @@ source "fs/exofs/Kconfig"
 
 endif # MISC_FILESYSTEMS
 
+source "fs/exofs/Kconfig.ore"
+
 menuconfig NETWORK_FILESYSTEMS
 	bool "Network File Systems"
 	default y
--- a/fs/exofs/Kconfig
+++ b/fs/exofs/Kconfig
@@ -1,14 +1,3 @@
-# Note ORE needs to "select ASYNC_XOR". So Not to force multiple selects
-# for every ORE user we do it like this. Any user should add itself here
-# at the "depends on EXOFS_FS || ..." with an ||. The dependencies are
-# selected here, and we default to "ON". So in effect it is like been
-# selected by any of the users.
-config ORE
-	tristate
-	depends on EXOFS_FS || PNFS_OBJLAYOUT
-	select ASYNC_XOR
-	default SCSI_OSD_ULD
-
 config EXOFS_FS
 	tristate "exofs: OSD based file system support"
 	depends on SCSI_OSD_ULD
--- /dev/null
+++ b/fs/exofs/Kconfig.ore
@@ -0,0 +1,12 @@
+# ORE - Objects Raid Engine (libore.ko)
+#
+# Note ORE needs to "select ASYNC_XOR". So Not to force multiple selects
+# for every ORE user we do it like this. Any user should add itself here
+# at the "depends on EXOFS_FS || ..." with an ||. The dependencies are
+# selected here, and we default to "ON". So in effect it is like been
+# selected by any of the users.
+config ORE
+	tristate
+	depends on EXOFS_FS || PNFS_OBJLAYOUT
+	select ASYNC_XOR
+	default SCSI_OSD_ULD


