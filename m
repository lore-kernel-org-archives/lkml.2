Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab2HGDpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:45:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59842 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964810Ab2HGDiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:55 -0400
Message-Id: <20120807032802.781020919@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shawn Guo <shawn.guo@linaro.org>,
        Marek Vasut <marex@denx.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 46/70] ARM: 7466/1: disable interrupt before spinning endlessly
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawn.guo@linaro.org>

commit 98bd8b96b26db3399a48202318dca4aaa2515355 upstream.

The CPU will endlessly spin at the end of machine_halt and
machine_restart calls.  However, this will lead to a soft lockup
warning after about 20 seconds, if CONFIG_LOCKUP_DETECTOR is enabled,
as system timer is still alive.

Disable interrupt before going to spin endlessly, so that the lockup
warning will never be seen.

Reported-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/kernel/process.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -125,6 +125,7 @@ void arm_machine_restart(char mode, cons
 	 */
 	mdelay(1000);
 	printk("Reboot failed -- System halted\n");
+	local_irq_disable();
 	while (1);
 }
 
@@ -240,6 +241,7 @@ void machine_shutdown(void)
 void machine_halt(void)
 {
 	machine_shutdown();
+	local_irq_disable();
 	while (1);
 }
 


