Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab2AWXu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:50:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756191Ab2AWXuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:50:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:29 2012
Message-Id: <20120123234029.213341754@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:40:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stratos Psomadakis <psomas@gentoo.org>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [74/90] [SCSI] sym53c8xx: Fix NULL pointer dereference in slave_destroy
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stratos Psomadakis <psomas@gentoo.org>

commit cced5041ed5a2d1352186510944b0ddfbdbe4c0b upstream.

sym53c8xx_slave_destroy unconditionally assumes that sym53c8xx_slave_alloc has
succesesfully allocated a sym_lcb. This can lead to a NULL pointer dereference
(exposed by commit 4e6c82b).

Signed-off-by: Stratos Psomadakis <psomas@gentoo.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/sym53c8xx_2/sym_glue.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -839,6 +839,10 @@ static void sym53c8xx_slave_destroy(stru
 	struct sym_lcb *lp = sym_lp(tp, sdev->lun);
 	unsigned long flags;
 
+	/* if slave_alloc returned before allocating a sym_lcb, return */
+	if (!lp)
+		return;
+
 	spin_lock_irqsave(np->s.host->host_lock, flags);
 
 	if (lp->busy_itlq || lp->busy_itl) {


