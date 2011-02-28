Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab1B1VkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:40:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44359 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1B1VkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:40:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=aoRJ1YjO6wgt2RRqoKrQlsXGVfskZVECuT4y76BwpQhQVuPaC8DFE15LXf7LW4e7pE
         0XPynZYTIlri6Xy3wAuueE5tzxs7tp8Zg8e1KLZAowBCZ2/4h1JXz9UTj66DEBGLfAHq
         tV+pN00B0222YxV8J0qJcERxgDj463c/yqw+0=
Message-ID: <4D6C163A.4010904@openvz.org>
Date: Tue, 01 Mar 2011 00:40:10 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Don Zickus <dzickus@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: [PATHC -tip 1/2] x86, nmi: Define a name for NMI control port
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add a comment anout why we need in-out operations.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
  arch/x86/include/asm/mach_traps.h |   18 +++++++++++++-----
  1 file changed, 13 insertions(+), 5 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/mach_traps.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/mach_traps.h
+++ linux-2.6.git/arch/x86/include/asm/mach_traps.h
@@ -8,6 +8,7 @@
  #include <asm/mc146818rtc.h>

  #define NMI_REASON_PORT		0x61
+#define NMI_ENABLE_PORT		0x70 /* Real-Time Clock Address Register as well */

  #define NMI_REASON_SERR		0x80
  #define NMI_REASON_IOCHK	0x40
@@ -30,12 +31,19 @@ static inline void reassert_nmi(void)
  		old_reg = current_lock_cmos_reg();
  	else
  		lock_cmos(0); /* register doesn't matter here */
-	outb(0x8f, 0x70);
-	inb(0x71);		/* dummy */
-	outb(0x0f, 0x70);
-	inb(0x71);		/* dummy */
+
+	/*
+	 * This will cause the NMI output to transition low
+	 * then high if there are any pending NMI sources. The
+	 * CPU's NMI input logic will then register a new NMI.
+	 */
+	outb(0x8f, NMI_ENABLE_PORT);
+	inb(0x71);	/* dummy */
+	outb(0x0f, NMI_ENABLE_PORT);
+	inb(0x71);	/* dummy */
+
  	if (old_reg >= 0)
-		outb(old_reg, 0x70);
+		outb(old_reg, NMI_ENABLE_PORT);
  	else
  		unlock_cmos();
  }
-- 
     Cyrill
