Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161168Ab1FAIHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:07:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161146Ab1FAIHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:07:08 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:02:36 2011
Message-Id: <20110601080235.610959782@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:06 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arun Easi <arun.easi@qlogic.com>,
        Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>,
        James Bottomley <jbottomley@parallels.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [010/146] [SCSI] qla2xxx: Fix vport delete hang when logins are outstanding.
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arun Easi <arun.easi@qlogic.com>

commit 9f40682e2857a3c2ddb80a87b185af3c6a708346 upstream.

Timer is required to flush out entries that may be present in work queues.

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
Signed-off-by: James Bottomley <jbottomley@parallels.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_attr.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1877,14 +1877,15 @@ qla24xx_vport_delete(struct fc_vport *fc
 
 	scsi_remove_host(vha->host);
 
+	/* Allow timer to run to drain queued items, when removing vp */
+	qla24xx_deallocate_vp_id(vha);
+
 	if (vha->timer_active) {
 		qla2x00_vp_stop_timer(vha);
 		DEBUG15(printk(KERN_INFO "scsi(%ld): timer for the vport[%d]"
 		" = %p has stopped\n", vha->host_no, vha->vp_idx, vha));
 	}
 
-	qla24xx_deallocate_vp_id(vha);
-
 	/* No pending activities shall be there on the vha now */
 	DEBUG(msleep(random32()%10));  /* Just to see if something falls on
 					* the net we have placed below */


