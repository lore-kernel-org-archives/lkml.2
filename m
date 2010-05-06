Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab0EFLDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 07:03:04 -0400
Received: from mx1.emlix.com ([193.175.82.87]:40124 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab0EFLC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 07:02:59 -0400
From: "Oskar Schirmer" <os@emlix.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Oskar Schirmer <os@emlix.com>,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>
Subject: [PATCH] ad7877: keep dma rx buffers in seperate cache lines
Date: Thu,  6 May 2010 12:37:45 +0200
Message-Id: <1273142265-11929-2-git-send-email-os@emlix.com>
In-Reply-To: <1273142265-11929-1-git-send-email-os@emlix.com>
References: <1273142265-11929-1-git-send-email-os@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With dma based spi transmission, data corruption
is observed occasionally. With dma buffers located
right next to msg and xfer fields, cache lines
correctly flushed in preparation for dma usage
may be polluted again when writing to fields
in the same cache line.

Make sure cache fields used with dma do not
share cache lines with fields changed during
dma handling. As both fields are part of a
struct that is allocated via kzalloc, thus
cache aligned, moving the fields to the 1st
position and insert padding for alignment
does the job.

Signed-off-by: Oskar Schirmer <os@emlix.com>
Signed-off-by: Daniel Glöckner <dg@emlix.com>
Signed-off-by: Oliver Schneidewind <osw@emlix.com>
Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 drivers/input/touchscreen/ad7877.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
index 92acd85..9719368 100644
--- a/drivers/input/touchscreen/ad7877.c
+++ b/drivers/input/touchscreen/ad7877.c
@@ -153,15 +153,21 @@ enum {
  */
 
 struct ser_req {
+	u16			sample;
+	char			__padalign[L1_CACHE_BYTES - sizeof(u16)];
+
 	u16			reset;
 	u16			ref_on;
 	u16			command;
-	u16			sample;
 	struct spi_message	msg;
 	struct spi_transfer	xfer[6];
 };
 
 struct ad7877 {
+	u16			conversion_data[AD7877_NR_SENSE];
+	char			__padalign[L1_CACHE_BYTES
+					- AD7877_NR_SENSE * sizeof(u16)];
+
 	struct input_dev	*input;
 	char			phys[32];
 
@@ -182,8 +188,6 @@ struct ad7877 {
 	u8			averaging;
 	u8			pen_down_acc_interval;
 
-	u16			conversion_data[AD7877_NR_SENSE];
-
 	struct spi_transfer	xfer[AD7877_NR_SENSE + 2];
 	struct spi_message	msg;
 
-- 
1.5.3.7

