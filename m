Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab2J1X1D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:27:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41763 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756245Ab2J1X06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:26:58 -0400
Message-Id: <20121028231541.377182464@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:50 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Kosina <jkosina@suse.cz>, "David S. Miller" <davem@davemloft.net>
Subject: [ 014/105] sparc64: do not clobber personality flags in  sys_sparc64_personality()
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

[ Upstream commit a27032eee8cb6e16516f13c8a9752e9d5d4cc430 ]

There are multiple errors in how sys_sparc64_personality() handles
personality flags stored in top three bytes.

- directly comparing current->personality against PER_LINUX32 doesn't work
  in cases when any of the personality flags stored in the top three bytes
  are used.
- directly forcefully setting personality to PER_LINUX32 or PER_LINUX
  discards any flags stored in the top three bytes

Fix the first one by properly using personality() macro to compare only
PER_MASK bytes.
Fix the second one by setting only the bits that should be set, instead of
overwriting the whole value.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/kernel/sys_sparc_64.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 441521a..5e4252b 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -519,12 +519,12 @@ SYSCALL_DEFINE1(sparc64_personality, unsigned long, personality)
 {
 	int ret;
 
-	if (current->personality == PER_LINUX32 &&
-	    personality == PER_LINUX)
-		personality = PER_LINUX32;
+	if (personality(current->personality) == PER_LINUX32 &&
+	    personality(personality) == PER_LINUX)
+		personality |= PER_LINUX32;
 	ret = sys_personality(personality);
-	if (ret == PER_LINUX32)
-		ret = PER_LINUX;
+	if (personality(ret) == PER_LINUX32)
+		ret &= ~PER_LINUX32;
 
 	return ret;
 }


