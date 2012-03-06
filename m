Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031318Ab2CFVIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:08:22 -0500
Received: from smtp.ispras.ru ([83.149.198.202]:33519 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031155Ab2CFVIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:08:20 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Patrick Boettcher <Patrick.Boettcher@dibcom.fr>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Olivier Grenie <olivier.grenie@dibcom.fr>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH 1/2] [media] dib9000: fix explicit lock mismatches
Date: Wed,  7 Mar 2012 01:08:16 +0400
Message-Id: <1331068096-11563-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several error paths, where &state->platform.risc.mem_mbx_lock
is not unlocked. The patch fixes it.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/dvb/frontends/dib9000.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib9000.c b/drivers/media/dvb/frontends/dib9000.c
index 863ef3c..d96b6a1 100644
--- a/drivers/media/dvb/frontends/dib9000.c
+++ b/drivers/media/dvb/frontends/dib9000.c
@@ -2208,6 +2208,7 @@ static int dib9000_read_signal_strength(struct dvb_frontend *fe, u16 * strength)
 
 	DibAcquireLock(&state->platform.risc.mem_mbx_lock);
 	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0) {
+		DibReleaseLock(&state->platform.risc.mem_mbx_lock);
 		ret = -EIO;
 		goto error;
 	}
@@ -2233,8 +2234,10 @@ static u32 dib9000_get_snr(struct dvb_frontend *fe)
 	u16 val;
 
 	DibAcquireLock(&state->platform.risc.mem_mbx_lock);
-	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0)
+	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0) {
+		DibReleaseLock(&state->platform.risc.mem_mbx_lock);
 		return -EIO;
+	}
 	dib9000_risc_mem_read(state, FE_MM_R_FE_MONITOR, (u8 *) c, 16 * 2);
 	DibReleaseLock(&state->platform.risc.mem_mbx_lock);
 
@@ -2291,6 +2294,7 @@ static int dib9000_read_unc_blocks(struct dvb_frontend *fe, u32 * unc)
 	DibAcquireLock(&state->demod_lock);
 	DibAcquireLock(&state->platform.risc.mem_mbx_lock);
 	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0) {
+		DibReleaseLock(&state->platform.risc.mem_mbx_lock);
 		ret = -EIO;
 		goto error;
 	}
-- 
1.7.4.1

