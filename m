Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2BXLK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:10:28 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:44130 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2BXLK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 06:10:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: tony.luck@intel.com
Cc: fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 4/4] IA64: simserial, bail out when request_irq fails
Date: Fri, 24 Feb 2012 12:10:18 +0100
Message-Id: <1330081818-15517-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330081818-15517-1-git-send-email-jslaby@suse.cz>
References: <1330081818-15517-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this, the code succeeds when the port is opened by root and we
get unwanted interrupts storm on the first key stroke.

Instead of that, tell the user we failed and that we won't continue. I
suppose, the code was copied from the serial layer where we may want
to change the irq number, so we must allow open even of the failing
port. This is not the case for this driver at all.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/ia64/hp/sim/simserial.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 797e89a..60c9093 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -702,15 +702,8 @@ startup(struct async_struct *info)
 			handler = rs_interrupt_single;
 
 		retval = request_irq(state->irq, handler, IRQ_T(info), "simserial", NULL);
-		if (retval) {
-			if (capable(CAP_SYS_ADMIN)) {
-				if (info->tty)
-					set_bit(TTY_IO_ERROR,
-						&info->tty->flags);
-				retval = 0;
-			}
+		if (retval)
 			goto errout;
-		}
 	}
 
 	/*
-- 
1.7.9


