Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab2J1Xko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:40:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42017 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756755Ab2J1X1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:46 -0400
Message-Id: <20121028231556.720251581@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:40 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>,
        Andi Kleen <ak@linux.intel.com>,
        Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 064/105] kernel/sys.c: fix stack memory content leak via UNAME26
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sys.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index c5cb5b9..01865c6 100644
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


