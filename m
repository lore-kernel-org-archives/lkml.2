Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab0FAUxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:53:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61738 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab0FAUx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 02/31] istallion: use bit ops for the board flags
Date: Tue,  1 Jun 2010 22:52:42 +0200
Message-Id: <1275425591-8803-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18QpQUTR+ZkaKYuVyqkAE0GfrZB1MTzjo9nDLa
 3sVYfRqZeM2V4CNn44KiomLW3RSKE7+seUBG5oiUysmdEBwjmS
 L1DEqaciAzcFCby63/VyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This lets us avoid problems with races on the flag changes

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/char/istallion.c  |   36 ++++++++++++++++++------------------
 include/linux/istallion.h |    2 +-
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 750650c..5e9a81d 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -14,7 +14,6 @@
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
  *
- *	FIXME: brdp->state needs proper locking.
  */
 
 /*****************************************************************************/
@@ -204,9 +203,9 @@ static int		stli_shared;
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
@@ -817,7 +816,7 @@ static int stli_open(struct tty_struct *tty, struct file *filp)
 	brdp = stli_brds[brdnr];
 	if (brdp == NULL)
 		return -ENODEV;
-	if ((brdp->state & BST_STARTED) == 0)
+	if (!test_bit(BST_STARTED, &brdp->state))
 		return -ENODEV;
 	portnr = MINOR2PORT(minordev);
 	if (portnr > brdp->nrports)
@@ -1847,7 +1846,7 @@ static void stli_portinfo(struct seq_file *m, struct stlibrd *brdp, struct stlip
 	rc = stli_portcmdstats(NULL, portp);
 
 	uart = "UNKNOWN";
-	if (brdp->state & BST_STARTED) {
+	if (test_bit(BST_STARTED, &brdp->state)) {
 		switch (stli_comstats.hwid) {
 		case 0:	uart = "2681"; break;
 		case 1:	uart = "SC26198"; break;
@@ -1856,7 +1855,7 @@ static void stli_portinfo(struct seq_file *m, struct stlibrd *brdp, struct stlip
 	}
 	seq_printf(m, "%d: uart:%s ", portnr, uart);
 
-	if ((brdp->state & BST_STARTED) && (rc >= 0)) {
+	if (test_bit(BST_STARTED, &brdp->state) && rc >= 0) {
 		char sep;
 
 		seq_printf(m, "tx:%d rx:%d", (int) stli_comstats.txtotal,
@@ -2356,7 +2355,7 @@ static void stli_poll(unsigned long arg)
 		brdp = stli_brds[brdnr];
 		if (brdp == NULL)
 			continue;
-		if ((brdp->state & BST_STARTED) == 0)
+		if (!test_bit(BST_STARTED, &brdp->state))
 			continue;
 
 		spin_lock(&brd_lock);
@@ -3141,7 +3140,7 @@ static int stli_initecp(struct stlibrd *brdp)
 	}
 
 
-	brdp->state |= BST_FOUND;
+	set_bit(BST_FOUND, &brdp->state);
 	return 0;
 err_unmap:
 	iounmap(brdp->membase);
@@ -3298,7 +3297,7 @@ static int stli_initonb(struct stlibrd *brdp)
 	brdp->panels[0] = brdp->nrports;
 
 
-	brdp->state |= BST_FOUND;
+	set_bit(BST_FOUND, &brdp->state);
 	return 0;
 err_unmap:
 	iounmap(brdp->membase);
@@ -3408,7 +3407,7 @@ stli_donestartup:
 	spin_unlock_irqrestore(&brd_lock, flags);
 
 	if (rc == 0)
-		brdp->state |= BST_STARTED;
+		set_bit(BST_STARTED, &brdp->state);
 
 	if (! stli_timeron) {
 		stli_timeron++;
@@ -3711,7 +3710,7 @@ static int __devinit stli_pciprobe(struct pci_dev *pdev,
 	if (retval)
 		goto err_null;
 
-	brdp->state |= BST_PROBED;
+	set_bit(BST_PROBED, &brdp->state);
 	pci_set_drvdata(pdev, brdp);
 
 	EBRDENABLE(brdp);
@@ -3842,7 +3841,7 @@ static int __init stli_initbrds(void)
 			brdp = stli_brds[i];
 			if (brdp == NULL)
 				continue;
-			if (brdp->state & BST_FOUND) {
+			if (test_bit(BST_FOUND, &brdp->state)) {
 				EBRDENABLE(brdp);
 				brdp->enable = NULL;
 				brdp->disable = NULL;
@@ -4079,7 +4078,7 @@ static int stli_portcmdstats(struct tty_struct *tty, struct stliport *portp)
 		return -ENODEV;
 
 	mutex_lock(&portp->port.mutex);
-	if (brdp->state & BST_STARTED) {
+	if (test_bit(BST_STARTED, &brdp->state)) {
 		if ((rc = stli_cmdwait(brdp, portp, A_GETSTATS,
 		    &stli_cdkstats, sizeof(asystats_t), 1)) < 0) {
 			mutex_unlock(&portp->port.mutex);
@@ -4194,7 +4193,7 @@ static int stli_clrportstats(struct stliport *portp, comstats_t __user *cp)
 
 	mutex_lock(&portp->port.mutex);
 
-	if (brdp->state & BST_STARTED) {
+	if (test_bit(BST_STARTED, &brdp->state)) {
 		if ((rc = stli_cmdwait(brdp, portp, A_CLEARSTATS, NULL, 0, 0)) < 0) {
 			mutex_unlock(&portp->port.mutex);
 			return rc;
@@ -4323,10 +4322,10 @@ static long stli_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
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
@@ -4382,7 +4381,8 @@ static void istallion_cleanup_isa(void)
 	unsigned int j;
 
 	for (j = 0; (j < stli_nrbrds); j++) {
-		if ((brdp = stli_brds[j]) == NULL || (brdp->state & BST_PROBED))
+		if ((brdp = stli_brds[j]) == NULL ||
+				test_bit(BST_PROBED, &brdp->state))
 			continue;
 
 		stli_cleanup_ports(brdp);
diff --git a/include/linux/istallion.h b/include/linux/istallion.h
index 7faca98..ad700a6 100644
--- a/include/linux/istallion.h
+++ b/include/linux/istallion.h
@@ -86,7 +86,7 @@ struct stlibrd {
 	unsigned long	magic;
 	unsigned int	brdnr;
 	unsigned int	brdtype;
-	unsigned int	state;
+	unsigned long	state;
 	unsigned int	nrpanels;
 	unsigned int	nrports;
 	unsigned int	nrdevs;
-- 
1.7.0.4

