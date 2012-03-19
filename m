Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2CSUss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:48:48 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:39019 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab2CSUsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:48:45 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Patrick Boettcher <Patrick.Boettcher@dibcom.fr>,
        Olivier Grenie <olivier.grenie@dibcom.fr>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] [media] dib9000: get rid of Dib*Lock macros
Date: Tue, 20 Mar 2012 00:48:34 +0400
Message-Id: <1332190114-25573-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <4F676E55.1060003@redhat.com>
References: <4F676E55.1060003@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch replaces Dib*Lock macros with direct calls to mutex functions
as soon as they just make the driver code harder to review
(per request of Mauro).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/dvb/frontends/dib9000.c |  128 +++++++++++++++------------------
 1 files changed, 58 insertions(+), 70 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib9000.c b/drivers/media/dvb/frontends/dib9000.c
index 80848b4..953102f 100644
--- a/drivers/media/dvb/frontends/dib9000.c
+++ b/drivers/media/dvb/frontends/dib9000.c
@@ -31,13 +31,6 @@ struct i2c_device {
 	u8 *i2c_write_buffer;
 };
 
-/* lock */
-#define DIB_LOCK struct mutex
-#define DibAcquireLock(lock) mutex_lock_interruptible(lock)
-#define DibReleaseLock(lock) mutex_unlock(lock)
-#define DibInitLock(lock) mutex_init(lock)
-#define DibFreeLock(lock)
-
 struct dib9000_pid_ctrl {
 #define DIB9000_PID_FILTER_CTRL 0
 #define DIB9000_PID_FILTER      1
@@ -82,11 +75,11 @@ struct dib9000_state {
 			} fe_mm[18];
 			u8 memcmd;
 
-			DIB_LOCK mbx_if_lock;	/* to protect read/write operations */
-			DIB_LOCK mbx_lock;	/* to protect the whole mailbox handling */
+			struct mutex mbx_if_lock;	/* to protect read/write operations */
+			struct mutex mbx_lock;	/* to protect the whole mailbox handling */
 
-			DIB_LOCK mem_lock;	/* to protect the memory accesses */
-			DIB_LOCK mem_mbx_lock;	/* to protect the memory-based mailbox */
+			struct mutex mem_lock;	/* to protect the memory accesses */
+			struct mutex mem_mbx_lock;	/* to protect the memory-based mailbox */
 
 #define MBX_MAX_WORDS (256 - 200 - 2)
 #define DIB9000_MSG_CACHE_SIZE 2
@@ -108,7 +101,7 @@ struct dib9000_state {
 	struct i2c_msg msg[2];
 	u8 i2c_write_buffer[255];
 	u8 i2c_read_buffer[255];
-	DIB_LOCK demod_lock;
+	struct mutex demod_lock;
 	u8 get_frontend_internal;
 	struct dib9000_pid_ctrl pid_ctrl[10];
 	s8 pid_ctrl_index; /* -1: empty list; -2: do not use the list */
@@ -446,13 +439,13 @@ static int dib9000_risc_mem_read(struct dib9000_state *state, u8 cmd, u8 * b, u1
 	if (!state->platform.risc.fw_is_running)
 		return -EIO;
 
-	if (DibAcquireLock(&state->platform.risc.mem_lock) < 0) {
+	if (mutex_lock_interruptible(&state->platform.risc.mem_lock) < 0) {
 		dprintk("could not get the lock");
 		return -EINTR;
 	}
 	dib9000_risc_mem_setup(state, cmd | 0x80);
 	dib9000_risc_mem_read_chunks(state, b, len);
-	DibReleaseLock(&state->platform.risc.mem_lock);
+	mutex_unlock(&state->platform.risc.mem_lock);
 	return 0;
 }
 
@@ -462,13 +455,13 @@ static int dib9000_risc_mem_write(struct dib9000_state *state, u8 cmd, const u8
 	if (!state->platform.risc.fw_is_running)
 		return -EIO;
 
-	if (DibAcquireLock(&state->platform.risc.mem_lock) < 0) {
+	if (mutex_lock_interruptible(&state->platform.risc.mem_lock) < 0) {
 		dprintk("could not get the lock");
 		return -EINTR;
 	}
 	dib9000_risc_mem_setup(state, cmd);
 	dib9000_risc_mem_write_chunks(state, b, m->size);
-	DibReleaseLock(&state->platform.risc.mem_lock);
+	mutex_unlock(&state->platform.risc.mem_lock);
 	return 0;
 }
 
@@ -537,7 +530,7 @@ static int dib9000_mbx_send_attr(struct dib9000_state *state, u8 id, u16 * data,
 	if (!state->platform.risc.fw_is_running)
 		return -EINVAL;
 
-	if (DibAcquireLock(&state->platform.risc.mbx_if_lock) < 0) {
+	if (mutex_lock_interruptible(&state->platform.risc.mbx_if_lock) < 0) {
 		dprintk("could not get the lock");
 		return -EINTR;
 	}
@@ -584,7 +577,7 @@ static int dib9000_mbx_send_attr(struct dib9000_state *state, u8 id, u16 * data,
 	ret = (u8) dib9000_write_word_attr(state, 1043, 1 << 14, attr);
 
 out:
-	DibReleaseLock(&state->platform.risc.mbx_if_lock);
+	mutex_unlock(&state->platform.risc.mbx_if_lock);
 
 	return ret;
 }
@@ -602,7 +595,7 @@ static u8 dib9000_mbx_read(struct dib9000_state *state, u16 * data, u8 risc_id,
 	if (!state->platform.risc.fw_is_running)
 		return 0;
 
-	if (DibAcquireLock(&state->platform.risc.mbx_if_lock) < 0) {
+	if (mutex_lock_interruptible(&state->platform.risc.mbx_if_lock) < 0) {
 		dprintk("could not get the lock");
 		return 0;
 	}
@@ -643,7 +636,7 @@ static u8 dib9000_mbx_read(struct dib9000_state *state, u16 * data, u8 risc_id,
 	/* Update register nb_mes_in_TX */
 	dib9000_write_word_attr(state, 1028 + mc_base, 1 << 14, attr);
 
-	DibReleaseLock(&state->platform.risc.mbx_if_lock);
+	mutex_unlock(&state->platform.risc.mbx_if_lock);
 
 	return size + 1;
 }
@@ -713,7 +706,7 @@ static int dib9000_mbx_process(struct dib9000_state *state, u16 attr)
 	if (!state->platform.risc.fw_is_running)
 		return -1;
 
-	if (DibAcquireLock(&state->platform.risc.mbx_lock) < 0) {
+	if (mutex_lock_interruptible(&state->platform.risc.mbx_lock) < 0) {
 		dprintk("could not get the lock");
 		return -1;
 	}
@@ -724,7 +717,7 @@ static int dib9000_mbx_process(struct dib9000_state *state, u16 attr)
 	tmp = dib9000_read_word_attr(state, 1229, attr);	/* Clear the IRQ */
 /*      if (tmp) */
 /*              dprintk( "cleared IRQ: %x", tmp); */
-	DibReleaseLock(&state->platform.risc.mbx_lock);
+	mutex_unlock(&state->platform.risc.mbx_lock);
 
 	return ret;
 }
@@ -1193,7 +1186,7 @@ static int dib9000_fw_get_channel(struct dvb_frontend *fe)
 	struct dibDVBTChannel *ch;
 	int ret = 0;
 
-	if (DibAcquireLock(&state->platform.risc.mem_mbx_lock) < 0) {
+	if (mutex_lock_interruptible(&state->platform.risc.mem_mbx_lock) < 0) {
 		dprintk("could not get the lock");
 		return -EINTR;
 	}
@@ -1323,7 +1316,7 @@ static int dib9000_fw_get_channel(struct dvb_frontend *fe)
 	}
 
 error:
-	DibReleaseLock(&state->platform.risc.mem_mbx_lock);
+	mutex_unlock(&state->platform.risc.mem_mbx_lock);
 	return ret;
 }
 
@@ -1678,7 +1671,7 @@ static int dib9000_fw_component_bus_xfer(struct i2c_adapter *i2c_adap, struct i2
 		p[12] = 0;
 	}
 
-	if (DibAcquireLock(&state->platform.risc.mem_mbx_lock) < 0) {
+	if (mutex_lock_interruptible(&state->platform.risc.mem_mbx_lock) < 0) {
 		dprintk("could not get the lock");
 		return 0;
 	}
@@ -1692,7 +1685,7 @@ static int dib9000_fw_component_bus_xfer(struct i2c_adapter *i2c_adap, struct i2
 
 	/* do the transaction */
 	if (dib9000_fw_memmbx_sync(state, FE_SYNC_COMPONENT_ACCESS) < 0) {
-		DibReleaseLock(&state->platform.risc.mem_mbx_lock);
+		mutex_unlock(&state->platform.risc.mem_mbx_lock);
 		return 0;
 	}
 
@@ -1700,7 +1693,7 @@ static int dib9000_fw_component_bus_xfer(struct i2c_adapter *i2c_adap, struct i2
 	if ((num > 1) && (msg[1].flags & I2C_M_RD))
 		dib9000_risc_mem_read(state, FE_MM_RW_COMPONENT_ACCESS_BUFFER, msg[1].buf, msg[1].len);
 
-	DibReleaseLock(&state->platform.risc.mem_mbx_lock);
+	mutex_unlock(&state->platform.risc.mem_mbx_lock);
 
 	return num;
 }
@@ -1789,7 +1782,7 @@ int dib9000_fw_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
 		return 0;
 	}
 
-	if (DibAcquireLock(&state->demod_lock) < 0) {
+	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
 		dprintk("could not get the lock");
 		return -EINTR;
 	}
@@ -1799,7 +1792,7 @@ int dib9000_fw_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
 
 	dprintk("PID filter enabled %d", onoff);
 	ret = dib9000_write_word(state, 294 + 1, val);
-	DibReleaseLock(&state->demod_lock);
+	mutex_unlock(&state->demod_lock);
 	return ret;
 
 }
@@ -1824,14 +1817,14 @@ int dib9000_fw_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
 		return 0;
 	}
 
-	if (DibAcquireLock(&state->demod_lock) < 0) {
+	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
 		dprintk("could not get the lock");
 		return -EINTR;
 	}
 	dprintk("Index %x, PID %d, OnOff %d", id, pid, onoff);
 	ret = dib9000_write_word(state, 300 + 1 + id,
 			onoff ? (1 << 13) | pid : 0);
-	DibReleaseLock(&state->demod_lock);
+	mutex_unlock(&state->demod_lock);
 	return ret;
 }
 EXPORT_SYMBOL(dib9000_fw_pid_filter);
@@ -1851,11 +1844,6 @@ static void dib9000_release(struct dvb_frontend *demod)
 	for (index_frontend = 1; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (st->fe[index_frontend] != NULL); index_frontend++)
 		dvb_frontend_detach(st->fe[index_frontend]);
 
-	DibFreeLock(&state->platform.risc.mbx_if_lock);
-	DibFreeLock(&state->platform.risc.mbx_lock);
-	DibFreeLock(&state->platform.risc.mem_lock);
-	DibFreeLock(&state->platform.risc.mem_mbx_lock);
-	DibFreeLock(&state->demod_lock);
 	dibx000_exit_i2c_master(&st->i2c_master);
 
 	i2c_del_adapter(&st->tuner_adap);
@@ -1875,7 +1863,7 @@ static int dib9000_sleep(struct dvb_frontend *fe)
 	u8 index_frontend;
 	int ret = 0;
 
-	if (DibAcquireLock(&state->demod_lock) < 0) {
+	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
 		dprintk("could not get the lock");
 		return -EINTR;
 	}
@@ -1887,7 +1875,7 @@ static int dib9000_sleep(struct dvb_frontend *fe)
 	ret = dib9000_mbx_send(state, OUT_MSG_FE_SLEEP, NULL, 0);
 
 error:
-	DibReleaseLock(&state->demod_lock);
+	mutex_unlock(&state->demod_lock);
 	return ret;
 }
 
@@ -1905,7 +1893,7 @@ static int dib9000_get_frontend(struct dvb_frontend *fe)
 	int ret = 0;
 
 	if (state->get_frontend_internal == 0) {
-		if (DibAcquireLock(&state->demod_lock) < 0) {
+		if (mutex_lock_interruptible(&state->demod_lock) < 0) {
 			dprintk("could not get the lock");
 			return -EINTR;
 		}
@@ -1964,7 +1952,7 @@ static int dib9000_get_frontend(struct dvb_frontend *fe)
 
 return_value:
 	if (state->get_frontend_internal == 0)
-		DibReleaseLock(&state->demod_lock);
+		mutex_unlock(&state->demod_lock);
 	return ret;
 }
 
@@ -2012,7 +2000,7 @@ static int dib9000_set_frontend(struct dvb_frontend *fe)
 	}
 
 	state->pid_ctrl_index = -1; /* postpone the pid filtering cmd */
-	if (DibAcquireLock(&state->demod_lock) < 0) {
+	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
 		dprintk("could not get the lock");
 		return 0;
 	}
@@ -2081,7 +2069,7 @@ static int dib9000_set_frontend(struct dvb_frontend *fe)
 	/* check the tune result */
 	if (exit_condition == 1) {	/* tune failed */
 		dprintk("tune failed");
-		DibReleaseLock(&state->demod_lock);
+		mutex_unlock(&state->demod_lock);
 		/* tune failed; put all the pid filtering cmd to junk */
 		state->pid_ctrl_index = -1;
 		return 0;
@@ -2137,7 +2125,7 @@ static int dib9000_set_frontend(struct dvb_frontend *fe)
 	/* turn off the diversity for the last frontend */
 	dib9000_fw_set_diversity_in(state->fe[index_frontend - 1], 0);
 
-	DibReleaseLock(&state->demod_lock);
+	mutex_unlock(&state->demod_lock);
 	if (state->pid_ctrl_index >= 0) {
 		u8 index_pid_filter_cmd;
 		u8 pid_ctrl_index = state->pid_ctrl_index;
@@ -2175,7 +2163,7 @@ static int dib9000_read_status(struct dvb_frontend *fe, fe_status_t * stat)
 	u8 index_frontend;
 	u16 lock = 0, lock_slave = 0;
 
-	if (DibAcquireLock(&state->demod_lock) < 0) {
+	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
 		dprintk("could not get the lock");
 		return -EINTR;
 	}
@@ -2197,7 +2185,7 @@ static int dib9000_read_status(struct dvb_frontend *fe, fe_status_t * stat)
 	if ((lock & 0x0008) || (lock_slave & 0x0008))
 		*stat |= FE_HAS_LOCK;
 
-	DibReleaseLock(&state->demod_lock);
+	mutex_unlock(&state->demod_lock);
 
 	return 0;
 }
@@ -2208,30 +2196,30 @@ static int dib9000_read_ber(struct dvb_frontend *fe, u32 * ber)
 	u16 *c;
 	int ret = 0;
 
-	if (DibAcquireLock(&state->demod_lock) < 0) {
+	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
 		dprintk("could not get the lock");
 		return -EINTR;
 	}
-	if (DibAcquireLock(&state->platform.risc.mem_mbx_lock) < 0) {
+	if (mutex_lock_interruptible(&state->platform.risc.mem_mbx_lock) < 0) {
 		dprintk("could not get the lock");
 		ret = -EINTR;
 		goto error;
 	}
 	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0) {
-		DibReleaseLock(&state->platform.risc.mem_mbx_lock);
+		mutex_unlock(&state->platform.risc.mem_mbx_lock);
 		ret = -EIO;
 		goto error;
 	}
 	dib9000_risc_mem_read(state, FE_MM_R_FE_MONITOR,
 			state->i2c_read_buffer, 16 * 2);
-	DibReleaseLock(&state->platform.risc.mem_mbx_lock);
+	mutex_unlock(&state->platform.risc.mem_mbx_lock);
 
 	c = (u16 *)state->i2c_read_buffer;
 
 	*ber = c[10] << 16 | c[11];
 
 error:
-	DibReleaseLock(&state->demod_lock);
+	mutex_unlock(&state->demod_lock);
 	return ret;
 }
 
@@ -2243,7 +2231,7 @@ static int dib9000_read_signal_strength(struct dvb_frontend *fe, u16 * strength)
 	u16 val;
 	int ret = 0;
 
-	if (DibAcquireLock(&state->demod_lock) < 0) {
+	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
 		dprintk("could not get the lock");
 		return -EINTR;
 	}
@@ -2256,18 +2244,18 @@ static int dib9000_read_signal_strength(struct dvb_frontend *fe, u16 * strength)
 			*strength += val;
 	}
 
-	if (DibAcquireLock(&state->platform.risc.mem_mbx_lock) < 0) {
+	if (mutex_lock_interruptible(&state->platform.risc.mem_mbx_lock) < 0) {
 		dprintk("could not get the lock");
 		ret = -EINTR;
 		goto error;
 	}
 	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0) {
-		DibReleaseLock(&state->platform.risc.mem_mbx_lock);
+		mutex_unlock(&state->platform.risc.mem_mbx_lock);
 		ret = -EIO;
 		goto error;
 	}
 	dib9000_risc_mem_read(state, FE_MM_R_FE_MONITOR, (u8 *) c, 16 * 2);
-	DibReleaseLock(&state->platform.risc.mem_mbx_lock);
+	mutex_unlock(&state->platform.risc.mem_mbx_lock);
 
 	val = 65535 - c[4];
 	if (val > 65535 - *strength)
@@ -2276,7 +2264,7 @@ static int dib9000_read_signal_strength(struct dvb_frontend *fe, u16 * strength)
 		*strength += val;
 
 error:
-	DibReleaseLock(&state->demod_lock);
+	mutex_unlock(&state->demod_lock);
 	return ret;
 }
 
@@ -2287,16 +2275,16 @@ static u32 dib9000_get_snr(struct dvb_frontend *fe)
 	u32 n, s, exp;
 	u16 val;
 
-	if (DibAcquireLock(&state->platform.risc.mem_mbx_lock) < 0) {
+	if (mutex_lock_interruptible(&state->platform.risc.mem_mbx_lock) < 0) {
 		dprintk("could not get the lock");
 		return 0;
 	}
 	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0) {
-		DibReleaseLock(&state->platform.risc.mem_mbx_lock);
+		mutex_unlock(&state->platform.risc.mem_mbx_lock);
 		return 0;
 	}
 	dib9000_risc_mem_read(state, FE_MM_R_FE_MONITOR, (u8 *) c, 16 * 2);
-	DibReleaseLock(&state->platform.risc.mem_mbx_lock);
+	mutex_unlock(&state->platform.risc.mem_mbx_lock);
 
 	val = c[7];
 	n = (val >> 4) & 0xff;
@@ -2326,7 +2314,7 @@ static int dib9000_read_snr(struct dvb_frontend *fe, u16 * snr)
 	u8 index_frontend;
 	u32 snr_master;
 
-	if (DibAcquireLock(&state->demod_lock) < 0) {
+	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
 		dprintk("could not get the lock");
 		return -EINTR;
 	}
@@ -2340,7 +2328,7 @@ static int dib9000_read_snr(struct dvb_frontend *fe, u16 * snr)
 	} else
 		*snr = 0;
 
-	DibReleaseLock(&state->demod_lock);
+	mutex_unlock(&state->demod_lock);
 
 	return 0;
 }
@@ -2351,27 +2339,27 @@ static int dib9000_read_unc_blocks(struct dvb_frontend *fe, u32 * unc)
 	u16 *c = (u16 *)state->i2c_read_buffer;
 	int ret = 0;
 
-	if (DibAcquireLock(&state->demod_lock) < 0) {
+	if (mutex_lock_interruptible(&state->demod_lock) < 0) {
 		dprintk("could not get the lock");
 		return -EINTR;
 	}
-	if (DibAcquireLock(&state->platform.risc.mem_mbx_lock) < 0) {
+	if (mutex_lock_interruptible(&state->platform.risc.mem_mbx_lock) < 0) {
 		dprintk("could not get the lock");
 		ret = -EINTR;
 		goto error;
 	}
 	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0) {
-		DibReleaseLock(&state->platform.risc.mem_mbx_lock);
+		mutex_unlock(&state->platform.risc.mem_mbx_lock);
 		ret = -EIO;
 		goto error;
 	}
 	dib9000_risc_mem_read(state, FE_MM_R_FE_MONITOR, (u8 *) c, 16 * 2);
-	DibReleaseLock(&state->platform.risc.mem_mbx_lock);
+	mutex_unlock(&state->platform.risc.mem_mbx_lock);
 
 	*unc = c[12];
 
 error:
-	DibReleaseLock(&state->demod_lock);
+	mutex_unlock(&state->demod_lock);
 	return ret;
 }
 
@@ -2514,11 +2502,11 @@ struct dvb_frontend *dib9000_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, c
 	st->gpio_val = DIB9000_GPIO_DEFAULT_VALUES;
 	st->gpio_pwm_pos = DIB9000_GPIO_DEFAULT_PWM_POS;
 
-	DibInitLock(&st->platform.risc.mbx_if_lock);
-	DibInitLock(&st->platform.risc.mbx_lock);
-	DibInitLock(&st->platform.risc.mem_lock);
-	DibInitLock(&st->platform.risc.mem_mbx_lock);
-	DibInitLock(&st->demod_lock);
+	mutex_init(&st->platform.risc.mbx_if_lock);
+	mutex_init(&st->platform.risc.mbx_lock);
+	mutex_init(&st->platform.risc.mem_lock);
+	mutex_init(&st->platform.risc.mem_mbx_lock);
+	mutex_init(&st->demod_lock);
 	st->get_frontend_internal = 0;
 
 	st->pid_ctrl_index = -2;
-- 
1.7.4.1

