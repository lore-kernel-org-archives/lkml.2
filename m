Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab1BESVB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 13:21:01 -0500
Received: from mail.pripojeni.net ([217.66.174.14]:52685 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab1BESU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 13:20:59 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@infradead.org
Cc: jirislaby@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/1] DVB-USB: dib0700, fix oops with non-dib7000pc devices
Date: Sat,  5 Feb 2011 19:20:47 +0100
Message-Id: <1296930047-22689-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These devices use different internal structures (dib7000m) and
dib7000p pid ctrl accesses invalid members causing kernel to die.

Introduce pid control functions for dib7000m which operate on the
correct structure.

The oops it fixes:
BUG: unable to handle kernel NULL pointer dereference at 0000000000000012
IP: [<ffffffff813658a7>] i2c_transfer+0x17/0x140
PGD 13dcbb067 PUD 13e3c9067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
...
Modules linked in: ...
Pid: 3511, comm: kaffeine Tainted: G   M       2.6.34.8-0.1-desktop #1 NITU1/20023
RIP: 0010:[<ffffffff813658a7>]  [<ffffffff813658a7>] i2c_transfer+0x17/0x140
RSP: 0018:ffff88011ce59bc8  EFLAGS: 00010292
RAX: ffff88011ce59c38 RBX: 0000000000000002 RCX: 0000000000001cda
RDX: 0000000000000002 RSI: ffff88011ce59c18 RDI: 0000000000000002
...
CR2: 0000000000000012 CR3: 000000011ce53000 CR4: 00000000000406e0
Process kaffeine (pid: 3511, threadinfo ffff88011ce58000, task ffff88009a40c700)
Stack:
...
Call Trace:
 [<ffffffffa067a07f>] dib7000p_read_word+0x6f/0xd0 [dib7000p]
 [<ffffffffa067bfa2>] dib7000p_pid_filter_ctrl+0x42/0xb0 [dib7000p]
 [<ffffffffa0654221>] dvb_usb_ctrl_feed+0x151/0x170 [dvb_usb]
 [<ffffffffa062270b>] dmx_ts_feed_start_filtering+0x5b/0xe0 [dvb_core]
...
Code: a6 f9 ff 48 83 c4 18 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 41 57 41 56 41 89 d6 41 55 49 89 f5 41 54 55 53 48 89 fb 48 83 ec 18 <48> 8b 47 10 48 83 38 00 0f 84 c8 00 00 00 65 48 8b 04 25 40 b5

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   18 +++++++++++++++++-
 drivers/media/dvb/frontends/dib7000m.c      |   19 +++++++++++++++++++
 drivers/media/dvb/frontends/dib7000m.h      |   16 ++++++++++++++++
 3 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index c6022af..23fe0c3 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -80,6 +80,9 @@ static struct dib3000mc_config bristol_dib3000mc_config[2] = {
 	}
 };
 
+static int stk70x0m_pid_filter(struct dvb_usb_adapter *adapter, int index, u16 pid, int onoff);
+static int stk70x0m_pid_filter_ctrl(struct dvb_usb_adapter *adapter, int onoff);
+
 static int bristol_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_state *st = adap->dev->priv;
@@ -686,8 +689,11 @@ static int stk7700p_frontend_attach(struct dvb_usb_adapter *adap)
 	if (dib7000pc_detection(&adap->dev->i2c_adap)) {
 		adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 18, &stk7700p_dib7000p_config);
 		st->is_dib7000pc = 1;
-	} else
+	} else {
 		adap->fe = dvb_attach(dib7000m_attach, &adap->dev->i2c_adap, 18, &stk7700p_dib7000m_config);
+		adap->props.pid_filter = stk70x0m_pid_filter;
+		adap->props.pid_filter_ctrl = stk70x0m_pid_filter_ctrl;
+	}
 
 	return adap->fe == NULL ? -ENODEV : 0;
 }
@@ -882,6 +888,16 @@ static int stk70x0p_pid_filter_ctrl(struct dvb_usb_adapter *adapter, int onoff)
     return dib7000p_pid_filter_ctrl(adapter->fe, onoff);
 }
 
+static int stk70x0m_pid_filter(struct dvb_usb_adapter *adapter, int index, u16 pid, int onoff)
+{
+	return dib7000m_pid_filter(adapter->fe, index, pid, onoff);
+}
+
+static int stk70x0m_pid_filter_ctrl(struct dvb_usb_adapter *adapter, int onoff)
+{
+	return dib7000m_pid_filter_ctrl(adapter->fe, onoff);
+}
+
 static struct dibx000_bandwidth_config dib7070_bw_config_12_mhz = {
 	60000, 15000,
 	1, 20, 3, 1, 0,
diff --git a/drivers/media/dvb/frontends/dib7000m.c b/drivers/media/dvb/frontends/dib7000m.c
index c7f5ccf..90d9411 100644
--- a/drivers/media/dvb/frontends/dib7000m.c
+++ b/drivers/media/dvb/frontends/dib7000m.c
@@ -1372,6 +1372,25 @@ error:
 }
 EXPORT_SYMBOL(dib7000m_attach);
 
+int dib7000m_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
+{
+	struct dib7000m_state *state = fe->demodulator_priv;
+	u16 val = dib7000m_read_word(state, 235) & 0xffef;
+	val |= (onoff & 0x1) << 4;
+	dprintk("PID filter enabled %d", onoff);
+	return dib7000m_write_word(state, 235, val);
+}
+EXPORT_SYMBOL(dib7000m_pid_filter_ctrl);
+
+int dib7000m_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
+{
+	struct dib7000m_state *state = fe->demodulator_priv;
+	dprintk("PID filter: index %x, PID %d, OnOff %d", id, pid, onoff);
+	return dib7000m_write_word(state, 241 + id,
+			onoff ? (1 << 13) | pid : 0);
+}
+EXPORT_SYMBOL(dib7000m_pid_filter);
+
 static struct dvb_frontend_ops dib7000m_ops = {
 	.info = {
 		.name = "DiBcom 7000MA/MB/PA/PB/MC",
diff --git a/drivers/media/dvb/frontends/dib7000m.h b/drivers/media/dvb/frontends/dib7000m.h
index 113819c..3353f5a 100644
--- a/drivers/media/dvb/frontends/dib7000m.h
+++ b/drivers/media/dvb/frontends/dib7000m.h
@@ -46,6 +46,8 @@ extern struct dvb_frontend *dib7000m_attach(struct i2c_adapter *i2c_adap,
 extern struct i2c_adapter *dib7000m_get_i2c_master(struct dvb_frontend *,
 						   enum dibx000_i2c_interface,
 						   int);
+extern int dib7000m_pid_filter(struct dvb_frontend *, u8 id, u16 pid, u8 onoff);
+extern int dib7000m_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff);
 #else
 static inline
 struct dvb_frontend *dib7000m_attach(struct i2c_adapter *i2c_adap,
@@ -63,6 +65,20 @@ struct i2c_adapter *dib7000m_get_i2c_master(struct dvb_frontend *demod,
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
+
+static inline int dib7000m_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid,
+		u8 onoff)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return -ENODEV;
+}
+
+static inline int dib7000m_pid_filter_ctrl(struct dvb_frontend *fe,
+		uint8_t onoff)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return -ENODEV;
+}
 #endif
 
 /* TODO
-- 
1.7.3.2


