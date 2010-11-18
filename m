Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab0KRTVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:21:42 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35939 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683Ab0KRTVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:21:40 -0500
X-Sieve: CMU Sieve 2.3
X-Spam-TestScore: ALL_TRUSTED=-1.44,DNS_FROM_RFC_ABUSE=0.479
X-Spam-TokenSummary: Bayes not run.
X-Spam-Relay-Country: 
From: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Sonny Rao <sonnyrao@linux.vnet.ibm.com>, Milton Miller <miltonm@bga.com>,
        Matthew Wilcox <matthew@wil.cx>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] Fix crash in sym53c8xx_2 error path
Date: Thu, 18 Nov 2010 04:23:15 -0600
Message-Id: <1290075796-2975-2-git-send-email-sonnyrao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1290075796-2975-1-git-send-email-sonnyrao@linux.vnet.ibm.com>
References: <1290075796-2975-1-git-send-email-sonnyrao@linux.vnet.ibm.com>
X-Xagent-From: sonnyrao@linux.vnet.ibm.com
X-Xagent-To: sonnyrao@linux.vnet.ibm.com
X-Xagent-Gateway: vmsdvm6.vnet.ibm.com (XAGENTU at VMSDVM6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have observed NULL pointer dereference crashes in sym53c8xx_2
when a command cannot be found, fix it to check for this case
and print out [unknown cmd] if this happens.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
---
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   50 +++++++++++++++++++++++++++-------
 1 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 2c3e89d..ad9543e 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -70,9 +70,15 @@ static void sym_printl_hex(u_char *p, int n)
 	printf (".\n");
 }

-static void sym_print_msg(struct sym_ccb *cp, char *label, u_char *msg)
+static void sym_print_msg(struct sym_hcb *np, struct sym_ccb *cp, char *label,
+	u_char *msg)
 {
-	sym_print_addr(cp->cmd, "%s: ", label);
+	if (cp->cmd) {
+		sym_print_addr(cp->cmd, "%s: ", label);
+	} else {
+		shost_printk(KERN_INFO, np->s.host, "[unknown cmd]"
+		"%s: ", label);
+	}

 	spi_print_msg(msg);
 	printf("\n");
@@ -4412,7 +4418,11 @@ static void sym_int_sir(struct sym_hcb *np)
 	 *  been selected with ATN.  We do not want to handle that.
 	 */
 	case SIR_SEL_ATN_NO_MSG_OUT:
-		scmd_printk(KERN_WARNING, cp->cmd,
+		if (cp)
+			scmd_printk(KERN_WARNING, cp->cmd,
+				"No MSG OUT phase after selection with ATN\n");
+		else
+			shost_printk(KERN_WARNING, np->s.host, "[unknown cmd]"
 				"No MSG OUT phase after selection with ATN\n");
 		goto out_stuck;
 	/*
@@ -4420,7 +4430,11 @@ static void sym_int_sir(struct sym_hcb *np)
 	 *  having reselected the initiator.
 	 */
 	case SIR_RESEL_NO_MSG_IN:
-		scmd_printk(KERN_WARNING, cp->cmd,
+		if (cp)
+			scmd_printk(KERN_WARNING, cp->cmd,
+				"No MSG IN phase after reselection\n");
+		else
+			shost_printk(KERN_WARNING, np->s.host, "[unknown cmd]"
 				"No MSG IN phase after reselection\n");
 		goto out_stuck;
 	/*
@@ -4428,7 +4442,11 @@ static void sym_int_sir(struct sym_hcb *np)
 	 *  an IDENTIFY.
 	 */
 	case SIR_RESEL_NO_IDENTIFY:
-		scmd_printk(KERN_WARNING, cp->cmd,
+		if (cp)
+			scmd_printk(KERN_WARNING, cp->cmd,
+				"No IDENTIFY after reselection\n");
+		else
+			shost_printk(KERN_WARNING, np->s.host, "[unknown cmd]"
 				"No IDENTIFY after reselection\n");
 		goto out_stuck;
 	/*
@@ -4457,7 +4475,11 @@ static void sym_int_sir(struct sym_hcb *np)
 	case SIR_RESEL_ABORTED:
 		np->lastmsg = np->msgout[0];
 		np->msgout[0] = M_NOOP;
-		scmd_printk(KERN_WARNING, cp->cmd,
+		if (cp)
+			scmd_printk(KERN_WARNING, cp->cmd,
+			"message %x sent on bad reselection\n", np->lastmsg);
+		else
+			shost_printk(KERN_WARNING, np->s.host, "[unknown cmd]"
 			"message %x sent on bad reselection\n", np->lastmsg);
 		goto out;
 	/*
@@ -4491,7 +4513,7 @@ static void sym_int_sir(struct sym_hcb *np)
 	 *  REJECT message.
 	 */
 	case SIR_REJECT_TO_SEND:
-		sym_print_msg(cp, "M_REJECT to send for ", np->msgin);
+		sym_print_msg(np, cp, "M_REJECT to send for ", np->msgin);
 		np->msgout[0] = M_REJECT;
 		goto out;
 	/*
@@ -4555,7 +4577,7 @@ static void sym_int_sir(struct sym_hcb *np)
 			switch (np->msgin [2]) {
 			case M_X_MODIFY_DP:
 				if (DEBUG_FLAGS & DEBUG_POINTER)
-					sym_print_msg(cp, "extended msg ",
+					sym_print_msg(np, cp, "extended msg ",
 						      np->msgin);
 				tmp = (np->msgin[3]<<24) + (np->msgin[4]<<16) + 
 				      (np->msgin[5]<<8)  + (np->msgin[6]);
@@ -4583,7 +4605,7 @@ static void sym_int_sir(struct sym_hcb *np)
 		 */
 		case M_IGN_RESIDUE:
 			if (DEBUG_FLAGS & DEBUG_POINTER)
-				sym_print_msg(cp, "1 or 2 byte ", np->msgin);
+				sym_print_msg(np, cp, "1 or 2 byte ", np->msgin);
 			if (cp->host_flags & HF_SENSE)
 				OUTL_DSP(np, SCRIPTA_BA(np, clrack));
 			else
@@ -4593,7 +4615,13 @@ static void sym_int_sir(struct sym_hcb *np)
 			if (INB(np, HS_PRT) == HS_NEGOTIATE)
 				sym_nego_rejected(np, tp, cp);
 			else {
-				sym_print_addr(cp->cmd,
+				if (cp)
+					sym_print_addr(cp->cmd,
+					"M_REJECT received (%x:%x).\n",
+					scr_to_cpu(np->lastmsg), np->msgout[0]);
+				else
+					shost_printk(KERN_INFO, np->s.host,
+					"[unknown cmd]"
 					"M_REJECT received (%x:%x).\n",
 					scr_to_cpu(np->lastmsg), np->msgout[0]);
 			}
@@ -4608,7 +4636,7 @@ static void sym_int_sir(struct sym_hcb *np)
 	 *  Ignore all MSG IN phases and reject it.
 	 */
 	case SIR_MSG_WEIRD:
-		sym_print_msg(cp, "WEIRD message received", np->msgin);
+		sym_print_msg(np, cp, "WEIRD message received", np->msgin);
 		OUTL_DSP(np, SCRIPTB_BA(np, msg_weird));
 		return;
 	/*
-- 
1.5.6.5

