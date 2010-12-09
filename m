Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab0LIGLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 01:11:39 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:49317 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585Ab0LIGLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 01:11:38 -0500
Message-ID: <4D007315.1090704@lougher.demon.co.uk>
Date: Thu, 09 Dec 2010 06:11:33 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Linux Embedded Maillist <linux-embedded@vger.kernel.org>
CC: Lasse Collin <lasse.collin@tukaani.org>
Subject: [PATCH 2/2] Squashfs: Add XZ compression configuration option
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/Kconfig        |   16 ++++++++++++++++
  fs/squashfs/Makefile       |    1 +
  fs/squashfs/decompressor.c |   11 +++++++++++
  fs/squashfs/squashfs.h     |    3 +++
  4 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index e5f63da..e96d99a 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -53,6 +53,22 @@ config SQUASHFS_LZO

  	  If unsure, say N.

+config SQUASHFS_XZ
+	bool "Include support for XZ compressed file systems"
+	depends on SQUASHFS
+	default n
+	select XZ_DEC
+	help
+	  Saying Y here includes support for reading Squashfs file systems
+	  compressed with XZ compresssion.  XZ gives better compression than
+	  the default zlib compression, at the expense of greater CPU and
+	  memory overhead.
+
+	  XZ is not the standard compression used in Squashfs and so most
+	  file systems will be readable without selecting this option.
+
+	  If unsure, say N.
+
  config SQUASHFS_EMBEDDED
  	bool "Additional option for memory-constrained systems"
  	depends on SQUASHFS
diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
index 7672bac..cecf2be 100644
--- a/fs/squashfs/Makefile
+++ b/fs/squashfs/Makefile
@@ -7,3 +7,4 @@ squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
  squashfs-y += namei.o super.o symlink.o zlib_wrapper.o decompressor.o
  squashfs-$(CONFIG_SQUASHFS_XATTR) += xattr.o xattr_id.o
  squashfs-$(CONFIG_SQUASHFS_LZO) += lzo_wrapper.o
+squashfs-$(CONFIG_SQUASHFS_XZ) += xz_wrapper.o
diff --git a/fs/squashfs/decompressor.c b/fs/squashfs/decompressor.c
index 24af9ce..ac333b8 100644
--- a/fs/squashfs/decompressor.c
+++ b/fs/squashfs/decompressor.c
@@ -46,6 +46,12 @@ static const struct squashfs_decompressor squashfs_lzo_unsupported_comp_ops = {
  };
  #endif

+#ifndef CONFIG_SQUASHFS_XZ
+static const struct squashfs_decompressor squashfs_xz_unsupported_comp_ops = {
+	NULL, NULL, NULL, XZ_COMPRESSION, "xz", 0
+};
+#endif
+
  static const struct squashfs_decompressor squashfs_unknown_comp_ops = {
  	NULL, NULL, NULL, 0, "unknown", 0
  };
@@ -58,6 +64,11 @@ static const struct squashfs_decompressor *decompressor[] = {
  #else
  	&squashfs_lzo_unsupported_comp_ops,
  #endif
+#ifdef CONFIG_SQUASHFS_XZ
+	&squashfs_xz_comp_ops,
+#else
+	&squashfs_xz_unsupported_comp_ops,
+#endif
  	&squashfs_unknown_comp_ops
  };

diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index 5d45569..1096e2e 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -107,3 +107,6 @@ extern const struct squashfs_decompressor squashfs_zlib_comp_ops;

  /* lzo_wrapper.c */
  extern const struct squashfs_decompressor squashfs_lzo_comp_ops;
+
+/* xz_wrapper.c */
+extern const struct squashfs_decompressor squashfs_xz_comp_ops;
-- 
1.6.3.3

