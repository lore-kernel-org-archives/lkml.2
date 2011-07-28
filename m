Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab1G1Xth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:49:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:50848 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab1G1Xog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="32808999"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: rmanohar@qca.qualcomm.com, linville@tuxdriver.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [31/50] mac80211: Restart STA timers only on associated state
Message-Id: <20110728234435.D421B2403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

[ upstream commit 676b58c27475a9defccc025fea1cbd2b141ee539 ]

A panic was observed when the device is failed to resume properly,
and there are no running interfaces. ieee80211_reconfig tries
to restart STA timers on unassociated state.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/net/mac80211/mlme.c
===================================================================
--- linux-2.6.35.y.orig/net/mac80211/mlme.c
+++ linux-2.6.35.y/net/mac80211/mlme.c
@@ -1995,6 +1995,9 @@ void ieee80211_sta_restart(struct ieee80
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	if (!ifmgd->associated)
+		return;
+
 	if (test_and_clear_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running))
 		add_timer(&ifmgd->timer);
 	if (test_and_clear_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running))
