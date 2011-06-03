Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1FCXok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 19:44:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:47390 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377Ab1FCXoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 19:44:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,317,1304319600"; 
   d="scan'208";a="13344067"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Russ Gorby <russ.gorby@intel.com>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com, russ.gorby@intel.com
Subject: [PATCHv2 6/7] tty: n_gsm: Fixed logic to decode break signal in modem status
Date: Fri,  3 Jun 2011 16:44:01 -0700
Message-Id: <1307144642-5915-7-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCHv2 0/5] N_GSM patchset : 06/03/2011: v2>
References: <[PATCHv2 0/5] N_GSM patchset : 06/03/2011: v2>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe we were grabbing the break bits from the wrong
field in the u32

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/tty/n_gsm.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 2908199..7f95bfd 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1017,10 +1017,22 @@ static void gsm_control_reply(struct gsm_mux *gsm, int cmd, u8 *data,
  */
 
 static void gsm_process_modem(struct tty_struct *tty, struct gsm_dlci *dlci,
-							u32 modem)
+							u32 modem, int clen)
 {
 	int  mlines = 0;
-	u8 brk = modem >> 6;
+	u8 brk = 0;
+
+	/* The modem status command can either contain one octet (v.24 signals)
+	   or two octets (v.24 signals + break signals). The length field will
+	   either be 2 or 3 respectively. This is specified in section
+	   5.4.6.3.7 of the  27.010 mux spec. */
+
+	if (clen == 2)
+		modem = modem & 0x7f;
+	else {
+		brk = modem & 0x7f;
+		modem = (modem >> 7) & 0x7f;
+	};
 
 	/* Flow control/ready to communicate */
 	if (modem & MDM_FC) {
@@ -1094,7 +1106,7 @@ static void gsm_control_modem(struct gsm_mux *gsm, u8 *data, int clen)
 			return;
 	}
 	tty = tty_port_tty_get(&dlci->port);
-	gsm_process_modem(tty, dlci, modem);
+	gsm_process_modem(tty, dlci, modem, clen);
 	if (tty) {
 		tty_wakeup(tty);
 		tty_kref_put(tty);
@@ -1515,12 +1527,13 @@ static void gsm_dlci_begin_close(struct gsm_dlci *dlci)
  *	open we shovel the bits down it, if not we drop them.
  */
 
-static void gsm_dlci_data(struct gsm_dlci *dlci, u8 *data, int len)
+static void gsm_dlci_data(struct gsm_dlci *dlci, u8 *data, int clen)
 {
 	/* krefs .. */
 	struct tty_port *port = &dlci->port;
 	struct tty_struct *tty = tty_port_tty_get(port);
 	unsigned int modem = 0;
+	int len = clen;
 
 	if (debug & 16)
 		pr_debug("%d bytes for tty %p\n", len, tty);
@@ -1540,7 +1553,7 @@ static void gsm_dlci_data(struct gsm_dlci *dlci, u8 *data, int len)
 				if (len == 0)
 					return;
 			}
-			gsm_process_modem(tty, dlci, modem);
+			gsm_process_modem(tty, dlci, modem, clen);
 		/* Line state will go via DLCI 0 controls only */
 		case 1:
 		default:
-- 
1.7.0.4

