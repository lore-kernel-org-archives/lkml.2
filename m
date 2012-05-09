Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2EIF54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:57:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39079 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756538Ab2EIFxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:49 -0400
Message-Id: <20120509055050.848073649@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:53:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tim Bird <tim.bird@am.sony.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 154/167] [PATCH] ARM: 7410/1: Add extra clobber registers for assembly in
 kernel_execve
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Bird <tim.bird@am.sony.com>

commit e787ec1376e862fcea1bfd523feb7c5fb43ecdb9 upstream.

The inline assembly in kernel_execve() uses r8 and r9.  Since this
code sequence does not return, it usually doesn't matter if the
register clobber list is accurate.  However, I saw a case where a
particular version of gcc used r8 as an intermediate for the value
eventually passed to r9.  Because r8 is used in the inline
assembly, and not mentioned in the clobber list, r9 was set
to an incorrect value.

This resulted in a kernel panic on execution of the first user-space
program in the system.  r9 is used in ret_to_user as the thread_info
pointer, and if it's wrong, bad things happen.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/kernel/sys_arm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/sys_arm.c b/arch/arm/kernel/sys_arm.c
index d2b1779..76cbb05 100644
--- a/arch/arm/kernel/sys_arm.c
+++ b/arch/arm/kernel/sys_arm.c
@@ -115,7 +115,7 @@ int kernel_execve(const char *filename,
 		  "Ir" (THREAD_START_SP - sizeof(regs)),
 		  "r" (&regs),
 		  "Ir" (sizeof(regs))
-		: "r0", "r1", "r2", "r3", "ip", "lr", "memory");
+		: "r0", "r1", "r2", "r3", "r8", "r9", "ip", "lr", "memory");
 
  out:
 	return ret;
-- 
1.7.10



