Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab2FLMsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:48:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20636 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2FLMsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:48:41 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=aONDl-815hj8TuMJ4moA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339505320.13377.123.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.33-rt54
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Tue, 12 Jun 2012 08:48:40 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.0.33-rt54 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: f539529bbaf7bbd5b45d71e72bd49cbe33ef7ad0


Or to build 3.0.33-rt54 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.33.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.33-rt54.patch.xz


You can also build from 3.0.33-rt53 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.33-rt53-rt54.patch.xz



Enjoy,

-- Steve


Changes from 3.0.33-rt53:

---

John Kacur (1):
      scsi: qla2xxx: Use local_irq_save_nort() in qla2x00_poll

Priyanka Jain (1):
      net,RT:REmove preemption disabling in netif_rx()

Steven Rostedt (1):
      Linux 3.0.33-rt54

Thomas Gleixner (1):
      mips-remove-smp-reserve-lock.patch

----
 arch/mips/cavium-octeon/smp.c     |    6 ------
 drivers/scsi/qla2xxx/qla_inline.h |    4 ++--
 localversion-rt                   |    2 +-
 net/core/dev.c                    |    8 ++++----
 4 files changed, 7 insertions(+), 13 deletions(-)
---------------------------
diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
index efcfff4..86fce15 100644
--- a/arch/mips/cavium-octeon/smp.c
+++ b/arch/mips/cavium-octeon/smp.c
@@ -257,8 +257,6 @@ DEFINE_PER_CPU(int, cpu_state);
 
 extern void fixup_irqs(void);
 
-static DEFINE_SPINLOCK(smp_reserve_lock);
-
 static int octeon_cpu_disable(void)
 {
 	unsigned int cpu = smp_processor_id();
@@ -266,8 +264,6 @@ static int octeon_cpu_disable(void)
 	if (cpu == 0)
 		return -EBUSY;
 
-	spin_lock(&smp_reserve_lock);
-
 	cpu_clear(cpu, cpu_online_map);
 	cpu_clear(cpu, cpu_callin_map);
 	local_irq_disable();
@@ -277,8 +273,6 @@ static int octeon_cpu_disable(void)
 	flush_cache_all();
 	local_flush_tlb_all();
 
-	spin_unlock(&smp_reserve_lock);
-
 	return 0;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 4c8167e..e5e99e9 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -36,12 +36,12 @@ qla2x00_poll(struct rsp_que *rsp)
 {
 	unsigned long flags;
 	struct qla_hw_data *ha = rsp->hw;
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	if (IS_QLA82XX(ha))
 		qla82xx_poll(0, rsp);
 	else
 		ha->isp_ops->intr_handler(0, rsp);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 }
 
 static inline uint8_t *
diff --git a/localversion-rt b/localversion-rt
index e6c0dc6..3165a87 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt53
+-rt54
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


