Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab0KXHgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 02:36:52 -0500
Received: from mail.perches.com ([173.55.12.10]:1849 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472Ab0KXHgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 02:36:51 -0500
Subject: [PATCH] cpufreq: Add __attribute__((format (printf...) to
 cpufreq_debug_printk and fix fallout
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86 <x86@kernel.org>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 23:36:49 -0800
Message-ID: <1290584209.11971.49.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __attribute__((format (printf, 3, 4))) to cpufreq_debug_printk.
Use no_printk in !CONFIG_CPU_FREQ_DEBUG.
Make formats and arguments match.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c   |    6 +++---
 arch/x86/kernel/cpu/cpufreq/speedstep-smi.c |    4 ++--
 include/linux/cpufreq.h                     |    8 +++++---
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
index 4f6f679..14dec2b 100644
--- a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
@@ -178,8 +178,8 @@ static unsigned int pcc_get_freq(unsigned int cpu)
 	curr_freq = (((ioread32(&pcch_hdr->nominal) * (output_buffer & 0xff))
 			/ 100) * 1000);
 
-	dprintk("get: SUCCESS: (virtual) output_offset for cpu %d is "
-		"0x%x, contains a value of: 0x%x. Speed is: %d MHz\n",
+	dprintk("get: SUCCESS: (virtual) output_offset for cpu %d is %p, "
+		"contains a value of: 0x%x. Speed is: %d MHz\n",
 		cpu, (pcch_virt_addr + pcc_cpu_data->output_offset),
 		output_buffer, curr_freq);
 
@@ -213,7 +213,7 @@ static int pcc_cpufreq_target(struct cpufreq_policy *policy,
 	pcc_cpu_data = per_cpu_ptr(pcc_cpu_info, cpu);
 
 	dprintk("target: CPU %d should go to target freq: %d "
-		"(virtual) input_offset is 0x%x\n",
+		"(virtual) input_offset is %p\n",
 		cpu, target_freq,
 		(pcch_virt_addr + pcc_cpu_data->input_offset));
 
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c b/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
index 8abd869..5872f4da 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
@@ -407,8 +407,8 @@ static int __init speedstep_init(void)
 		return -ENODEV;
 	}
 
-	dprintk("signature:0x%.8lx, command:0x%.8lx, "
-		"event:0x%.8lx, perf_level:0x%.8lx.\n",
+	dprintk("signature:0x%.8x, command:0x%.8x, "
+		"event:0x%.8x, perf_level:0x%.8x.\n",
 		ist_info.signature, ist_info.command,
 		ist_info.event, ist_info.perf_level);
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index c3e9de8..117b921 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -416,12 +416,14 @@ void cpufreq_frequency_table_put_attr(unsigned int cpu);
 
 #ifdef CONFIG_CPU_FREQ_DEBUG
 
-extern void cpufreq_debug_printk(unsigned int type, const char *prefix, 
-				 const char *fmt, ...);
+extern __attribute__((format (printf, 3, 4)))
+void cpufreq_debug_printk(unsigned int type, const char *prefix,
+			  const char *fmt, ...);
 
 #else
 
-#define cpufreq_debug_printk(msg...) do { } while(0)
+#define cpufreq_debug_printk(type, prefix, fmt, ...)	\
+	no_printk(fmt, ##__VA_ARGS__)
 
 #endif /* CONFIG_CPU_FREQ_DEBUG */
 


