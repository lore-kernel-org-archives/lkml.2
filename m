Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab2CHUBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:01:45 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:58283 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758356Ab2CHUBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:01:39 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] [IA64] simserial, bail out when request_irq fails
Date: Thu,  8 Mar 2012 21:01:19 +0100
Message-Id: <1331236879-20124-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1331236879-20124-1-git-send-email-jslaby@suse.cz>
References: <20120308195028.GA17564@kroah.com>
 <1331236879-20124-1-git-send-email-jslaby@suse.cz>
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
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/hp/sim/simserial.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

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
1.7.9.2


