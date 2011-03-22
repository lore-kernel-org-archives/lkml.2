Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab1CVMsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:48:09 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59307 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab1CVMsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:48:07 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V1 1/2] cpuidle: Data structure changes for global cpuidle
	device
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 22 Mar 2011 18:18:02 +0530
Message-ID: <20110322124750.29408.17788.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110322124724.29408.12885.stgit@tringupt.in.ibm.com>
References: <20110322124724.29408.12885.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently cpuidle subsystem has the following data structures:

* Global cpuidle_driver which is maintained in a list for each
  registered driver

* cpuidle_device is per-cpu per-driver structure that contains the
  array of cpuidle_state defined for that CPU

* cpuidle_state contains the definition of the idle routine and place
  holders for statistics that are used by the governor to make the
  selection.

Proposed new data structures:

* Basically the cpuidle_state structure along with the cpuidle_device
  is made global and per-driver. The cpuidle_state contains the idle state
  definitions.

* The statistics part of the cpuidle_state that is needed by the
  governor on a per-cpu bases is split into a new per-cpu structure
  called cpuidle_state_stats.  This structure is generic and
  independent of the cpuidle_driver/device that is currently in force.


<<- Global--->>                 <<per-cpu>>

cpuidle_driver                  cpuidle_device_stats
  |                                    -> state_stats[]
  \
    -> cpuidle_device
        -> states[]


Open Issues:

* Handle per-cpu, per-driver's driver_data appropriately within the
  cpuidle_driver structure.  For this RFC, it is pushed into
  cpuidle_device_stats structure.

* Handle double initialization of kobj structs on multiple driver
  registration.

Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
---

 include/linux/cpuidle.h |   75 +++++++++++++++++++++++++++++++++--------------
 1 files changed, 52 insertions(+), 23 deletions(-)

diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index a5f5fd0..16423df 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -22,6 +22,7 @@
 #define CPUIDLE_DESC_LEN	32
 
 struct cpuidle_device;
+struct cpuidle_state_stats;
 
 
 /****************************
@@ -31,18 +32,21 @@ struct cpuidle_device;
 struct cpuidle_state {
 	char		name[CPUIDLE_NAME_LEN];
 	char		desc[CPUIDLE_DESC_LEN];
-	void		*driver_data;
 
 	unsigned int	flags;
 	unsigned int	exit_latency; /* in US */
 	unsigned int	power_usage; /* in mW */
 	unsigned int	target_residency; /* in US */
 
-	unsigned long long	usage;
-	unsigned long long	time; /* in US */
-
 	int (*enter)	(struct cpuidle_device *dev,
-			 struct cpuidle_state *state);
+			 struct cpuidle_state *state,
+			 struct cpuidle_state_stats *state_stats);
+};
+
+struct cpuidle_state_stats {
+	void		*driver_data;
+	unsigned long long usage;
+	unsigned long long time; /* in US */
 };
 
 /* Idle State Flags */
@@ -55,9 +59,9 @@ struct cpuidle_state {
  * cpuidle_get_statedata - retrieves private driver state data
  * @state: the state
  */
-static inline void * cpuidle_get_statedata(struct cpuidle_state *state)
+static inline void *cpuidle_get_statedata(struct cpuidle_state_stats *stats)
 {
-	return state->driver_data;
+	return stats->driver_data;
 }
 
 /**
@@ -66,9 +70,9 @@ static inline void * cpuidle_get_statedata(struct cpuidle_state *state)
  * @data: the private data
  */
 static inline void
-cpuidle_set_statedata(struct cpuidle_state *state, void *data)
+cpuidle_set_statedata(struct cpuidle_state_stats *state_stats, void *data)
 {
-	state->driver_data = data;
+	state_stats->driver_data = data;
 }
 
 struct cpuidle_state_kobj {
@@ -77,29 +81,42 @@ struct cpuidle_state_kobj {
 	struct kobject kobj;
 };
 
+struct cpuidle_device_stats {
+	unsigned int			enabled:1;
+	unsigned int			cpu;
+	int				last_residency;
+	struct cpuidle_state		*last_state;
+	struct cpuidle_state_stats	state_stats[CPUIDLE_STATE_MAX];
+
+	struct cpuidle_state_kobj	*kobjs[CPUIDLE_STATE_MAX];
+	struct kobject			kobj;
+	struct completion		kobj_unregister;
+
+	struct cpuidle_driver		*drv;
+};
+
 struct cpuidle_device {
 	unsigned int		registered:1;
 	unsigned int		enabled:1;
 	unsigned int		power_specified:1;
-	unsigned int		cpu;
 
-	int			last_residency;
 	int			state_count;
 	struct cpuidle_state	states[CPUIDLE_STATE_MAX];
-	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
-	struct cpuidle_state	*last_state;
 
-	struct list_head 	device_list;
 	struct cpuidle_driver	*drv;
-	struct kobject		kobj;
-	struct completion	kobj_unregister;
 	void			*governor_data;
 	struct cpuidle_state	*safe_state;
 
-	int (*prepare)		(struct cpuidle_device *dev);
+	int (*prepare)		(struct cpuidle_device_stats *dev_stats);
 };
 
-DECLARE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
+
+DECLARE_PER_CPU(struct cpuidle_device_stats, cpuidle_dev_stats);
+static inline struct cpuidle_state_stats *get_cpuidle_state_stats(int cpu,
+						int count)
+{
+	return &per_cpu(cpuidle_dev_stats, cpu).state_stats[count];
+}
 
 /**
  * cpuidle_get_last_residency - retrieves the last state's residency time
@@ -107,7 +124,7 @@ DECLARE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
  *
  * NOTE: this value is invalid if CPUIDLE_FLAG_TIME_VALID isn't set
  */
-static inline int cpuidle_get_last_residency(struct cpuidle_device *dev)
+static inline int cpuidle_get_last_residency(struct cpuidle_device_stats *dev)
 {
 	return dev->last_residency;
 }
@@ -122,6 +139,7 @@ struct cpuidle_driver {
 	struct module 		*owner;
 	unsigned int		priority;
 	struct list_head	driver_list;
+	struct cpuidle_device	*dev;
 };
 
 #ifdef CONFIG_CPU_IDLE
@@ -145,12 +163,22 @@ static inline struct cpuidle_driver *cpuidle_get_driver(void) {return NULL; }
 static inline void cpuidle_unregister_driver(struct cpuidle_driver *drv) { }
 static inline int cpuidle_register_device(struct cpuidle_device *dev)
 {return -ENODEV; }
+static inline int cpuidle_register_device_stats(
+				struct cpuidle_device_stats *dev_stats)
+{return -ENODEV; }
+static inline void cpuidle_unregister_device_stats(
+			struct cpuidle_device_stats *dev_stats) { };
 static inline void cpuidle_unregister_device(struct cpuidle_device *dev) { }
 
 static inline void cpuidle_pause_and_lock(void) { }
 static inline void cpuidle_resume_and_unlock(void) { }
 static inline int cpuidle_enable_device(struct cpuidle_device *dev)
 {return -ENODEV; }
+static inline int cpuidle_enable_device_stats(
+			struct cpuidle_device_stats *dev_stats)
+{return -ENODEV; }
+static inline void cpuidle_disable_device_stats(
+				struct cpuidle_device_stats *dev_stats) { }
 static inline void cpuidle_disable_device(struct cpuidle_device *dev) { }
 
 #endif
@@ -164,11 +192,12 @@ struct cpuidle_governor {
 	struct list_head 	governor_list;
 	unsigned int		rating;
 
-	int  (*enable)		(struct cpuidle_device *dev);
-	void (*disable)		(struct cpuidle_device *dev);
+	int  (*enable)		(struct cpuidle_device_stats *dev_stats);
+	void (*disable)		(struct cpuidle_device_stats *dev_stats);
 
-	int  (*select)		(struct cpuidle_device *dev);
-	void (*reflect)		(struct cpuidle_device *dev);
+	int  (*select)		(struct cpuidle_device *dev,
+					struct cpuidle_device_stats *dev_stats);
+	void (*reflect)		(struct cpuidle_device_stats *dev_stats);
 
 	struct module 		*owner;
 };

