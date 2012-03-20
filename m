Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab2CTFZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 01:25:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47768 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab2CTFZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 01:25:01 -0400
Message-ID: <4F681685.4030109@gmail.com>
Date: Tue, 20 Mar 2012 15:32:53 +1000
From: wei <yinwei168@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] mac80211:  modify debugfs in  PID to monitor rate performance
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Wei YIN <Wei.Yin@nicta.com.au>
addressed v2 comments from Julian and John

Signed-off-by: Wei YIN <Wei.Yin@nicta.com.au>
---
kernel 3.3.0
net/mac80211/rc80211_pid_debugfs.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
1 file changed, 64 insertions(+), 5 deletions(-)

--- wireless-testing_orig/net/mac80211/rc80211_pid_debugfs.c	2012-02-17 13:59:53.487182968 +1000
+++ wireless-testing/net/mac80211/rc80211_pid_debugfs.c	2012-03-17 12:52:48.335192212 +1000
@@ -1,5 +1,6 @@
 /*
  * Copyright 2007, Mattias Nissler <mattias.nissler@gmx.de>
+ * Copyright 2012, Wei Yin, National ICT Australia <Wei.Yin@nicta.com.au>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -14,12 +15,73 @@
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/debugfs.h>
+#include <linux/ieee80211.h>
+#include <linux/slab.h>
 
 #include <net/mac80211.h>
 #include "rate.h"
 
 #include "rc80211_pid.h"
 
+
+int
+pid_stats_open(struct inode *inode, struct file *file)
+{
+	struct rc_pid_sta_info *sinfo = inode->i_private;
+	struct rc_pid_debugfs_info *ms;
+	struct rc_pid_rateinfo *rinfo;
+	char *p;
+	int i;
+
+	rinfo = sinfo->rinfo;
+	ms = kmalloc(sizeof(*ms) + 4096, GFP_KERNEL);
+	if (!ms)
+		return -ENOMEM;
+
+	file->private_data = ms;
+	p = ms->buf;
+	p += sprintf(p, "R for current rate;   T for temporary rate\n"
+			"rate    throughput      attempt          fail"
+			"        success         this_FLR\n");
+
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
 static void rate_control_pid_event(struct rc_pid_event_buffer *buf,
 				   enum rc_pid_event_type type,
 				   union rc_pid_event_data *data)
@@ -203,11 +265,9 @@ static ssize_t rate_control_pid_events_r
 
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

