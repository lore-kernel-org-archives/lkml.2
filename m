Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607Ab2KZRK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:10:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47844 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933451Ab2KZRKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:10:54 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Andi Kleen <ak@linux.intel.com>,
        PaX Team <pageexec@freemail.hu>,
        Brad Spengler <spender@grsecurity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 175/270] kernel/sys.c: fix stack memory content leak via UNAME26
Date: Mon, 26 Nov 2012 14:57:45 -0200
Message-Id: <1353949160-26803-176-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 2702b1526c7278c4d65d78de209a465d4de2885e upstream.

Calling uname() with the UNAME26 personality set allows a leak of kernel
stack contents.  This fixes it by defensively calculating the length of
copy_to_user() call, making the len argument unsigned, and initializing
the stack buffer to zero (now technically unneeded, but hey, overkill).

CVE-2012-0957

Reported-by: PaX Team <pageexec@freemail.hu>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: PaX Team <pageexec@freemail.hu>
Cc: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/sys.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 0349bde..1b66408 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1265,15 +1265,16 @@ DECLARE_RWSEM(uts_sem);
  * Work around broken programs that cannot handle "Linux 3.0".
  * Instead we map 3.x to 2.6.40+x, so e.g. 3.0 would be 2.6.40
  */
-static int override_release(char __user *release, int len)
+static int override_release(char __user *release, size_t len)
 {
 	int ret = 0;
-	char buf[65];
 
 	if (current->personality & UNAME26) {
-		char *rest = UTS_RELEASE;
+		const char *rest = UTS_RELEASE;
+		char buf[65] = { 0 };
 		int ndots = 0;
 		unsigned v;
+		size_t copy;
 
 		while (*rest) {
 			if (*rest == '.' && ++ndots >= 3)
@@ -1283,8 +1284,9 @@ static int override_release(char __user *release, int len)
 			rest++;
 		}
 		v = ((LINUX_VERSION_CODE >> 8) & 0xff) + 40;
-		snprintf(buf, len, "2.6.%u%s", v, rest);
-		ret = copy_to_user(release, buf, len);
+		copy = min(sizeof(buf), max_t(size_t, 1, len));
+		copy = scnprintf(buf, copy, "2.6.%u%s", v, rest);
+		ret = copy_to_user(release, buf, copy + 1);
 	}
 	return ret;
 }
-- 
1.7.9.5

