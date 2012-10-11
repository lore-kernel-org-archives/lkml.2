Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964835Ab2JKCOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:14:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49552 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934198Ab2JKCOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:14:43 -0400
X-Sasl-enc: QmGIPwPFu/WTPYR0X0Xh+JvP+3O7zttkKBolMxTEQqJ4 1349921682
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 40/84] tg3: Fix TSO CAP for 5704 devs w / ASF enabled
Date: Thu, 11 Oct 2012 11:03:24 +0900
Message-Id: <20121011015424.276412012@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tg3.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -13647,9 +13647,13 @@ static int __devinit tg3_get_invariants(
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
@@ -13887,6 +13891,12 @@ static int __devinit tg3_get_invariants(
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


