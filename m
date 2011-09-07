Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab1IGQLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:11:45 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:48704 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab1IGQLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:11:43 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 1/6] SPI: add ability to say we want a cs change after every transfer.
Date: Wed,  7 Sep 2011 17:19:42 +0100
Message-Id: <1315412387-5765-2-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <4E679770.4090008@cam.ac.uk>
References: <4E679770.4090008@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows a number of drivers to make use of utility functions
such spi_write_then_read as well as making use of regmap possible.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/spi/spi.c       |    8 ++++++++
 include/linux/spi/spi.h |    2 ++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 4d1b9f5..bee8aee 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -781,6 +781,14 @@ static int __spi_async(struct spi_device *spi, struct spi_message *message)
 		}
 	}
 
+	if (spi->cs_between_transfers) {
+		struct spi_transfer *xfer;
+		list_for_each_entry(xfer, &message->transfers, transfer_list) {
+			if (!list_is_last(&xfer->transfer_list, &message->transfers))
+				xfer->cs_change = 1;
+		}
+	}
+	    
 	message->spi = spi;
 	message->status = -EINPROGRESS;
 	return master->transfer(spi, message);
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index bb4f5fb..f1e378d 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -90,6 +90,8 @@ struct spi_device {
 	void			*controller_data;
 	char			modalias[SPI_NAME_SIZE];
 
+  unsigned cs_between_transfers:1;
+
 	/*
 	 * likely need more hooks for more protocol options affecting how
 	 * the controller talks to each chip, like:
-- 
1.7.3.4

