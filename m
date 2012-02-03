Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab2BCPtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:49:16 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:56120 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab2BCPsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:48:19 -0500
From: Corey Minyard <cminyard@mvista.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 6/6] ipmi: Use locks on watchdog timeout set on reboot
Date: Fri, 03 Feb 2012 09:47:59 -0600
Message-id: <1328284079-5489-6-git-send-email-cminyard@mvista.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1328284079-5489-1-git-send-email-cminyard@mvista.com>
References: <1328284079-5489-1-git-send-email-cminyard@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IPMI watchdog timer clears or extends the timer on reboot/shutdown.
It was using the non-locking routine for setting the watchdog timer, but
this was causing race conditions.  Instead, use the locking version to
avoid the races.  It seems to work fine.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_watchdog.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 57a53ba..99dc1da 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -1167,7 +1167,7 @@ static int wdog_reboot_handler(struct notifier_block *this,
 		if (code == SYS_POWER_OFF || code == SYS_HALT) {
 			/* Disable the WDT if we are shutting down. */
 			ipmi_watchdog_state = WDOG_TIMEOUT_NONE;
-			panic_halt_ipmi_set_timeout();
+			ipmi_set_timeout(IPMI_SET_TIMEOUT_NO_HB);
 		} else if (ipmi_watchdog_state != WDOG_TIMEOUT_NONE) {
 			/* Set a long timer to let the reboot happens, but
 			   reboot if it hangs, but only if the watchdog
@@ -1175,7 +1175,7 @@ static int wdog_reboot_handler(struct notifier_block *this,
 			timeout = 120;
 			pretimeout = 0;
 			ipmi_watchdog_state = WDOG_TIMEOUT_RESET;
-			panic_halt_ipmi_set_timeout();
+			ipmi_set_timeout(IPMI_SET_TIMEOUT_NO_HB);
 		}
 	}
 	return NOTIFY_OK;
-- 
1.7.4.1

