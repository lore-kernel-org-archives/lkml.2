Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030447Ab2HGWiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:38:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40991 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030417Ab2HGWiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:38:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 039/109] s390/idle: fix sequence handling vs cpu hotplug
Date: Tue,  7 Aug 2012 15:34:58 -0700
Message-Id: <20120807222046.541563224@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 0008204ffe85d23382d6fd0f971f3f0fbe70bae2 upstream.

The s390 idle accounting code uses a sequence counter which gets used
when the per cpu idle statistics get updated and read.

One assumption on read access is that only when the sequence counter is
even and did not change while reading all values the result is valid.
On cpu hotplug however the per cpu data structure gets initialized via
a cpu hotplug notifier on CPU_ONLINE.
CPU_ONLINE however is too late, since the onlined cpu is already running
and might access the per cpu data. Worst case is that the data structure
gets initialized while an idle thread is updating its idle statistics.
This will result in an uneven sequence counter after an update.

As a result user space tools like top, which access /proc/stat in order
to get idle stats, will busy loop waiting for the sequence counter to
become even again, which will never happen until the queried cpu will
update its idle statistics again. And even then the sequence counter
will only have an even value for a couple of cpu cycles.

Fix this by moving the initialization of the per cpu idle statistics
to cpu_init(). I prefer that solution in favor of changing the
notifier to CPU_UP_PREPARE, which would be a different solution to
the problem.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/processor.c |    2 ++
 arch/s390/kernel/smp.c       |    3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/arch/s390/kernel/processor.c
+++ b/arch/s390/kernel/processor.c
@@ -26,12 +26,14 @@ static DEFINE_PER_CPU(struct cpuid, cpu_
 void __cpuinit cpu_init(void)
 {
 	struct cpuid *id = &per_cpu(cpu_id, smp_processor_id());
+	struct s390_idle_data *idle = &__get_cpu_var(s390_idle);
 
 	get_cpu_id(id);
 	atomic_inc(&init_mm.mm_count);
 	current->active_mm = &init_mm;
 	BUG_ON(current->mm);
 	enter_lazy_tlb(&init_mm, current);
+	memset(idle, 0, sizeof(*idle));
 }
 
 /*
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -1034,14 +1034,11 @@ static int __cpuinit smp_cpu_notify(stru
 	unsigned int cpu = (unsigned int)(long)hcpu;
 	struct cpu *c = &pcpu_devices[cpu].cpu;
 	struct device *s = &c->dev;
-	struct s390_idle_data *idle;
 	int err = 0;
 
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		idle = &per_cpu(s390_idle, cpu);
-		memset(idle, 0, sizeof(struct s390_idle_data));
 		err = sysfs_create_group(&s->kobj, &cpu_online_attr_group);
 		break;
 	case CPU_DEAD:


