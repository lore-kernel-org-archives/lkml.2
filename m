Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1DKHRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 03:17:42 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:54025 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab1DKHRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 03:17:41 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V2 3/4] Split cpuidle_state structure and move per-cpu
	statistics fields
To: linux-pm@lists.linux-foundation.org, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, rnayak@ti.com, karthik-dp@ti.com,
        magnus.damm@gmail.com
Date: Mon, 11 Apr 2011 12:47:33 +0530
Message-ID: <20110411071724.6348.22246.stgit@tringupt.in.ibm.com>
In-Reply-To: <20110411071508.6348.67918.stgit@tringupt.in.ibm.com>
References: <20110411071508.6348.67918.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first step towards global registration of cpuidle
states. The statistics used primarily by the governor are per-cpu
and have to be split from rest of the fields inside cpuidle_state,
which would be made global i.e. single copy. The driver_data field
is also per-cpu and moved.

Signed-off-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
---

 drivers/acpi/processor_idle.c |   37 ++++++++++++++++++-------------------
 drivers/cpuidle/cpuidle.c     |   12 +++++++-----
 drivers/cpuidle/sysfs.c       |   15 +++++++++------
 include/linux/cpuidle.h       |   25 +++++++++++++++----------
 4 files changed, 49 insertions(+), 40 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 00712a7..bd29363 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -745,14 +745,13 @@ static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
  *
  * This is equivalent to the HALT instruction.
  */
-static int acpi_idle_enter_c1(struct cpuidle_device *dev,
-				int index)
+static int acpi_idle_enter_c1(struct cpuidle_device *dev, int index)
 {
 	ktime_t  kt1, kt2;
 	s64 idle_time;
 	struct acpi_processor *pr;
-	struct cpuidle_state *state = &dev->states[index];
-	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
+	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
+	struct acpi_processor_cx *cx = cpuidle_get_statedata(state_usage);
 
 	pr = __this_cpu_read(processors);
 	dev->last_residency = 0;
@@ -777,8 +776,8 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 
 	/* Update device last_residency and state counters*/
 	dev->last_residency = (int)idle_time;
-	dev->states[index].time += (unsigned long long)dev->last_residency;
-	dev->states[index].usage++;
+	state_usage->time += (unsigned long long)dev->last_residency;
+	state_usage->usage++;
 
 	local_irq_enable();
 	cx->usage++;
@@ -792,12 +791,11 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
  * @dev: the target CPU
  * @index: the index of suggested state
  */
-static int acpi_idle_enter_simple(struct cpuidle_device *dev,
-				int index)
+static int acpi_idle_enter_simple(struct cpuidle_device *dev, int index)
 {
 	struct acpi_processor *pr;
-	struct cpuidle_state *state = &dev->states[index];
-	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
+	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
+	struct acpi_processor_cx *cx = cpuidle_get_statedata(state_usage);
 	ktime_t  kt1, kt2;
 	s64 idle_time_ns;
 	s64 idle_time;
@@ -852,8 +850,8 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 
 	/* Update device last_residency and state counters*/
 	dev->last_residency = (int)idle_time;
-	dev->states[index].time += (unsigned long long)dev->last_residency;
-	dev->states[index].usage++;
+	state_usage->time += (unsigned long long)dev->last_residency;
+	state_usage->usage++;
 
 	/* Tell the scheduler how much we idled: */
 	sched_clock_idle_wakeup_event(idle_time_ns);
@@ -879,12 +877,11 @@ static DEFINE_SPINLOCK(c3_lock);
  *
  * If BM is detected, the deepest non-C3 idle state is entered instead.
  */
-static int acpi_idle_enter_bm(struct cpuidle_device *dev,
-				int index)
+static int acpi_idle_enter_bm(struct cpuidle_device *dev, int index)
 {
 	struct acpi_processor *pr;
-	struct cpuidle_state *state = &dev->states[index];
-	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
+	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
+	struct acpi_processor_cx *cx = cpuidle_get_statedata(state_usage);
 	ktime_t  kt1, kt2;
 	s64 idle_time_ns;
 	s64 idle_time;
@@ -979,8 +976,8 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 
 	/* Update device last_residency and state counters*/
 	dev->last_residency = (int)idle_time;
-	dev->states[index].time += (unsigned long long)dev->last_residency;
-	dev->states[index].usage++;
+	state_usage->time += (unsigned long long)dev->last_residency;
+	state_usage->usage++;
 
 	/* Tell the scheduler how much we idled: */
 	sched_clock_idle_wakeup_event(idle_time_ns);
@@ -1010,6 +1007,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 	int i, count = CPUIDLE_DRIVER_STATE_START;
 	struct acpi_processor_cx *cx;
 	struct cpuidle_state *state;
+	struct cpuidle_state_usage *state_usage;
 	struct cpuidle_device *dev = &pr->power.dev;
 
 	if (!pr->flags.power_setup_done)
@@ -1032,6 +1030,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER && i <= max_cstate; i++) {
 		cx = &pr->power.states[i];
 		state = &dev->states[count];
+		state_usage = &dev->states_usage[count];
 
 		if (!cx->valid)
 			continue;
@@ -1042,7 +1041,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 		    !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED))
 			continue;
 #endif
-		cpuidle_set_statedata(state, cx);
+		cpuidle_set_statedata(state_usage, cx);
 
 		snprintf(state->name, CPUIDLE_NAME_LEN, "C%d", i);
 		strncpy(state->desc, cx->desc, CPUIDLE_DESC_LEN);
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 92a6216..5d6f98d 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -160,8 +160,9 @@ static int poll_idle(struct cpuidle_device *dev, int index)
 		diff = INT_MAX;
 
 	dev->last_residency = (int) diff;
-	dev->states[index].time += (unsigned long long)dev->last_residency;
-	dev->states[index].usage++;
+	dev->states_usage[index].time +=
+			(unsigned long long)dev->last_residency;
+	dev->states_usage[index].usage++;
 
 	return index;
 }
@@ -169,8 +170,9 @@ static int poll_idle(struct cpuidle_device *dev, int index)
 static void poll_idle_init(struct cpuidle_device *dev)
 {
 	struct cpuidle_state *state = &dev->states[0];
+	struct cpuidle_state_usage *state_usage = &dev->states_usage[0];
 
-	cpuidle_set_statedata(state, NULL);
+	cpuidle_set_statedata(state_usage, NULL);
 
 	snprintf(state->name, CPUIDLE_NAME_LEN, "POLL");
 	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
@@ -218,8 +220,8 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
 		goto fail_sysfs;
 
 	for (i = 0; i < dev->state_count; i++) {
-		dev->states[i].usage = 0;
-		dev->states[i].time = 0;
+		dev->states_usage[i].usage = 0;
+		dev->states_usage[i].time = 0;
 	}
 	dev->last_residency = 0;
 
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index be7917e..09c9c77 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -216,7 +216,7 @@ static struct kobj_type ktype_cpuidle = {
 
 struct cpuidle_state_attr {
 	struct attribute attr;
-	ssize_t (*show)(struct cpuidle_state *, char *);
+	ssize_t (*show)(struct cpuidle_state *, struct cpuidle_state_usage *, char *);
 	ssize_t (*store)(struct cpuidle_state *, const char *, size_t);
 };
 
@@ -224,19 +224,19 @@ struct cpuidle_state_attr {
 static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0444, show, NULL)
 
 #define define_show_state_function(_name) \
-static ssize_t show_state_##_name(struct cpuidle_state *state, char *buf) \
+static ssize_t show_state_##_name(struct cpuidle_state *state, struct cpuidle_state_usage *state_usage, char *buf) \
 { \
 	return sprintf(buf, "%u\n", state->_name);\
 }
 
 #define define_show_state_ull_function(_name) \
-static ssize_t show_state_##_name(struct cpuidle_state *state, char *buf) \
+static ssize_t show_state_##_name(struct cpuidle_state *state, struct cpuidle_state_usage *state_usage, char *buf) \
 { \
-	return sprintf(buf, "%llu\n", state->_name);\
+	return sprintf(buf, "%llu\n", state_usage->_name);\
 }
 
 #define define_show_state_str_function(_name) \
-static ssize_t show_state_##_name(struct cpuidle_state *state, char *buf) \
+static ssize_t show_state_##_name(struct cpuidle_state *state, struct cpuidle_state_usage *state_usage, char *buf) \
 { \
 	if (state->_name[0] == '\0')\
 		return sprintf(buf, "<null>\n");\
@@ -269,16 +269,18 @@ static struct attribute *cpuidle_state_default_attrs[] = {
 
 #define kobj_to_state_obj(k) container_of(k, struct cpuidle_state_kobj, kobj)
 #define kobj_to_state(k) (kobj_to_state_obj(k)->state)
+#define kobj_to_state_usage(k) (kobj_to_state_obj(k)->state_usage)
 #define attr_to_stateattr(a) container_of(a, struct cpuidle_state_attr, attr)
 static ssize_t cpuidle_state_show(struct kobject * kobj,
 	struct attribute * attr ,char * buf)
 {
 	int ret = -EIO;
 	struct cpuidle_state *state = kobj_to_state(kobj);
+	struct cpuidle_state_usage *state_usage = kobj_to_state_usage(kobj);
 	struct cpuidle_state_attr * cattr = attr_to_stateattr(attr);
 
 	if (cattr->show)
-		ret = cattr->show(state, buf);
+		ret = cattr->show(state, state_usage, buf);
 
 	return ret;
 }
@@ -323,6 +325,7 @@ int cpuidle_add_state_sysfs(struct cpuidle_device *device)
 		if (!kobj)
 			goto error_state;
 		kobj->state = &device->states[i];
+		kobj->state_usage = &device->states_usage[i];
 		init_completion(&kobj->kobj_unregister);
 
 		ret = kobject_init_and_add(&kobj->kobj, &ktype_state_cpuidle, &device->kobj,
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index a3306be..5a1a238 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -28,19 +28,22 @@ struct cpuidle_device;
  * CPUIDLE DEVICE INTERFACE *
  ****************************/
 
+struct cpuidle_state_usage {
+	void		*driver_data;
+
+	unsigned long long	usage;
+	unsigned long long	time; /* in US */
+};
+
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
 			int index);
 };
@@ -52,26 +55,27 @@ struct cpuidle_state {
 
 /**
  * cpuidle_get_statedata - retrieves private driver state data
- * @state: the state
+ * @st_usage: the state usage statistics
  */
-static inline void * cpuidle_get_statedata(struct cpuidle_state *state)
+static inline void *cpuidle_get_statedata(struct cpuidle_state_usage *st_usage)
 {
-	return state->driver_data;
+	return st_usage->driver_data;
 }
 
 /**
  * cpuidle_set_statedata - stores private driver state data
- * @state: the state
+ * @st_usage: the state usage statistics
  * @data: the private data
  */
 static inline void
-cpuidle_set_statedata(struct cpuidle_state *state, void *data)
+cpuidle_set_statedata(struct cpuidle_state_usage *st_usage, void *data)
 {
-	state->driver_data = data;
+	st_usage->driver_data = data;
 }
 
 struct cpuidle_state_kobj {
 	struct cpuidle_state *state;
+	struct cpuidle_state_usage *state_usage;
 	struct completion kobj_unregister;
 	struct kobject kobj;
 };
@@ -85,6 +89,7 @@ struct cpuidle_device {
 	int			last_residency;
 	int			state_count;
 	struct cpuidle_state	states[CPUIDLE_STATE_MAX];
+	struct cpuidle_state_usage	states_usage[CPUIDLE_STATE_MAX];
 	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
 
 	struct list_head 	device_list;

