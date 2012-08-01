Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab2HAUDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:03:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab2HAUDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:03:51 -0400
Date: Wed, 1 Aug 2012 22:03:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: fix personality handling in ppc64_personality()
Message-ID: <alpine.LNX.2.00.1208012201520.14910@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Directly comparing current->personality against PER_LINUX32 doesn't work 
in cases when any of the personality flags stored in the top three bytes 
are used.

Directly forcefully setting personality to PER_LINUX32 or PER_LINUX
discards any flags stored in the top three bytes

Use personality() macro to compare only PER_MASK bytes and make sure that
we are setting only the bits that should be set, instead of
overwriting the whole value.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

Found accidentally. Untested, I don't have the hardware.

 arch/powerpc/kernel/syscalls.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/syscalls.c b/arch/powerpc/kernel/syscalls.c
index f2496f2..4dcc7c6 100644
--- a/arch/powerpc/kernel/syscalls.c
+++ b/arch/powerpc/kernel/syscalls.c
@@ -107,11 +107,11 @@ long ppc64_personality(unsigned long personality)
 	long ret;
 
 	if (personality(current->personality) == PER_LINUX32
-	    && personality == PER_LINUX)
-		personality = PER_LINUX32;
+	    && personality(personality) == PER_LINUX)
+		personality &= ~PER_LINUX | PER_LINUX32;
 	ret = sys_personality(personality);
-	if (ret == PER_LINUX32)
-		ret = PER_LINUX;
+	if (personality(ret) == PER_LINUX32)
+		ret &= ~PER_LINUX32 | PER_LINUX;
 	return ret;
 }
 #endif

-- 
Jiri Kosina
SUSE Labs
