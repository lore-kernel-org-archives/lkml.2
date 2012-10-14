Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab2JNPFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:05:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46348 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754026Ab2JNOmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:42 -0400
Message-Id: <20121014143547.966741383@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shawn Guo <shawn.guo@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 105/147] kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawn.guo@linaro.org>

commit f96972f2dc6365421cf2366ebd61ee4cf060c8d5 upstream.

As kernel_power_off() calls disable_nonboot_cpus(), we may also want to
have kernel_restart() call disable_nonboot_cpus().  Doing so can help
machines that require boot cpu be the last alive cpu during reboot to
survive with kernel restart.

This fixes one reboot issue seen on imx6q (Cortex-A9 Quad).  The machine
requires that the restart routine be run on the primary cpu rather than
secondary ones.  Otherwise, the secondary core running the restart
routine will fail to come to online after reboot.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sys.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sys.c b/kernel/sys.c
index f949228..fdad206 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -368,6 +368,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
 void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
+	disable_nonboot_cpus();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
 	else


