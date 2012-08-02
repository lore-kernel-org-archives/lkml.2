Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab2HBHLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 03:11:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454Ab2HBHLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 03:11:30 -0400
Date: Thu, 2 Aug 2012 09:11:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] [S390] do not clobber personality flags in
 sys_32_personality()
In-Reply-To: <alpine.LNX.2.00.1208012045500.14910@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1208020910260.14910@pobox.suse.cz>
References: <alpine.LNX.2.00.1208012045500.14910@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are multiple errors in how sys_32_personality() handles personality
flags stored in top three bytes.

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

 arch/s390/kernel/sys_s390.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kernel/sys_s390.c b/arch/s390/kernel/sys_s390.c
index b4a29ee..d0964d2 100644
--- a/arch/s390/kernel/sys_s390.c
+++ b/arch/s390/kernel/sys_s390.c
@@ -81,11 +81,12 @@ SYSCALL_DEFINE1(s390_personality, unsigned int, personality)
 {
 	unsigned int ret;
 
-	if (current->personality == PER_LINUX32 && personality == PER_LINUX)
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
