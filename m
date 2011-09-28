Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198Ab1I1Wr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:47:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933121Ab1I1Wrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:47:52 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:42 2011
Message-Id: <20110928220142.593500295@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matt Carlson <mcarlson@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [164/244] tg3: Fix int selftest for recent devices.
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Carlson <mcarlson@broadcom.com>

commit 3aa1cdf87c0b3f2345e75c474acc32ebbf0a4724 upstream.

This patch fixes interrupt selftest failures for recent devices (57765,
5717, 5718. 5719, 5720) by disabling MSI one-shot mode and applying the
status tag workaround to the selftest code.

Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
Reviewed-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tg3.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -8982,7 +8982,7 @@ static int tg3_test_interrupt(struct tg3
 	 * Turn off MSI one shot mode.  Otherwise this test has no
 	 * observable way to know whether the interrupt was delivered.
 	 */
-	if (tg3_flag(tp, 57765_PLUS) && tg3_flag(tp, USING_MSI)) {
+	if (tg3_flag(tp, 57765_PLUS)) {
 		val = tr32(MSGINT_MODE) | MSGINT_MODE_ONE_SHOT_DISABLE;
 		tw32(MSGINT_MODE, val);
 	}
@@ -9010,6 +9010,10 @@ static int tg3_test_interrupt(struct tg3
 			break;
 		}
 
+		if (tg3_flag(tp, 57765_PLUS) &&
+		    tnapi->hw_status->status_tag != tnapi->last_tag)
+			tw32_mailbox_f(tnapi->int_mbox, tnapi->last_tag << 24);
+
 		msleep(10);
 	}
 
@@ -9024,7 +9028,7 @@ static int tg3_test_interrupt(struct tg3
 
 	if (intr_ok) {
 		/* Reenable MSI one shot mode. */
-		if (tg3_flag(tp, 57765_PLUS) && tg3_flag(tp, USING_MSI)) {
+		if (tg3_flag(tp, 57765_PLUS)) {
 			val = tr32(MSGINT_MODE) & ~MSGINT_MODE_ONE_SHOT_DISABLE;
 			tw32(MSGINT_MODE, val);
 		}


