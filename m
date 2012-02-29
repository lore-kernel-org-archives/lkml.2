Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab2B2MOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:14:25 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60960 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab2B2MOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:14:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of yinwei168@gmail.com designates 10.68.224.133 as permitted sender) smtp.mail=yinwei168@gmail.com; dkim=pass header.i=yinwei168@gmail.com
MIME-Version: 1.0
Date: Wed, 29 Feb 2012 22:14:21 +1000
Message-ID: <CAFxU49m76xaLGv9CFhKcZBhE-8QgT1KSuhnZRcVwzP2ogrGpbQ@mail.gmail.com>
Subject: [PATCH] mac80211: improve PID rate control mechanism by avoiding rate
 oscillation problem
From: YIN Wei <yinwei168@gmail.com>
To: johannes <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mattias.nissler@gmx.de,
        stefano.brivio@polimi.it
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei YIN (Wei.Yin@nicta.com.au)

Improve PID rate control mechanism by solving the rate oscillation
problem. Current PID mechanism is based on a PID  controller which
tries to minimise the difference between the frame loss ratio (FLR)
and the target FLR. Therefore it is straight forward that it increases
to a higher rate when the FLR is less than the target without
considering whether the higher rate can be supported. If the higher
rate cannot be supported, significant FLR will occur, which causes the
mechanism to decrease the rate sharply. The proposed approach only
updates the rate when the proposed rate by the PID controller can
achieve better throughput than the old rate. This patch applies to
kernel 3.3.0.
Signed-off-by: Wei YIN (Wei.Yin@nicta.com.au)
---
diff -uprN wireless-testing_orig/net/mac80211/Kconfig
wireless-testing/net/mac80211/Kconfig
--- wireless-testing_orig/net/mac80211/Kconfig	2012-02-17
13:59:53.495254495 +1000
+++ wireless-testing/net/mac80211/Kconfig	2012-02-21 11:35:40.495706869 +1000
@@ -21,6 +21,7 @@ config MAC80211_HAS_RC
 config MAC80211_RC_PID
 	bool "PID controller based rate control algorithm" if EXPERT
 	select MAC80211_HAS_RC
+	default y
 	---help---
 	  This option enables a TX rate control algorithm for
 	  mac80211 that uses a PID controller to select the TX
diff -uprN wireless-testing_orig/net/mac80211/rc80211_pid_algo.c
wireless-testing/net/mac80211/rc80211_pid_algo.c
--- wireless-testing_orig/net/mac80211/rc80211_pid_algo.c	2012-02-17
13:59:53.495254495 +1000
+++ wireless-testing/net/mac80211/rc80211_pid_algo.c	2012-02-29
11:01:32.043698711 +1000
@@ -4,6 +4,8 @@
  * Copyright 2007, Mattias Nissler <mattias.nissler@gmx.de>
  * Copyright 2007-2008, Stefano Brivio <stefano.brivio@polimi.it>
  *
+ * Copyright 2012, Wei Yin, National ICT Australia <Wei.Yin@nicta.com.au>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -69,6 +71,90 @@
  * exhibited a worse failed frames behaviour and we'll choose the highest rate
  * whose failed frames behaviour is not worse than the one of the original rate
  * target. While at it, check that the new rate is valid. */
+
+/* Solve the rate oscilation problem in PID. The idea of PID is based on
+ * control system’s principle of a feedback loop. That is, defining a target
+ * frame loss ratio (FLR) — e.g., the target FLR in PID is fixed at
14% — let
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
+ * paper "Performance of mac80211 rate control mechanisms".
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
+ * debug/ieee80211/phy0/netdev\:wlan0/stations/MAC_ADDR/rc_pid_events
+ *
+ *
+ */
+
+static int pide_frame_duration(int band, size_t len,
+			     int rate, int erp, int short_preamble)
+{
+	int dur = 0;
+
+	/* calculate duration (in microseconds, rounded up to next higher
+	 * integer if it includes a fractional microsecond) to send frame of
+	 * len bytes (does not include FCS) at the given rate. Duration will
+	 * also include SIFS.
+	 *
+	 * rate is in 100 kbps, so divident is multiplied by 10 in the
+	 * DIV_ROUND_UP() operations.
+	 */
+
+	if (band == IEEE80211_BAND_5GHZ || erp) {
+		/*
+		 * OFDM:
+		 *
+		 * N_DBPS = DATARATE x 4
+		 * N_SYM = Ceiling((16+8xLENGTH+6) / N_DBPS)
+		 *	(16 = SIGNAL time, 6 = tail bits)
+		 * TXTIME = T_PREAMBLE + T_SIGNAL + T_SYM x N_SYM + Signal Ext
+		 *
+		 * T_SYM = 4 usec
+		 * 802.11a - 17.5.2: aSIFSTime = 16 usec
+		 * 802.11g - 19.8.4: aSIFSTime = 10 usec +
+		 *	signal ext = 6 usec
+		 */
+		
+		dur += 16; /* 17.3.2.3: T_PREAMBLE = 16 usec */
+		dur += 4; /* 17.3.2.3: T_SIGNAL = 4 usec */
+		dur += 4 * DIV_ROUND_UP((16 + 8 * (len + 4) + 6) * 10,
+					4 * rate); /* T_SYM x N_SYM */
+	} else {
+		/*
+		 * 802.11b or 802.11g with 802.11b compatibility:
+		 * 18.3.4: TXTIME = PreambleLength + PLCPHeaderTime +
+		 * Ceiling(((LENGTH+PBCC)x8)/DATARATE). PBCC=0.
+		 *
+		 * 802.11 (DS): 15.3.3, 802.11b: 18.3.4
+		 * aSIFSTime = 10 usec
+		 * aPreambleLength = 144 usec or 72 usec with short preamble
+		 * aPLCPHeaderLength = 48 usec or 24 usec with short preamble
+		 */
+		
+		dur += short_preamble ? (72 + 24) : (144 + 48);
+
+		dur += DIV_ROUND_UP(8 * (len + 4) * 10, rate);
+	}
+
+	return dur;
+}
+
 static void rate_control_pid_adjust_rate(struct
ieee80211_supported_band *sband,
 					 struct ieee80211_sta *sta,
 					 struct rc_pid_sta_info *spinfo, int adj,
@@ -109,7 +195,8 @@ static void rate_control_pid_adjust_rate
 	/* Fit the rate found to the nearest supported rate. */
 	do {
 		if (rate_supported(sta, band, rinfo[tmp].index)) {
-			spinfo->txrate_idx = rinfo[tmp].index;
+			/* PIDE: record proposed rate as a temporary rate. */
+			spinfo->tmp_rate_idx = rinfo[tmp].index;
 			break;
 		}
 		if (adj < 0)
@@ -118,10 +205,19 @@ static void rate_control_pid_adjust_rate
 			tmp++;
 	} while (tmp < n_bitrates && tmp >= 0);

+	/* PIDE: check whether monitor window is needed */
+	spinfo->oldrate = spinfo->txrate_idx;
+	if (spinfo->tmp_rate_idx != spinfo->txrate_idx) {
+		spinfo->monitoring = 1;
+		spinfo->probe_cnt = MAXPROBES;
+	}
+	
+
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 	rate_control_pid_event_rate_change(&spinfo->events,
-		spinfo->txrate_idx,
-		sband->bitrates[spinfo->txrate_idx].bitrate);
+		spinfo->tmp_rate_idx,
+		sband->bitrates[spinfo->tmp_rate_idx].bitrate);
 #endif
 }

@@ -155,99 +251,247 @@ static void rate_control_pid_sample(stru
 	u32 err_der;
 	int adj, i, j, tmp;
 	unsigned long period;
+	
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
-
-	spinfo->tx_num_xmit = 0;
-	spinfo->tx_num_failed = 0;
-
-	/* If we just switched rate, update the rate behaviour info. */
-	if (pinfo->oldrate != spinfo->txrate_idx) {
-
-		i = rinfo[pinfo->oldrate].rev_index;
-		j = rinfo[spinfo->txrate_idx].rev_index;
-
-		tmp = (pf - spinfo->last_pf);
-		tmp = RC_PID_DO_ARITH_RIGHT_SHIFT(tmp, RC_PID_ARITH_SHIFT);
-
-		rinfo[j].diff = rinfo[i].diff + tmp;
-		pinfo->oldrate = spinfo->txrate_idx;
-	}
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
+		
+		/* PIDE: calculate statistics for the current rate */
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
+			/* If just switched rate, update rate info. */
+			if (pinfo->oldrate != spinfo->txrate_idx) {
+
+				i = rinfo[pinfo->oldrate].rev_index;
+				j = rinfo[spinfo->txrate_idx].rev_index;
+
+				tmp = (pf - spinfo->last_pf);
+				tmp = RC_PID_DO_ARITH_RIGHT_SHIFT(tmp,
+				      RC_PID_ARITH_SHIFT);
+
+				rinfo[j].diff = rinfo[i].diff + tmp;
+				pinfo->oldrate = spinfo->txrate_idx;
+		
+			}
+			rate_control_pid_normalize(pinfo, sband->n_bitrates);

-#ifdef CONFIG_MAC80211_DEBUGFS
-	rate_control_pid_event_pf_sample(&spinfo->events, pf, err_prop, err_int,
-					 err_der);
-#endif
+			/* proportional, integral and derivative errors. */
+			err_prop = (pinfo->target - pf) << RC_PID_ARITH_SHIFT;

-	/* Compute the controller output. */
-	adj = (err_prop * pinfo->coeff_p + err_int * pinfo->coeff_i
-	      + err_der * pinfo->coeff_d);
-	adj = RC_PID_DO_ARITH_RIGHT_SHIFT(adj, 2 * RC_PID_ARITH_SHIFT);
-
-	/* Change rate. */
-	if (adj)
-		rate_control_pid_adjust_rate(sband, sta, spinfo, adj, rinfo);
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
+		/* PIDE: calculate statistics for current rate */
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
+
+		}
+		rate = &pinfo->rinfo[spinfo->tmp_rate_idx];
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
+			
+		}
+		spinfo->probes = 0;
+		spinfo->fail_probes = 0;
+		spinfo->tx_num_xmit = 0;
+		spinfo->tx_num_failed = 0;
+		spinfo->monitoring = 0;
+	}
 }

-static void rate_control_pid_tx_status(void *priv, struct
ieee80211_supported_band *sband,
-				       struct ieee80211_sta *sta, void *priv_sta,
+static void rate_control_pid_tx_status(void *priv,
+				       struct ieee80211_supported_band *sband,
+				       struct ieee80211_sta *sta,
+				       void *priv_sta,
 				       struct sk_buff *skb)
 {
 	struct rc_pid_info *pinfo = priv;
 	struct rc_pid_sta_info *spinfo = priv_sta;
 	unsigned long period;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
+	
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
+	/* PIDE: get statistics for the temporary rate and the current rate. */
+	if ((info->status.rates[0].idx != spinfo->txrate_idx) &&
+			(info->status.rates[0].idx != spinfo->tmp_rate_idx))
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
+
+		if (!(info->flags & IEEE80211_TX_STAT_ACK)) {
+			spinfo->tx_num_failed += count;
+			rate->this_fail += count;
+			rate->this_attempt += count;
+			spinfo->tx_num_xmit += count - 1;
+			
+		} else if (count > 1) {
+			rate->this_fail += count - 1;
+			spinfo->tx_num_failed += count - 1;
+			rate->this_attempt += count;
+			spinfo->tx_num_xmit += count - 1;
+			rate->this_success += 1;
+			
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
+
 	}

 	/* Update PID controller state. */
@@ -270,15 +514,24 @@ rate_control_pid_get_rate(void *priv, st
 	if (txrc->rts)
 		info->control.rates[0].count =
 			txrc->hw->conf.long_frame_max_tx_count;
-	else
-		info->control.rates[0].count =
-			txrc->hw->conf.short_frame_max_tx_count;
+	else {

+		info->control.rates[0].count = 2;
+		/* info->control.rates[0].count =
+			txrc->hw->conf.short_frame_max_tx_count; */
+	
+	}
 	/* Send management frames and NO_ACK data using lowest rate. */
 	if (rate_control_send_low(sta, priv_sta, txrc))
 		return;

-	rateidx = spinfo->txrate_idx;
+	/* PIDE: In the monitor window, send three probing frames */
+	if (spinfo->monitoring && spinfo->probe_cnt > 0) {
+		rateidx = spinfo->tmp_rate_idx;
+		spinfo->probe_cnt--;
+	} else {
+		rateidx = spinfo->txrate_idx;
+	}

 	if (rateidx >= sband->n_bitrates)
 		rateidx = sband->n_bitrates - 1;
@@ -301,8 +554,15 @@ rate_control_pid_rate_init(void *priv, s
 	int i, j, tmp;
 	bool s;

+	/* PIDE: n is the number of transmission rates available */
+	int n = 0;
+	struct ieee80211_rate *ctl_rate;
+	int band_info = 0;
+
+	int erp = 0, sifs = 0;
+
 	/* TODO: This routine should consider using RSSI from previous packets
-	 * as we need to have IEEE 802.1X auth succeed immediately after assoc..
+	 * as we need to have IEEE 802.1X auth succeed immediately after assoc.
 	 * Until that method is implemented, we will use the lowest supported
 	 * rate as a workaround. */

@@ -318,22 +578,61 @@ rate_control_pid_rate_init(void *priv, s
 			rinfo[i].diff = i * pinfo->norm_offset;
 	}
 	for (i = 1; i < sband->n_bitrates; i++) {
-		s = false;
+		s = 0;
 		for (j = 0; j < sband->n_bitrates - i; j++)
 			if (unlikely(sband->bitrates[rinfo[j].index].bitrate >
-				     sband->bitrates[rinfo[j + 1].index].bitrate)) {
+				sband->bitrates[rinfo[j + 1].index].bitrate)) {
 				tmp = rinfo[j].index;
 				rinfo[j].index = rinfo[j + 1].index;
 				rinfo[j + 1].index = tmp;
 				rinfo[rinfo[j].index].rev_index = j;
 				rinfo[rinfo[j + 1].index].rev_index = j + 1;
-				s = true;
+				s = 1;
 			}
 		if (!s)
 			break;
 	}

 	spinfo->txrate_idx = rate_lowest_index(sband, sta);
+
+
+	/* PIDE: initialisation */
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
+		rinfo[i].perfect_tx_time = Tdifs + (Tslot * 15 >> 1) + sifs +
+					   pide_frame_duration(band_info,
+					     1530, sband->bitrates[i].bitrate,
+					     erp, 1) +
+					   pide_frame_duration(band_info,
+					     10, sband->bitrates[i].bitrate,
+					     erp, 1);
+		rinfo[i].throughput = 0;
+		rinfo[i].this_attempt = 0;
+		rinfo[i].this_success = 0;
+		rinfo[i].this_fail = 0;
+		rinfo[i].attempt = 0;
+		rinfo[i].success = 0;
+		rinfo[i].fail = 0;
+		
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
+
 }

 static void *rate_control_pid_alloc(struct ieee80211_hw *hw,
diff -uprN wireless-testing_orig/net/mac80211/rc80211_pid_debugfs.c
wireless-testing/net/mac80211/rc80211_pid_debugfs.c
--- wireless-testing_orig/net/mac80211/rc80211_pid_debugfs.c	2012-02-17
13:59:53.487182968 +1000
+++ wireless-testing/net/mac80211/rc80211_pid_debugfs.c	2012-02-29
09:31:06.347703730 +1000
@@ -1,5 +1,6 @@
 /*
  * Copyright 2007, Mattias Nissler <mattias.nissler@gmx.de>
+ * Copyright 2012, Wei Yin, National ICT Australia <Wei.Yin@nicta.com.au>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -13,13 +14,74 @@
 #include <linux/types.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
-#include <linux/export.h>
-
 #include <net/mac80211.h>
 #include "rate.h"

 #include "rc80211_pid.h"

+#include <linux/debugfs.h>
+#include <linux/ieee80211.h>
+#include <linux/slab.h>
+#include <linux/export.h>
+
+
+int
+pid_stats_open(struct inode *inode, struct file *file)
+{
+	struct rc_pid_sta_info *sinfo = inode->i_private;
+	struct rc_pid_debugfs_info *ms;
+	struct rc_pid_rateinfo *rinfo;
+	char *p;
+	int i;
+	rinfo = sinfo->rinfo;
+	ms = kmalloc(sizeof(*ms) + 4096, GFP_KERNEL);
+	if (!ms)
+		return -ENOMEM;
+
+	file->private_data = ms;
+	p = ms->buf;
+	p += sprintf(p, "R for current rate;   T for temporary rate\n");
+	p += sprintf(p, "rate    throughput      attempt          fail");
+	p += sprintf(p, "        success         this_FLR \n");
+	for (i = 0; i < sinfo->n_rates; i++) {
+		struct rc_pid_rateinfo *pr = &rinfo[i];
+		*(p++) = (i == sinfo->txrate_idx) ? 'R' : ' ';
+		*(p++) = (i == sinfo->tmp_rate_idx) ? 'T' : ' ';
+		p += sprintf(p, "%3u%s", pr->bitrate / 2,
+				(pr->bitrate & 1 ? ".5" : "  "));
+		p += sprintf(p,
+			 "%6u.%2u     %10lu     %10lu     %10lu        %2u%%\n",
+			 (pr->throughput * 1530 *8 / 1024 / 1024) /100,
+			 (pr->throughput * 1530 *8 / 1024 / 1024) % 100,
+			 pr->attempt, pr->fail, pr->success,
+			 pr->this_fail == 0 ? 0:
+			 (pr->this_fail *100 /
+			 pr->this_attempt) % 100);
+	}
+	
+	ms->len = p - ms->buf;
+
+	return 0;
+}
+
+ssize_t
+pid_stats_read(struct file *file, char __user *buf, size_t len, loff_t *ppos)
+{
+	struct rc_pid_debugfs_info *ms;
+
+	ms = file->private_data;
+	return simple_read_from_buffer(buf, len, ppos, ms->buf, ms->len);
+}
+
+int
+pid_stats_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
+
+
 static void rate_control_pid_event(struct rc_pid_event_buffer *buf,
 				   enum rc_pid_event_type type,
 				   union rc_pid_event_data *data)
@@ -130,7 +192,8 @@ static unsigned int rate_control_pid_eve

 #define RC_PID_PRINT_BUF_SIZE 64

-static ssize_t rate_control_pid_events_read(struct file *file, char
__user *buf,
+static ssize_t rate_control_pid_events_read(struct file *file,
+					    char __user *buf,
 					    size_t length, loff_t *offset)
 {
 	struct rc_pid_events_file_info *file_info = file->private_data;
@@ -163,7 +226,7 @@ static ssize_t rate_control_pid_events_r
 	file_info->next_entry = (file_info->next_entry + 1) %
 				RC_PID_EVENT_RING_SIZE;

-	/* Print information about the event. Note that userspace needs to
+	/* Print information about the event. Note that userpace needs to
 	 * provide large enough buffers. */
 	length = length < RC_PID_PRINT_BUF_SIZE ?
 		 length : RC_PID_PRINT_BUF_SIZE;
@@ -203,11 +266,9 @@ static ssize_t rate_control_pid_events_r

 static const struct file_operations rc_pid_fop_events = {
 	.owner = THIS_MODULE,
-	.read = rate_control_pid_events_read,
-	.poll = rate_control_pid_events_poll,
-	.open = rate_control_pid_events_open,
-	.release = rate_control_pid_events_release,
-	.llseek = noop_llseek,
+	.read = pid_stats_read,
+	.open = pid_stats_open,
+	.release = pid_stats_release,
 };

 void rate_control_pid_add_sta_debugfs(void *priv, void *priv_sta,
@@ -226,3 +287,4 @@ void rate_control_pid_remove_sta_debugfs

 	debugfs_remove(spinfo->events_entry);
 }
+
diff -uprN wireless-testing_orig/net/mac80211/rc80211_pid.h
wireless-testing/net/mac80211/rc80211_pid.h
--- wireless-testing_orig/net/mac80211/rc80211_pid.h	2012-02-17
13:59:53.403182811 +1000
+++ wireless-testing/net/mac80211/rc80211_pid.h	2012-02-29
10:45:28.043682855 +1000
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
@@ -48,6 +52,14 @@
 #define RC_PID_DO_ARITH_RIGHT_SHIFT(x, y) \
 	((x) < 0 ? -((-(x)) >> (y)) : (x) >> (y))

+#define MAXPROBES 3
+
+
+/* PIDE */
+
+#define Tdifs 34
+#define Tslot 9
+
 enum rc_pid_event_type {
 	RC_PID_EVENT_TYPE_TX_STATUS,
 	RC_PID_EVENT_TYPE_RATE_CHANGE,
@@ -77,7 +89,7 @@ union rc_pid_event_data {
 };

 struct rc_pid_event {
-	/* The time when the event occurred */
+	/* The time when the event occured */
 	unsigned long timestamp;

 	/* Event ID number */
@@ -118,6 +130,14 @@ struct rc_pid_events_file_info {
 	unsigned int next_entry;
 };

+/* PIDE: debug fs */
+struct rc_pid_debugfs_info {
+	size_t len;
+	char buf[];
+};
+
+
+
 /**
  * struct rc_pid_debugfs_entries - tunable parameters
  *
@@ -169,6 +189,15 @@ void rate_control_pid_add_sta_debugfs(vo

 void rate_control_pid_remove_sta_debugfs(void *priv, void *priv_sta);

+/* PIDE; debug file system */
+
+int pid_stats_open(struct inode *inode, struct file *file);
+ssize_t pid_stats_read(struct file *file, char __user *buf, size_t len,
+		       loff_t *ppos);
+int pid_stats_release(struct inode *inode, struct file *file);
+
+
+
 struct rc_pid_sta_info {
 	unsigned long last_change;
 	unsigned long last_sample;
@@ -219,6 +248,20 @@ struct rc_pid_sta_info {

 	/* Events debugfs file entry */
 	struct dentry *events_entry;
+
+	/* PIDE */
+	int last_dlr;
+	int fail_probes;
+	int probes;
+	int monitoring;
+	int oldrate;
+	int n_rates;
+	int tmp_rate_idx;
+	int probe_cnt;
+	
+	struct rc_pid_rateinfo *rinfo;
+	
+	
 #endif
 };

@@ -235,9 +278,21 @@ struct rc_pid_rateinfo {

 	/* Did we do any measurement on this rate? */
 	bool valid;
-
+	
 	/* Comparison with the lowest rate. */
 	int diff;
+
+	/* PIDE */
+	int bitrate;
+	int perfect_tx_time;
+	unsigned int throughput;
+	unsigned int this_attempt;
+	unsigned int this_success;
+	unsigned int this_fail;
+	unsigned long attempt;
+	unsigned long success;
+	unsigned long fail;
+	
 };

 struct rc_pid_info {
