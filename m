Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab1CaOxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:53:30 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57440 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758068Ab1CaOwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:55 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 18/21] staging:iio:ring_sw add function needed for threaded irq.
Date: Thu, 31 Mar 2011 15:54:12 +0100
Message-Id: <1301583255-28468-19-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/ring_sw.c |   14 ++++++++++----
 drivers/staging/iio/ring_sw.h |    1 +
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
index 5fbf5ff..bc028ca 100644
--- a/drivers/staging/iio/ring_sw.c
+++ b/drivers/staging/iio/ring_sw.c
@@ -456,11 +456,8 @@ int iio_sw_ring_preenable(struct iio_dev *indio_dev)
 }
 EXPORT_SYMBOL(iio_sw_ring_preenable);
 
-void iio_sw_trigger_bh_to_ring(struct work_struct *work_s)
+void iio_sw_trigger_to_ring(struct iio_sw_ring_helper_state *st)
 {
-	struct iio_sw_ring_helper_state *st
-		= container_of(work_s, struct iio_sw_ring_helper_state,
-			work_trigger_to_ring);
 	struct iio_ring_buffer *ring = st->indio_dev->ring;
 	int len = 0;
 	size_t datasize = ring->access.get_bytes_per_datum(ring);
@@ -489,6 +486,15 @@ void iio_sw_trigger_bh_to_ring(struct work_struct *work_s)
 
 	return;
 }
+EXPORT_SYMBOL(iio_sw_trigger_to_ring);
+
+void iio_sw_trigger_bh_to_ring(struct work_struct *work_s)
+{
+	struct iio_sw_ring_helper_state *st
+		= container_of(work_s, struct iio_sw_ring_helper_state,
+			work_trigger_to_ring);
+	iio_sw_trigger_to_ring(st);
+}
 EXPORT_SYMBOL(iio_sw_trigger_bh_to_ring);
 
 void iio_sw_poll_func_th(struct iio_dev *indio_dev, s64 time)
diff --git a/drivers/staging/iio/ring_sw.h b/drivers/staging/iio/ring_sw.h
index ee86020..5b6a802 100644
--- a/drivers/staging/iio/ring_sw.h
+++ b/drivers/staging/iio/ring_sw.h
@@ -218,6 +218,7 @@ struct iio_sw_ring_helper_state {
 
 void iio_sw_poll_func_th(struct iio_dev *indio_dev, s64 time);
 void iio_sw_trigger_bh_to_ring(struct work_struct *work_s);
+void iio_sw_trigger_to_ring(struct iio_sw_ring_helper_state *st);
 
 #else /* CONFIG_IIO_RING_BUFFER*/
 struct iio_sw_ring_helper_state {
-- 
1.7.3.4

