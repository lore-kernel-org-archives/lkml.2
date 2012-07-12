Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162603Ab2GLXD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:03:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63192 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162583Ab2GLXDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:03:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rolf Offermanns <rolf.offermanns@gmx.net>,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 21/68] ath9k: Fix softlockup in AR9485
Date: Thu, 12 Jul 2012 16:01:55 -0700
Message-Id: <20120712175037.323234452@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/main.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -648,6 +648,15 @@ void ath_hw_pll_work(struct work_struct
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


