Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab2EBUxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:53:19 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:43485 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756407Ab2EBUxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:53:18 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zf7Iz1469K542Mzz1202hzz8275bh8275dhz2fh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4FA19EB7.7080000@am.sony.com>
Date: Wed, 2 May 2012 13:53:11 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Fwd: [PATCH] arm: Add extra clobber registers for assembly in kernel_execve
References: <4F7F2DA2.4040805@am.sony.com>
In-Reply-To: <4F7F2DA2.4040805@am.sony.com>
X-Forwarded-Message-Id: <4F7F2DA2.4040805@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone interested in this?

-------- Original Message --------
Subject: [PATCH] arm: Add extra clobber registers for assembly in kernel_execve
Date: Fri, 6 Apr 2012 10:53:38 -0700
From: Tim Bird <tim.bird@am.sony.com>
To: linux-arm-kernel@lists.infradead.org <linux-arm-kernel@lists.infradead.org>, Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>


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

Signed off by: Tim Bird <tim.bird@am.sony.com>
---
 arch/arm/kernel/sys_arm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/sys_arm.c b/arch/arm/kernel/sys_arm.c
index 62e7c61..0264ab4 100644
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



