Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab2JAXAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:00:47 -0400
Received: from 1wt.eu ([62.212.114.60]:35203 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932643Ab2JAXAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:40 -0400
Message-Id: <20121001225201.077130761@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:19 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tim Bird <tim.bird@am.sony.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 082/180] ARM: 7410/1: Add extra clobber registers for assembly in kernel_execve
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/arm/kernel/sys_arm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/sys_arm.c b/arch/arm/kernel/sys_arm.c
index ae4027b..2dd070f 100644
--- a/arch/arm/kernel/sys_arm.c
+++ b/arch/arm/kernel/sys_arm.c
@@ -240,7 +240,7 @@ int kernel_execve(const char *filename, char *const argv[], char *const envp[])
 		  "Ir" (THREAD_START_SP - sizeof(regs)),
 		  "r" (&regs),
 		  "Ir" (sizeof(regs))
-		: "r0", "r1", "r2", "r3", "ip", "lr", "memory");
+		: "r0", "r1", "r2", "r3", "r8", "r9", "ip", "lr", "memory");
 
  out:
 	return ret;
-- 
1.7.2.1.45.g54fbc



