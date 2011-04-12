Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab1DLOsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:48:55 -0400
Received: from kroah.org ([198.145.64.141]:57639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab1DLOiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:21 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:54 2011
Message-Id: <20110412143554.289223792@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [059/105] staging: IIO: IMU: ADIS16400: Make sure only enabled scan_elements are pushed into the ring
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Hennerich <michael.hennerich@analog.com>

commit 0fea4d6192cb82789e28905240d3c1dac6529c7c upstream.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/iio/imu/adis16400_ring.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/staging/iio/imu/adis16400_ring.c
+++ b/drivers/staging/iio/imu/adis16400_ring.c
@@ -160,9 +160,10 @@ static void adis16400_trigger_bh_to_ring
 			       work_trigger_to_ring);
 	struct iio_ring_buffer *ring = st->indio_dev->ring;
 
-	int i = 0;
+	int i = 0, j;
 	s16 *data;
 	size_t datasize = ring->access.get_bytes_per_datum(ring);
+	unsigned long mask = ring->scan_mask;
 
 	data = kmalloc(datasize , GFP_KERNEL);
 	if (data == NULL) {
@@ -172,9 +173,12 @@ static void adis16400_trigger_bh_to_ring
 
 	if (ring->scan_count)
 		if (adis16400_spi_read_burst(&st->indio_dev->dev, st->rx) >= 0)
-			for (; i < ring->scan_count; i++)
+			for (; i < ring->scan_count; i++) {
+				j = __ffs(mask);
+				mask &= ~(1 << j);
 				data[i]	= be16_to_cpup(
-					(__be16 *)&(st->rx[i*2]));
+					(__be16 *)&(st->rx[j*2]));
+			}
 
 	/* Guaranteed to be aligned with 8 byte boundary */
 	if (ring->scan_timestamp)


