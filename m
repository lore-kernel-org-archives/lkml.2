Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153Ab0HTHgC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 03:36:02 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40221 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab0HTHgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 03:36:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pk89N2MspZAKMjaj+ATzkhUMvAzRNSgv8cz7q3kvvdKlrByrmlJh5usZK4V37B58te
         QFFxVSen2gJMsARfaTyPBtl9upXdQ57f5kw/ZOuKB1xZP5lMt8s6tiWFme527JRZUiAr
         rS3RStwuJ6/M7LhmRS1xkjlEsDv/erWjrXDog=
Date: Fri, 20 Aug 2010 10:36:34 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix BUG using smp_processor_id() in preemptible
 thermal_throttle_add_dev
Message-ID: <20100820073634.GB5209@swordfish.minsk.epam.com>
References: <20100818091157.GA5238@swordfish.minsk.epam.com>
 <20100819170358.GD19773@amd.com>
 <4C6DA620.7060009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6DA620.7060009@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix: using smp_processor_id() in preemptible thermal_throttle_add_dev.
We know the cpu number when calling thermal_throttle_add_dev, so we can
remove smp_processor_id call in thermal_throttle_add_dev by supplying 
the cpu number as argument.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index c2a8b26..bcd8499 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -202,11 +202,12 @@ static int therm_throt_process(bool new_event, int event, int level)
 
 #ifdef CONFIG_SYSFS
 /* Add/Remove thermal_throttle interface for CPU device: */
-static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
+static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
+				unsigned int cpu)
 {
 	int err;
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
-
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	
 	err = sysfs_create_group(&sys_dev->kobj, &thermal_attr_group);
 	if (err)
 		return err;
@@ -251,7 +252,7 @@ thermal_throttle_cpu_callback(struct notifier_block *nfb,
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&therm_cpu_lock);
-		err = thermal_throttle_add_dev(sys_dev);
+		err = thermal_throttle_add_dev(sys_dev, cpu);
 		mutex_unlock(&therm_cpu_lock);
 		WARN_ON(err);
 		break;
@@ -287,7 +288,7 @@ static __init int thermal_throttle_init_device(void)
 #endif
 	/* connect live CPUs to sysfs */
 	for_each_online_cpu(cpu) {
-		err = thermal_throttle_add_dev(get_cpu_sysdev(cpu));
+		err = thermal_throttle_add_dev(get_cpu_sysdev(cpu), cpu);
 		WARN_ON(err);
 	}
 #ifdef CONFIG_HOTPLUG_CPU

