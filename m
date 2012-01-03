Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab2ACWgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:36:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524Ab2ACWgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:36:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:32 2012
Message-Id: <20120103223031.984230471@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steffen Maier <maier@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [08/67] SCSI: zfcp: return early from slave_destroy if slave_alloc returned early
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Maier <maier@linux.vnet.ibm.com>

commit 44f747fff6e9f027a4866c1a6864e26ae7c510c8 upstream.

zfcp_scsi_slave_destroy erroneously always tried to finish its task
even if the corresponding previous zfcp_scsi_slave_alloc returned
early. This can lead to kernel page faults on accessing uninitialized
fields of struct zfcp_scsi_dev in zfcp_erp_lun_shutdown_wait. Take the
port field of the struct to determine if slave_alloc returned early.

This zfcp bug is exposed by 4e6c82b (in turn fixing f7c9c6b to be
compatible with 21208ae) which can call slave_destroy for a
corresponding previous slave_alloc that did not finish.

This patch is based on James Bottomley's fix suggestion in
http://www.spinics.net/lists/linux-scsi/msg55449.html.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/s390/scsi/zfcp_scsi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -57,6 +57,10 @@ static void zfcp_scsi_slave_destroy(stru
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 
+	/* if previous slave_alloc returned early, there is nothing to do */
+	if (!zfcp_sdev->port)
+		return;
+
 	zfcp_erp_lun_shutdown_wait(sdev, "scssd_1");
 	put_device(&zfcp_sdev->port->dev);
 }


