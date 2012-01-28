Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2A1NhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 08:37:22 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53101 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2A1NhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 08:37:21 -0500
From: Rabin Vincent <rabin@rab.in>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 5/6] jump label: detect %c support for ARM
Date: Sat, 28 Jan 2012 19:05:24 +0530
Message-Id: <1327757725-10114-6-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327757725-10114-1-git-send-email-rabin@rab.in>
References: <1327757725-10114-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some versions of ARM GCC which do support asm goto, have problems
handling the the %c specifier.  Since we need the %c to support jump
labels on ARM, detect that too in the asm goto detection script to avoid
build errors with these versions.

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48637

Cc: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 scripts/gcc-goto.sh |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/scripts/gcc-goto.sh b/scripts/gcc-goto.sh
index 98cffcb..9b744de 100644
--- a/scripts/gcc-goto.sh
+++ b/scripts/gcc-goto.sh
@@ -2,4 +2,20 @@
 # Test for gcc 'asm goto' support
 # Copyright (C) 2010, Jason Baron <jbaron@redhat.com>
 
-echo "int main(void) { entry: asm goto (\"\"::::entry); return 0; }" | $@ -x c - -c -o /dev/null >/dev/null 2>&1 && echo "y"
+cat << "END" | $@ -x c - -c -o /dev/null >/dev/null 2>&1 && echo "y"
+int main(void)
+{
+#ifdef __arm__
+	/*
+	 * Not related to asm goto, but used by jump label
+	 * and broken on some ARM GCC versions (see GCC Bug 48637).
+	 */
+	static struct { int dummy; int state; } tp;
+	asm ("@ %c0" :: "i" (&tp.state));
+#endif
+
+entry:
+	asm goto ("" :::: entry);
+	return 0;
+}
+END
-- 
1.7.8.3

