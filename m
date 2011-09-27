Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab1I0KD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:03:58 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:52856 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab1I0KDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:03:55 -0400
Subject: [PATCH V7 3/4] cpuidle: Split cpuidle_state structure and move
 per-cpu statistics fields
To: khilman@ti.com, venki@google.com, ak@linux.intel.com, len.brown@intel.com,
        peterz@infradead.org, santosh.shilimkar@ti.com, arjan@linux.intel.com,
        lenb@kernel.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Tue, 27 Sep 2011 15:33:49 +0530
Message-ID: <20110927100335.16043.16046.stgit@localhost6.localdomain6>
In-Reply-To: <20110927100202.16043.58669.stgit@localhost6.localdomain6>
References: <20110927100202.16043.58669.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
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

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Signed-off-by: Trinabh Gupta <g.trinabh@gmail.com>
Signed-off-by: Jean Pihet <j-pihet@ti.com>
Reviewed-by: Kevin Hilman <khilman@ti.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Kevin Hilman <khilman@ti.com>
---
 arch/arm/mach-davinci/cpuidle.c   |    5 ++--
 arch/arm/mach-omap2/cpuidle34xx.c |   13 ++++++----
 drivers/acpi/processor_idle.c     |   25 ++++++++++----------
 drivers/cpuidle/cpuidle.c         |   11 +++++----
 drivers/cpuidle/sysfs.c           |   19 ++++++++++-----
 drivers/idle/intel_idle.c         |   46 +++++++++++++++++++++++++++----------
 include/linux/cpuidle.h           |   25 ++++++++++++--------
 7 files changed, 90 insertions(+), 54 deletions(-)

diff --git a/arch/arm/mach-davinci/cpuidle.c b/arch/arm/mach-davinci/cpuidle.c
index ca8582a..f2d2f34 100644
--- a/arch/arm/mach-davinci/cpuidle.c
+++ b/arch/arm/mach-davinci/cpuidle.c
@@ -80,7 +80,8 @@ static struct davinci_ops davinci_states[DAVINCI_CPUIDLE_MAX_STATES] = {
 static int davinci_enter_idle(struct cpuidle_device *dev,
 						int index)
 {
-	struct davinci_ops *ops = cpuidle_get_statedata(&dev->states[index]);
+	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
+	struct davinci_ops *ops = cpuidle_get_statedata(state_usage);
 	struct timeval before, after;
 	int idle_time;
 
@@ -142,7 +143,7 @@ static int __init davinci_cpuidle_probe(struct platform_device *pdev)
 	strcpy(device->states[1].desc, "WFI and DDR Self Refresh");
 	if (pdata->ddr2_pdown)
 		davinci_states[1].flags |= DAVINCI_CPUIDLE_FLAGS_DDR2_PWDN;
-	cpuidle_set_statedata(&device->states[1], &davinci_states[1]);
+	cpuidle_set_statedata(&device->states_usage[1], &davinci_states[1]);
 
 	device->state_count = DAVINCI_CPUIDLE_MAX_STATES;
 
diff --git a/arch/arm/mach-omap2/cpuidle34xx.c b/arch/arm/mach-omap2/cpuidle34xx.c
index 58425c7..d3fce7b 100644
--- a/arch/arm/mach-omap2/cpuidle34xx.c
+++ b/arch/arm/mach-omap2/cpuidle34xx.c
@@ -97,7 +97,7 @@ static int omap3_enter_idle(struct cpuidle_device *dev,
 				int index)
 {
 	struct omap3_idle_statedata *cx =
-			cpuidle_get_statedata(&dev->states[index]);
+			cpuidle_get_statedata(&dev->states_usage[index]);
 	struct timespec ts_preidle, ts_postidle, ts_idle;
 	u32 mpu_state = cx->mpu_state, core_state = cx->core_state;
 	int idle_time;
@@ -160,8 +160,9 @@ return_sleep_time:
 static int next_valid_state(struct cpuidle_device *dev,
 				int index)
 {
+	struct cpuidle_state_usage *curr_usage = &dev->states_usage[index];
 	struct cpuidle_state *curr = &dev->states[index];
-	struct omap3_idle_statedata *cx = cpuidle_get_statedata(curr);
+	struct omap3_idle_statedata *cx = cpuidle_get_statedata(curr_usage);
 	u32 mpu_deepest_state = PWRDM_POWER_RET;
 	u32 core_deepest_state = PWRDM_POWER_RET;
 	int next_index = -1;
@@ -202,7 +203,7 @@ static int next_valid_state(struct cpuidle_device *dev,
 		 */
 		idx--;
 		for (; idx >= 0; idx--) {
-			cx = cpuidle_get_statedata(&dev->states[idx]);
+			cx = cpuidle_get_statedata(&dev->states_usage[idx]);
 			if ((cx->valid) &&
 			    (cx->mpu_state >= mpu_deepest_state) &&
 			    (cx->core_state >= core_deepest_state)) {
@@ -231,7 +232,6 @@ static int next_valid_state(struct cpuidle_device *dev,
 static int omap3_enter_idle_bm(struct cpuidle_device *dev,
 			       int index)
 {
-	struct cpuidle_state *state = &dev->states[index];
 	int new_state_idx;
 	u32 core_next_state, per_next_state = 0, per_saved_state = 0, cam_state;
 	struct omap3_idle_statedata *cx;
@@ -264,7 +264,7 @@ static int omap3_enter_idle_bm(struct cpuidle_device *dev,
 	 * Prevent PER off if CORE is not in retention or off as this
 	 * would disable PER wakeups completely.
 	 */
-	cx = cpuidle_get_statedata(state);
+	cx = cpuidle_get_statedata(&dev->states_usage[index]);
 	core_next_state = cx->core_state;
 	per_next_state = per_saved_state = pwrdm_read_next_pwrst(per_pd);
 	if ((per_next_state == PWRDM_POWER_OFF) &&
@@ -318,6 +318,7 @@ static inline struct omap3_idle_statedata *_fill_cstate(
 {
 	struct omap3_idle_statedata *cx = &omap3_idle_data[idx];
 	struct cpuidle_state *state = &dev->states[idx];
+	struct cpuidle_state_usage *state_usage = &dev->states_usage[idx];
 
 	state->exit_latency	= cpuidle_params_table[idx].exit_latency;
 	state->target_residency	= cpuidle_params_table[idx].target_residency;
@@ -326,7 +327,7 @@ static inline struct omap3_idle_statedata *_fill_cstate(
 	cx->valid		= cpuidle_params_table[idx].valid;
 	sprintf(state->name, "C%d", idx + 1);
 	strncpy(state->desc, descr, CPUIDLE_DESC_LEN);
-	cpuidle_set_statedata(state, cx);
+	cpuidle_set_statedata(state_usage, cx);
 
 	return cx;
 }
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 9cd08ce..b98c752 100644
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
@@ -790,12 +789,11 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
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
@@ -875,12 +873,11 @@ static DEFINE_SPINLOCK(c3_lock);
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
@@ -1004,6 +1001,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 	int i, count = CPUIDLE_DRIVER_STATE_START;
 	struct acpi_processor_cx *cx;
 	struct cpuidle_state *state;
+	struct cpuidle_state_usage *state_usage;
 	struct cpuidle_device *dev = &pr->power.dev;
 
 	if (!pr->flags.power_setup_done)
@@ -1026,6 +1024,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER && i <= max_cstate; i++) {
 		cx = &pr->power.states[i];
 		state = &dev->states[count];
+		state_usage = &dev->states_usage[count];
 
 		if (!cx->valid)
 			continue;
@@ -1036,7 +1035,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 		    !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED))
 			continue;
 #endif
-		cpuidle_set_statedata(state, cx);
+		cpuidle_set_statedata(state_usage, cx);
 
 		snprintf(state->name, CPUIDLE_NAME_LEN, "C%d", i);
 		strncpy(state->desc, cx->desc, CPUIDLE_DESC_LEN);
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index f66bcf9..7127e92 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -105,9 +105,9 @@ int cpuidle_idle_call(void)
 		/* This can be moved to within driver enter routine
 		 * but that results in multiple copies of same code.
 		 */
-		dev->states[entered_state].time +=
+		dev->states_usage[entered_state].time +=
 				(unsigned long long)dev->last_residency;
-		dev->states[entered_state].usage++;
+		dev->states_usage[entered_state].usage++;
 	}
 
 	/* give the governor an opportunity to reflect on the outcome */
@@ -186,8 +186,9 @@ static int poll_idle(struct cpuidle_device *dev, int index)
 static void poll_idle_init(struct cpuidle_device *dev)
 {
 	struct cpuidle_state *state = &dev->states[0];
+	struct cpuidle_state_usage *state_usage = &dev->states_usage[0];
 
-	cpuidle_set_statedata(state, NULL);
+	cpuidle_set_statedata(state_usage, NULL);
 
 	snprintf(state->name, CPUIDLE_NAME_LEN, "POLL");
 	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
@@ -235,8 +236,8 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
 		goto fail_sysfs;
 
 	for (i = 0; i < dev->state_count; i++) {
-		dev->states[i].usage = 0;
-		dev->states[i].time = 0;
+		dev->states_usage[i].usage = 0;
+		dev->states_usage[i].time = 0;
 	}
 	dev->last_residency = 0;
 
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index be7917ec..8a1ace1 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -216,7 +216,8 @@ static struct kobj_type ktype_cpuidle = {
 
 struct cpuidle_state_attr {
 	struct attribute attr;
-	ssize_t (*show)(struct cpuidle_state *, char *);
+	ssize_t (*show)(struct cpuidle_state *, \
+					struct cpuidle_state_usage *, char *);
 	ssize_t (*store)(struct cpuidle_state *, const char *, size_t);
 };
 
@@ -224,19 +225,22 @@ struct cpuidle_state_attr {
 static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0444, show, NULL)
 
 #define define_show_state_function(_name) \
-static ssize_t show_state_##_name(struct cpuidle_state *state, char *buf) \
+static ssize_t show_state_##_name(struct cpuidle_state *state, \
+			 struct cpuidle_state_usage *state_usage, char *buf) \
 { \
 	return sprintf(buf, "%u\n", state->_name);\
 }
 
 #define define_show_state_ull_function(_name) \
-static ssize_t show_state_##_name(struct cpuidle_state *state, char *buf) \
+static ssize_t show_state_##_name(struct cpuidle_state *state, \
+			struct cpuidle_state_usage *state_usage, char *buf) \
 { \
-	return sprintf(buf, "%llu\n", state->_name);\
+	return sprintf(buf, "%llu\n", state_usage->_name);\
 }
 
 #define define_show_state_str_function(_name) \
-static ssize_t show_state_##_name(struct cpuidle_state *state, char *buf) \
+static ssize_t show_state_##_name(struct cpuidle_state *state, \
+			struct cpuidle_state_usage *state_usage, char *buf) \
 { \
 	if (state->_name[0] == '\0')\
 		return sprintf(buf, "<null>\n");\
@@ -269,16 +273,18 @@ static struct attribute *cpuidle_state_default_attrs[] = {
 
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
@@ -323,6 +329,7 @@ int cpuidle_add_state_sysfs(struct cpuidle_device *device)
 		if (!kobj)
 			goto error_state;
 		kobj->state = &device->states[i];
+		kobj->state_usage = &device->states_usage[i];
 		init_completion(&kobj->kobj_unregister);
 
 		ret = kobject_init_and_add(&kobj->kobj, &ktype_state_cpuidle, &device->kobj,
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index a1c888d..3aa8d4c 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -109,7 +109,6 @@ static struct cpuidle_state nehalem_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C1 */
 		.name = "C1-NHM",
 		.desc = "MWAIT 0x00",
-		.driver_data = (void *) 0x00,
 		.flags = CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 3,
 		.target_residency = 6,
@@ -117,7 +116,6 @@ static struct cpuidle_state nehalem_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C2 */
 		.name = "C3-NHM",
 		.desc = "MWAIT 0x10",
-		.driver_data = (void *) 0x10,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 20,
 		.target_residency = 80,
@@ -125,7 +123,6 @@ static struct cpuidle_state nehalem_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C3 */
 		.name = "C6-NHM",
 		.desc = "MWAIT 0x20",
-		.driver_data = (void *) 0x20,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 200,
 		.target_residency = 800,
@@ -137,7 +134,6 @@ static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C1 */
 		.name = "C1-SNB",
 		.desc = "MWAIT 0x00",
-		.driver_data = (void *) 0x00,
 		.flags = CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 1,
 		.target_residency = 1,
@@ -145,7 +141,6 @@ static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C2 */
 		.name = "C3-SNB",
 		.desc = "MWAIT 0x10",
-		.driver_data = (void *) 0x10,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 80,
 		.target_residency = 211,
@@ -153,7 +148,6 @@ static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C3 */
 		.name = "C6-SNB",
 		.desc = "MWAIT 0x20",
-		.driver_data = (void *) 0x20,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 104,
 		.target_residency = 345,
@@ -161,7 +155,6 @@ static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C4 */
 		.name = "C7-SNB",
 		.desc = "MWAIT 0x30",
-		.driver_data = (void *) 0x30,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 109,
 		.target_residency = 345,
@@ -173,7 +166,6 @@ static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C1 */
 		.name = "C1-ATM",
 		.desc = "MWAIT 0x00",
-		.driver_data = (void *) 0x00,
 		.flags = CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 1,
 		.target_residency = 4,
@@ -181,7 +173,6 @@ static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C2 */
 		.name = "C2-ATM",
 		.desc = "MWAIT 0x10",
-		.driver_data = (void *) 0x10,
 		.flags = CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 20,
 		.target_residency = 80,
@@ -190,7 +181,6 @@ static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C4 */
 		.name = "C4-ATM",
 		.desc = "MWAIT 0x30",
-		.driver_data = (void *) 0x30,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 100,
 		.target_residency = 400,
@@ -199,13 +189,41 @@ static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C6 */
 		.name = "C6-ATM",
 		.desc = "MWAIT 0x52",
-		.driver_data = (void *) 0x52,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 140,
 		.target_residency = 560,
 		.enter = &intel_idle },
 };
 
+static int get_driver_data(int cstate)
+{
+	int driver_data;
+	switch (cstate) {
+
+	case 1:	/* MWAIT C1 */
+		driver_data = 0x00;
+		break;
+	case 2:	/* MWAIT C2 */
+		driver_data = 0x10;
+		break;
+	case 3:	/* MWAIT C3 */
+		driver_data = 0x20;
+		break;
+	case 4:	/* MWAIT C4 */
+		driver_data = 0x30;
+		break;
+	case 5:	/* MWAIT C5 */
+		driver_data = 0x40;
+		break;
+	case 6:	/* MWAIT C6 */
+		driver_data = 0x52;
+		break;
+	default:
+		driver_data = 0x00;
+	}
+	return driver_data;
+}
+
 /**
  * intel_idle
  * @dev: cpuidle_device
@@ -216,7 +234,8 @@ static int intel_idle(struct cpuidle_device *dev, int index)
 {
 	unsigned long ecx = 1; /* break on interrupt flag */
 	struct cpuidle_state *state = &dev->states[index];
-	unsigned long eax = (unsigned long)cpuidle_get_statedata(state);
+	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
+	unsigned long eax = (unsigned long)cpuidle_get_statedata(state_usage);
 	unsigned int cstate;
 	ktime_t kt_before, kt_after;
 	s64 usec_delta;
@@ -451,6 +470,9 @@ static int intel_idle_cpuidle_devices_init(void)
 			dev->states[dev->state_count] =	/* structure copy */
 				cpuidle_state_table[cstate];
 
+			dev->states_usage[dev->state_count].driver_data =
+				(void *)get_driver_data(cstate);
+
 			dev->state_count += 1;
 		}
 
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index c6d85cf..0156540 100644
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

