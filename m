Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab2GASU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:20:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47055 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932422Ab2GASQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:45 -0400
Message-Id: <20120701172010.214132456@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        Rolf Offermanns <rolf.offermanns@gmx.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 25/48] ath9k: Fix softlockup in AR9485
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

commit bcb7ad7bcbef030e6ba71ede1f9866368aca7c99 upstream.

steps to recreate:
load latest ath9k driver with AR9485
stop the network-manager and wpa_supplicant
bring the interface up

	Call Trace:
	[<ffffffffa0517490>] ? ath_hw_check+0xe0/0xe0 [ath9k]
	[<ffffffff812cd1e8>] __const_udelay+0x28/0x30
	[<ffffffffa03bae7a>] ar9003_get_pll_sqsum_dvc+0x4a/0x80 [ath9k_hw]
	[<ffffffffa05174eb>] ath_hw_pll_work+0x5b/0xe0 [ath9k]
	[<ffffffff810744fe>] process_one_work+0x11e/0x470
	[<ffffffff8107530f>] worker_thread+0x15f/0x360
	[<ffffffff810751b0>] ? manage_workers+0x230/0x230
	[<ffffffff81079af3>] kthread+0x93/0xa0
	[<ffffffff815fd3a4>] kernel_thread_helper+0x4/0x10
	[<ffffffff81079a60>] ? kthread_freezable_should_stop+0x70/0x70
	[<ffffffff815fd3a0>] ? gs_change+0x13/0x13

ensure that the PLL-WAR for AR9485/AR9340 is executed only if the STA is
associated (or) IBSS/AP mode had started beaconing. Ideally this WAR
is needed to recover from some rare beacon stuck during stress testing.
Before the STA is associated/IBSS had started beaconing, PLL4(0x1618c)
always seem to have zero even though we had configured PLL3(0x16188) to
query about PLL's locking status. When we keep on polling infinitely PLL4's
8th bit(ie check for PLL locking measurements is done), machine hangs
due to softlockup.

fixes https://bugzilla.redhat.com/show_bug.cgi?id=811142

Reported-by: Rolf Offermanns <rolf.offermanns@gmx.net>
Tested-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/main.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ac41f1e..dac1a27 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -971,6 +971,15 @@ void ath_hw_pll_work(struct work_struct *work)
 					    hw_pll_work.work);
 	u32 pll_sqsum;
 
+	/*
+	 * ensure that the PLL WAR is executed only
+	 * after the STA is associated (or) if the
+	 * beaconing had started in interfaces that
+	 * uses beacons.
+	 */
+	if (!(sc->sc_flags & SC_OP_BEACONS))
+		return;
+
 	if (AR_SREV_9485(sc->sc_ah)) {
 
 		ath9k_ps_wakeup(sc);


