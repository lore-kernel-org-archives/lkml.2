Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab2J1Xa6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:30:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42248 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757062Ab2J1X2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:31 -0400
Message-Id: <20121028231544.405054446@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:00 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Drake <dsd@laptop.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [ 024/105] viafb: dont touch clock state on OLPC XO-1.5
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Drake <dsd@laptop.org>

commit 012a1211845eab69a5488d59eb87d24cc518c627 upstream.

As detailed in the thread titled "viafb PLL/clock tweaking causes XO-1.5
instability," enabling or disabling the IGA1/IGA2 clocks causes occasional
stability problems during suspend/resume cycles on this platform.

This is rather odd, as the documentation suggests that clocks have two
states (on/off) and the default (stable) configuration is configured to
enable the clock only when it is needed. However, explicitly enabling *or*
disabling the clock triggers this system instability, suggesting that there
is a 3rd state at play here.

Leaving the clock enable/disable registers alone solves this problem.
This fixes spurious reboots during suspend/resume behaviour introduced by
commit b692a63a.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/via/via_clock.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/video/via/via_clock.c b/drivers/video/via/via_clock.c
index af8f26b..db1e392 100644
--- a/drivers/video/via/via_clock.c
+++ b/drivers/video/via/via_clock.c
@@ -25,6 +25,7 @@
 
 #include <linux/kernel.h>
 #include <linux/via-core.h>
+#include <asm/olpc.h>
 #include "via_clock.h"
 #include "global.h"
 #include "debug.h"
@@ -289,6 +290,10 @@ static void dummy_set_pll(struct via_pll_config config)
 	printk(KERN_INFO "Using undocumented set PLL.\n%s", via_slap);
 }
 
+static void noop_set_clock_state(u8 state)
+{
+}
+
 void via_clock_init(struct via_clock *clock, int gfx_chip)
 {
 	switch (gfx_chip) {
@@ -346,4 +351,18 @@ void via_clock_init(struct via_clock *clock, int gfx_chip)
 		break;
 
 	}
+
+	if (machine_is_olpc()) {
+		/* The OLPC XO-1.5 cannot suspend/resume reliably if the
+		 * IGA1/IGA2 clocks are set as on or off (memory rot
+		 * occasionally happens during suspend under such
+		 * configurations).
+		 *
+		 * The only known stable scenario is to leave this bits as-is,
+		 * which in their default states are documented to enable the
+		 * clock only when it is needed.
+		 */
+		clock->set_primary_clock_state = noop_set_clock_state;
+		clock->set_secondary_clock_state = noop_set_clock_state;
+	}
 }


