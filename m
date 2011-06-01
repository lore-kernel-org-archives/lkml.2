Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161154Ab1FAIHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:07:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161146Ab1FAIG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:06:58 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:02:34 2011
Message-Id: <20110601080234.337904530@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:04 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arun Easi <arun.easi@qlogic.com>,
        Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>,
        James Bottomley <jbottomley@parallels.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [008/146] [SCSI] qla2xxx: Fix hang during driver unload when vport is active.
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arun Easi <arun.easi@qlogic.com>

commit 43ebf16d762b082663976b679b813e1b546548d1 upstream.

Bumping ref count during fc_vport_terminate() was the cause. vport
delete would wait for ref count to drop to zero and that would never
happen.

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
Signed-off-by: James Bottomley <jbottomley@parallels.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_os.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2359,21 +2359,26 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	base_vha = pci_get_drvdata(pdev);
 	ha = base_vha->hw;
 
-	spin_lock_irqsave(&ha->vport_slock, flags);
-	list_for_each_entry(vha, &ha->vp_list, list) {
-		atomic_inc(&vha->vref_count);
+	mutex_lock(&ha->vport_lock);
+	while (ha->cur_vport_count) {
+		struct Scsi_Host *scsi_host;
 
-		if (vha->fc_vport) {
-			spin_unlock_irqrestore(&ha->vport_slock, flags);
+		spin_lock_irqsave(&ha->vport_slock, flags);
 
-			fc_vport_terminate(vha->fc_vport);
+		BUG_ON(base_vha->list.next == &ha->vp_list);
+		/* This assumes first entry in ha->vp_list is always base vha */
+		vha = list_first_entry(&base_vha->list, scsi_qla_host_t, list);
+		scsi_host = scsi_host_get(vha->host);
 
-			spin_lock_irqsave(&ha->vport_slock, flags);
-		}
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+		mutex_unlock(&ha->vport_lock);
 
-		atomic_dec(&vha->vref_count);
+		fc_vport_terminate(vha->fc_vport);
+		scsi_host_put(vha->host);
+
+		mutex_lock(&ha->vport_lock);
 	}
-	spin_unlock_irqrestore(&ha->vport_slock, flags);
+	mutex_unlock(&ha->vport_lock);
 
 	set_bit(UNLOADING, &base_vha->dpc_flags);
 


