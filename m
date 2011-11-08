Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1KHSCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:02:35 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:38926
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751822Ab1KHSCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:02:34 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 10/11] Staging: hv: storvsc: Support hot add of scsi disks
Date: Tue,  8 Nov 2011 09:01:49 -0800
Message-Id: <1320771710-29139-10-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1320771710-29139-1-git-send-email-kys@microsoft.com>
References: <1320771677-29095-1-git-send-email-kys@microsoft.com>
 <1320771710-29139-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support hot add of scsi disks.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 9153641..7c82d14 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -304,6 +304,30 @@ struct storvsc_cmd_request {
 	struct hv_storvsc_request request;
 };
 
+struct storvsc_scan_work {
+	struct work_struct work;
+	struct Scsi_Host *host;
+	uint lun;
+};
+
+static void storvsc_bus_scan(struct work_struct *work)
+{
+	struct storvsc_scan_work *wrk;
+	int id, order_id;
+
+	wrk = container_of(work, struct storvsc_scan_work, work);
+	for (id = 0; id < wrk->host->max_id; ++id) {
+		if (wrk->host->reverse_ordering)
+			order_id = wrk->host->max_id - id - 1;
+		else
+			order_id = id;
+
+		scsi_scan_target(&wrk->host->shost_gendev, 0,
+				order_id, SCAN_WILD_CARD, 1);
+	}
+	kfree(wrk);
+}
+
 static inline struct storvsc_device *get_out_stor_device(
 					struct hv_device *device)
 {
@@ -551,11 +575,25 @@ static void storvsc_on_receive(struct hv_device *device,
 			     struct vstor_packet *vstor_packet,
 			     struct hv_storvsc_request *request)
 {
+	struct storvsc_scan_work *work;
+	struct storvsc_device *stor_device;
+
 	switch (vstor_packet->operation) {
 	case VSTOR_OPERATION_COMPLETE_IO:
 		storvsc_on_io_completion(device, vstor_packet, request);
 		break;
+
 	case VSTOR_OPERATION_REMOVE_DEVICE:
+	case VSTOR_OPERATION_ENUMERATE_BUS:
+		stor_device = get_in_stor_device(device);
+		work = kmalloc(sizeof(struct storvsc_scan_work), GFP_ATOMIC);
+		if (!work)
+			return;
+
+		INIT_WORK(&work->work, storvsc_bus_scan);
+		work->host = stor_device->host;
+		schedule_work(&work->work);
+		break;
 
 	default:
 		break;
-- 
1.7.4.1

