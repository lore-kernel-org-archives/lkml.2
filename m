Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1KGUyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:54:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36648 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab1KGUxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:53:01 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>,
        Andrew Skalski <askalski@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/7] Input: ALPS - Remove assumptions about packet size
Date: Mon,  7 Nov 2011 14:52:37 -0600
Message-Id: <1320699160-28492-5-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320699160-28492-1-git-send-email-seth.forshee@canonical.com>
References: <1320699160-28492-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for version 4 protocol support, which has 8-byte
data packets, remove all hard-coded assumptions about packet size
and use psmouse->pktsize instead.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/input/mouse/alps.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 77b776d..44a0a71 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -308,7 +308,7 @@ static void alps_flush_packet(unsigned long data)
 
 	serio_pause_rx(psmouse->ps2dev.serio);
 
-	if (psmouse->pktcnt == 6) {
+	if (psmouse->pktcnt == psmouse->pktsize) {
 
 		/*
 		 * We did not any more data in reasonable amount of time.
@@ -359,8 +359,8 @@ static psmouse_ret_t alps_process_byte(struct psmouse *psmouse)
 		return PSMOUSE_BAD_DATA;
 	}
 
-	/* Bytes 2 - 6 should have 0 in the highest bit */
-	if (psmouse->pktcnt >= 2 && psmouse->pktcnt <= 6 &&
+	/* Bytes 2 - pktsize should have 0 in the highest bit */
+	if (psmouse->pktcnt >= 2 && psmouse->pktcnt <= psmouse->pktsize &&
 	    (psmouse->packet[psmouse->pktcnt - 1] & 0x80)) {
 		psmouse_dbg(psmouse, "refusing packet[%i] = %x\n",
 			    psmouse->pktcnt - 1,
@@ -368,7 +368,7 @@ static psmouse_ret_t alps_process_byte(struct psmouse *psmouse)
 		return PSMOUSE_BAD_DATA;
 	}
 
-	if (psmouse->pktcnt == 6) {
+	if (psmouse->pktcnt == psmouse->pktsize) {
 		alps_process_packet(psmouse);
 		return PSMOUSE_FULL_PACKET;
 	}
@@ -529,7 +529,7 @@ static int alps_tap_mode(struct psmouse *psmouse, int enable)
 static int alps_poll(struct psmouse *psmouse)
 {
 	struct alps_data *priv = psmouse->private;
-	unsigned char buf[6];
+	unsigned char buf[sizeof(psmouse->packet)];
 	bool poll_failed;
 
 	if (priv->i->flags & ALPS_PASS)
-- 
1.7.5.4

