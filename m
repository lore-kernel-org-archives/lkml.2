Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946242Ab2ERXDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:03:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65112 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946225Ab2ERXDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:03:00 -0400
Message-Id: <20120518211600.090329148@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tim Bird <tim.bird@am.sony.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 07/54] ARM: 7410/1: Add extra clobber registers for assembly in kernel_execve
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 arch/arm/kernel/sys_arm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


