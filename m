Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2CLBDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 21:03:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33617 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab2CLBDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 21:03:38 -0400
Message-ID: <4F5D4D1D.40004@gmail.com>
Date: Mon, 12 Mar 2012 11:10:53 +1000
From: wei <yinwei168@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3]mac80211: improve PID rate control mechanism by avoiding
 rate oscillation problem
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Wei YIN <Wei.Yin@nicta.com.au>
Improve PID rate control mechanism by avoiding rate oscillation problem

Signed-off-by: Wei YIN <Wei.Yin@nicta.com.au>
---
kernel 3.3.0
net/mac80211/rc80211_pid.h | 38 ++++++++++++++++++++++++++++++++++++++
1 file changed, 38 insertions(+), 0 deletions(-)

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

