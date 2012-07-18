Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab2GROmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 10:42:16 -0400
Received: from toro.web-alm.net ([62.245.132.31]:54305 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab2GROmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 10:42:12 -0400
Message-ID: <5006CA64.4070003@osadl.org>
Date: Wed, 18 Jul 2012 16:38:28 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
CC: Len Brown <len.brown@intel.com>, Kevin Hilman <khilman@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: [PATCH 1/1 v3] Honor state disabling in the cpuidle ladder governor
 - with sanitizer
References: <20120717185914.063547728@osadl.org> <20120717190330.700421963@osadl.org> <50065953.9040904@linux.vnet.ibm.com> <500697A9.6070101@osadl.org> <5006A2A6.8030902@linux.vnet.ibm.com>
In-Reply-To: <5006A2A6.8030902@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------010608010601070909030904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010608010601070909030904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/18/2012 01:48 PM, Deepthi Dharwar wrote:
> On 07/18/2012 04:32 PM, Carsten Emde wrote:
>> On 07/18/2012 08:36 AM, Deepthi Dharwar wrote:
>>> On 07/18/2012 12:29 AM, Carsten Emde wrote:
>>>> There are two cpuidle governors ladder and menu. While the ladder
>>>> governor is always available, if CONFIG_CPU_IDLE is selected, the
>>>> menu governor additionally requires CONFIG_NO_HZ.
>>>>
>>>> A particular C state can be disabled by writing to the sysfs file
>>>> /sys/devices/system/cpu/cpuN/cpuidle/stateN/disable, but this mechanism
>>>> is only implemented in the menu governor. Thus, in a system where
>>>> CONFIG_NO_HZ is not selected, the ladder governor becomes default and
>>>> always will walk through all sleep states - irrespective of whether the
>>>> C state was disabled via sysfs or not. The only way to select a specific
>>>> C state was to write the related latency to /dev/cpu_dma_latency and
>>>> keep the file open as long as this setting was required - not very
>>>> practical and not suitable for setting a single core in an SMP system.
>>>>
>>>> With this patch, the ladder governor only will promote to the next
>>>> C state, if it has not been disabled, and it will demote, if the
>>>> current C state was disabled.
>>>
>>> Yes, I agree that currently that disabling a particular C-state
>>> is not reflected in working of ladder governor. This patch is needed
>>> to fix it on ladder too.
>>>
>>> Also wanted to clarify on the intended implementation here,
>>> if there are say 5 C-states on a system, disabling 2nd
>>> state would also end by disabling all the remaining 3 deeper states too
>>> as ladder governor enters the lightest state first, and will only move
>>> on to the next deeper state if a idle period was long enough as
>>> per the implementation.
>>> If one is disabling only the deepest state, then it would
>>> work as intended.
>> Yes, the patch does not make the setting of the sysfs variable
>> "disable" coherent, i.e. if one is disabling a light state, then all
>> deeper states are disabled as well, but the "disable" variable does not
>> reflect it. Likewise, if one enables a deep state but a lighter state
>> still is disabled, then this has no effect.
>
> Agree, as per the ladder design.
>
>> I could implement a sanitize mechanism of the ladder governor that
>> takes care the "disable" variables of all deeper states are set to 1,
>> if a state is disabled, and those of all lighter states are set to 0,
>> if a state is enabled. Do you wish me to do that?
>
> No, I dont think thats necessary, current code suffices it.
> The disable flag is knob we are giving to the user . So may be just
> document  the  intended use of disable flag working
> alongside design of ladder governor.
It's not necessary - but maybe better. Here comes v3 with a sanitizer.
Is this too ugly?

	-Carsten.


--------------010608010601070909030904
Content-Type: text/x-patch;
 name="drivers-cpuidle-ladder-honor-disabling-with-sanitizer.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="drivers-cpuidle-ladder-honor-disabling-with-sanitizer.patch"

From: Carsten Emde <C.Emde@osadl.org>
Subject: Honor state disabling in the cpuidle ladder governor

There are two cpuidle governors ladder and menu. While the ladder
governor is always available, if CONFIG_CPU_IDLE is selected, the
menu governor additionally requires CONFIG_NO_HZ.

A particular C state can be disabled by writing to the sysfs file
/sys/devices/system/cpu/cpuN/cpuidle/stateN/disable, but this mechanism
is only implemented in the menu governor. Thus, in a system where
CONFIG_NO_HZ is not selected, the ladder governor becomes default and
always will walk through all sleep states - irrespective of whether the
C state was disabled via sysfs or not. The only way to select a specific
C state was to write the related latency to /dev/cpu_dma_latency and
keep the file open as long as this setting was required - not very
practical and not suitable for setting a single core in an SMP system.

With this patch, the ladder governor only will promote to the next
C state, if it has not been disabled, and it will demote, if the
current C state was disabled.

A sanitize mechanism takes care the disable variables of all deeper
states are set to 1, if a state is disabled, and those of all lighter
states are set to 0, if a state is enabled.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>

---
 drivers/cpuidle/governors/ladder.c |   25 ++++++++++++++++++++++++-
 drivers/cpuidle/sysfs.c            |    6 ++++++
 include/linux/cpuidle.h            |    4 ++++
 3 files changed, 34 insertions(+), 1 deletion(-)

Index: linux-3.4.4-rt14-rc2-64/drivers/cpuidle/governors/ladder.c
===================================================================
--- linux-3.4.4-rt14-rc2-64.orig/drivers/cpuidle/governors/ladder.c
+++ linux-3.4.4-rt14-rc2-64/drivers/cpuidle/governors/ladder.c
@@ -58,6 +58,25 @@ static inline void ladder_do_selection(s
 	ldev->last_state_idx = new_idx;
 }
 
+void notify_state_modified(struct cpuidle_state *state)
+{
+	if (state->disable) {
+		/* synchronize all deeper states, if any */
+		int states = state->state_count - 1 - state->state_no;
+		struct cpuidle_state *last = state + states;
+
+		while (++state <= last)
+			state->disable = 1;
+	} else {
+		/* synchronize all lighter states, if any */
+		int states = state->state_no;
+		struct cpuidle_state *first = state - states;
+
+		while (--state >= first)
+			state->disable = 0;
+	}
+}
+
 /**
  * ladder_select_state - selects the next state to enter
  * @drv: cpuidle driver
@@ -88,6 +107,7 @@ static int ladder_select_state(struct cp
 
 	/* consider promotion */
 	if (last_idx < drv->state_count - 1 &&
+	    !drv->states[last_idx + 1].disable &&
 	    last_residency > last_state->threshold.promotion_time &&
 	    drv->states[last_idx + 1].exit_latency <= latency_req) {
 		last_state->stats.promotion_count++;
@@ -100,7 +120,8 @@ static int ladder_select_state(struct cp
 
 	/* consider demotion */
 	if (last_idx > CPUIDLE_DRIVER_STATE_START &&
-	    drv->states[last_idx].exit_latency > latency_req) {
+	    (drv->states[last_idx].disable ||
+	    drv->states[last_idx].exit_latency > latency_req)) {
 		int i;
 
 		for (i = last_idx - 1; i > CPUIDLE_DRIVER_STATE_START; i--) {
@@ -154,6 +175,8 @@ static int ladder_enable_device(struct c
 			lstate->threshold.promotion_time = state->exit_latency;
 		if (i > 0)
 			lstate->threshold.demotion_time = state->exit_latency;
+
+		state->notify = notify_state_modified;
 	}
 
 	return 0;
Index: linux-3.4.4-rt14-rc2-64/drivers/cpuidle/sysfs.c
===================================================================
--- linux-3.4.4-rt14-rc2-64.orig/drivers/cpuidle/sysfs.c
+++ linux-3.4.4-rt14-rc2-64/drivers/cpuidle/sysfs.c
@@ -239,15 +239,19 @@ static ssize_t store_state_##_name(struc
 { \
 	long value; \
 	int err; \
+	unsigned int old; \
 	if (!capable(CAP_SYS_ADMIN)) \
 		return -EPERM; \
 	err = kstrtol(buf, 0, &value); \
 	if (err) \
 		return err; \
+	old = state->disable; \
 	if (value) \
 		state->disable = 1; \
 	else \
 		state->disable = 0; \
+	if (state->notify && state->disable != old) \
+		state->notify(state); \
 	return size; \
 }
 
@@ -377,6 +381,8 @@ int cpuidle_add_state_sysfs(struct cpuid
 			kfree(kobj);
 			goto error_state;
 		}
+		drv->states[i].state_no = i;
+		drv->states[i].state_count = device->state_count;
 		kobject_uevent(&kobj->kobj, KOBJ_ADD);
 		device->kobjs[i] = kobj;
 	}
Index: linux-3.4.4-rt14-rc2-64/include/linux/cpuidle.h
===================================================================
--- linux-3.4.4-rt14-rc2-64.orig/include/linux/cpuidle.h
+++ linux-3.4.4-rt14-rc2-64/include/linux/cpuidle.h
@@ -47,6 +47,10 @@ struct cpuidle_state {
 	int		power_usage; /* in mW */
 	unsigned int	target_residency; /* in US */
 	unsigned int    disable;
+	unsigned int	state_no;
+	unsigned int	state_count;
+
+	void (*notify)	(struct cpuidle_state *state);
 
 	int (*enter)	(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,

--------------010608010601070909030904--
