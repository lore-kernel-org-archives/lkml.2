Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab2HBHMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 03:12:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab2HBHMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 03:12:52 -0400
Date: Thu, 2 Aug 2012 09:12:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] sparc64: do not clobber personality flags in
 sys_sparc64_personality()
In-Reply-To: <alpine.LNX.2.00.1208012204140.14910@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1208020912130.14910@pobox.suse.cz>
References: <alpine.LNX.2.00.1208012204140.14910@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4f000eda5917ceecb03767962026cc6a390b8216 Mon Sep 17 00:00:00 2001
From: Jiri Kosina <jkosina@suse.cz>
Date: Wed, 1 Aug 2012 21:10:51 +0200
Subject: [PATCH 4/4] sparc64: do not clobber personality flags in sys_sparc64_personality()

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
---

changed since v1: fix the bit ops to reflect the fact that PER_LINUX is 
actually 0

 arch/sparc/kernel/sys_sparc_64.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 0dc1f57..11c6c96 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -502,12 +502,12 @@ SYSCALL_DEFINE1(sparc64_personality, unsigned long, personality)
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
Jiri Kosina
SUSE Labs
