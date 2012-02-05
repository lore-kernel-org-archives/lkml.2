Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab2BEW2U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:28:20 -0500
Received: from 1wt.eu ([62.212.114.60]:62162 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab2BEW1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:27:36 -0500
Message-Id: <20120205220952.614104123@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:03 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stratos Psomadakis <psomas@gentoo.org>,
        James Bottomley <JBottomley@Parallels.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 74/91] sym53c8xx: Fix NULL pointer dereference in slave_destroy
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit cced5041ed5a2d1352186510944b0ddfbdbe4c0b upstream.

sym53c8xx_slave_destroy unconditionally assumes that sym53c8xx_slave_alloc has
succesesfully allocated a sym_lcb. This can lead to a NULL pointer dereference
(exposed by commit 4e6c82b).

Signed-off-by: Stratos Psomadakis <psomas@gentoo.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
--- longterm-2.6.27.orig/drivers/scsi/sym53c8xx_2/sym_glue.c	2012-02-05 22:34:32.760914610 +0100
+++ longterm-2.6.27/drivers/scsi/sym53c8xx_2/sym_glue.c	2012-02-05 22:34:45.383915058 +0100
@@ -821,6 +821,10 @@
 	struct sym_hcb *np = sym_get_hcb(sdev->host);
 	struct sym_lcb *lp = sym_lp(&np->target[sdev->id], sdev->lun);
 
+	/* if slave_alloc returned before allocating a sym_lcb, return */
+	if (!lp)
+		return;
+
 	if (lp->itlq_tbl)
 		sym_mfree_dma(lp->itlq_tbl, SYM_CONF_MAX_TASK * 4, "ITLQ_TBL");
 	kfree(lp->cb_tags);


