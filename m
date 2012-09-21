Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab2IULvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 07:51:41 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:1173 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755804Ab2IULvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 07:51:40 -0400
Message-ID: <1348228298.1581.18.camel@x61.thuisdomein>
Subject: [PATCH] rtc: m41t80: remove disabled alarm functionality
From: Paul Bolle <pebolle@tiscali.nl>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: John Stultz <john.stultz@linaro.org>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Date: Fri, 21 Sep 2012 13:51:38 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Sep 2012 11:51:38.0463 (UTC) FILETIME=[754DE6F0:01CD97EF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c3b79770e51ab1fd4201f3b54edf30113b9ce74f ("rtc: m41t80:
Workaround broken alarm functionality") disabled m41t80's alarm
functions. But since those functions were not touched, building
this driver triggers these GCC warnings:
    drivers/rtc/rtc-m41t80.c:216:12: warning: 'm41t80_rtc_alarm_irq_enable' defined but not used [-Wunused-function]
    drivers/rtc/rtc-m41t80.c:238:12: warning: 'm41t80_rtc_set_alarm' defined but not used [-Wunused-function]
    drivers/rtc/rtc-m41t80.c:308:12: warning: 'm41t80_rtc_read_alarm' defined but not used [-Wunused-function]

Remove these functions (and the commented out references to them) to
silence these warnings. Anyone wanting to fix the alarm irq
functionality can easily find the removed code in the git log of this
file or through some web searches.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) I noticed this warning while building v3.6-rc6 on current Fedora 17,
using Fedora's default config.

1) Compile tested only.

 drivers/rtc/rtc-m41t80.c | 157 ++---------------------------------------------
 1 file changed, 4 insertions(+), 153 deletions(-)

diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 4e0f84a..b885bcd 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -213,163 +213,14 @@ static int m41t80_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return m41t80_set_datetime(to_i2c_client(dev), tm);
 }
 
-static int m41t80_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	int rc;
-
-	rc = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_MON);
-	if (rc < 0)
-		goto err;
-
-	if (enabled)
-		rc |= M41T80_ALMON_AFE;
-	else
-		rc &= ~M41T80_ALMON_AFE;
-
-	if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON, rc) < 0)
-		goto err;
-
-	return 0;
-err:
-	return -EIO;
-}
-
-static int m41t80_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *t)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	u8 wbuf[1 + M41T80_ALARM_REG_SIZE];
-	u8 *buf = &wbuf[1];
-	u8 *reg = buf - M41T80_REG_ALARM_MON;
-	u8 dt_addr[1] = { M41T80_REG_ALARM_MON };
-	struct i2c_msg msgs_in[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= dt_addr,
-		},
-		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= M41T80_ALARM_REG_SIZE,
-			.buf	= buf,
-		},
-	};
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1 + M41T80_ALARM_REG_SIZE,
-			.buf	= wbuf,
-		 },
-	};
-
-	if (i2c_transfer(client->adapter, msgs_in, 2) < 0) {
-		dev_err(&client->dev, "read error\n");
-		return -EIO;
-	}
-	reg[M41T80_REG_ALARM_MON] &= ~(0x1f | M41T80_ALMON_AFE);
-	reg[M41T80_REG_ALARM_DAY] = 0;
-	reg[M41T80_REG_ALARM_HOUR] &= ~(0x3f | 0x80);
-	reg[M41T80_REG_ALARM_MIN] = 0;
-	reg[M41T80_REG_ALARM_SEC] = 0;
-
-	wbuf[0] = M41T80_REG_ALARM_MON; /* offset into rtc's regs */
-	reg[M41T80_REG_ALARM_SEC] |= t->time.tm_sec >= 0 ?
-		bin2bcd(t->time.tm_sec) : 0x80;
-	reg[M41T80_REG_ALARM_MIN] |= t->time.tm_min >= 0 ?
-		bin2bcd(t->time.tm_min) : 0x80;
-	reg[M41T80_REG_ALARM_HOUR] |= t->time.tm_hour >= 0 ?
-		bin2bcd(t->time.tm_hour) : 0x80;
-	reg[M41T80_REG_ALARM_DAY] |= t->time.tm_mday >= 0 ?
-		bin2bcd(t->time.tm_mday) : 0x80;
-	if (t->time.tm_mon >= 0)
-		reg[M41T80_REG_ALARM_MON] |= bin2bcd(t->time.tm_mon + 1);
-	else
-		reg[M41T80_REG_ALARM_DAY] |= 0x40;
-
-	if (i2c_transfer(client->adapter, msgs, 1) != 1) {
-		dev_err(&client->dev, "write error\n");
-		return -EIO;
-	}
-
-	if (t->enabled) {
-		reg[M41T80_REG_ALARM_MON] |= M41T80_ALMON_AFE;
-		if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
-					      reg[M41T80_REG_ALARM_MON]) < 0) {
-			dev_err(&client->dev, "write error\n");
-			return -EIO;
-		}
-	}
-	return 0;
-}
-
-static int m41t80_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *t)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	u8 buf[M41T80_ALARM_REG_SIZE + 1]; /* all alarm regs and flags */
-	u8 dt_addr[1] = { M41T80_REG_ALARM_MON };
-	u8 *reg = buf - M41T80_REG_ALARM_MON;
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= dt_addr,
-		},
-		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= M41T80_ALARM_REG_SIZE + 1,
-			.buf	= buf,
-		},
-	};
-
-	if (i2c_transfer(client->adapter, msgs, 2) < 0) {
-		dev_err(&client->dev, "read error\n");
-		return -EIO;
-	}
-	t->time.tm_sec = -1;
-	t->time.tm_min = -1;
-	t->time.tm_hour = -1;
-	t->time.tm_mday = -1;
-	t->time.tm_mon = -1;
-	if (!(reg[M41T80_REG_ALARM_SEC] & 0x80))
-		t->time.tm_sec = bcd2bin(reg[M41T80_REG_ALARM_SEC] & 0x7f);
-	if (!(reg[M41T80_REG_ALARM_MIN] & 0x80))
-		t->time.tm_min = bcd2bin(reg[M41T80_REG_ALARM_MIN] & 0x7f);
-	if (!(reg[M41T80_REG_ALARM_HOUR] & 0x80))
-		t->time.tm_hour = bcd2bin(reg[M41T80_REG_ALARM_HOUR] & 0x3f);
-	if (!(reg[M41T80_REG_ALARM_DAY] & 0x80))
-		t->time.tm_mday = bcd2bin(reg[M41T80_REG_ALARM_DAY] & 0x3f);
-	if (!(reg[M41T80_REG_ALARM_DAY] & 0x40))
-		t->time.tm_mon = bcd2bin(reg[M41T80_REG_ALARM_MON] & 0x1f) - 1;
-	t->time.tm_year = -1;
-	t->time.tm_wday = -1;
-	t->time.tm_yday = -1;
-	t->time.tm_isdst = -1;
-	t->enabled = !!(reg[M41T80_REG_ALARM_MON] & M41T80_ALMON_AFE);
-	t->pending = !!(reg[M41T80_REG_FLAGS] & M41T80_FLAGS_AF);
-	return 0;
-}
-
+/*
+ * XXX - m41t80 alarm functionality is reported broken.
+ * until it is fixed, don't register alarm functions.
+ */
 static struct rtc_class_ops m41t80_rtc_ops = {
 	.read_time = m41t80_rtc_read_time,
 	.set_time = m41t80_rtc_set_time,
-	/*
-	 * XXX - m41t80 alarm functionality is reported broken.
-	 * until it is fixed, don't register alarm functions.
-	 *
-	.read_alarm = m41t80_rtc_read_alarm,
-	.set_alarm = m41t80_rtc_set_alarm,
-	*/
 	.proc = m41t80_rtc_proc,
-	/*
-	 * See above comment on broken alarm
-	 *
-	.alarm_irq_enable = m41t80_rtc_alarm_irq_enable,
-	*/
 };
 
 #if defined(CONFIG_RTC_INTF_SYSFS) || defined(CONFIG_RTC_INTF_SYSFS_MODULE)
-- 
1.7.11.4

