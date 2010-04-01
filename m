Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab0DAQel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:34:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44892 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757923Ab0DAQeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:34:18 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 06/14] istallion: use bit ops for the board flags
To: linux-kernel@vger.kernel.org
Date: Thu, 01 Apr 2010 17:05:28 +0100
Message-ID: <20100401160525.8882.50125.stgit@localhost.localdomain>
In-Reply-To: <20100401155513.8882.54006.stgit@localhost.localdomain>
References: <20100401155513.8882.54006.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets us avoid problems with races on the flag changes

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/istallion.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)


diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 3699e30..1937e61 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -204,9 +204,9 @@ static int		stli_shared;
  *	the board has been detected, and whether it is actually running a slave
  *	or not.
  */
-#define	BST_FOUND	0x1
-#define	BST_STARTED	0x2
-#define	BST_PROBED	0x4
+#define	BST_FOUND	0
+#define	BST_STARTED	1
+#define	BST_PROBED	2
 
 /*
  *	Define the set of port state flags. These are marked for internal
@@ -817,7 +817,7 @@ static int stli_open(struct tty_struct *tty, struct file *filp)
 	brdp = stli_brds[brdnr];
 	if (brdp == NULL)
 		return -ENODEV;
-	if ((brdp->state & BST_STARTED) == 0)
+	if (!(test_bit(BST_STARTED, &brdp->state))
 		return -ENODEV;
 	portnr = MINOR2PORT(minordev);
 	if (portnr > brdp->nrports)
@@ -1845,7 +1845,7 @@ static void stli_portinfo(struct seq_file *m, struct stlibrd *brdp, struct stlip
 	rc = stli_portcmdstats(NULL, portp);
 
 	uart = "UNKNOWN";
-	if (brdp->state & BST_STARTED) {
+	if (test_bit(BST_STARTED, &brdp->state)) {
 		switch (stli_comstats.hwid) {
 		case 0:	uart = "2681"; break;
 		case 1:	uart = "SC26198"; break;
@@ -1854,7 +1854,7 @@ static void stli_portinfo(struct seq_file *m, struct stlibrd *brdp, struct stlip
 	}
 	seq_printf(m, "%d: uart:%s ", portnr, uart);
 
-	if ((brdp->state & BST_STARTED) && (rc >= 0)) {
+	if (test_bit(BST_STARTED, &brdp->state) && rc >= 0) {
 		char sep;
 
 		seq_printf(m, "tx:%d rx:%d", (int) stli_comstats.txtotal,
@@ -2354,7 +2354,7 @@ static void stli_poll(unsigned long arg)
 		brdp = stli_brds[brdnr];
 		if (brdp == NULL)
 			continue;
-		if ((brdp->state & BST_STARTED) == 0)
+		if (!test_bit(BST_STARTED, &brdp->state))
 			continue;
 
 		spin_lock(&brd_lock);
@@ -3139,7 +3139,7 @@ static int stli_initecp(struct stlibrd *brdp)
 	}
 
 
-	brdp->state |= BST_FOUND;
+	set_bit(BST_FOUND, &brdp->state);
 	return 0;
 err_unmap:
 	iounmap(brdp->membase);
@@ -3296,7 +3296,7 @@ static int stli_initonb(struct stlibrd *brdp)
 	brdp->panels[0] = brdp->nrports;
 
 
-	brdp->state |= BST_FOUND;
+	set_bit(BST_FOUND, &brdp->state);
 	return 0;
 err_unmap:
 	iounmap(brdp->membase);
@@ -3406,7 +3406,7 @@ stli_donestartup:
 	spin_unlock_irqrestore(&brd_lock, flags);
 
 	if (rc == 0)
-		brdp->state |= BST_STARTED;
+		set_bit(BST_STARTED, &brdp->state);
 
 	if (! stli_timeron) {
 		stli_timeron++;
@@ -3709,7 +3709,7 @@ static int __devinit stli_pciprobe(struct pci_dev *pdev,
 	if (retval)
 		goto err_null;
 
-	brdp->state |= BST_PROBED;
+	set_bit(BST_PROBED, &brdp->state);
 	pci_set_drvdata(pdev, brdp);
 
 	EBRDENABLE(brdp);
@@ -3840,7 +3840,7 @@ static int __init stli_initbrds(void)
 			brdp = stli_brds[i];
 			if (brdp == NULL)
 				continue;
-			if (brdp->state & BST_FOUND) {
+			if (test_bit(BST_FOUND, &brdp->state)) {
 				EBRDENABLE(brdp);
 				brdp->enable = NULL;
 				brdp->disable = NULL;
@@ -4079,7 +4079,7 @@ static int stli_portcmdstats(struct tty_struct *tty, struct stliport *portp)
 		return -ENODEV;
 
 	mutex_lock(&portp->port.mutex);
-	if (brdp->state & BST_STARTED) {
+	if (test_bit(BST_STARTED, &brdp->state)) {
 		if ((rc = stli_cmdwait(brdp, portp, A_GETSTATS,
 		    &stli_cdkstats, sizeof(asystats_t), 1)) < 0) {
 			mutex_unlock(&portp->port.mutex);
@@ -4194,7 +4194,7 @@ static int stli_clrportstats(struct stliport *portp, comstats_t __user *cp)
 
 	mutex_lock(&portp->port.mutex);
 
-	if (brdp->state & BST_STARTED) {
+	if (test_bit(BST_STARTED, &brdp->state)) {
 		if ((rc = stli_cmdwait(brdp, portp, A_CLEARSTATS, NULL, 0, 0)) < 0) {
 			mutex_unlock(&portp->port.mutex);
 			return rc;
@@ -4323,10 +4323,10 @@ static long stli_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		rc = stli_startbrd(brdp);
 		break;
 	case STL_BSTOP:
-		brdp->state &= ~BST_STARTED;
+		clear_bit(BST_STARTED, &brdp->state);
 		break;
 	case STL_BRESET:
-		brdp->state &= ~BST_STARTED;
+		clear_bit(BST_STARTED, &brdp->state);
 		EBRDRESET(brdp);
 		if (stli_shared == 0) {
 			if (brdp->reenable != NULL)
@@ -4382,7 +4382,8 @@ static void istallion_cleanup_isa(void)
 	unsigned int j;
 
 	for (j = 0; (j < stli_nrbrds); j++) {
-		if ((brdp = stli_brds[j]) == NULL || (brdp->state & BST_PROBED))
+		if ((brdp = stli_brds[j]) == NULL ||
+				test_bit(BST_PROBED, &brdp->state))
 			continue;
 
 		stli_cleanup_ports(brdp);

