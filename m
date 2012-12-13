Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab2LMOL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:11:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44822 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933006Ab2LMOLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:11:22 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Kosina <jkosina@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 171/241] sparc64: do not clobber personality flags in sys_sparc64_personality()
Date: Thu, 13 Dec 2012 11:58:56 -0200
Message-Id: <1355407206-17100-172-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit a27032eee8cb6e16516f13c8a9752e9d5d4cc430 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/sparc/kernel/sys_sparc_64.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 275f74f..3c38914 100644
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
-- 
1.7.9.5

