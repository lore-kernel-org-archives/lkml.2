Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab2JLTHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 15:07:00 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57933 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881Ab2JLTG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 15:06:56 -0400
Date: Fri, 12 Oct 2012 12:06:45 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Andi Kleen <ak@linux.intel.com>,
        PaX Team <pageexec@freemail.hu>,
        Brad Spengler <spender@grsecurity.net>
Subject: [PATCH v4] fix stack memory content leak via UNAME26
Message-ID: <20121012190645.GA6111@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling uname() with the UNAME26 personality set allows a leak of kernel
stack contents. This fixes it by defensively calculating the length of
copy_to_user() call, making the len argument unsigned, and initializing
the stack buffer to zero (now technically unneeded, but hey, overkill).

CVE-2012-0957

Reported-by: PaX Team <pageexec@freemail.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: PaX Team <pageexec@freemail.hu>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>

---
v4:
 - switch to clamp_t, thanks to Fengguang Wu.
v3:
 - use scnprintf, suggested by Andrew Morton.
v2:
 - corrected credit to PaX Team.
 - moved stack clearing into if case to avoid penalty to common case.
---
 kernel/sys.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index c5cb5b9..e6e0ece 100644
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
+		copy = clamp_t(size_t, len, 1, sizeof(buf));
+		copy = scnprintf(buf, copy, "2.6.%u%s", v, rest);
+		ret = copy_to_user(release, buf, copy + 1);
 	}
 	return ret;
 }
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
