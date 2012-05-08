Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2EHJyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:54:37 -0400
Received: from mail.southpole.se ([193.12.106.18]:56644 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab2EHJyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:54:12 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 6/6] openrisc: use scratch regs in atomic syscall
Date: Tue,  8 May 2012 11:54:05 +0200
Message-Id: <1336470845-13859-7-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336470845-13859-1-git-send-email-jonas@southpole.se>
References: <1336470845-13859-1-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 70848-08813
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The function sys_or1k_atomic was using call-saved registers without
restoring their value before returning.  This is a faux pas: either
we need to restore their values or use scratch regs; the latter is
less code so that's the route this patch takes.

Thanks to David Hennerström for doing most of the heavy-lifting in
tracking this one down.

Reported-by: Davd Hennerström <david.hennerstrom@aacmicrotec.com>
Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/kernel/entry.S |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
index 6e61af8..ddfcaa8 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -1117,10 +1117,10 @@ ENTRY(sys_rt_sigreturn)
 ENTRY(sys_or1k_atomic)
 	/* FIXME: This ignores r3 and always does an XCHG */
 	DISABLE_INTERRUPTS(r17,r19)
-	l.lwz	r30,0(r4)
-	l.lwz	r28,0(r5)
-	l.sw	0(r4),r28
-	l.sw	0(r5),r30
+	l.lwz	r29,0(r4)
+	l.lwz	r27,0(r5)
+	l.sw	0(r4),r27
+	l.sw	0(r5),r29
 	ENABLE_INTERRUPTS(r17)
 	l.jr	r9
 	 l.or	r11,r0,r0
-- 
1.7.0.4

