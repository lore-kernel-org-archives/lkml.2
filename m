Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab0LHCJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:09:05 -0500
Received: from kroah.org ([198.145.64.141]:58385 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149Ab0LHArY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:24 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:30 2010
Message-Id: <20101208004430.302634016@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [060/127] libata: fix NULL sdev dereference race in atapi_qc_complete()
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 2a5f07b5ec098edc69e05fdd2f35d3fbb1235723 upstream.

SCSI commands may be issued between __scsi_add_device() and dev->sdev
assignment, so it's unsafe for ata_qc_complete() to dereference
dev->sdev->locked without checking whether it's NULL or not.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-scsi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2497,8 +2497,11 @@ static void atapi_qc_complete(struct ata
 		 *
 		 * If door lock fails, always clear sdev->locked to
 		 * avoid this infinite loop.
+		 *
+		 * This may happen before SCSI scan is complete.  Make
+		 * sure qc->dev->sdev isn't NULL before dereferencing.
 		 */
-		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL)
+		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
 			qc->dev->sdev->locked = 0;
 
 		qc->scsicmd->result = SAM_STAT_CHECK_CONDITION;


