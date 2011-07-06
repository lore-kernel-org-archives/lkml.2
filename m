Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab1GFQJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:09:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37130 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab1GFQJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:09:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:content-transfer-encoding;
	b=qNRUy8rvyiNqIRW6+9sXavfYdjebAeA68SgRZXTAOom17OtnTuR57Ziq0o2//JDWL
	gwGGoztfFL/39qVQoEwgA==
Subject: [PATCH 1/2] watchdog: iTCO_wdt: optionally leave watchdog enabled
	during restart
To: Wim Van Sebroeck <wim@iguana.be>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Date: Wed, 06 Jul 2011 10:09:36 -0600
Message-ID: <20110706160936.4002.1846.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20110706160744.4002.94920.stgit@bhelgaas.mtv.corp.google.com>
References: <20110706160744.4002.94920.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A system reboot may fail, especially when rebooting via kexec, which can
result in a hung system that requires manual intervention.

This patch adds support for a "reboot_timeout", so we can program the
watchdog to reset the system if a reboot hangs.

On the way down, we schedule a watchdog reset for some time in the future:
long enough for the new kernel to boot and set up the watchdog timer itself.

If we reboot via BIOS, BIOS should disable the watchdog itself, so this
shouldn't cause unintended resets, even if the user interrupts the boot.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/watchdog/iTCO_wdt.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 5fd020d..66f800c 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -507,6 +507,11 @@ MODULE_PARM_DESC(heartbeat, "Watchdog timeout in seconds. "
 	"5..76 (TCO v1) or 3..614 (TCO v2), default="
 				__MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
+static int reboot_timeout;
+module_param(reboot_timeout, int, 0);
+MODULE_PARM_DESC(reboot_timeout,
+	"Schedule reset N seconds after reboot (default=0 (no reset))");
+
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout,
@@ -1050,6 +1055,14 @@ static int __devexit iTCO_wdt_remove(struct platform_device *dev)
 static void iTCO_wdt_shutdown(struct platform_device *dev)
 {
 	iTCO_wdt_stop();
+
+	if (system_state == SYSTEM_RESTART && reboot_timeout) {
+		printk(KERN_CRIT PFX
+		       "scheduling watchdog reset %d seconds from now\n",
+		       reboot_timeout);
+		iTCO_wdt_set_heartbeat(reboot_timeout);
+		iTCO_wdt_start();
+	}
 }
 
 #define iTCO_wdt_suspend NULL

