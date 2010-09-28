Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab0I1QRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:17:25 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:41016 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab0I1QRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:17:24 -0400
Date: Tue, 28 Sep 2010 12:17:06 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linux Power Management List <linux-pm@lists.osdl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, x86@kernel.org
Subject: x86_energy_perf_policy.c
In-reply-to: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
Message-id: <alpine.LFD.2.00.1009281143070.14962@localhost.localdomain>
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/* In June, I proposed /sys/power/policy_preference
to consolidate the knobs that user-space needs to turn
to tell the kernel its performance/energy preference.

The feedback I got was that user-space doesn't want the
kernel to consolidate anything, but instead wants the
kernel to expose everything and user-space will be able
to keep up with new devices and hooks, as long as
they are sufficiently documented.

I think that past history and the current state of affairs
suggests that user-space will come up short, but who am I to judge?

So here is a utility to implement the user-space
approach for Intel's new ENERGY_PERFR_BIAS MSR.
(You'll see it on some Westmere, and all Sandy Bridge processors)

The utility translates the words "powersave",
"normal", or "performance" into the right bits for
this register, and scribbles on /dev/cpu/*/msr,
as appropriate.

I'll be delighted to re-implement this in a different way
if consensus emerges that a better way exists.

thanks,
Len Brown
Intel Open Source Technology Center
*/

/*
 * x86_energy_perf_policy -- set the energy versus performance
 * policy preference bias on recent X86 processors.
 */
/*
 * Copyright (c) 2010, Intel Corporation.
 * Len Brown <len.brown@intel.com>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU General Public License,
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/resource.h>
#include <fcntl.h>
#include <signal.h>
#include <sys/time.h>
#include <stdlib.h>

unsigned int verbose;		/* set with -v */
unsigned int read_only;		/* set with -r */
char *progname;
unsigned long long new_bias;
int cpu = -1;

/*
 * Usage:
 *
 * -c cpu: limit action to a single CPU (default is all CPUs)
 * -v: verbose output (can invoke more than once)
 * -r: read-only, don't change any settings
 *
 *  performance
 *	Performance is paramount.
 *	Unwilling to sacrafice any performance
 *	for the sake of energy saving. (hardware default)
 *
 *  normal
 *	Can tolerate minor performance compromise
 *	for potentially significant energy savings.
 *	(reasonable default for most desktops and servers)
 *
 *  powersave
 *	Can tolerate significant performance hit
 *	to maximize energy savings.
 *
 * n
 * 	a numerical value to write to the underlying MSR.
 */
void usage(void)
{
	printf("%s: [-c cpu] [-v] "
		"(-r | 'performance' | 'normal' | 'powersave' | n)\n",
		progname);
}

/*
 * MSR_IA32_ENERGY_PERF_BIAS allows software to convey
 * its policy for the relative importance of performance
 * versus energy savings.
 *
 * The hardware uses this information in model-specific ways
 * when it must choose trade-offs between performance and
 * energy consumption.
 *
 * This policy hint does not supercede Processor Performance states
 * (P-states) or CPU Idle power states (C-states), but allows
 * software to have influence where it has been unable to
 * express a preference in the past.
 *
 * For example, this setting may tell the hardware how
 * aggressively or conservatively to control frequency
 * in the "turbo range" above the explicitly OS-controlled
 * P-state frequency range.  It may also tell the hardware
 * how aggressively is should enter the OS requestec C-states.
 *
 * The support for this feature is indicated by CPUID.06H.ECX.bit3
 * per the Intel Architectures Software Developer's Manual.
 */

#define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0

#define	BIAS_PERFORMANCE		0
#define BIAS_BALANCE			6
#define	BIAS_POWERSAVE			15

cmdline(int argc, char **argv) {
	int opt;

	progname = argv[0];

	while((opt = getopt(argc, argv, "+rvc:")) != -1) {
		switch (opt) {
		case 'c':
			cpu = atoi(optarg);
			break;
		case 'r':
			read_only = 1;
			break;
		case 'v':
			verbose++;
			break;
		default:
			usage();
			exit(-1);
		}
	}
	/* if -r, then should be no additional optind */
	if (read_only && (argc > optind)) {
		usage();
		exit(-1);
	}

	/*
	 * if no -r , then must be one additional optind
	 */
	if (!read_only) {

		if (argc != optind + 1 ) {
			printf("must supply -r or policy param\n");
			usage();
			exit(-1);
			}

		if (!strcmp("performance", argv[optind])) {
			new_bias = BIAS_PERFORMANCE;
		} else if (!strcmp("normal", argv[optind])) {
			new_bias = BIAS_BALANCE;
		} else if (!strcmp("powersave", argv[optind])) {
			new_bias = BIAS_POWERSAVE;
		} else {
			new_bias = atoll(argv[optind]);
			if (new_bias > BIAS_POWERSAVE) {
				usage();
				exit(-1);
			}
		}
		printf("new_bias 0x%016llx\n", new_bias);
	}
}

/*
 * validate_cpuid()
 * returns on success, quietly exits on failure (make verbose with -v)
 */
void validate_cpuid(void) {
	unsigned int eax, ebx, ecx, edx, max_level;
	char brand[16];
	unsigned int fms, family, model, stepping, ht_capable;

	eax = ebx = ecx = edx = 0;

	asm("cpuid" : "=a" (max_level), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0));

	sprintf(brand, "%.4s%.4s%.4s", &ebx, &edx, &ecx);

	if (strncmp(brand, "GenuineIntel", 12)) {
		if (verbose) printf("CPUID: %s != GenuineIntel\n",
			brand);
		exit(-1);
	}

	asm("cpuid" : "=a" (fms), "=c" (ecx), "=d" (edx) : "a" (1) : "ebx");
	family = (fms >> 8) & 0xf;
	model = (fms >> 4) & 0xf;
	stepping = fms & 0xf;
	if (family == 6 || family == 0xf)
		model += ((fms >> 16) & 0xf) << 4;

	if (verbose > 1)
		printf("CPUID %s %d levels family:model:stepping "
			"0x%x:%x:%x (%d:%d:%d)\n",
			brand, max_level, family, model, stepping, family, model, stepping);

	if (!(edx & (1 << 5))) {
		if (verbose)
			printf("CPUID: no MSR\n");
		exit(-1);
	}

 	/*
 	 * Support for MSR_IA32_ENERGY_PERF_BIAS is indicated by CPUID.06H.ECX.bit3
 	 */
	asm("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (6));
	if (verbose) printf("CPUID.06H.ECX: 0x%x\n", ecx);
	if (!(ecx & (1 << 3))) {
		if (verbose)
			printf("CPUID: No MSR_IA32_ENERGY_PERF_BIAS\n");
		exit(-1);
	}
	return;	/* success */
}

check_dev_msr() {
	struct stat sb;

	if (stat("/dev/cpu/0/msr", &sb)) {
		printf("no /dev/cpu/0/msr\n");
		printf("Try \"# modprobe msr\"\n");
		exit(-5);
	}
}

unsigned long long get_msr(int cpu, int offset)
{
	unsigned long long msr;
	char msr_path[32];
	int retval;
	int fd;

	sprintf(msr_path, "/dev/cpu/%d/msr", cpu);
	fd = open(msr_path, O_RDONLY);
	if (fd < 0) {
		perror(msr_path);
		exit(-1);
	}

	retval = pread(fd, &msr, sizeof msr, offset);

	if (retval != sizeof msr) {
		printf("pread cpu%d 0x%x = %d\n", cpu, offset, retval);
		exit(-2);
	}
	close(fd);
	return msr;
}

unsigned long long  put_msr(int cpu, unsigned long long new_msr, int offset)
{
	unsigned long long old_msr;
	char msr_path[32];
	int retval;
	int fd;

	sprintf(msr_path, "/dev/cpu/%d/msr", cpu);
	fd = open(msr_path, O_RDWR);
	if (fd < 0) {
		perror(msr_path);
		exit(-1);
	}

	retval = pread(fd, &old_msr, sizeof old_msr, offset);
	if (retval != sizeof old_msr) {
		perror("pwrite");
		printf("pread cpu%d 0x%x = %d\n", cpu, offset, retval);
		exit(-2);
	}

	retval = pwrite(fd, &new_msr, sizeof new_msr, offset);
	if (retval != sizeof new_msr) {
		perror("pwrite");
		printf("pwrite cpu%d 0x%x = %d\n", cpu, offset, retval);
		exit(-2);
	}

	close(fd);

	return old_msr;
}

void print_msr(int cpu)
{
	printf("cpu%d: 0x%016llx\n", cpu, get_msr(cpu, MSR_IA32_ENERGY_PERF_BIAS));
}

void update_msr(int cpu)
{
	unsigned long long previous_msr;

	previous_msr = put_msr(cpu, new_bias, MSR_IA32_ENERGY_PERF_BIAS);

	if (verbose)
		printf("cpu%d  msr0x%x 0x%016llx -> 0x%016llx\n",
			cpu, MSR_IA32_ENERGY_PERF_BIAS, previous_msr, new_bias);

	return;
}

char *proc_stat = "/proc/stat";
/*
 * run func() on every cpu in /dev/cpu
 */
void for_every_cpu(void (func)(int)) {
	FILE *fp;
	int cpu_count;
	int retval;

	fp = fopen(proc_stat, "r");
	if (fp == NULL) {
		perror(proc_stat);
		exit(-1);
	}

	retval = fscanf(fp, "cpu %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d\n");
	if (retval != 0) {
		perror("/proc/stat format");
		exit(-1);
	}

	for (cpu_count = 0; ;cpu_count++) {
		int cpu;

		retval = fscanf(fp, "cpu%u %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d\n", &cpu);
		if (retval != 1)
			return;

		func(cpu);
	}
	fclose(fp);
}

int main(int argc, char **argv)
{
	cmdline(argc, argv);

	if (verbose > 1)
		printf("x86_energy_perf_policy Aug 2, 2010"
				" - Len Brown <lenb@kernel.org>\n");
	if (verbose > 1 && !read_only)
		printf("new_bias %lld\n", new_bias);

	validate_cpuid();
	check_dev_msr();

	if (cpu != -1) {
		if (read_only)
			print_msr(cpu);
		else
			update_msr(cpu);
	} else {
		if (read_only) {
			for_every_cpu(print_msr);
		} else {
			for_every_cpu(update_msr);
		}
	}
		
	return 0;
}
