Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab1DKPFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:05:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:35692 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab1DKPFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:05:15 -0400
From: Michal Marek <mmarek@suse.cz>
To: jwjstone@fastmail.fm
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] kbuild: Allow to override LINUX_COMPILE_BY and LINUX_COMPILE_HOST macros
Date: Mon, 11 Apr 2011 17:04:49 +0200
Message-Id: <1302534289-17689-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <4D9B3AA4.5090402@fastmail.fm>
References: <4D9B3AA4.5090402@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it possible to override the user@host string displayed during boot
and in /proc/version by the environment variables KBUILD_BUILD_USER and
KBUILD_BUILD_HOST. Several distributions patch scripts/mkcompile_h to
achieve this, so let's provide an official way.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Documentation/kbuild/kbuild.txt |   12 ++++++++++++
 scripts/mkcompile_h             |   14 ++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index 4a99031..27d7928 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -196,3 +196,15 @@ to be included in the databases, separated by blank space. E.g.:
 To get all available archs you can also specify all. E.g.:
 
     $ make ALLSOURCE_ARCHS=all tags
+
+KBUILD_BUILD_TIMESTAMP
+--------------------------------------------------
+Setting this to a date string overrides the timestamp used in the
+UTS_VERSION definition (uname -v in the running kernel). The default value
+is the output of the date command at one point during build.
+
+KBUILD_BUILD_USER, KBUILD_BUILD_HOST
+--------------------------------------------------
+These two variables allow to override the user@host string displayed during
+boot and in /proc/version. The default value is the output of the commands
+whoami and host, respectively.
diff --git a/scripts/mkcompile_h b/scripts/mkcompile_h
index 82416a8..7ad6bf7 100755
--- a/scripts/mkcompile_h
+++ b/scripts/mkcompile_h
@@ -42,6 +42,16 @@ if [ -z "$KBUILD_BUILD_TIMESTAMP" ]; then
 else
 	TIMESTAMP=$KBUILD_BUILD_TIMESTAMP
 fi
+if test -z "$KBUILD_BUILD_USER"; then
+	LINUX_COMPILE_BY=`whoami`
+else
+	LINUX_COMPILE_BY=$KBUILD_BUILD_USER
+fi
+if test -z "$KBUILD_BUILD_HOST"; then
+	LINUX_COMPILE_HOST=`hostname`
+else
+	LINUX_COMPILE_HOST=$KBUILD_BUILD_HOST
+fi
 
 UTS_VERSION="#$VERSION"
 CONFIG_FLAGS=""
@@ -63,8 +73,8 @@ UTS_TRUNCATE="cut -b -$UTS_LEN"
 
   echo \#define UTS_VERSION \"`echo $UTS_VERSION | $UTS_TRUNCATE`\"
 
-  echo \#define LINUX_COMPILE_BY \"`whoami`\"
-  echo \#define LINUX_COMPILE_HOST \"`hostname | $UTS_TRUNCATE`\"
+  echo \#define LINUX_COMPILE_BY \"`echo $LINUX_COMPILE_BY | $UTS_TRUNCATE`\"
+  echo \#define LINUX_COMPILE_HOST \"`echo $LINUX_COMPILE_HOST | $UTS_TRUNCATE`\"
 
   echo \#define LINUX_COMPILER \"`$CC -v 2>&1 | tail -n 1`\"
 ) > .tmpcompile
-- 
1.7.4.1

