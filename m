Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1HDNyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 09:54:24 -0400
Received: from fb2.tech.numericable.fr ([82.216.111.50]:54085 "EHLO
	fb2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1HDNyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 09:54:14 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH] scripts: add extract-vmlinux
Date: Thu,  4 Aug 2011 15:52:57 +0200
Message-Id: <1312465977-12388-1-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfedvhedrtdegucetggdotefuucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucguihgtkhculdeftddmneffihgtkhculddqfedtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This script can be used to extract vmlinux from a compressed
kernel image (bzImage, etc..). It's inspired from (a subset of)
extract-ikconfig.

I don't know if this scripts really have this place in the kernel
tree, but it's something a lot of people have been looking for (mainly
people with xen < 4 that doesn't support bzImages at all).

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 scripts/extract-vmlinux |   60 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)
 create mode 100755 scripts/extract-vmlinux

diff --git a/scripts/extract-vmlinux b/scripts/extract-vmlinux
new file mode 100755
index 0000000..444f404
--- /dev/null
+++ b/scripts/extract-vmlinux
@@ -0,0 +1,60 @@
+#!/bin/sh
+# ----------------------------------------------------------------------
+# extract-vmlinux - Extract uncompressed vmlinux from a kernel image
+#
+# The obscure use of the "tr" filter is to work around older versions of
+# "grep" that report the byte offset of the line instead of the pattern.
+#
+# Inspired from extract-ikconfig
+# (c) 2009,2010 Dick Streefland <dick@streefland.net>
+#
+# (c) 2011      Corentin Chary <corentin.chary@gmail.com>
+# Licensed under the terms of the GNU General Public License.
+# ----------------------------------------------------------------------
+
+check_elf()
+{
+	# Use readelf to check if it's a valid ELF
+	# There is probably a better way to do that...
+	readelf -h $1 > /dev/null 2>&1 || return 1
+
+	cat $1
+	exit 0
+}
+
+try_decompress()
+{
+	for	pos in `tr "$1\n$2" "\n$2=" < "$img" | grep -abo "^$2"`
+	do
+		pos=${pos%%:*}
+		tail -c+$pos "$img" | $3 > $tmp 2> /dev/null
+		check_elf $tmp
+	done
+}
+
+# Check invocation:
+me=${0##*/}
+img=$1
+if	[ $# -ne 1 -o ! -s "$img" ]
+then
+	echo "Usage: $me <kernel-image>" >&2
+	exit 2
+fi
+
+# Prepare temp files:
+tmp=$(mktemp /tmp/vmlinux-XXX)
+trap "rm -f $tmp" 0
+
+# Initial attempt for uncompressed images or objects:
+check_elf $img
+
+# That didn't work, so retry after decompression.
+try_decompress '\037\213\010' xy    gunzip
+try_decompress '\3757zXZ\000' abcde unxz
+try_decompress 'BZh'          xy    bunzip2
+try_decompress '\135\0\0\0'   xxx   unlzma
+try_decompress '\211\114\132' xy    'lzop -d'
+
+# Bail out:
+echo "$me: Cannot find vmlinux." >&2
+exit 1
-- 
1.7.3.4

