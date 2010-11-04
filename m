Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab0KDCrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 22:47:12 -0400
Received: from mail.asbjorn.biz ([217.195.185.3]:53964 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab0KDCrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 22:47:10 -0400
From: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        debian-kernel@lists.debian.org
Subject: [PATCH] kbuild, deb-pkg: fix Architecture field when cross compiling
Date: Thu,  4 Nov 2010 02:42:40 +0000
Message-Id: <1288838560-6173-1-git-send-email-asbjorn@asbjorn.biz>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <4CD20F85.7040005@asbjorn.biz>
References: <4CD20F85.7040005@asbjorn.biz>
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
 scripts/package/builddeb |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 5f1e2fc..02fd63f 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -25,8 +25,24 @@ create_package() {
 	chown -R root:root "$pdir"
 	chmod -R go-w "$pdir"
 
+	# Attempt to find correct debian architecture
+	local forcearch="" debarch=""
+	case "$ARCH" in
+		x86_64) debarch="amd64" ;;
+		i386|ia64) debarch="$ARCH" ;;
+		*)
+			case "$SUBARCH" in
+				arm) debarch=$(grep -q CONFIG_AEABI=y .config \
+						&& echo armel || echo arm) ;;
+			esac
+			;;
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

