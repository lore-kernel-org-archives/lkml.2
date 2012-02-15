Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab2BOQi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:38:57 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:21072
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752980Ab2BOQiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:38:55 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz13e6Kzz1202hzz8275bh8275dhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZG0WN-01-1NK-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Michal Marek <mmarek@suse.cz>,
        maximilian attems <max@stro.at>, Ben Hutchings <ben@decadent.org.uk>,
        <debian-kernel@lists.debian.org>, <linux-kbuild@vger.kernel.org>
Subject: [PATCH 2/2] kbuild: Only build linux-image package for UML
Date: Wed, 15 Feb 2012 17:38:27 +0100
Message-ID: <1329323907-7696-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329323907-7696-1-git-send-email-joerg.roedel@amd.com>
References: <1329323907-7696-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For user-mode Linux the other packages are not required. So
only build the package with the linux-image in it.

Cc: Michal Marek <mmarek@suse.cz>
Cc: maximilian attems <max@stro.at>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: debian-kernel@lists.debian.org
Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 scripts/package/builddeb |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 39e3f30..0db889f 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -130,8 +130,10 @@ if grep -q '^CONFIG_MODULES=y' .config ; then
 	fi
 fi
 
-make headers_check
-make headers_install INSTALL_HDR_PATH="$libc_headers_dir/usr"
+if [ "$ARCH" != "um" ]; then
+	make headers_check
+	make headers_install INSTALL_HDR_PATH="$libc_headers_dir/usr"
+fi
 
 # Install the maintainer scripts
 # Note: hook scripts under /etc/kernel are also executed by official Debian
@@ -263,8 +265,6 @@ Description: Linux kernel headers for $KERNELRELEASE on $arch
  This is useful for people who need to build external modules
 EOF
 
-create_package "$kernel_headers_packagename" "$kernel_headers_dir"
-
 # Do we have firmware? Move it out of the way and build it into a package.
 if [ -e "$tmpdir/lib/firmware" ]; then
 	mv "$tmpdir/lib/firmware" "$fwdir/lib/"
@@ -291,7 +291,11 @@ Description: Linux support headers for userspace development
  are used by the installed headers for GNU glibc and other system libraries.
 EOF
 
-create_package "$libc_headers_packagename" "$libc_headers_dir"
+if [ "$ARCH" != "um" ]; then
+	create_package "$kernel_headers_packagename" "$kernel_headers_dir"
+	create_package "$libc_headers_packagename" "$libc_headers_dir"
+fi
+
 create_package "$packagename" "$tmpdir"
 
 exit 0
-- 
1.7.5.4


