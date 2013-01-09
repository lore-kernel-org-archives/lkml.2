Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab3AIRa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 12:30:59 -0500
Received: from smtp-out-052.synserver.de ([212.40.185.52]:1026 "EHLO
	smtp-out-052.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab3AIRae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 12:30:34 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5469
From: Lars-Peter Clausen <lars@metafoo.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/3] iio: Use spi_sync_transfer()
Date: Wed,  9 Jan 2013 18:31:10 +0100
Message-Id: <1357752671-30222-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1357752671-30222-1-git-send-email-lars@metafoo.de>
References: <1357752671-30222-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new spi_sync_transfer() helper function instead of open-coding it.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/iio/dac/ad5360.c       |  7 +------
 drivers/iio/dac/ad5421.c       |  7 +------
 drivers/iio/dac/ad5504.c       |  6 +-----
 drivers/iio/dac/ad5686.c       |  7 +------
 drivers/iio/dac/ad5755.c       |  7 +------
 drivers/iio/dac/ad5764.c       |  7 +------
 drivers/iio/dac/ad5791.c       |  6 +-----
 drivers/iio/frequency/ad9523.c | 14 ++------------
 8 files changed, 9 insertions(+), 52 deletions(-)

diff --git a/drivers/iio/dac/ad5360.c b/drivers/iio/dac/ad5360.c
index 8fce84f..8ae07a5 100644
--- a/drivers/iio/dac/ad5360.c
+++ b/drivers/iio/dac/ad5360.c
@@ -213,7 +213,6 @@ static int ad5360_read(struct iio_dev *indio_dev, unsigned int type,
 	unsigned int addr)
 {
 	struct ad5360_state *st = iio_priv(indio_dev);
-	struct spi_message m;
 	int ret;
 	struct spi_transfer t[] = {
 		{
@@ -226,10 +225,6 @@ static int ad5360_read(struct iio_dev *indio_dev, unsigned int type,
 		},
 	};
 
-	spi_message_init(&m);
-	spi_message_add_tail(&t[0], &m);
-	spi_message_add_tail(&t[1], &m);
-
 	mutex_lock(&indio_dev->mlock);
 
 	st->data[0].d32 = cpu_to_be32(AD5360_CMD(AD5360_CMD_SPECIAL_FUNCTION) |
@@ -237,7 +232,7 @@ static int ad5360_read(struct iio_dev *indio_dev, unsigned int type,
 		AD5360_READBACK_TYPE(type) |
 		AD5360_READBACK_ADDR(addr));
 
-	ret = spi_sync(st->spi, &m);
+	ret = spi_sync_transfer(st->spi, t, ARRAY_SIZE(t));
 	if (ret >= 0)
 		ret = be32_to_cpu(st->data[1].d32) & 0xffff;
 
diff --git a/drivers/iio/dac/ad5421.c b/drivers/iio/dac/ad5421.c
index cdbc5bf..e8f752f 100644
--- a/drivers/iio/dac/ad5421.c
+++ b/drivers/iio/dac/ad5421.c
@@ -127,7 +127,6 @@ static int ad5421_write(struct iio_dev *indio_dev, unsigned int reg,
 static int ad5421_read(struct iio_dev *indio_dev, unsigned int reg)
 {
 	struct ad5421_state *st = iio_priv(indio_dev);
-	struct spi_message m;
 	int ret;
 	struct spi_transfer t[] = {
 		{
@@ -140,15 +139,11 @@ static int ad5421_read(struct iio_dev *indio_dev, unsigned int reg)
 		},
 	};
 
-	spi_message_init(&m);
-	spi_message_add_tail(&t[0], &m);
-	spi_message_add_tail(&t[1], &m);
-
 	mutex_lock(&indio_dev->mlock);
 
 	st->data[0].d32 = cpu_to_be32((1 << 23) | (reg << 16));
 
-	ret = spi_sync(st->spi, &m);
+	ret = spi_sync_transfer(st->spi, t, ARRAY_SIZE(t));
 	if (ret >= 0)
 		ret = be32_to_cpu(st->data[1].d32) & 0xffff;
 
diff --git a/drivers/iio/dac/ad5504.c b/drivers/iio/dac/ad5504.c
index 242bdc7..428a549 100644
--- a/drivers/iio/dac/ad5504.c
+++ b/drivers/iio/dac/ad5504.c
@@ -85,11 +85,7 @@ static int ad5504_spi_read(struct spi_device *spi, u8 addr)
 			.rx_buf		= &val,
 			.len		= 2,
 		};
-	struct spi_message	m;
-
-	spi_message_init(&m);
-	spi_message_add_tail(&t, &m);
-	ret = spi_sync(spi, &m);
+	ret = spi_sync_transfer(spi, &t, 1);
 
 	if (ret < 0)
 		return ret;
diff --git a/drivers/iio/dac/ad5686.c b/drivers/iio/dac/ad5686.c
index 6948d75..1bf32d8 100644
--- a/drivers/iio/dac/ad5686.c
+++ b/drivers/iio/dac/ad5686.c
@@ -117,18 +117,13 @@ static int ad5686_spi_read(struct ad5686_state *st, u8 addr)
 			.len = 3,
 		},
 	};
-	struct spi_message m;
 	int ret;
 
-	spi_message_init(&m);
-	spi_message_add_tail(&t[0], &m);
-	spi_message_add_tail(&t[1], &m);
-
 	st->data[0].d32 = cpu_to_be32(AD5686_CMD(AD5686_CMD_READBACK_ENABLE) |
 			      AD5686_ADDR(addr));
 	st->data[1].d32 = cpu_to_be32(AD5686_CMD(AD5686_CMD_NOOP));
 
-	ret = spi_sync(st->spi, &m);
+	ret = spi_sync_transfer(st->spi, t, ARRAY_SIZE(t));
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/iio/dac/ad5755.c b/drivers/iio/dac/ad5755.c
index 5db3506..906b022 100644
--- a/drivers/iio/dac/ad5755.c
+++ b/drivers/iio/dac/ad5755.c
@@ -153,7 +153,6 @@ static int ad5755_write_ctrl(struct iio_dev *indio_dev, unsigned int channel,
 static int ad5755_read(struct iio_dev *indio_dev, unsigned int addr)
 {
 	struct ad5755_state *st = iio_priv(indio_dev);
-	struct spi_message m;
 	int ret;
 	struct spi_transfer t[] = {
 		{
@@ -167,16 +166,12 @@ static int ad5755_read(struct iio_dev *indio_dev, unsigned int addr)
 		},
 	};
 
-	spi_message_init(&m);
-	spi_message_add_tail(&t[0], &m);
-	spi_message_add_tail(&t[1], &m);
-
 	mutex_lock(&indio_dev->mlock);
 
 	st->data[0].d32 = cpu_to_be32(AD5755_READ_FLAG | (addr << 16));
 	st->data[1].d32 = cpu_to_be32(AD5755_NOOP);
 
-	ret = spi_sync(st->spi, &m);
+	ret = spi_sync_transfer(st->spi, t, ARRAY_SIZE(t));
 	if (ret >= 0)
 		ret = be32_to_cpu(st->data[1].d32) & 0xffff;
 
diff --git a/drivers/iio/dac/ad5764.c b/drivers/iio/dac/ad5764.c
index ffce304..d3d334b 100644
--- a/drivers/iio/dac/ad5764.c
+++ b/drivers/iio/dac/ad5764.c
@@ -135,7 +135,6 @@ static int ad5764_read(struct iio_dev *indio_dev, unsigned int reg,
 	unsigned int *val)
 {
 	struct ad5764_state *st = iio_priv(indio_dev);
-	struct spi_message m;
 	int ret;
 	struct spi_transfer t[] = {
 		{
@@ -148,15 +147,11 @@ static int ad5764_read(struct iio_dev *indio_dev, unsigned int reg,
 		},
 	};
 
-	spi_message_init(&m);
-	spi_message_add_tail(&t[0], &m);
-	spi_message_add_tail(&t[1], &m);
-
 	mutex_lock(&indio_dev->mlock);
 
 	st->data[0].d32 = cpu_to_be32((1 << 23) | (reg << 16));
 
-	ret = spi_sync(st->spi, &m);
+	ret = spi_sync_transfer(st->spi, t, ARRAY_SIZE(t));
 	if (ret >= 0)
 		*val = be32_to_cpu(st->data[1].d32) & 0xffff;
 
diff --git a/drivers/iio/dac/ad5791.c b/drivers/iio/dac/ad5791.c
index 2bd2e37..2cc0a8e 100644
--- a/drivers/iio/dac/ad5791.c
+++ b/drivers/iio/dac/ad5791.c
@@ -125,7 +125,6 @@ static int ad5791_spi_read(struct spi_device *spi, u8 addr, u32 *val)
 		u8 d8[4];
 	} data[3];
 	int ret;
-	struct spi_message msg;
 	struct spi_transfer xfers[] = {
 		{
 			.tx_buf = &data[0].d8[1],
@@ -144,10 +143,7 @@ static int ad5791_spi_read(struct spi_device *spi, u8 addr, u32 *val)
 			      AD5791_ADDR(addr));
 	data[1].d32 = cpu_to_be32(AD5791_ADDR(AD5791_ADDR_NOOP));
 
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfers[0], &msg);
-	spi_message_add_tail(&xfers[1], &msg);
-	ret = spi_sync(spi, &msg);
+	ret = spi_sync_transfer(spi, xfers, ARRAY_SIZE(xfers));
 
 	*val = be32_to_cpu(data[2].d32);
 
diff --git a/drivers/iio/frequency/ad9523.c b/drivers/iio/frequency/ad9523.c
index b737c64..2a18405 100644
--- a/drivers/iio/frequency/ad9523.c
+++ b/drivers/iio/frequency/ad9523.c
@@ -287,7 +287,6 @@ struct ad9523_state {
 static int ad9523_read(struct iio_dev *indio_dev, unsigned addr)
 {
 	struct ad9523_state *st = iio_priv(indio_dev);
-	struct spi_message m;
 	int ret;
 
 	/* We encode the register size 1..3 bytes into the register address.
@@ -305,15 +304,11 @@ static int ad9523_read(struct iio_dev *indio_dev, unsigned addr)
 		},
 	};
 
-	spi_message_init(&m);
-	spi_message_add_tail(&t[0], &m);
-	spi_message_add_tail(&t[1], &m);
-
 	st->data[0].d32 = cpu_to_be32(AD9523_READ |
 				      AD9523_CNT(AD9523_TRANSF_LEN(addr)) |
 				      AD9523_ADDR(addr));
 
-	ret = spi_sync(st->spi, &m);
+	ret = spi_sync_transfer(st->spi, t, ARRAY_SIZE(t));
 	if (ret < 0)
 		dev_err(&indio_dev->dev, "read failed (%d)", ret);
 	else
@@ -326,7 +321,6 @@ static int ad9523_read(struct iio_dev *indio_dev, unsigned addr)
 static int ad9523_write(struct iio_dev *indio_dev, unsigned addr, unsigned val)
 {
 	struct ad9523_state *st = iio_priv(indio_dev);
-	struct spi_message m;
 	int ret;
 	struct spi_transfer t[] = {
 		{
@@ -338,16 +332,12 @@ static int ad9523_write(struct iio_dev *indio_dev, unsigned addr, unsigned val)
 		},
 	};
 
-	spi_message_init(&m);
-	spi_message_add_tail(&t[0], &m);
-	spi_message_add_tail(&t[1], &m);
-
 	st->data[0].d32 = cpu_to_be32(AD9523_WRITE |
 				      AD9523_CNT(AD9523_TRANSF_LEN(addr)) |
 				      AD9523_ADDR(addr));
 	st->data[1].d32 = cpu_to_be32(val);
 
-	ret = spi_sync(st->spi, &m);
+	ret = spi_sync_transfer(st->spi, t, ARRAY_SIZE(t));
 
 	if (ret < 0)
 		dev_err(&indio_dev->dev, "write failed (%d)", ret);
-- 
1.8.0

