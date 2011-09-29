Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab1I2CL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 22:11:28 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18056 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab1I2CL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 22:11:26 -0400
Message-ID: <4E83D3B3.7090508@oracle.com>
Date: Thu, 29 Sep 2011 10:10:59 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>
CC: Guru Anbalagane <guru.anbalagane@oracle.com>,
        Gurudas Pai <gurudas.pai@oracle.com>, Joe Jin <joe.jin@oracle.com>,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Marsden <greg.marsden@oracle.com>
Subject: [PATCH] tg3: Dont dump registers if interface not ready.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E83D3CD.000A:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When bootup the server with BCM5704 Gigabit Ethernet get below warning:

tg3 0000:03:01.0: eth0: DMA Status error.  Resetting chip.
<Registers state of device>
tg3 0000:03:01.0: eth0: 0: Host status block [00000007:00000002:(0000:0000:0000):(0000:0000)]
tg3 0000:03:01.0: eth0: 0: NAPI info [00000001:00000002:(0000:0000:01ff):0000:(00c8:0000:0000:0000)]
tg3 0000:03:01.0: eth0: Link is up at 1000 Mbps, full duplex
tg3 0000:03:01.0: eth0: Flow control is on for TX and on for RX
tg3 0000:03:01.0: tg3_stop_block timed out, ofs=4800 enable_bit=2
tg3 0000:03:01.0: eth0: Link is down
tg3 0000:03:01.0: eth0: Link is up at 1000 Mbps, full duplex
tg3 0000:03:01.0: eth0: Flow control is on for TX and on for RX

If device not ready, then would not dump registers info.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Guru Anbalagane <guru.anbalagane@oracle.com>
Reported-by: Gurudas Pai <gurudas.pai@oracle.com>
Cc: Matt Carlson <mcarlson@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>
---
 drivers/net/tg3.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 4a1374d..d79d344 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -5475,10 +5475,15 @@ static void tg3_process_error(struct tg3 *tp)
 {
 	u32 val;
 	bool real_error = false;
+	bool dump = true;
 
 	if (tg3_flag(tp, ERROR_PROCESSED))
 		return;
 
+	/* If interface not ready then dont dump error */
+	if (!netif_carrier_ok(tp->dev))
+		dump = false;
+
 	/* Check Flow Attention register */
 	val = tr32(HOSTCC_FLOW_ATTN);
 	if (val & ~HOSTCC_FLOW_ATTN_MBUF_LWM) {
@@ -5492,14 +5497,16 @@ static void tg3_process_error(struct tg3 *tp)
 	}
 
 	if (tr32(RDMAC_STATUS) || tr32(WDMAC_STATUS)) {
-		netdev_err(tp->dev, "DMA Status error.  Resetting chip.\n");
+		if (dump)
+			netdev_err(tp->dev, "DMA Status error.  Resetting chip.\n");
 		real_error = true;
 	}
 
 	if (!real_error)
 		return;
 
-	tg3_dump_state(tp);
+	if (dump)
+		tg3_dump_state(tp);
 
 	tg3_flag_set(tp, ERROR_PROCESSED);
 	schedule_work(&tp->reset_task);
-- 
1.7.6.2

