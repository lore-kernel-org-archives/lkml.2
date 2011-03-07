Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab1CGPzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:55:41 -0500
Received: from dakia2.marvell.com ([65.219.4.35]:33392 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab1CGPzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:55:20 -0500
X-ASG-Debug-ID: 1299512695-082b752f0001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: johnpol@2ka.mipt.ru, sameo@linux.intel.com, a.zummo@towertech.it,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        dmitry.torokhov@gmail.com, dtor@mail.ru, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH] mfd: append additional read write on 88pm860x
Subject: [PATCH] mfd: append additional read write on 88pm860x
Date: Mon,  7 Mar 2011 23:43:16 +0800
X-ASG-Orig-Subj: [PATCH] mfd: append additional read write on 88pm860x
Message-Id: <1299512600-29047-8-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299512600-29047-7-git-send-email-haojian.zhuang@marvell.com>
References: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-4-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-5-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-6-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-7-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1299512695
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Append the additional read/write operation on 88pm860x for accessing
test page in 88PM860x.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/mfd/88pm860x-i2c.c   |  103 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/88pm860x.h |    8 +++
 2 files changed, 111 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/88pm860x-i2c.c b/drivers/mfd/88pm860x-i2c.c
index bc02e6b..e017dc8 100644
--- a/drivers/mfd/88pm860x-i2c.c
+++ b/drivers/mfd/88pm860x-i2c.c
@@ -126,6 +126,109 @@ out:
 }
 EXPORT_SYMBOL(pm860x_set_bits);
 
+int pm860x_page_reg_read(struct i2c_client *i2c, int reg)
+{
+	struct pm860x_chip *chip = i2c_get_clientdata(i2c);
+	unsigned char zero = 0;
+	unsigned char data;
+	int ret;
+
+	mutex_lock(&chip->io_lock);
+	pm860x_write_device(i2c, 0xFA, 0, &zero);
+	pm860x_write_device(i2c, 0xFB, 0, &zero);
+	pm860x_write_device(i2c, 0xFF, 0, &zero);
+	ret = pm860x_read_device(i2c, reg, 1, &data);
+	if (ret >= 0)
+		ret = (int)data;
+	pm860x_write_device(i2c, 0xFE, 0, &zero);
+	pm860x_write_device(i2c, 0xFC, 0, &zero);
+	mutex_unlock(&chip->io_lock);
+	return ret;
+}
+EXPORT_SYMBOL(pm860x_page_reg_read);
+
+int pm860x_page_reg_write(struct i2c_client *i2c, int reg,
+			  unsigned char data)
+{
+	struct pm860x_chip *chip = i2c_get_clientdata(i2c);
+	unsigned char zero;
+	int ret;
+
+	mutex_lock(&chip->io_lock);
+	pm860x_write_device(i2c, 0xFA, 0, &zero);
+	pm860x_write_device(i2c, 0xFB, 0, &zero);
+	pm860x_write_device(i2c, 0xFF, 0, &zero);
+	ret = pm860x_write_device(i2c, reg, 1, &data);
+	pm860x_write_device(i2c, 0xFE, 0, &zero);
+	pm860x_write_device(i2c, 0xFC, 0, &zero);
+	mutex_unlock(&chip->io_lock);
+	return ret;
+}
+EXPORT_SYMBOL(pm860x_page_reg_write);
+
+int pm860x_page_bulk_read(struct i2c_client *i2c, int reg,
+			  int count, unsigned char *buf)
+{
+	struct pm860x_chip *chip = i2c_get_clientdata(i2c);
+	unsigned char zero = 0;
+	int ret;
+
+	mutex_lock(&chip->io_lock);
+	pm860x_write_device(i2c, 0xFA, 0, &zero);
+	pm860x_write_device(i2c, 0xFB, 0, &zero);
+	pm860x_write_device(i2c, 0xFF, 0, &zero);
+	ret = pm860x_read_device(i2c, reg, count, buf);
+	pm860x_write_device(i2c, 0xFE, 0, &zero);
+	pm860x_write_device(i2c, 0xFC, 0, &zero);
+	mutex_unlock(&chip->io_lock);
+	return ret;
+}
+EXPORT_SYMBOL(pm860x_page_bulk_read);
+
+int pm860x_page_bulk_write(struct i2c_client *i2c, int reg,
+			   int count, unsigned char *buf)
+{
+	struct pm860x_chip *chip = i2c_get_clientdata(i2c);
+	unsigned char zero = 0;
+	int ret;
+
+	mutex_lock(&chip->io_lock);
+	pm860x_write_device(i2c, 0xFA, 0, &zero);
+	pm860x_write_device(i2c, 0xFB, 0, &zero);
+	pm860x_write_device(i2c, 0xFF, 0, &zero);
+	ret = pm860x_write_device(i2c, reg, count, buf);
+	pm860x_write_device(i2c, 0xFE, 0, &zero);
+	pm860x_write_device(i2c, 0xFC, 0, &zero);
+	mutex_unlock(&chip->io_lock);
+	return ret;
+}
+EXPORT_SYMBOL(pm860x_page_bulk_write);
+
+int pm860x_page_set_bits(struct i2c_client *i2c, int reg,
+			 unsigned char mask, unsigned char data)
+{
+	struct pm860x_chip *chip = i2c_get_clientdata(i2c);
+	unsigned char zero;
+	unsigned char value;
+	int ret;
+
+	mutex_lock(&chip->io_lock);
+	pm860x_write_device(i2c, 0xFA, 0, &zero);
+	pm860x_write_device(i2c, 0xFB, 0, &zero);
+	pm860x_write_device(i2c, 0xFF, 0, &zero);
+	ret = pm860x_read_device(i2c, reg, 1, &value);
+	if (ret < 0)
+		goto out;
+	value &= ~mask;
+	value |= data;
+	ret = pm860x_write_device(i2c, reg, 1, &value);
+out:
+	pm860x_write_device(i2c, 0xFE, 0, &zero);
+	pm860x_write_device(i2c, 0xFC, 0, &zero);
+	mutex_unlock(&chip->io_lock);
+	return ret;
+}
+EXPORT_SYMBOL(pm860x_page_set_bits);
 
 static const struct i2c_device_id pm860x_id_table[] = {
 	{ "88PM860x", 0 },
diff --git a/include/linux/mfd/88pm860x.h b/include/linux/mfd/88pm860x.h
index 87df510..05f8677 100644
--- a/include/linux/mfd/88pm860x.h
+++ b/include/linux/mfd/88pm860x.h
@@ -369,6 +369,14 @@ extern int pm860x_bulk_read(struct i2c_client *, int, int, unsigned char *);
 extern int pm860x_bulk_write(struct i2c_client *, int, int, unsigned char *);
 extern int pm860x_set_bits(struct i2c_client *, int, unsigned char,
 			   unsigned char);
+extern int pm860x_page_reg_read(struct i2c_client *, int);
+extern int pm860x_page_reg_write(struct i2c_client *, int, unsigned char);
+extern int pm860x_page_bulk_read(struct i2c_client *, int, int,
+				 unsigned char *);
+extern int pm860x_page_bulk_write(struct i2c_client *, int, int,
+				  unsigned char *);
+extern int pm860x_page_set_bits(struct i2c_client *, int, unsigned char,
+				unsigned char);
 
 extern int pm860x_device_init(struct pm860x_chip *chip,
 			      struct pm860x_platform_data *pdata) __devinit ;
-- 
1.5.6.5

