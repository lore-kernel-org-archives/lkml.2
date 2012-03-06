Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031384Ab2CFVJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:09:06 -0500
Received: from smtp.ispras.ru ([83.149.198.202]:33525 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031121Ab2CFVJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:09:03 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Patrick Boettcher <Patrick.Boettcher@dibcom.fr>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Olivier Grenie <olivier.grenie@dibcom.fr>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH 2/2] [media] dib9000: implement error handling for DibAcquireLock
Date: Wed,  7 Mar 2012 01:08:29 +0400
Message-Id: <1331068109-11613-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DibAcquireLock() is implemented as mutex_lock_interruptible() 
but the driver does not handle unsuccessful locking.
As a result it may lead to unlock of an unheld mutex.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/dvb/frontends/dib9000.c |  115 ++++++++++++++++++++++++++-------
 1 files changed, 91 insertions(+), 24 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib9000.c b/drivers/media/dvb/frontends/dib9000.c
index d96b6a1..80848b4 100644
--- a/drivers/media/dvb/frontends/dib9000.c
+++ b/drivers/media/dvb/frontends/dib9000.c
@@ -33,7 +33,7 @@ struct i2c_device {
 
 /* lock */
 #define DIB_LOCK struct mutex
-#define DibAcquireLock(lock) do { if (mutex_lock_interruptible(lock) < 0) dprintk("could not get the lock"); } while (0)
+#define DibAcquireLock(lock) mutex_lock_interruptible(lock)
 #define DibReleaseLock(lock) mutex_unlock(lock)
 #define DibInitLock(lock) mutex_init(lock)
 #define DibFreeLock(lock)
@@ -446,7 +446,10 @@ static int dib9000_risc_mem_read(struct dib9000_state *state, u8 cmd, u8 * b, u1
 	if (!state->platform.risc.fw_is_running)
 		return -EIO;
 
-	DibAcquireLock(&state->platform.risc.mem_lock);
+	if (DibAcquireLock(&state->platform.risc.mem_lock) < 0) {
+		dprintk("could not get the lock");
+		return -EINTR;
+	}
 	dib9000_risc_mem_setup(state, cmd | 0x80);
 	dib9000_risc_mem_read_chunks(state, b, len);
 	DibReleaseLock(&state->platform.risc.mem_lock);
@@ -459,7 +462,10 @@ static int dib9000_risc_mem_write(struct dib9000_state *state, u8 cmd, const u8
 	if (!state->platform.risc.fw_is_running)
 		return -EIO;
 
-	DibAcquireLock(&state->platform.risc.mem_lock);
+	if (DibAcquireLock(&state->platform.risc.mem_lock) < 0) {
+		dprintk("could not get the lock");
+		return -EINTR;
+	}
 	dib9000_risc_mem_setup(state, cmd);
 	dib9000_risc_mem_write_chunks(state, b, m->size);
 	DibReleaseLock(&state->platform.risc.mem_lock);
@@ -531,7 +537,10 @@ static int dib9000_mbx_send_attr(struct dib9000_state *state, u8 id, u16 * data,
 	if (!state->platform.risc.fw_is_running)
 		return -EINVAL;
 
-	DibAcquireLock(&state->platform.risc.mbx_if_lock);
+	if (DibAcquireLock(&state->platform.risc.mbx_if_lock) < 0) {
+		dprintk("could not get the lock");
+		return -EINTR;
+	}
 	tmp = MAX_MAILBOX_TRY;
 	do {
 		size = dib9000_read_word_attr(state, 1043, attr) & 0xff;
@@ -593,7 +602,10 @@ static u8 dib9000_mbx_read(struct dib9000_state *state, u16 * data, u8 risc_id,
 	if (!state->platform.risc.fw_is_running)
 		return 0;
 
-	DibAcquireLock(&state->platform.risc.mbx_if_lock);
+	if (DibAcquireLock(&state->platform.risc.mbx_if_lock) < 0) {
+		dprintk("could not get the lock");
+		return 0;
+	}
 	if (risc_id == 1)
 		mc_base = 16;
 	else
@@ -701,7 +713,10 @@ static int dib9000_mbx_process(struct dib9000_state *state, u16 attr)
 	if (!state->platform.risc.fw_is_running)
 		return -1;
 
-	DibAcquireLock(&state->platform.risc.mbx_lock);
+	if (DibAcquireLock(&state->platform.risc.mbx_lock) < 0) {
+		dprintk("could not get the lock");
+		return -1;
+	}
 
 	if (dib9000_mbx_count(state, 1, attr))	/* 1=RiscB */
 		ret = dib9000_mbx_fetch_to_cache(state, attr);
@@ -1178,7 +1193,10 @@ static int dib9000_fw_get_channel(struct dvb_frontend *fe)
 	struct dibDVBTChannel *ch;
 	int ret = 0;
 
-	DibAcquireLock(&state->platform.risc.mem_mbx_lock);
+	if (DibAcquireLock(&state->platform.risc.mem_mbx_lock) < 0) {
+		dprintk("could not get the lock");
+		return -EINTR;
+	}
 	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0) {
 		ret = -EIO;
 		goto error;
@@ -1660,7 +1678,10 @@ static int dib9000_fw_component_bus_xfer(struct i2c_adapter *i2c_adap, struct i2
 		p[12] = 0;
 	}
 
-	DibAcquireLock(&state->platform.risc.mem_mbx_lock);
+	if (DibAcquireLock(&state->platform.risc.mem_mbx_lock) < 0) {
+		dprintk("could not get the lock");
+		return 0;
+	}
 
 	dib9000_risc_mem_write(state, FE_MM_W_COMPONENT_ACCESS, p);
 
@@ -1768,7 +1789,10 @@ int dib9000_fw_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
 		return 0;
 	}
 
-	DibAcquireLock(&state->demod_lock);
+	if (DibAcquireLock(&state->demod_lock) < 0) {
+		dprintk("could not get the lock");
+		return -EINTR;
+	}
 
 	val = dib9000_read_word(state, 294 + 1) & 0xffef;
 	val |= (onoff & 0x1) << 4;
@@ -1800,7 +1824,10 @@ int dib9000_fw_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
 		return 0;
 	}
 
-	DibAcquireLock(&state->demod_lock);
+	if (DibAcquireLock(&state->demod_lock) < 0) {
+		dprintk("could not get the lock");
+		return -EINTR;
+	}
 	dprintk("Index %x, PID %d, OnOff %d", id, pid, onoff);
 	ret = dib9000_write_word(state, 300 + 1 + id,
 			onoff ? (1 << 13) | pid : 0);
@@ -1848,7 +1875,10 @@ static int dib9000_sleep(struct dvb_frontend *fe)
 	u8 index_frontend;
 	int ret = 0;
 
-	DibAcquireLock(&state->demod_lock);
+	if (DibAcquireLock(&state->demod_lock) < 0) {
+		dprintk("could not get the lock");
+		return -EINTR;
+	}
 	for (index_frontend = 1; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
 		ret = state->fe[index_frontend]->ops.sleep(state->fe[index_frontend]);
 		if (ret < 0)
@@ -1874,8 +1904,12 @@ static int dib9000_get_frontend(struct dvb_frontend *fe)
 	fe_status_t stat;
 	int ret = 0;
 
-	if (state->get_frontend_internal == 0)
-		DibAcquireLock(&state->demod_lock);
+	if (state->get_frontend_internal == 0) {
+		if (DibAcquireLock(&state->demod_lock) < 0) {
+			dprintk("could not get the lock");
+			return -EINTR;
+		}
+	}
 
 	for (index_frontend = 1; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
 		state->fe[index_frontend]->ops.read_status(state->fe[index_frontend], &stat);
@@ -1978,7 +2012,10 @@ static int dib9000_set_frontend(struct dvb_frontend *fe)
 	}
 
 	state->pid_ctrl_index = -1; /* postpone the pid filtering cmd */
-	DibAcquireLock(&state->demod_lock);
+	if (DibAcquireLock(&state->demod_lock) < 0) {
+		dprintk("could not get the lock");
+		return 0;
+	}
 
 	fe->dtv_property_cache.delivery_system = SYS_DVBT;
 
@@ -2138,7 +2175,10 @@ static int dib9000_read_status(struct dvb_frontend *fe, fe_status_t * stat)
 	u8 index_frontend;
 	u16 lock = 0, lock_slave = 0;
 
-	DibAcquireLock(&state->demod_lock);
+	if (DibAcquireLock(&state->demod_lock) < 0) {
+		dprintk("could not get the lock");
+		return -EINTR;
+	}
 	for (index_frontend = 1; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++)
 		lock_slave |= dib9000_read_lock(state->fe[index_frontend]);
 
@@ -2168,8 +2208,15 @@ static int dib9000_read_ber(struct dvb_frontend *fe, u32 * ber)
 	u16 *c;
 	int ret = 0;
 
-	DibAcquireLock(&state->demod_lock);
-	DibAcquireLock(&state->platform.risc.mem_mbx_lock);
+	if (DibAcquireLock(&state->demod_lock) < 0) {
+		dprintk("could not get the lock");
+		return -EINTR;
+	}
+	if (DibAcquireLock(&state->platform.risc.mem_mbx_lock) < 0) {
+		dprintk("could not get the lock");
+		ret = -EINTR;
+		goto error;
+	}
 	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0) {
 		DibReleaseLock(&state->platform.risc.mem_mbx_lock);
 		ret = -EIO;
@@ -2196,7 +2243,10 @@ static int dib9000_read_signal_strength(struct dvb_frontend *fe, u16 * strength)
 	u16 val;
 	int ret = 0;
 
-	DibAcquireLock(&state->demod_lock);
+	if (DibAcquireLock(&state->demod_lock) < 0) {
+		dprintk("could not get the lock");
+		return -EINTR;
+	}
 	*strength = 0;
 	for (index_frontend = 1; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
 		state->fe[index_frontend]->ops.read_signal_strength(state->fe[index_frontend], &val);
@@ -2206,7 +2256,11 @@ static int dib9000_read_signal_strength(struct dvb_frontend *fe, u16 * strength)
 			*strength += val;
 	}
 
-	DibAcquireLock(&state->platform.risc.mem_mbx_lock);
+	if (DibAcquireLock(&state->platform.risc.mem_mbx_lock) < 0) {
+		dprintk("could not get the lock");
+		ret = -EINTR;
+		goto error;
+	}
 	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0) {
 		DibReleaseLock(&state->platform.risc.mem_mbx_lock);
 		ret = -EIO;
@@ -2233,10 +2287,13 @@ static u32 dib9000_get_snr(struct dvb_frontend *fe)
 	u32 n, s, exp;
 	u16 val;
 
-	DibAcquireLock(&state->platform.risc.mem_mbx_lock);
+	if (DibAcquireLock(&state->platform.risc.mem_mbx_lock) < 0) {
+		dprintk("could not get the lock");
+		return 0;
+	}
 	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0) {
 		DibReleaseLock(&state->platform.risc.mem_mbx_lock);
-		return -EIO;
+		return 0;
 	}
 	dib9000_risc_mem_read(state, FE_MM_R_FE_MONITOR, (u8 *) c, 16 * 2);
 	DibReleaseLock(&state->platform.risc.mem_mbx_lock);
@@ -2269,7 +2326,10 @@ static int dib9000_read_snr(struct dvb_frontend *fe, u16 * snr)
 	u8 index_frontend;
 	u32 snr_master;
 
-	DibAcquireLock(&state->demod_lock);
+	if (DibAcquireLock(&state->demod_lock) < 0) {
+		dprintk("could not get the lock");
+		return -EINTR;
+	}
 	snr_master = dib9000_get_snr(fe);
 	for (index_frontend = 1; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++)
 		snr_master += dib9000_get_snr(state->fe[index_frontend]);
@@ -2291,8 +2351,15 @@ static int dib9000_read_unc_blocks(struct dvb_frontend *fe, u32 * unc)
 	u16 *c = (u16 *)state->i2c_read_buffer;
 	int ret = 0;
 
-	DibAcquireLock(&state->demod_lock);
-	DibAcquireLock(&state->platform.risc.mem_mbx_lock);
+	if (DibAcquireLock(&state->demod_lock) < 0) {
+		dprintk("could not get the lock");
+		return -EINTR;
+	}
+	if (DibAcquireLock(&state->platform.risc.mem_mbx_lock) < 0) {
+		dprintk("could not get the lock");
+		ret = -EINTR;
+		goto error;
+	}
 	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0) {
 		DibReleaseLock(&state->platform.risc.mem_mbx_lock);
 		ret = -EIO;
-- 
1.7.4.1

