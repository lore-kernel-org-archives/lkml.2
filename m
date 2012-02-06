Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab2BFWTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:19:42 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:36458 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab2BFWTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:19:41 -0500
X-Greylist: delayed 652 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Feb 2012 17:19:41 EST
Message-ID: <4F304CAD.5080700@simon.arlott.org.uk>
Date: Mon, 06 Feb 2012 21:57:01 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110823 Thunderbird/5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] dvb-core: fix DVBFE_ALGO_HW retune bug
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7e07222 breaks DVBFE_ALGO_HW tuning after a retune is requested,
which causes bad tuning on my TBS 6920.

[    0.769091] pci 0000:06:00.0: [14f1:8852] type 0 class 0x000400
[   19.733530] CORE cx23885[0]: subsystem: 6920:8888, board: TurboSight TBS 6920 [card=14,autodetected]
[  762.824912] cx24116_load_firmware: FW version 1.23.86.1

7e0722215a510921cbb73ab4c37477d4dcb91bf8 [media] dvb-core: Don't pass DVBv3 parameters on tune() fops

Although re_tune is set to true when FESTATE_RETUNE occurs, it is never
set back to false which the old code used to do when !FESTATE_RETUNE.

This patch sets re_tune to false if !(state & FESTATE_RETUNE).

$ szap-s2 -a 2 "Channel 5"
reading channels from file '/home/simon/.szap/channels.conf'
zapping to 247 'Channel 5':
delivery DVB-S, modulation QPSK
sat 0, frequency 10964 MHz H, symbolrate 22000000, coderate 5/6, rolloff 0.35
vpid 0x092a, apid 0x092b, sid 0x092d
using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
status 1f | signal cf40 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal cf40 | snr eccd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal cf40 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal cf40 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal cf40 | snr eccd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal cf40 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal cf40 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal cf40 | snr eb33 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal cf40 | snr eccd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal cf40 | snr eccd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal cf40 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal cf40 | snr eccd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal cf40 | snr eccd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal cf40 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal cec0 | snr eccd | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal cec0 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index fbbe545..4555baa 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -655,6 +655,8 @@ restart:
 					dprintk("%s: Retune requested, FESTATE_RETUNE\n", __func__);
 					re_tune = true;
 					fepriv->state = FESTATE_TUNED;
+				} else {
+					re_tune = false;
 				}
 
 				if (fe->ops.tune)
-- 
1.7.8.rc3

-- 
Simon Arlott
