Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab0DOLFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 07:05:38 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36577 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab0DOLFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 07:05:36 -0400
Date: Thu, 15 Apr 2010 16:35:26 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: peterz@infradead.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       linux-kernel@vger.kernel.org, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: [v12 PATCH 1/8]: cpuidle: cleanup cpuidle.h header file.
Message-ID: <20100415110526.GB16760@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20100415110046.GA16760@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100415110046.GA16760@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2010-04-15 16:30:46]:

This patch re-designs the data structures used in cpuidle infrastructure.
Currently, we have a per-cpu device structure. Each cpu needs to register
under cpuidle as a cpuidle_device. This is not desirable and hence the
per-cpu registration is removed by this patch.

This patch introduces a cpuidle_subsystem structure. This needs a one-time
registration to cpuidle. Also the current design has an array of the idle states
for each of the CPUs. This is changed to have a global array of idle states.
The statistics data like 'usage' and 'time' which were earlier part of the
cpuidle_states structure is biforcated to form a new structure cpuidle_stats,
which is per-cpu.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle.h |    6 +--
 include/linux/cpuidle.h   |   70 ++++++++++++++++++++--------------------------
 2 files changed, 33 insertions(+), 43 deletions(-)

Index: linux.trees.git/include/linux/cpuidle.h
===================================================================
--- linux.trees.git.orig/include/linux/cpuidle.h
+++ linux.trees.git/include/linux/cpuidle.h
@@ -20,8 +20,7 @@
 #define CPUIDLE_STATE_MAX	8
 #define CPUIDLE_NAME_LEN	16
 #define CPUIDLE_DESC_LEN	32
-
-struct cpuidle_device;
+#define	CPUIDLE_MAX_CPUS	128
 
 
 /****************************
@@ -38,11 +37,11 @@ struct cpuidle_state {
 	unsigned int	power_usage; /* in mW */
 	unsigned int	target_residency; /* in US */
 
-	unsigned long long	usage;
-	unsigned long long	time; /* in US */
+	int			state_index;
+	unsigned long long	*usage;
+	unsigned long long	*time;
 
-	int (*enter)	(struct cpuidle_device *dev,
-			 struct cpuidle_state *state);
+	int (*enter)	(struct cpuidle_state *state);
 };
 
 /* Idle State Flags */
@@ -76,30 +75,31 @@ cpuidle_set_statedata(struct cpuidle_sta
 }
 
 struct cpuidle_state_kobj {
+	int	cpuid;
 	struct cpuidle_state *state;
 	struct completion kobj_unregister;
 	struct kobject kobj;
 };
 
-struct cpuidle_device {
-	unsigned int		registered:1;
-	unsigned int		enabled:1;
-	unsigned int		cpu;
-
-	int			last_residency;
-	int			state_count;
-	struct cpuidle_state	states[CPUIDLE_STATE_MAX];
+struct cpuidle_stats {
+	unsigned long long	usage[CPUIDLE_STATE_MAX];
+	unsigned long long	time[CPUIDLE_STATE_MAX]; /* in US */
 	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
-	struct cpuidle_state	*last_state;
-
-	struct list_head 	device_list;
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
-	void			*governor_data;
+};
+
+struct cpuidle_subsystem {
+	unsigned int		registered:1;
+	int			state_count;
+	int			last_residency[CPUIDLE_MAX_CPUS];
+	struct cpuidle_state	*last_state[CPUIDLE_MAX_CPUS];
+	struct cpuidle_state	states[CPUIDLE_STATE_MAX];
 	struct cpuidle_state	*safe_state;
 };
 
-DECLARE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
+extern struct cpuidle_subsystem cpuidle_subsys;
+DECLARE_PER_CPU(struct cpuidle_stats, stats);
 
 /**
  * cpuidle_get_last_residency - retrieves the last state's residency time
@@ -107,9 +107,9 @@ DECLARE_PER_CPU(struct cpuidle_device *,
  *
  * NOTE: this value is invalid if CPUIDLE_FLAG_TIME_VALID isn't set
  */
-static inline int cpuidle_get_last_residency(struct cpuidle_device *dev)
+static inline int cpuidle_get_last_residency(int cpu)
 {
-	return dev->last_residency;
+	return cpuidle_subsys.last_residency[cpu];
 }
 
 
@@ -123,32 +123,23 @@ struct cpuidle_driver {
 };
 
 #ifdef CONFIG_CPU_IDLE
-
 extern int cpuidle_register_driver(struct cpuidle_driver *drv);
 extern void cpuidle_unregister_driver(struct cpuidle_driver *drv);
-extern int cpuidle_register_device(struct cpuidle_device *dev);
-extern void cpuidle_unregister_device(struct cpuidle_device *dev);
+extern int cpuidle_register_subsystem(int state_count);
+extern void cpuidle_unregister_subsystem(void);
 
 extern void cpuidle_pause_and_lock(void);
 extern void cpuidle_resume_and_unlock(void);
-extern int cpuidle_enable_device(struct cpuidle_device *dev);
-extern void cpuidle_disable_device(struct cpuidle_device *dev);
-
 #else
-
 static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
 {return 0;}
 static inline void cpuidle_unregister_driver(struct cpuidle_driver *drv) { }
-static inline int cpuidle_register_device(struct cpuidle_device *dev)
+static inline int cpuidle_register_subsystem(int state_count)
 {return 0;}
-static inline void cpuidle_unregister_device(struct cpuidle_device *dev) { }
-
+static inline void cpuidle_unregister_subsystem(void)
+{ }
 static inline void cpuidle_pause_and_lock(void) { }
 static inline void cpuidle_resume_and_unlock(void) { }
-static inline int cpuidle_enable_device(struct cpuidle_device *dev)
-{return 0;}
-static inline void cpuidle_disable_device(struct cpuidle_device *dev) { }
-
 #endif
 
 /******************************
@@ -160,11 +151,11 @@ struct cpuidle_governor {
 	struct list_head 	governor_list;
 	unsigned int		rating;
 
-	int  (*enable)		(struct cpuidle_device *dev);
-	void (*disable)		(struct cpuidle_device *dev);
+	int  (*enable)		(int cpu);
+	void (*disable)		(int cpu);
 
-	int  (*select)		(struct cpuidle_device *dev);
-	void (*reflect)		(struct cpuidle_device *dev);
+	int  (*select)		(int cpu);
+	void (*reflect)		(int cpu);
 
 	struct module 		*owner;
 };
@@ -187,5 +178,6 @@ static inline void cpuidle_unregister_go
 #else
 #define CPUIDLE_DRIVER_STATE_START	0
 #endif
+extern void cpuidle_idle_call(void);
 
 #endif /* _LINUX_CPUIDLE_H */
Index: linux.trees.git/drivers/cpuidle/cpuidle.h
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/cpuidle.h
+++ linux.trees.git/drivers/cpuidle/cpuidle.h
@@ -11,12 +11,10 @@
 extern struct cpuidle_governor *cpuidle_curr_governor;
 extern struct cpuidle_driver *cpuidle_curr_driver;
 extern struct list_head cpuidle_governors;
-extern struct list_head cpuidle_detected_devices;
 extern struct mutex cpuidle_lock;
 extern spinlock_t cpuidle_driver_lock;
 
 /* idle loop */
-extern void cpuidle_install_idle_handler(void);
 extern void cpuidle_uninstall_idle_handler(void);
 
 /* governors */
@@ -25,8 +23,8 @@ extern int cpuidle_switch_governor(struc
 /* sysfs */
 extern int cpuidle_add_class_sysfs(struct sysdev_class *cls);
 extern void cpuidle_remove_class_sysfs(struct sysdev_class *cls);
-extern int cpuidle_add_state_sysfs(struct cpuidle_device *device);
-extern void cpuidle_remove_state_sysfs(struct cpuidle_device *device);
+extern int cpuidle_add_state_sysfs(int cpu);
+extern void cpuidle_remove_state_sysfs(int cpu);
 extern int cpuidle_add_sysfs(struct sys_device *sysdev);
 extern void cpuidle_remove_sysfs(struct sys_device *sysdev);
 
