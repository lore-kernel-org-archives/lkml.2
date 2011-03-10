Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1CJX5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:57:39 -0500
Received: from kroah.org ([198.145.64.141]:46950 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab1CJX5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:39 2011
Message-Id: <20110310235538.934707753@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Olivier Grenie <olivier.grenie@dibcom.fr>,
        Patrick Boettcher <patrick.boettcher@dibcom.fr>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 29/29] [media] DiB7000M: add pid filtering
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Olivier Grenie <olivier.grenie@dibcom.fr>

commit e192a7cf0effe7680264a5bc35c0ad1bdcdc921c upstream.

This patch adds the pid filtering for the dib7000M demod. It also
corrects the pid filtering for the dib7700 based board. It should
prevent an oops, when using dib7700p based board.

References: https://bugzilla.novell.com/show_bug.cgi?id=644807

Signed-off-by: Olivier Grenie <olivier.grenie@dibcom.fr>
Signed-off-by: Patrick Boettcher <patrick.boettcher@dibcom.fr>
Tested-by: Pavel SKARKA <paul.sp@seznam.cz>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   21 +++++++++++++++++++--
 drivers/media/dvb/frontends/dib7000m.c      |   19 +++++++++++++++++++
 drivers/media/dvb/frontends/dib7000m.h      |   15 +++++++++++++++
 3 files changed, 53 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -870,6 +870,23 @@ static int dib7070p_tuner_attach(struct
 	return 0;
 }
 
+static int stk7700p_pid_filter(struct dvb_usb_adapter *adapter, int index,
+		u16 pid, int onoff)
+{
+	struct dib0700_state *st = adapter->dev->priv;
+	if (st->is_dib7000pc)
+		return dib7000p_pid_filter(adapter->fe, index, pid, onoff);
+	return dib7000m_pid_filter(adapter->fe, index, pid, onoff);
+}
+
+static int stk7700p_pid_filter_ctrl(struct dvb_usb_adapter *adapter, int onoff)
+{
+	struct dib0700_state *st = adapter->dev->priv;
+	if (st->is_dib7000pc)
+		return dib7000p_pid_filter_ctrl(adapter->fe, onoff);
+	return dib7000m_pid_filter_ctrl(adapter->fe, onoff);
+}
+
 static int stk70x0p_pid_filter(struct dvb_usb_adapter *adapter, int index, u16 pid, int onoff)
 {
     return dib7000p_pid_filter(adapter->fe, index, pid, onoff);
@@ -1875,8 +1892,8 @@ struct dvb_usb_device_properties dib0700
 			{
 				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
-				.pid_filter       = stk70x0p_pid_filter,
-				.pid_filter_ctrl  = stk70x0p_pid_filter_ctrl,
+				.pid_filter       = stk7700p_pid_filter,
+				.pid_filter_ctrl  = stk7700p_pid_filter_ctrl,
 				.frontend_attach  = stk7700p_frontend_attach,
 				.tuner_attach     = stk7700p_tuner_attach,
 
--- a/drivers/media/dvb/frontends/dib7000m.c
+++ b/drivers/media/dvb/frontends/dib7000m.c
@@ -1285,6 +1285,25 @@ struct i2c_adapter * dib7000m_get_i2c_ma
 }
 EXPORT_SYMBOL(dib7000m_get_i2c_master);
 
+int dib7000m_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
+{
+	struct dib7000m_state *state = fe->demodulator_priv;
+	u16 val = dib7000m_read_word(state, 294 + state->reg_offs) & 0xffef;
+	val |= (onoff & 0x1) << 4;
+	dprintk("PID filter enabled %d", onoff);
+	return dib7000m_write_word(state, 294 + state->reg_offs, val);
+}
+EXPORT_SYMBOL(dib7000m_pid_filter_ctrl);
+
+int dib7000m_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
+{
+	struct dib7000m_state *state = fe->demodulator_priv;
+	dprintk("PID filter: index %x, PID %d, OnOff %d", id, pid, onoff);
+	return dib7000m_write_word(state, 300 + state->reg_offs + id,
+			onoff ? (1 << 13) | pid : 0);
+}
+EXPORT_SYMBOL(dib7000m_pid_filter);
+
 #if 0
 /* used with some prototype boards */
 int dib7000m_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods,
--- a/drivers/media/dvb/frontends/dib7000m.h
+++ b/drivers/media/dvb/frontends/dib7000m.h
@@ -46,6 +46,8 @@ extern struct dvb_frontend *dib7000m_att
 extern struct i2c_adapter *dib7000m_get_i2c_master(struct dvb_frontend *,
 						   enum dibx000_i2c_interface,
 						   int);
+extern int dib7000m_pid_filter(struct dvb_frontend *, u8 id, u16 pid, u8 onoff);
+extern int dib7000m_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff);
 #else
 static inline
 struct dvb_frontend *dib7000m_attach(struct i2c_adapter *i2c_adap,
@@ -63,6 +65,19 @@ struct i2c_adapter *dib7000m_get_i2c_mas
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
+static inline int dib7000m_pid_filter(struct dvb_frontend *fe, u8 id,
+						u16 pid, u8 onoff)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return -ENODEV;
+}
+
+static inline int dib7000m_pid_filter_ctrl(struct dvb_frontend *fe,
+						uint8_t onoff)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return -ENODEV;
+}
 #endif
 
 /* TODO


