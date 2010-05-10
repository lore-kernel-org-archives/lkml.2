Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab0EJKmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 06:42:45 -0400
Received: from mx1.emlix.com ([193.175.82.87]:53994 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab0EJKmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 06:42:43 -0400
From: "Oskar Schirmer" <os@emlix.com>
To: Michael Hennerich <Michael.Hennerich@analog.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Oskar Schirmer <os@emlix.com>,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>
Subject: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
Date: Mon, 10 May 2010 12:42:34 +0200
Message-Id: <1273488154-2993-1-git-send-email-os@emlix.com>
In-Reply-To: <1273487642-2169-1-git-send-email-os@emlix.com>
References: <1273487642-2169-1-git-send-email-os@emlix.com>
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
 drivers/input/touchscreen/ad7877.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

v2: add a comment to explain why alignment is needed

v3: fix the typo in comment and layout (- to end of line)

diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
index 885354c..9ebb1b4 100644
--- a/drivers/input/touchscreen/ad7877.c
+++ b/drivers/input/touchscreen/ad7877.c
@@ -153,15 +153,29 @@ enum {
  */
 
 struct ser_req {
+	u16			sample;
+	/*
+	 * DMA (thus cache coherency maintenance) requires the
+	 * transfer buffers to live in their own cache lines.
+	 */
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
+	/*
+	 * DMA (thus cache coherency maintenance) requires the
+	 * transfer buffers to live in their own cache lines.
+	 */
+	char			__padalign[L1_CACHE_BYTES -
+					AD7877_NR_SENSE * sizeof(u16)];
+
 	struct input_dev	*input;
 	char			phys[32];
 
@@ -182,8 +196,6 @@ struct ad7877 {
 	u8			averaging;
 	u8			pen_down_acc_interval;
 
-	u16			conversion_data[AD7877_NR_SENSE];
-
 	struct spi_transfer	xfer[AD7877_NR_SENSE + 2];
 	struct spi_message	msg;
 
-- 
1.5.3.7

