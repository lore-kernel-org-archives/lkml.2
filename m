Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081Ab2FGPxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:53:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8721 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab2FGPwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:52:23 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=l95s83e4SmoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=6ohNodAXAAAA:8 a=VwQbUJbxAAAA:8 a=lpFEZuzkmf573gxAE2YA:9 a=gDjHQkheYgsA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120607155221.623644092@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Jun 2012 11:51:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Priyanka Jain <Priyanka.Jain@freescale.com>,
        Rajan Srivastava <Rajan.Srivastava@freescale.com>
Subject: [PATCH RT 2/4] net,RT:REmove preemption disabling in netif_rx()
References: <20120607155148.698959275@goodmis.org>
Content-Disposition: inline; filename=0002-net-RT-REmove-preemption-disabling-in-netif_rx.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Priyanka Jain <Priyanka.Jain@freescale.com>

1)enqueue_to_backlog() (called from netif_rx) should be
  bind to a particluar CPU. This can be achieved by
  disabling migration. No need to disable preemption

2)Fixes crash "BUG: scheduling while atomic: ksoftirqd"
  in case of RT.
  If preemption is disabled, enqueue_to_backog() is called
  in atomic context. And if backlog exceeds its count,
  kfree_skb() is called. But in RT, kfree_skb() might
  gets scheduled out, so it expects non atomic context.

3)When CONFIG_PREEMPT_RT_FULL is not defined,
 migrate_enable(), migrate_disable() maps to
 preempt_enable() and preempt_disable(), so no
 change in functionality in case of non-RT.

-Replace preempt_enable(), preempt_disable() with
 migrate_enable(), migrate_disable() respectively
-Replace get_cpu(), put_cpu() with get_cpu_light(),
 put_cpu_light() respectively

Signed-off-by: Priyanka Jain <Priyanka.Jain@freescale.com>
Acked-by: Rajan Srivastava <Rajan.Srivastava@freescale.com>
Cc: <rostedt@goodmis.orgn>
Link: http://lkml.kernel.org/r/1337227511-2271-1-git-send-email-Priyanka.Jain@freescale.com
Cc: stable-rt@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/core/dev.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 79e9903..d9f43e1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2898,7 +2898,7 @@ int netif_rx(struct sk_buff *skb)
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
 		int cpu;
 
-		preempt_disable();
+		migrate_disable();
 		rcu_read_lock();
 
 		cpu = get_rps_cpu(skb->dev, skb, &rflow);
@@ -2908,13 +2908,13 @@ int netif_rx(struct sk_buff *skb)
 		ret = enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
 
 		rcu_read_unlock();
-		preempt_enable();
+		migrate_enable();
 	}
 #else
 	{
 		unsigned int qtail;
-		ret = enqueue_to_backlog(skb, get_cpu(), &qtail);
-		put_cpu();
+		ret = enqueue_to_backlog(skb, get_cpu_light(), &qtail);
+		put_cpu_light();
 	}
 #endif
 	return ret;
-- 
1.7.10


