Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab1I1W6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:58:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933255Ab1I1WtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:49:01 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:48 2011
Message-Id: <20110928220147.920671965@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [214/244] cnic: Fix race conditions with firmware
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Chan <mchan@broadcom.com>

commit 101c40c8cb0d10c30f423805f9f5b7a75956832d upstream.

During iSCSI connection terminations, if the target is also terminating
at about the same time, the firmware may not complete the driver's
request to close or reset the connection.  This is fixed by handling
other events (instead of the expected completion event) as an indication
that the driver's request has been rejected.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/cnic.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/net/cnic.c
+++ b/drivers/net/cnic.c
@@ -3767,7 +3767,13 @@ static void cnic_cm_process_kcqe(struct
 		break;
 
 	case L4_KCQE_OPCODE_VALUE_CLOSE_RECEIVED:
-		cnic_cm_upcall(cp, csk, opcode);
+		/* after we already sent CLOSE_REQ */
+		if (test_bit(CNIC_F_BNX2X_CLASS, &dev->flags) &&
+		    !test_bit(SK_F_OFFLD_COMPLETE, &csk->flags) &&
+		    csk->state == L4_KCQE_OPCODE_VALUE_CLOSE_COMP)
+			cp->close_conn(csk, L4_KCQE_OPCODE_VALUE_RESET_COMP);
+		else
+			cnic_cm_upcall(cp, csk, opcode);
 		break;
 	}
 	csk_put(csk);
@@ -3821,12 +3827,14 @@ static int cnic_ready_to_close(struct cn
 	}
 
 	/* 1. If event opcode matches the expected event in csk->state
-	 * 2. If the expected event is CLOSE_COMP, we accept any event
+	 * 2. If the expected event is CLOSE_COMP or RESET_COMP, we accept any
+	 *    event
 	 * 3. If the expected event is 0, meaning the connection was never
 	 *    never established, we accept the opcode from cm_abort.
 	 */
 	if (opcode == csk->state || csk->state == 0 ||
-	    csk->state == L4_KCQE_OPCODE_VALUE_CLOSE_COMP) {
+	    csk->state == L4_KCQE_OPCODE_VALUE_CLOSE_COMP ||
+	    csk->state == L4_KCQE_OPCODE_VALUE_RESET_COMP) {
 		if (!test_and_set_bit(SK_F_CLOSING, &csk->flags)) {
 			if (csk->state == 0)
 				csk->state = opcode;


