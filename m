Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab2JIWyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 18:54:10 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53311 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937Ab2JIWyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:54:08 -0400
Date: Tue, 9 Oct 2012 15:54:01 -0700
From: Kees Cook <keescook@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>
Subject: [PATCH v2] fix stack memory content leak via UNAME26
Message-ID: <20121009225401.GA10219@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling uname() with the UNAME26 personality set allows a leak of kernel
stack contents. This fixes it by initializing the stack buffer to zero,
defensively calculating the length of copy_to_user() call, and making
the len argument unsigned.

CVE-2012-0957

Reported-by: PaX Team <pageexec@freemail.hu>
Cc: stable@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>

---
v2:
 - corrected credit to PaX Team.
 - moved stack clearing into if case to avoid penalty to common case.
---
 kernel/sys.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index c5cb5b9..2300248 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1265,13 +1265,13 @@ DECLARE_RWSEM(uts_sem);
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
 
@@ -1283,7 +1283,9 @@ static int override_release(char __user *release, int len)
 			rest++;
 		}
 		v = ((LINUX_VERSION_CODE >> 8) & 0xff) + 40;
-		snprintf(buf, len, "2.6.%u%s", v, rest);
+		snprintf(buf, sizeof(buf), "2.6.%u%s", v, rest);
+		if (sizeof(buf) < len)
+			len = sizeof(buf);
 		ret = copy_to_user(release, buf, len);
 	}
 	return ret;
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
