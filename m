Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab0E0DpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 23:45:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757028Ab0E0DpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 23:45:05 -0400
Date: Wed, 26 May 2010 20:44:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 8/8] intel_idle: create a native cpuidle driver for
 select intel processors
Message-Id: <20100526204426.fd2be7e0.akpm@linux-foundation.org>
In-Reply-To: <198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
	<198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 22:42:31 -0400 Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> This EXPERIMENTAL driver supersedes acpi_idle
> on modern Intel processors. (Nehalem and Atom Processors).
> 
> For CONFIG_INTEL_IDLE=y, intel_idle probes before acpi_idle,
> no matter if CONFIG_ACPI_PROCESSOR=y or =m.
> 
> Boot with "intel_idle.max_cstate=0" to disable the driver
> and to fall back on ACPI.
> 
> CONFIG_INTEL_IDLE=m is not recommended unless the system
> has a method to guarantee intel_idle loads before ACPI's
> processor_idle.
> 
> This driver does not yet know about cpu online/offline
> and thus will not yet play well with cpu-hotplug.
> 
>
> ...
>
> +/*
> + * Known issues
> + *
> + * The driver currently initializes for_each_online_cpu() upon modprobe.
> + * It it unaware cpu online/offline and cpui hotplug

(typo).

Implications?  What happens when an additional CPU is brought online? 
It melts?  ;)

CPU hotplug support is usually pretty simple to provide.  But it tends
to affect the overall code structure and is best designed-in at the
outset.

> + * ACPI has a .suspend hack to turn off deep c-statees during suspend
> + * to avoid complications with the lapic timer workaround
> + * will need to address that situation here too.
> + *
> + * There is currently no automatic probing/loading mechanism
> + * if the driver is built as a module.
> + */
>
> ...
>
> +#define mwait_hint_to_cstate(hint) ((((hint) >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK) + 1)
> +#define lapic_timer_reliable(cstate) (lapic_timer_reliable_states & (1 << (cstate)))

Could have been implemented in C.  Nicer to look at, better typechecking.

> +static struct cpuidle_driver intel_idle_driver = {
> +	.name = "intel_idle",
> +	.owner = THIS_MODULE,
> +};
> +static int max_cstate = MWAIT_MAX_NUM_CSTATES - 1;	/* intel_idle.max_cstate=0 disables driver */
> +static int power_policy = 7; /* 0 = max perf; 15 = max powersave */
> +
> +static unsigned int substates;
> +#define get_num_mwait_substates(cstate) ((substates >> ((cstate) * 4)) && 0xF)

ddiittoo..

> +/* Reliable LAPIC Timer States, bit 1 for C1 etc.  */
> +static unsigned int lapic_timer_reliable_states;
> +
> +static struct cpuidle_device *intel_idle_cpuidle_devices;
> +static int intel_idle(struct cpuidle_device *dev, struct cpuidle_state *state);
> +
> +/*
> + * These attributes are be visible under
> + * /sys/devices/system/cpu/cpu.../cpuidle/state.../
> + *
> + * name 
> + * 	Hardware name of the state, from datasheet
> + * desc
> + * 	MWAIT param
> + * driver_data
> + * 	token passed to intel_idle()
> + * flags
> + * 	CPUIDLE_FLAG_TIME_VALID
> + * 		we return valid times in all states
> + * 	CPUIDLE_FLAG_SHALLOW
> + * 		lapic timer keeps running
> + * exit_latency
> + * 	[usec]
> + * power_usage
> + * 	mW (TBD)
> + * target_residency
> + * 	currently we multiply exit_latency by 4
> + * 	[usec]
> + * usage
> + * 	instance counter
> + * time
> + * 	residency counter [usec]
> + */

There's been a half-hearted attempt to describe sysfs files in
Documentation/ABI/.

>
> ...
>
> +static struct cpuidle_state nehalem_cstates[MWAIT_MAX_NUM_CSTATES] = {
> +	{ "", "", 0, 0, 0, 0, 0, 0, 0, 0},
> +	{ "NHM-C1", "MWAIT 0x00", (void *) 0x00,
> +		CPUIDLE_FLAG_TIME_VALID,
> +		3, 1000, 6, 0, 0, &intel_idle },
> +	{ "NHM-C3", "MWAIT 0x10", (void *) 0x10,
> +		CPUIDLE_FLAG_TIME_VALID,
> +		20, 500, 80, 0, 0, &intel_idle },
> +	{ "NHM-C6", "MWAIT 0x20", (void *) 0x20,
> +		CPUIDLE_FLAG_TIME_VALID,
> +		200, 350, 800, 0, 0, &intel_idle },
> +	{ "", "", 0, 0, 0, 0, 0, 0, 0, 0},
> +	{ "", "", 0, 0, 0, 0, 0, 0, 0, 0},
> +	{ "", "", 0, 0, 0, 0, 0, 0, 0, 0},
> +	{ "", "", 0, 0, 0, 0, 0, 0, 0, 0}
> +};
> +
> +static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
> +	{ "", "", 0, 0, 0, 0, 0, 0, 0, 0},
> +	{ "ATM-C1", "MWAIT 0x00", (void *) 0x00,
> +		CPUIDLE_FLAG_TIME_VALID,
> +		1, 1000, 4, 0, 0, &intel_idle },
> +	{ "ATM-C2", "MWAIT 0x10", (void *) 0x10,
> +		CPUIDLE_FLAG_TIME_VALID,
> +		20, 500, 80, 0, 0, &intel_idle },
> +	{ "", "", 0, 0, 0, 0, 0, 0, 0, 0},
> +	{ "ATM-C4", "MWAIT 0x30", (void *) 0x30,
> +		CPUIDLE_FLAG_TIME_VALID,
> +		100, 250, 400, 0, 0, &intel_idle },
> +	{ "ATM-C6", "MWAIT 0x40", (void *) 0x40,
> +		CPUIDLE_FLAG_TIME_VALID,
> +		200, 150, 800, 0, 0, &intel_idle },
> +	{ "", "", 0, 0, 0, 0, 0, 0, 0, 0},
> +	{ "", "", 0, 0, 0, 0, 0, 0, 0, 0}
> +};

Could omit all the zeroes.  Could possibly also omit the "" strings,
with suitable handling.

These would be better in { .name = value, } form.

>
> ...
>
> +static int intel_idle_probe(void)
> +{
> +	unsigned int eax, ebx, ecx, edx;
> +
> +	if (max_cstate == 0) {
> +		pr_debug(PREFIX "disabled\n" );
> +		return -1;
> +	}
> +
> +	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> +		return -1;
> + 
> +	if (!boot_cpu_has(X86_FEATURE_MWAIT))
> +		return -1;
> +
> +	if (boot_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
> +		return -1;
> +
> +	cpuid(CPUID_MWAIT_LEAF, &eax, &ebx, &ecx, &edx);
> +
> +	if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED) ||
> +		!(ecx & CPUID5_ECX_INTERRUPT_BREAK))
> +			return -1;
> +
> +	pr_debug(PREFIX "MWAIT substates: 0x%x\n", edx);
> +
> +#ifdef DEBUG
> +	if (substates == 0)	/* can over-ride via modparam */
> +#endif
> +		substates = edx;
> +
> +	/*
> + 	 * Bail out if non-stop TSC unavailable.
> + 	 * Nehalem and newer have it.
> + 	 *
> + 	 * Atom and Core2 will will require
> + 	 * mark_tsc_unstable("TSC halts in idle")
> + 	 * when have a state deeper than C1
> + 	 */
> +	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
> +		return -1;
> +
> +	if (boot_cpu_has(X86_FEATURE_ARAT))	/* Always Reliable APIC Timer */
> +		lapic_timer_reliable_states = 0xFFFFFFFF;
> +
> +	if (boot_cpu_data.x86 != 6)	/* family 6 */
> +		return -1;
> +
> +	switch (boot_cpu_data.x86_model) {
> +
> +	case 0x1A:	/* Core i7, Xeon 5500 series */
> +	case 0x1E:	/* Core i7 and i5 Processor - Lynnfield, Jasper Forest */
> +	case 0x1F:	/* Core i7 and i5 Processor - Nehalem */
> +	case 0x2E:	/* Nehalem-EX Xeon */
> +		lapic_timer_reliable_states = (1 << 1);	 /* C1 */
> +
> +	case 0x25:	/* Westmere */
> +	case 0x2C:	/* Westmere */
> +
> +		cpuidle_state_table = nehalem_cstates;
> +		break;
> +#ifdef notyet
> +	case 0x1C:	/* 28 - Atom Processor */
> +		cpuidle_state_table = atom_cstates;
> +		break;
> +#endif
> +
> +	case 0x17:	/* 23 - Core 2 Duo */
> +		lapic_timer_reliable_states = (1 << 2) | (1 << 1); /* C2, C1 */
> +
> +	default:
> +		pr_debug(PREFIX "does not run on family %d model %d\n",
> +			boot_cpu_data.x86, boot_cpu_data.x86_model);
> +		return -1;
> +	}
> +
> +	pr_debug(PREFIX "v" INTEL_IDLE_VERSION
> +		" model 0x%X\n", boot_cpu_data.x86_model);
> +
> +pr_debug(PREFIX "lapic_timer_reliable_states 0x%x\n", lapic_timer_reliable_states);

layout went funny.

> +	return 0;
> +}
> +
> +/*
> + * intel_idle_cpuidle_devices_init()
> + * allocate, initialize, register cpuidle_devices
> + */
> +static int intel_idle_cpuidle_devices_init(void)
> +{
> +	int i, cstate;
> +	struct cpuidle_device *dev;
> +
> +	intel_idle_cpuidle_devices = alloc_percpu(struct cpuidle_device);
> +	if (intel_idle_cpuidle_devices == NULL)
> +		return -1;
> +
> +	for_each_online_cpu(i) {
> +		dev = per_cpu_ptr(intel_idle_cpuidle_devices, i);
> +
> +		dev->state_count = 1;
> +
> +		for (cstate = 1; cstate < MWAIT_MAX_NUM_CSTATES; ++cstate) {
> +			int num_substates;
> +
> +			if (cstate > max_cstate) {
> +				printk(PREFIX "max_cstate %d exceeded", max_cstate);
> +				break;
> +			}
> +
> +			/* does the state exist in CPUID.MWAIT? */
> +			num_substates = get_num_mwait_substates(cstate);
> +			if (num_substates == 0)
> +				continue;
> +
> +			/* does the state exist in the driver's table? */
> +			if (cpuidle_state_table[cstate].name == NULL) {
> +				pr_debug(PREFIX "unaware of model 0x%x MWAIT %x\
> +					please contact lenb@kernel.org", boot_cpu_data.x86_model, cstate);
> +				continue;
> +			}
> +			dev->states[dev->state_count] = cpuidle_state_table[cstate];	/* structure copy */
> +			dev->state_count += 1;
> +		}
> +
> +		dev->cpu = i;
> +		if (cpuidle_register_device(dev)) {
> +			pr_debug(PREFIX "cpuidle_register_device %d failed!\n", i);
> +			free_percpu(intel_idle_cpuidle_devices);
> +			return -EIO;

Should this unregister all the thus-far-registered devices?

> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * intel_idle_cpuidle_devices_uninit()
> + * unregister, free cpuidle_devices
> + */
> +static void intel_idle_cpuidle_devices_uninit(void)
> +{
> +	int i;
> +	struct cpuidle_device *dev;
> +
> +	for_each_online_cpu(i) {
> +		dev = per_cpu_ptr(intel_idle_cpuidle_devices, i);
> +		cpuidle_unregister_device(dev);
> +	}
> +
> +	free_percpu(intel_idle_cpuidle_devices);
> +	return;
> +}
> +
> +static int intel_idle_init(void) 

__init?

The patch adds trailing whitespace.  Has various other checkpatch
problems.

> +{
> +
> +	if (intel_idle_probe())
> +		return -1;
> +
> +	if (cpuidle_register_driver(&intel_idle_driver)) {
> +		pr_debug(PREFIX "unable to register with cpuidle due to %s",
> +			cpuidle_get_driver()->name);
> +		return -1;
> +	}
> +
> +	if (intel_idle_cpuidle_devices_init()) {
> +		cpuidle_unregister_driver(&intel_idle_driver);
> +		return -1;
> +	}

All these hard-coded -1's are a bit sloppy.  Could use -ENODEV, -EIO,
etc.  The only real value in this is to get better diagnostics out of
do_one_initcall() when initcall_debug was selected.

> +	return 0;	
> +}
> +

