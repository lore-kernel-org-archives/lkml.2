Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab0KOG7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 01:59:21 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:45760 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab0KOG7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 01:59:20 -0500
Date: Mon, 15 Nov 2010 15:58:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [v2,5/8] NUMA Hotplug emulator
Message-ID: <20101115065847.GH8489@linux-sh.org>
References: <20101113061611.GO32501@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101113061611.GO32501@shaohui>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 02:16:11PM +0800, Shaohui Zheng wrote:
> @@ -37,6 +40,11 @@ static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
>  /*
>   * Add nid(NUMA node id) as parameter for cpu hotplug emulation. It supports
>   * to register a CPU to any nodes.
> + *
> + * nid is a special parameter, it has 2 different branches:
> + * 1) when nid == NUMA_NO_NODE, the CPU will be registered into the normal node
> + * which it should be in.
> + * 2) nid != NUMA_NO_NODE, it will be registered into the specified node.
>   */
>  static int __ref __arch_register_cpu(int num, int nid)
>  {
> @@ -52,8 +60,23 @@ static int __ref __arch_register_cpu(int num, int nid)
>  	if (num)
>  		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
>  
> -	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
> +	if (nid == NUMA_NO_NODE)
> +		return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
> +	else
> +		return register_cpu_emu(&per_cpu(cpu_devices, num).cpu, num, nid);
> +}
> +
This looks like an incredibly painful interface. How about scrapping all
of this _emu() mess and just reworking the register_cpu() interface?
Something like:

---

 drivers/base/cpu.c  |    7 ++++---
 include/linux/cpu.h |    8 +++++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 251acea..039fd44 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -212,13 +212,14 @@ static SYSDEV_CLASS_ATTR(offline, 0444, print_cpus_offline, NULL);
  * @cpu - cpu->hotpluggable field set to 1 will generate a control file in
  *	  sysfs for this CPU.
  * @num - CPU number to use when creating the device.
+ * @nid - Node ID to use, if any.
  *
  * Initialize and register the CPU device.
  */
-int __cpuinit register_cpu(struct cpu *cpu, int num)
+int __cpuinit register_cpu_node(struct cpu *cpu, int num, int nid)
 {
 	int error;
-	cpu->node_id = cpu_to_node(num);
+	cpu->node_id = nid;
 	cpu->sysdev.id = num;
 	cpu->sysdev.cls = &cpu_sysdev_class;
 
@@ -229,7 +230,7 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
 	if (!error)
 		per_cpu(cpu_sys_devices, num) = &cpu->sysdev;
 	if (!error)
-		register_cpu_under_node(num, cpu_to_node(num));
+		register_cpu_under_node(num, nid);
 
 #ifdef CONFIG_KEXEC
 	if (!error)
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 4823af6..d9e19c8 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -30,7 +30,13 @@ struct cpu {
 	struct sys_device sysdev;
 };
 
-extern int register_cpu(struct cpu *cpu, int num);
+extern int register_cpu_node(struct cpu *cpu, int num, int nid);
+
+static inline int register_cpu(struct cpu *cpu, int num)
+{
+	return register_cpu_node(cpu, num, cpu_to_node(num));
+}
+
 extern struct sys_device *get_cpu_sysdev(unsigned cpu);
 
 extern int cpu_add_sysdev_attr(struct sysdev_attribute *attr);
