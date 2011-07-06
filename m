Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab1GFQJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:09:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37153 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab1GFQJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:09:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:content-transfer-encoding;
	b=ejCWVRbUdrBNLPE2L9v7pXg/wReEbKhlO1+Ir38gsBGvushGLeg/9DYllYJy1JL0C
	4sH97o4Tshc9lY+5dR+AA==
Subject: [PATCH 2/2] watchdog: nv_tco: optionally leave watchdog enabled
	during restart
To: Wim Van Sebroeck <wim@iguana.be>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Date: Wed, 06 Jul 2011 10:09:41 -0600
Message-ID: <20110706160941.4002.43149.stgit@bhelgaas.mtv.corp.google.com>
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
 drivers/watchdog/nv_tco.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/nv_tco.c b/drivers/watchdog/nv_tco.c
index afa78a5..90eac80 100644
--- a/drivers/watchdog/nv_tco.c
+++ b/drivers/watchdog/nv_tco.c
@@ -60,6 +60,11 @@ module_param(heartbeat, int, 0);
 MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (2<heartbeat<39, "
 			    "default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
+static int reboot_timeout;
+module_param(reboot_timeout, int, 0);
+MODULE_PARM_DESC(reboot_timeout,
+	"Schedule reset N seconds after reboot (default=0 (no reset))");
+
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started"
@@ -459,6 +464,14 @@ static int __devexit nv_tco_remove(struct platform_device *dev)
 static void nv_tco_shutdown(struct platform_device *dev)
 {
 	tco_timer_stop();
+
+	if (system_state == SYSTEM_RESTART && reboot_timeout) {
+		printk(KERN_CRIT PFX
+		       "scheduling watchdog reset %d seconds from now\n",
+		       reboot_timeout);
+		tco_timer_set_heartbeat(reboot_timeout);
+		tco_timer_start();
+	}
 }
 
 static struct platform_driver nv_tco_driver = {

