Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab0ERIe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 04:34:28 -0400
Received: from mx1.emlix.com ([193.175.82.87]:55531 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101Ab0ERIeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 04:34:25 -0400
From: "Oskar Schirmer" <os@emlix.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       H Hartley Sweeten <hartleys@visionengravers.com>,
       Oskar Schirmer <os@emlix.com>,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>
Subject: [PATCH v2] ad7877: fix spi word size to 16 bit
Date: Tue, 18 May 2010 10:34:13 +0200
Message-Id: <1274171653-8152-1-git-send-email-os@emlix.com>
In-Reply-To: <1273142265-11929-1-git-send-email-os@emlix.com>
References: <1273142265-11929-1-git-send-email-os@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With no word size given in the users platform data,
a generic spi host controller driver will assume a default
word size of eight bit. This causes transmission to be
performed bytewise, which will fail on little endian
machines for sure. Failure on big endian depends on usage
of slave select to mark word boundaries.

Anyway, ad7877 is specified to work with 16 bit per word,
so unconditionally set the word size accordingly.
Flag an error where 16 bit per word is not available.

Signed-off-by: Oskar Schirmer <os@emlix.com>
Signed-off-by: Daniel Glöckner <dg@emlix.com>
Signed-off-by: Oliver Schneidewind <osw@emlix.com>
---
 drivers/input/touchscreen/ad7877.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

v2: check return value for spi_setup failure

diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
index 698d6e7..eebde5b 100644
--- a/drivers/input/touchscreen/ad7877.c
+++ b/drivers/input/touchscreen/ad7877.c
@@ -680,6 +680,13 @@ static int __devinit ad7877_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
+	spi->bits_per_word = 16;
+	err = spi_setup(spi);
+	if (err) {
+		dev_dbg(&spi->dev, "spi master doesn't support 16 bits/word\n");
+		return err;
+	}
+
 	ts = kzalloc(sizeof(struct ad7877), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!ts || !input_dev) {
-- 
1.5.3.7

