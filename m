Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab0KAXpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 19:45:24 -0400
Received: from mail.asbjorn.biz ([217.195.185.3]:57933 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab0KAXpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 19:45:21 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Nov 2010 19:45:21 EDT
From: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild, deb-pkg: fix Architecture field when cross compiling
Date: Mon,  1 Nov 2010 23:31:01 +0000
Message-Id: <1288654261-8269-1-git-send-email-asbjorn@asbjorn.biz>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the environment variable CROSS_COMPILE is set, override
the Architecture control field, based on the value of the
ARCH environment variable.

With this patch the following make command:

	make CROSS_COMPILE='' ARCH=i386 deb-pkg

will output an i386 Debian package instead of an amd64 one,
when run on amd64 machine.

Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
---
 scripts/package/builddeb |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 49b74e1..e5b7b9b 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -25,8 +25,20 @@ create_package() {
 	chown -R root:root "$pdir"
 	chmod -R go-w "$pdir"
 
+	# Check for cross compilation
+	local forcearch=""
+	env | grep -q CROSS_COMPILE
+	if [ $? -eq 0 ] ; then
+		local debarch=""
+		case "$ARCH" in
+			x86_64) debarch="amd64" ;;
+			*) debarch="$ARCH" ;;
+		esac
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

