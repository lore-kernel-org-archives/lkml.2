Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab2JGXqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:46:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38196 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700Ab2JGXWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:06 -0400
Message-Id: <20121007225849.100079501@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 08 Oct 2012 00:00:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 104/108] tg3: Fix TSO CAP for 5704 devs w / ASF enabled
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Carlson <mcarlson@broadcom.com>

[ Upstream commit cf9ecf4b631f649a964fa611f1a5e8874f2a76db ]

On the earliest TSO capable devices, TSO was accomplished through
firmware.  The TSO cannot coexist with ASF management firmware though.
The tg3 driver determines whether or not ASF is enabled by calling
tg3_get_eeprom_hw_cfg(), which checks a particular bit of NIC memory.
Commit dabc5c670d3f86d15ee4f42ab38ec5bd2682487d, entitled "tg3: Move
TSO_CAPABLE assignment", accidentally moved the code that determines
TSO capabilities earlier than the call to tg3_get_eeprom_hw_cfg().  As a
consequence, the driver was attempting to determine TSO capabilities
before it had all the data it needed to make the decision.

This patch fixes the problem by revisiting and reevaluating the decision
after tg3_get_eeprom_hw_cfg() is called.

Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/broadcom/tg3.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 6b258d9..01bc102 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -14013,9 +14013,13 @@ static int __devinit tg3_get_invariants(struct tg3 *tp)
 	if (tg3_flag(tp, HW_TSO_1) ||
 	    tg3_flag(tp, HW_TSO_2) ||
 	    tg3_flag(tp, HW_TSO_3) ||
-	    (tp->fw_needed && !tg3_flag(tp, ENABLE_ASF)))
+	    tp->fw_needed) {
+		/* For firmware TSO, assume ASF is disabled.
+		 * We'll disable TSO later if we discover ASF
+		 * is enabled in tg3_get_eeprom_hw_cfg().
+		 */
 		tg3_flag_set(tp, TSO_CAPABLE);
-	else {
+	} else {
 		tg3_flag_clear(tp, TSO_CAPABLE);
 		tg3_flag_clear(tp, TSO_BUG);
 		tp->fw_needed = NULL;
@@ -14290,6 +14294,12 @@ static int __devinit tg3_get_invariants(struct tg3 *tp)
 	 */
 	tg3_get_eeprom_hw_cfg(tp);
 
+	if (tp->fw_needed && tg3_flag(tp, ENABLE_ASF)) {
+		tg3_flag_clear(tp, TSO_CAPABLE);
+		tg3_flag_clear(tp, TSO_BUG);
+		tp->fw_needed = NULL;
+	}
+
 	if (tg3_flag(tp, ENABLE_APE)) {
 		/* Allow reads and writes to the
 		 * APE register and memory space.


