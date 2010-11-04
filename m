Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab0KDDof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 23:44:35 -0400
Received: from mail.asbjorn.biz ([217.195.185.3]:47087 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab0KDDoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 23:44:34 -0400
From: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        debian-kernel@lists.debian.org
Subject: [PATCH] kbuild, deb-pkg: fix Architecture field when cross compiling
Date: Thu,  4 Nov 2010 03:44:04 +0000
Message-Id: <1288842244-6863-1-git-send-email-asbjorn@asbjorn.biz>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <4CD22ACF.1000407@asbjorn.it>
References: <4CD22ACF.1000407@asbjorn.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attempt to guess the correct value of the Architecture control
field, based on the ARCH environment variable. Fallback to letting
deb-gencontrol use the host platform's architecture.

With this patch the following make command:

	make ARCH=i386 deb-pkg

will output an i386 Debian package instead of an amd64 one,
when run on amd64 machine.

Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
---
 scripts/package/builddeb |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 5f1e2fc..43b8826 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -25,8 +25,23 @@ create_package() {
 	chown -R root:root "$pdir"
 	chmod -R go-w "$pdir"
 
+	# Attempt to find the correct Debian architecture
+	local forcearch="" debarch=""
+	case "$ARCH" in
+	i386|ia64)
+		debarch="$ARCH" ;;
+	x86_64)
+		debarch="amd64" ;;
+	*)
+		grep -q CONFIG_ARM=y .config &&
+			debarch=arm$(grep -q CONFIG_AEABI=y .config && echo el)
+	esac
+	if [ -n "$debarch" ] ; then
+		forcearch="-DArchitecture=$debarch"
+	fi
+
 	# Create the package
-	dpkg-gencontrol -isp -p$pname -P"$pdir"
+	dpkg-gencontrol -isp $forcearch -p$pname -P"$pdir"
 	dpkg --build "$pdir" ..
 }
 
-- 
1.7.2.3

