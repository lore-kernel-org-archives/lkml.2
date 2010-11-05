Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab0KENaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 09:30:23 -0400
Received: from mail.asbjorn.biz ([217.195.185.3]:43717 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab0KENaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 09:30:22 -0400
From: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        debian-kernel@lists.debian.org
Subject: [PATCH] kbuild, deb-pkg: select userland architecture based on UTS_MACHINE
Date: Fri,  5 Nov 2010 13:30:08 +0000
Message-Id: <1288963808-7057-1-git-send-email-asbjorn@asbjorn.biz>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <4CD406C7.8090801@asbjorn.biz>
References: <4CD406C7.8090801@asbjorn.biz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of creating the debian package for the compiling userland,
create it for a userland matching the kernel thats being compiled.

This patch supports all Lenny release architectures,
and Linux-based architecture candidates for Squeeze.

If it can't find a proper Debian userspace it displays a warning,
and fallback to let deb-gencontrol use the host's userspace arch.

Eg. with this patch the following make command:

	make ARCH=i386 deb-pkg

will output an i386 Debian package instead of an amd64 one,
when run on an amd64 machine.

Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
---
 scripts/package/builddeb |   35 ++++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 5f1e2fc..0043ccd 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -25,8 +25,41 @@ create_package() {
 	chown -R root:root "$pdir"
 	chmod -R go-w "$pdir"
 
+	# Attempt to find the correct Debian architecture
+	local forcearch="" debarch=""
+	case "$UTS_MACHINE" in
+	i386|ia64|alpha)
+		debarch="$UTS_MACHINE" ;;
+	x86_64)
+		debarch=amd64 ;;
+	sparc*)
+		debarch=sparc ;;
+	s390*)
+		debarch=s390 ;;
+	ppc*)
+		debarch=powerpc ;;
+	parisc*)
+		debarch=hppa ;;
+	mips*)
+		debarch=mips$(grep -q CPU_LITTLE_ENDIAN=y .config && echo el) ;;
+	arm*)
+		debarch=arm$(grep -q CONFIG_AEABI=y .config && echo el) ;;
+	*)
+		echo "" >&2
+		echo "** ** **  WARNING  ** ** **" >&2
+		echo "" >&2
+		echo "Your architecture doesn't have it's equivalent" >&2
+		echo "Debian userspace architecture defined!" >&2
+		echo "Falling back to using your current userspace instead!" >&2
+		echo "Please add support for $UTS_MACHINE to ${0} ..." >&2
+		echo "" >&2
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

