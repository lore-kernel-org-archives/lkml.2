Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab2CTFT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 01:19:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40807 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2CTFT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 01:19:57 -0400
Message-ID: <4F681551.6030805@gmail.com>
Date: Tue, 20 Mar 2012 15:27:45 +1000
From: wei <yinwei168@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH v3 ] mac80211: avoiding rate oscillation problem in PID
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Wei YIN <Wei.Yin@nicta.com.au>
Addressed version 2 comments from Julian and John

Signed-off-by: Wei YIN <Wei.Yin@nicta.com.au>
---
kernel 3.3.0
net/mac80211/rc80211_pid_algo.c | 392 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------------
net/mac80211/rc80211_pid.h      |  38 ++++++++++++++++++++++++++++++++++++++
2 files changed, 355 insertions(+), 75 deletions(-)

diff -uprN wireless-testing_orig/net/mac80211/rc80211_pid_algo.c wireless-testing/net/mac80211/rc80211_pid_algo.c
--- wireless-testing_orig/net/mac80211/rc80211_pid_algo.c	2012-02-17 13:59:53.495254495 +1000
+++ wireless-testing/net/mac80211/rc80211_pid_algo.c	2012-03-20 11:19:43.431698695 +1000
@@ -3,6 +3,7 @@
  * Copyright 2005, Devicescape Software, Inc.
  * Copyright 2007, Mattias Nissler <mattias.nissler@gmx.de>
  * Copyright 2007-2008, Stefano Brivio <stefano.brivio@polimi.it>
+ * Copyright 2012, Wei Yin, National ICT Australia <Wei.Yin@nicta.com.au>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -69,6 +70,61 @@
  * exhibited a worse failed frames behaviour and we'll choose the highest rate
  * whose failed frames behaviour is not worse than the one of the original rate
  * target. While at it, check that the new rate is valid. */
+
+/* Solve the rate oscilation problem in PID. The idea of PID is based on
+ * control system’s principle of a feedback loop. That is, defining a target
+ * frame loss ratio (FLR) — e.g., the target FLR in PID is fixed at 14% — let
+ * the rate control mechanism to adapt its rate to meet that target by
+ * minimising the difference between the current FLR  and the target FLR. It
+ * is very straight forward; such that PID drops the sending rate when FLR is
+ * greater than 14%, while increases the sending rate when FLR is less than the
+ * target FLR. During the adaptation process PID will increase the rate
+ * whenever the current FLR is below the target threshold, regardless the
+ * current channel conditions which may not be sufficient to support the
+ * higher rate. The consequence of this is the FLR of the higher rate is
+ * higher than the target threshold and this causes PID to drop the rate
+ * again. Hence, this results in oscillation in rate selection as shown in the
+ * paper "Wei Yin, Peizhao Hu, Jadwiga Indulska, and Konstanty Bialkowski. 
+ * Performance of mac80211 rate control mechanisms. In Proceedings of 
+ * MSWiM 2011,October 31- November 4, 2011 Miami Beach, FL, USA". you can find
+ * the paper here http://www.itee.uq.edu.au/~uqwyin/publications/MSWiM2011
+ *
+ * In the proposed approach, when a new rate is proposed by PID controller,
+ * if it is different from the current rate, PIDE will first use a monitor
+ * window (a rate adaptation period long) to check its performance before
+ * adopting it. To achieve this, PIDE sends n frames (e.g., current
+ * implementation uses three frames) using the proposed rate in the next rate
+ * adaptation period. Other frames within next adaptation period will continue
+ * to use the old rate. The proposed rate will be adopted if it is better than
+ * the old rate.
+ *
+ * The debug fs is also changed to monitor PID performance. see /sys/kernel/
+ * debug/ieee80211/phy0/netdev:wlan0/stations/MAC_ADDR/rc_pid_events
+ */
+
+static int pide_frame_duration(int band, size_t len,
+			     int rate, int erp, int short_preamble)
+{
+	int dur = 0;
+
+	/* calculate transmission time (in microseconds) for a data/ACK frame.
+	 * The function code is modified based on ieee80211_frame_duration()
+	 * in net/mac80211/util.c
+	 */
+
+	if (band == IEEE80211_BAND_5GHZ || erp) {
+		dur += 16;
+		dur += 4;
+		dur += 4 * DIV_ROUND_UP((16 + 8 * (len + 4) + 6) * 10,
+					4 * rate);
+	} else {
+		dur += short_preamble ? (72 + 24) : (144 + 48);
+		dur += DIV_ROUND_UP(8 * (len + 4) * 10, rate);
+	}
+
+	return dur;
+}
+
 static void rate_control_pid_adjust_rate(struct ieee80211_supported_band *sband,
 					 struct ieee80211_sta *sta,
 					 struct rc_pid_sta_info *spinfo, int adj,
@@ -109,7 +165,7 @@ static void rate_control_pid_adjust_rate
 	/* Fit the rate found to the nearest supported rate. */
 	do {
 		if (rate_supported(sta, band, rinfo[tmp].index)) {
-			spinfo->txrate_idx = rinfo[tmp].index;
+			spinfo->tmp_rate_idx = rinfo[tmp].index;
 			break;
 		}
 		if (adj < 0)
@@ -118,10 +174,16 @@ static void rate_control_pid_adjust_rate
 			tmp++;
 	} while (tmp < n_bitrates && tmp >= 0);
 
+	spinfo->oldrate = spinfo->txrate_idx;
+	if (spinfo->tmp_rate_idx != spinfo->txrate_idx) {
+		spinfo->monitoring = 1;
+		spinfo->probe_cnt = MAXPROBES;
+	}
+	
 #ifdef CONFIG_MAC80211_DEBUGFS
 	rate_control_pid_event_rate_change(&spinfo->events,
-		spinfo->txrate_idx,
-		sband->bitrates[spinfo->txrate_idx].bitrate);
+		spinfo->tmp_rate_idx,
+		sband->bitrates[spinfo->tmp_rate_idx].bitrate);
 #endif
 }
 
@@ -155,65 +217,168 @@ static void rate_control_pid_sample(stru
 	u32 err_der;
 	int adj, i, j, tmp;
 	unsigned long period;
+	unsigned int dlr;
+	unsigned int perfect_time = 0;
+	unsigned int this_thp, ewma_thp;
+	struct rc_pid_rateinfo *rate;
 
 	/* In case nothing happened during the previous control interval, turn
 	 * the sharpening factor on. */
-	period = msecs_to_jiffies(pinfo->sampling_period);
-	if (jiffies - spinfo->last_sample > 2 * period)
-		spinfo->sharp_cnt = pinfo->sharpen_duration;
-
-	spinfo->last_sample = jiffies;
-
-	/* This should never happen, but in case, we assume the old sample is
-	 * still a good measurement and copy it. */
-	if (unlikely(spinfo->tx_num_xmit == 0))
-		pf = spinfo->last_pf;
-	else
-		pf = spinfo->tx_num_failed * 100 / spinfo->tx_num_xmit;
+	if (!spinfo->monitoring) {
+		period = msecs_to_jiffies(pinfo->sampling_period);
+		if (jiffies - spinfo->last_sample > 2 * period)
+			spinfo->sharp_cnt = pinfo->sharpen_duration;
+
+		spinfo->last_sample = jiffies;
+
+		/* This should never happen, but in case, assume old sample is
+		 * still a good measurement and copy it. */
+		if (unlikely(spinfo->tx_num_xmit == 0))
+			pf = spinfo->last_pf;			
+		else 
+			pf = spinfo->tx_num_failed * 100 / spinfo->tx_num_xmit;
+		
+		if (pinfo->rinfo[spinfo->txrate_idx].this_attempt > 0) {
+			rate = &pinfo->rinfo[spinfo->txrate_idx];
+			dlr = 100 - rate->this_fail * 100 / rate->this_attempt;
+			perfect_time = rate->perfect_tx_time;
+			if (!perfect_time)
+				perfect_time = 1000000;
+
+			this_thp =  dlr * (1000000 / perfect_time);
+			ewma_thp = rate->throughput;
+			if (ewma_thp == 0) 
+				rate->throughput = this_thp;
+			else
+				rate->throughput = (ewma_thp + this_thp) / 2;
+
+			rate->attempt += rate->this_attempt;
+			rate->success += rate->this_success;
+			rate->fail += rate->this_fail;
+			spinfo->tx_num_xmit = 0;
+			spinfo->tx_num_failed = 0;
+			rate->this_fail = 0;
+			rate->this_success = 0;
+			rate->this_attempt = 0;
+
+			/* If just switched rate, update rate info. */
+			if (pinfo->oldrate != spinfo->txrate_idx) {
+				i = rinfo[pinfo->oldrate].rev_index;
+				j = rinfo[spinfo->txrate_idx].rev_index;
+
+				tmp = (pf - spinfo->last_pf);
+				tmp = RC_PID_DO_ARITH_RIGHT_SHIFT(tmp, 
+				      RC_PID_ARITH_SHIFT);
 
-	spinfo->tx_num_xmit = 0;
-	spinfo->tx_num_failed = 0;
+				rinfo[j].diff = rinfo[i].diff + tmp;
+				pinfo->oldrate = spinfo->txrate_idx;
+			}
 
-	/* If we just switched rate, update the rate behaviour info. */
-	if (pinfo->oldrate != spinfo->txrate_idx) {
+			rate_control_pid_normalize(pinfo, sband->n_bitrates);
 
-		i = rinfo[pinfo->oldrate].rev_index;
-		j = rinfo[spinfo->txrate_idx].rev_index;
+			/* proportional, integral and derivative errors. */
+			err_prop = (pinfo->target - pf) << RC_PID_ARITH_SHIFT;
 
-		tmp = (pf - spinfo->last_pf);
-		tmp = RC_PID_DO_ARITH_RIGHT_SHIFT(tmp, RC_PID_ARITH_SHIFT);
+			err_avg = spinfo->err_avg_sc >> pinfo->smoothing_shift;
+			spinfo->err_avg_sc = spinfo->err_avg_sc - err_avg + 
+					     err_prop;
+			err_int = spinfo->err_avg_sc >> pinfo->smoothing_shift;
+
+			err_der = (pf - spinfo->last_pf) *
+				  (1 + pinfo->sharpen_factor * 
+				  spinfo->sharp_cnt);
+			spinfo->last_pf = pf;
+
+			spinfo->last_dlr = dlr;
+			spinfo->oldrate = spinfo->txrate_idx;
+		
+			if (spinfo->sharp_cnt)
+					spinfo->sharp_cnt--;
+
+		#ifdef CONFIG_MAC80211_DEBUGFS
+			rate_control_pid_event_pf_sample(&spinfo->events, pf,
+				err_prop, err_int, err_der);
+		#endif
+
+			/* Compute the controller output. */
+			adj = (err_prop * pinfo->coeff_p + err_int * 
+			      pinfo->coeff_i + err_der * pinfo->coeff_d);
+			adj = RC_PID_DO_ARITH_RIGHT_SHIFT(adj, 
+			      2 * RC_PID_ARITH_SHIFT);
+
+			/* Change rate. */
+			if (adj) {
+				rate_control_pid_adjust_rate(sband, sta,
+				spinfo, adj, rinfo);
+			}
+		}
+	} else {
+		rate = &pinfo->rinfo[spinfo->txrate_idx];
+		period = msecs_to_jiffies(pinfo->sampling_period);
+		if (jiffies - spinfo->last_sample > 2 * period)
+			spinfo->sharp_cnt = pinfo->sharpen_duration;
+
+		spinfo->last_sample = jiffies;
+
+		if (rate->this_attempt > 0) {
+			dlr = 100 - rate->this_fail * 100 / rate->this_attempt;
+			spinfo->last_dlr = dlr;
+			perfect_time = rate->perfect_tx_time;
+			if (!perfect_time)
+				perfect_time = 1000000;
+
+			this_thp =  dlr * (1000000 / perfect_time);
+			ewma_thp = rate->throughput;
+			if (ewma_thp == 0)
+				rate->throughput = this_thp;
+			else
+				rate->throughput = (ewma_thp + this_thp) / 2;
+			
+			rate->attempt += rate->this_attempt;
+			rate->success += rate->this_success;
+			rinfo[spinfo->txrate_idx].fail += rate->this_fail;
+			rate->this_fail = 0;
+			rate->this_success = 0;
+			rate->this_attempt = 0;
+		} 
+
+		rate = &pinfo->rinfo[spinfo->tmp_rate_idx];
+
+		if (rate->this_attempt > 0) {
+			dlr = 100 - rate->this_fail * 100 / rate->this_attempt;
+			perfect_time = rate->perfect_tx_time;
+			if (!perfect_time)
+				perfect_time = 1000000;
+
+			this_thp =  dlr * (1000000 / perfect_time);
+			ewma_thp = rate->throughput;
+			if (ewma_thp == 0)
+				rate->throughput = this_thp;
+			else
+				rate->throughput = (ewma_thp + this_thp) / 2;
+
+			/* adopt proposed rate if it is better. */
+			if (rate->throughput > 
+			    pinfo->rinfo[spinfo->txrate_idx].throughput)
+				spinfo->txrate_idx = spinfo->tmp_rate_idx;
+
+			rate->attempt += rate->this_attempt;
+			rate->success += rate->this_success;
+			rate->fail += rate->this_fail;
+
+			rate->this_fail = 0;
+			rate->this_success = 0;
+			rate->this_attempt = 0;
+	
+			spinfo->oldrate = spinfo->txrate_idx;	
+		}
 
-		rinfo[j].diff = rinfo[i].diff + tmp;
-		pinfo->oldrate = spinfo->txrate_idx;
+		spinfo->probes = 0;
+		spinfo->fail_probes = 0;
+		spinfo->tx_num_xmit = 0;
+		spinfo->tx_num_failed = 0;
+		spinfo->monitoring = 0;
 	}
-	rate_control_pid_normalize(pinfo, sband->n_bitrates);
-
-	/* Compute the proportional, integral and derivative errors. */
-	err_prop = (pinfo->target - pf) << RC_PID_ARITH_SHIFT;
-
-	err_avg = spinfo->err_avg_sc >> pinfo->smoothing_shift;
-	spinfo->err_avg_sc = spinfo->err_avg_sc - err_avg + err_prop;
-	err_int = spinfo->err_avg_sc >> pinfo->smoothing_shift;
-
-	err_der = (pf - spinfo->last_pf) *
-		  (1 + pinfo->sharpen_factor * spinfo->sharp_cnt);
-	spinfo->last_pf = pf;
-	if (spinfo->sharp_cnt)
-			spinfo->sharp_cnt--;
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	rate_control_pid_event_pf_sample(&spinfo->events, pf, err_prop, err_int,
-					 err_der);
-#endif
-
-	/* Compute the controller output. */
-	adj = (err_prop * pinfo->coeff_p + err_int * pinfo->coeff_i
-	      + err_der * pinfo->coeff_d);
-	adj = RC_PID_DO_ARITH_RIGHT_SHIFT(adj, 2 * RC_PID_ARITH_SHIFT);
-
-	/* Change rate. */
-	if (adj)
-		rate_control_pid_adjust_rate(sband, sta, spinfo, adj, rinfo);
 }
 
 static void rate_control_pid_tx_status(void *priv, struct ieee80211_supported_band *sband,
@@ -224,30 +389,65 @@ static void rate_control_pid_tx_status(v
 	struct rc_pid_sta_info *spinfo = priv_sta;
 	unsigned long period;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct rc_pid_rateinfo * pidrate = spinfo->rinfo;
+	struct rc_pid_rateinfo *rate;
+	int count;
 
 	if (!spinfo)
 		return;
 
 	/* Ignore all frames that were sent with a different rate than the rate
 	 * we currently advise mac80211 to use. */
-	if (info->status.rates[0].idx != spinfo->txrate_idx)
-		return;
 
-	spinfo->tx_num_xmit++;
+	if (info->status.rates[0].idx != spinfo->txrate_idx &&
+		info->status.rates[0].idx != spinfo->tmp_rate_idx)
+		return;
 
-#ifdef CONFIG_MAC80211_DEBUGFS
-	rate_control_pid_event_tx_status(&spinfo->events, info);
-#endif
+	count = info->status.rates[0].count;
 
-	/* We count frames that totally failed to be transmitted as two bad
-	 * frames, those that made it out but had some retries as one good and
-	 * one bad frame. */
-	if (!(info->flags & IEEE80211_TX_STAT_ACK)) {
-		spinfo->tx_num_failed += 2;
-		spinfo->tx_num_xmit++;
-	} else if (info->status.rates[0].count > 1) {
-		spinfo->tx_num_failed++;
+	if (info->status.rates[0].idx == spinfo->txrate_idx) {
 		spinfo->tx_num_xmit++;
+		#ifdef CONFIG_MAC80211_DEBUGFS
+		rate_control_pid_event_tx_status(&spinfo->events, info);
+		#endif
+		rate = &pidrate[spinfo->txrate_idx];
+
+		if (!(info->flags & IEEE80211_TX_STAT_ACK)) {
+			spinfo->tx_num_failed += count;
+			rate->this_fail += count;
+			rate->this_attempt += count;
+			spinfo->tx_num_xmit += count - 1;
+		} else if (count > 1) {
+			rate->this_fail += count - 1;
+			spinfo->tx_num_failed += count - 1;
+			rate->this_attempt += count;
+			spinfo->tx_num_xmit += count - 1;
+			rate->this_success += 1;	
+		} else if (count == 1) {
+			rate->this_success += 1;
+			rate->this_attempt += 1;
+		}
+	} 
+
+	if (info->status.rates[0].idx != spinfo->txrate_idx && 
+	    info->status.rates[0].idx == spinfo->tmp_rate_idx) {
+		spinfo->probes++;
+		rate = &pidrate[spinfo->tmp_rate_idx];
+		if (!(info->flags & IEEE80211_TX_STAT_ACK)) {
+			rate->this_fail += count;
+			spinfo->fail_probes += count; 
+			spinfo->probes += count - 1;
+			rate->this_attempt += count;
+		} else if (count > 1) {
+			rate->this_success += 1;
+			spinfo->fail_probes += count - 1;
+			spinfo->probes += count - 1;
+			rate->this_fail += count - 1;
+			rate->this_attempt += count;
+		} else if (count == 1) {
+			rate->this_success += 1;
+			rate->this_attempt += 1;
+		}
 	}
 
 	/* Update PID controller state. */
@@ -267,18 +467,34 @@ rate_control_pid_get_rate(void *priv, st
 	struct rc_pid_sta_info *spinfo = priv_sta;
 	int rateidx;
 
+	/* The target FLR in PID is 14% and it attempts to decrease the rate if
+	 * the FLR is higher than 14%. Let us assume that the current FLR is
+	 * 14%. The probability for two consecutive failed attempts should
+	 * be 14% * 14% = 1.96%, which is very low. So it should not try
+	 * further retransmissions at this rate but fall back as soon as
+	 * possible. In addition, the number of probes at the proposed rate is
+	 * set to MAX_PROBES = 3, which means there may be 6 attempts at the
+	 * newly proposed rate. If the proposed rate is the lowest, say 1 Mbit/s,
+	 * in 120 ms (a rate adaptation period in PID), the maximum number of
+	 * attempts is around 8--9. To set the retry count to 2 could limit 
+	 * the number of attempts at the proposed rate within the maximum in
+	 * one rate adaptation period.
+	 */
 	if (txrc->rts)
 		info->control.rates[0].count =
 			txrc->hw->conf.long_frame_max_tx_count;
 	else
-		info->control.rates[0].count =
-			txrc->hw->conf.short_frame_max_tx_count;
-
+		info->control.rates[0].count = 2;
 	/* Send management frames and NO_ACK data using lowest rate. */
 	if (rate_control_send_low(sta, priv_sta, txrc))
 		return;
 
-	rateidx = spinfo->txrate_idx;
+	if (spinfo->monitoring && spinfo->probe_cnt > 0) {
+		rateidx = spinfo->tmp_rate_idx;
+		spinfo->probe_cnt--;
+	} else {
+		rateidx = spinfo->txrate_idx;
+	}
 
 	if (rateidx >= sband->n_bitrates)
 		rateidx = sband->n_bitrates - 1;
@@ -300,6 +516,10 @@ rate_control_pid_rate_init(void *priv, s
 	struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
 	int i, j, tmp;
 	bool s;
+	int n = 0;
+	struct ieee80211_rate *ctl_rate;
+	int band_info = 0;
+	int erp = 0, sifs = 0;
 
 	/* TODO: This routine should consider using RSSI from previous packets
 	 * as we need to have IEEE 802.1X auth succeed immediately after assoc..
@@ -334,6 +554,39 @@ rate_control_pid_rate_init(void *priv, s
 	}
 
 	spinfo->txrate_idx = rate_lowest_index(sband, sta);
+
+	band_info = sband->band;
+	spinfo->rinfo = pinfo->rinfo;
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if (!rate_supported(sta, sband->band, i))
+			continue;
+		n++;
+		ctl_rate = &sband->bitrates[i];
+		rinfo[i].bitrate = sband->bitrates[i].bitrate / 5;
+		erp = !!(ctl_rate->flags & IEEE80211_RATE_ERP_G);
+		sifs = (band_info == IEEE80211_BAND_5GHZ || erp) ? 16 : 10;
+		rinfo[i].perfect_tx_time = TDIFS + (TSLOT * 15 >> 1) + sifs +
+			pide_frame_duration(band_info, 1530, 
+				sband->bitrates[i].bitrate, erp, 1) +
+			pide_frame_duration(band_info, 10,
+				sband->bitrates[i].bitrate, erp, 1);
+		rinfo[i].throughput = 0;
+		rinfo[i].this_attempt = 0;
+		rinfo[i].this_success = 0;
+		rinfo[i].this_fail = 0;
+		rinfo[i].attempt = 0;
+		rinfo[i].success = 0;
+		rinfo[i].fail = 0;
+	}
+	
+	spinfo->last_dlr = 0;
+	spinfo->fail_probes = 0;
+	spinfo->probes = 0;
+	spinfo->monitoring = 0;
+	spinfo->oldrate = 0;
+	spinfo->n_rates = n;
+	spinfo->tmp_rate_idx = 0;
+	spinfo->probe_cnt = MAXPROBES;
 }
 
 static void *rate_control_pid_alloc(struct ieee80211_hw *hw,

diff -uprN wireless-testing_orig/net/mac80211/rc80211_pid.h wireless-testing/net/mac80211/rc80211_pid.h
--- wireless-testing_orig/net/mac80211/rc80211_pid.h	2012-02-17 13:59:53.403182811 +1000
+++ wireless-testing/net/mac80211/rc80211_pid.h	2012-03-08 14:07:49.775694466 +1000
@@ -1,6 +1,7 @@
 /*
  * Copyright 2007, Mattias Nissler <mattias.nissler@gmx.de>
  * Copyright 2007, Stefano Brivio <stefano.brivio@polimi.it>
+ * Copyright 2012, Wei Yin, National ICT Australia <Wei.Yin@nicta.com.au>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -24,6 +25,9 @@
 /* Fixed point arithmetic shifting amount. */
 #define RC_PID_ARITH_SHIFT		8
 
+/* Fixed point arithmetic factor. */
+#define RC_PID_ARITH_FACTOR		(1 << RC_PID_ARITH_SHIFT)
+
 /* Proportional PID component coefficient. */
 #define RC_PID_COEFF_P			15
 /* Integral PID component coefficient. */
@@ -48,6 +52,10 @@
 #define RC_PID_DO_ARITH_RIGHT_SHIFT(x, y) \
 	((x) < 0 ? -((-(x)) >> (y)) : (x) >> (y))
 
+#define MAXPROBES 3
+#define TDIFS 34
+#define TSLOT 9
+
 enum rc_pid_event_type {
 	RC_PID_EVENT_TYPE_TX_STATUS,
 	RC_PID_EVENT_TYPE_RATE_CHANGE,
@@ -118,6 +126,11 @@ struct rc_pid_events_file_info {
 	unsigned int next_entry;
 };
 
+struct rc_pid_debugfs_info {
+	size_t len;
+	char buf[];
+};
+
 /**
  * struct rc_pid_debugfs_entries - tunable parameters
  *
@@ -169,6 +182,11 @@ void rate_control_pid_add_sta_debugfs(vo
 
 void rate_control_pid_remove_sta_debugfs(void *priv, void *priv_sta);
 
+int pid_stats_open(struct inode *inode, struct file *file);
+ssize_t pid_stats_read(struct file *file, char __user *buf, size_t len,
+		       loff_t *ppos);
+int pid_stats_release(struct inode *inode, struct file *file);
+
 struct rc_pid_sta_info {
 	unsigned long last_change;
 	unsigned long last_sample;
@@ -219,6 +237,16 @@ struct rc_pid_sta_info {
 
 	/* Events debugfs file entry */
 	struct dentry *events_entry;
+
+	int last_dlr; 
+	int fail_probes; 
+	int probes; 
+	int monitoring; 
+	int oldrate;
+	int n_rates;
+	int tmp_rate_idx;
+	int probe_cnt;
+	struct rc_pid_rateinfo *rinfo;
 #endif
 };
 
@@ -238,6 +266,16 @@ struct rc_pid_rateinfo {
 
 	/* Comparison with the lowest rate. */
 	int diff;
+
+	int bitrate;
+	int perfect_tx_time;
+	unsigned int throughput;
+	unsigned int this_attempt;
+	unsigned int this_success;
+	unsigned int this_fail;
+	unsigned long attempt;
+	unsigned long success;
+	unsigned long fail;
 };
 
 struct rc_pid_info {

