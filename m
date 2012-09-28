Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250Ab2I1VFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:05:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60532 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965225Ab2I1VFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:05:44 -0400
X-Sasl-enc: DI9J1f/R52I+DxC7PioUrqGUihd0e319OGv9gVt3XRA4 1348866342
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 109/127] drop_monitor: prevent init path from scheduling on the wrong cpu
Date: Fri, 28 Sep 2012 13:34:42 -0700
Message-Id: <20120928203058.624574181@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

commit 4fdcfa12843bca38d0c9deff70c8720e4e8f515f upstream.

I just noticed after some recent updates, that the init path for the drop
monitor protocol has a minor error.  drop monitor maintains a per cpu structure,
that gets initalized from a single cpu.  Normally this is fine, as the protocol
isn't in use yet, but I recently made a change that causes a failed skb
allocation to reschedule itself .  Given the current code, the implication is
that this workqueue reschedule will take place on the wrong cpu.  If drop
monitor is used early during the boot process, its possible that two cpus will
access a single per-cpu structure in parallel, possibly leading to data
corruption.

This patch fixes the situation, by storing the cpu number that a given instance
of this per-cpu data should be accessed from.  In the case of a need for a
reschedule, the cpu stored in the struct is assigned the rescheule, rather than
the currently executing cpu

Tested successfully by myself.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: David Miller <davem@davemloft.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/drop_monitor.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -49,6 +49,7 @@ struct per_cpu_dm_data {
 	struct sk_buff __rcu *skb;
 	atomic_t dm_hit_count;
 	struct timer_list send_timer;
+	int cpu;
 };
 
 struct dm_hw_stat_delta {
@@ -73,7 +74,6 @@ static int dm_hit_limit = 64;
 static int dm_delay = 1;
 static unsigned long dm_hw_check_delta = 2*HZ;
 static LIST_HEAD(hw_stats_list);
-static int initialized = 0;
 
 static void reset_per_cpu_data(struct per_cpu_dm_data *data)
 {
@@ -96,8 +96,8 @@ static void reset_per_cpu_data(struct pe
 				  sizeof(struct net_dm_alert_msg));
 		msg = nla_data(nla);
 		memset(msg, 0, al);
-	} else if (initialized)
-		schedule_work_on(smp_processor_id(), &data->dm_alert_work);
+	} else
+		schedule_work_on(data->cpu, &data->dm_alert_work);
 
 	/*
 	 * Don't need to lock this, since we are guaranteed to only
@@ -121,6 +121,8 @@ static void send_dm_alert(struct work_st
 	struct sk_buff *skb;
 	struct per_cpu_dm_data *data = &get_cpu_var(dm_cpu_data);
 
+	WARN_ON_ONCE(data->cpu != smp_processor_id());
+
 	/*
 	 * Grab the skb we're about to send
 	 */
@@ -403,14 +405,14 @@ static int __init init_net_drop_monitor(
 
 	for_each_present_cpu(cpu) {
 		data = &per_cpu(dm_cpu_data, cpu);
-		reset_per_cpu_data(data);
+		data->cpu = cpu;
 		INIT_WORK(&data->dm_alert_work, send_dm_alert);
 		init_timer(&data->send_timer);
 		data->send_timer.data = cpu;
 		data->send_timer.function = sched_send_work;
+		reset_per_cpu_data(data);
 	}
 
-	initialized = 1;
 
 	goto out;
 


