Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161188Ab1FAJbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:31:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161100Ab1FAIHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:07:03 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:02:35 2011
Message-Id: <20110601080234.958754430@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:05 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>,
        James Bottomley <jbottomley@parallels.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [009/146] [SCSI] qla2xxx: Fix virtual port failing to login after chip reset.
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

commit cefcaba67ab97fb756b3a6af5139c94d861b660d upstream.

This patch ensures qla82xx_watchdog is not being run for the vport. It also
makes sure that beacon ON is not done for the vport, as it will lead to the
waking up of the dpc thread again and again.

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
Signed-off-by: James Bottomley <jbottomley@parallels.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_os.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3608,7 +3608,8 @@ qla2x00_timer(scsi_qla_host_t *vha)
 	if (!pci_channel_offline(ha->pdev))
 		pci_read_config_word(ha->pdev, PCI_VENDOR_ID, &w);
 
-	if (IS_QLA82XX(ha)) {
+	/* Make sure qla82xx_watchdog is run only for physical port */
+	if (!vha->vp_idx && IS_QLA82XX(ha)) {
 		if (test_bit(ISP_QUIESCE_NEEDED, &vha->dpc_flags))
 			start_dpc++;
 		qla82xx_watchdog(vha);
@@ -3679,8 +3680,8 @@ qla2x00_timer(scsi_qla_host_t *vha)
 		    atomic_read(&vha->loop_down_timer)));
 	}
 
-	/* Check if beacon LED needs to be blinked */
-	if (ha->beacon_blink_led == 1) {
+	/* Check if beacon LED needs to be blinked for physical host only */
+	if (!vha->vp_idx && (ha->beacon_blink_led == 1)) {
 		set_bit(BEACON_BLINK_NEEDED, &vha->dpc_flags);
 		start_dpc++;
 	}


