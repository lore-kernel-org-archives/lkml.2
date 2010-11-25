Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab0KYI7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 03:59:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:1509 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab0KYI7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 03:59:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,253,1288594800"; 
   d="scan'208";a="630197017"
Message-ID: <4CEE2558.1050903@linux.intel.com>
Date: Thu, 25 Nov 2010 16:59:04 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Chen Gong <gong.chen@linux.intel.com>
CC: Len Brown <lenb@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2] tools: create power/x86/x86_energy_perf_policy
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain> <alpine.LFD.2.00.1009281143070.14962@localhost.localdomain> <alpine.LFD.2.00.1010230035360.29399@localhost.localdomain> <alpine.LFD.2.00.1011151103280.2939@x980> <alpine.LFD.2.00.1011240028470.20657@x980> <4CEDF9BB.9030002@linux.intel.com>
In-Reply-To: <4CEDF9BB.9030002@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 11/25/2010 1:52 PM, Chen Gong 写道:
> 于 11/24/2010 1:31 PM, Len Brown 写道:
>> From: Len Brown<len.brown@intel.com>
>>
>> MSR_IA32_ENERGY_PERF_BIAS first became available on Westmere Xeon.
>> It is implemented in all Sandy Bridge processors -- mobile, desktop
>> and server.
>> It is expected to become increasingly important in subsequent
>> generations.
>>
>> x86_energy_perf_policy is a user-space utility to set this
>> hardware energy vs performance policy hint in the processor.
>> Most systems would benefit from "x86_energy_perf_policy normal"
>> at system startup, as the hardware default is maximum performance
>> at the expense of energy efficiency.
>>
>> Linux-2.6.36 added "epb" to /proc/cpuinfo to indicate
>> if an x86 processor supports MSR_IA32_ENERGY_PERF_BIAS,
>> though the kernel does not actually program the MSR.
>>
>> In March, Venkatesh Pallipadi proposed a small driver
>> that programmed MSR_IA32_ENERGY_PERF_BIAS, based on
>> the cpufreq governor in use. It also offered
>> a boot-time cmdline option to override.
>> http://lkml.org/lkml/2010/3/4/457
>> But hiding the hardware policy behind the
>> governor choice was deemed "kinda icky".
>>
>> So in June, I proposed a generic user/kernel API to
>> consolidate the power/performance policy trade-off.
>> "RFC: /sys/power/policy_preference"
>> http://lkml.org/lkml/2010/6/16/399
>> That is my preference for implementing this capability,
>> but I received no support on the list.
>>
>> So in September, I sent x86_energy_perf_policy.c to LKML,
>> a user-space utility that scribbles directly to the MSR.
>> http://lkml.org/lkml/2010/9/28/246
>>
>> Here is the same utility re-sent, this time proposed
>> to reside in the kernel tools directory.
>>
>> Signed-off-by: Len Brown<len.brown@intel.com>
>> ---
>> v2
>> create man page
>> minor tweaks in response to review comments
>>
>> tools/power/x86/x86_energy_perf_policy/Makefile | 8 +
>> .../x86_energy_perf_policy.8 | 104 +++++++
>> .../x86_energy_perf_policy.c | 325 ++++++++++++++++++++
>>
>> diff --git a/tools/power/x86/x86_energy_perf_policy/Makefile
>> b/tools/power/x86/x86_energy_perf_policy/Makefile
>> new file mode 100644
>> index 0000000..f458237
>> --- /dev/null
>> +++ b/tools/power/x86/x86_energy_perf_policy/Makefile
>> @@ -0,0 +1,8 @@
>> +x86_energy_perf_policy : x86_energy_perf_policy.c
>> +
>> +clean :
>> + rm -f x86_energy_perf_policy
>> +
>> +install :
>> + install x86_energy_perf_policy /usr/bin/
>> + install x86_energy_perf_policy.8 /usr/share/man/man8/
>> diff --git
>> a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.8
>> b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.8
>> new file mode 100644
>> index 0000000..8eaaad6
>> --- /dev/null
>> +++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.8
>> @@ -0,0 +1,104 @@
>> +.\" This page Copyright (C) 2010 Len Brown<len.brown@intel.com>
>> +.\" Distributed under the GPL, Copyleft 1994.
>> +.TH X86_ENERGY_PERF_POLICY 8
>> +.SH NAME
>> +x86_energy_perf_policy \- read or write MSR_IA32_ENERGY_PERF_BIAS
>> +.SH SYNOPSIS
>> +.ft B
>> +.B x86_energy_perf_policy
>> +.RB [ "\-c cpu" ]
>> +.RB [ "\-v" ]
>> +.RB "\-r"
>> +.br
>> +.B x86_energy_perf_policy
>> +.RB [ "\-c cpu" ]
>> +.RB [ "\-v" ]
>> +.RB 'performance'
>> +.br
>> +.B x86_energy_perf_policy
>> +.RB [ "\-c cpu" ]
>> +.RB [ "\-v" ]
>> +.RB 'normal'
>> +.br
>> +.B x86_energy_perf_policy
>> +.RB [ "\-c cpu" ]
>> +.RB [ "\-v" ]
>> +.RB 'powersave'
>> +.br
>> +.B x86_energy_perf_policy
>> +.RB [ "\-c cpu" ]
>> +.RB [ "\-v" ]
>> +.RB n
>> +.br
>> +.SH DESCRIPTION
>> +\fBx86_energy_perf_policy\fP
>> +allows software to convey
>> +its policy for the relative importance of performance
>> +versus energy savings to the processor.
>> +
>> +The processor uses this information in model-specific ways
>> +when it must select trade-offs between performance and
>> +energy efficiency.
>> +
>> +This policy hint does not supersede Processor Performance states
>> +(P-states) or CPU Idle power states (C-states), but allows
>> +software to have influence where it would otherwise be unable
>> +to express a preference.
>> +
>> +For example, this setting may tell the hardware how
>> +aggressively or conservatively to control frequency
>> +in the "turbo range" above the explicitly OS-controlled
>> +P-state frequency range. It may also tell the hardware
>> +how aggressively is should enter the OS requested C-states.
>> +
>> +Support for this feature is indicated by CPUID.06H.ECX.bit3
>> +per the Intel Architectures Software Developer's Manual.
>> +
>> +.SS Options
>> +\fB-c\fP limits operation to a single CPU.
>> +The default is to operate on all CPUs.
>> +Note that MSR_IA32_ENERGY_PERF_BIAS is defined per
>> +logical processor, but that the initial implementations
>> +of the MSR were shared among all processors in each package.
>> +.PP
>> +\fB-v\fP increases verbosity. By default
>> +x86_energy_perf_policy is silent.
>> +.PP
>> +\fB-r\fP is for "read-only" mode - the unchanged state
>> +is read and displayed.
>> +.PP
>> +.I performance
>> +Set a policy where performance is paramount.
>> +The processor will be unwilling to sacrifice any performance
>> +for the sake of energy saving. This is the hardware default.
>> +.PP
>> +.I normal
>> +Set a policy with a normal balance between performance and energy
>> efficiency.
>> +The processor will tolerate minor performance compromise
>> +for potentially significant energy savings.
>> +This reasonable default for most desktops and servers.
>> +.PP
>> +.I powersave
>> +Set a policy where the processor can accept
>> +a measurable performance hit to maximize energy efficiency.
>> +.PP
>> +.I n
>> +Set MSR_IA32_ENERGY_PERF_BIAS to the specified number.
>> +The range of valid numbers is 0-15, where 0 is maximum
>> +performance and 15 is maximum energy efficiency.
>> +
>> +.SH NOTES
>> +.B "x86_energy_perf_policy "
>> +runs only as root.
>> +.SH FILES
>> +.ta
>> +.nf
>> +/dev/cpu/*/msr
>> +.fi
>> +
>> +.SH "SEE ALSO"
>> +msr(4)
>> +.PP
>> +.SH AUTHORS
>> +.nf
>> +Written by Len Brown<len.brown@intel.com>
>> diff --git
>> a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
>> b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
>> new file mode 100644
>> index 0000000..b539923
>> --- /dev/null
>> +++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
>> @@ -0,0 +1,325 @@
>> +/*
>> + * x86_energy_perf_policy -- set the energy versus performance
>> + * policy preference bias on recent X86 processors.
>> + */
>> +/*
>> + * Copyright (c) 2010, Intel Corporation.
>> + * Len Brown<len.brown@intel.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but
>> WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
>> License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> along with
>> + * this program; if not, write to the Free Software Foundation, Inc.,
>> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
>> + */
>> +
>> +#include<stdio.h>
>> +#include<unistd.h>
>> +#include<sys/types.h>
>> +#include<sys/stat.h>
>> +#include<sys/resource.h>
>> +#include<fcntl.h>
>> +#include<signal.h>
>> +#include<sys/time.h>
>> +#include<stdlib.h>
>> +#include<string.h>
>> +
>> +unsigned int verbose; /* set with -v */
>> +unsigned int read_only; /* set with -r */
>> +char *progname;
>> +unsigned long long new_bias;
>> +int cpu = -1;
>> +
>> +/*
>> + * Usage:
>> + *
>> + * -c cpu: limit action to a single CPU (default is all CPUs)
>> + * -v: verbose output (can invoke more than once)
>> + * -r: read-only, don't change any settings
>> + *
>> + * performance
>> + * Performance is paramount.
>> + * Unwilling to sacrafice any performance
>> + * for the sake of energy saving. (hardware default)
>> + *
>> + * normal
>> + * Can tolerate minor performance compromise
>> + * for potentially significant energy savings.
>> + * (reasonable default for most desktops and servers)
>> + *
>> + * powersave
>> + * Can tolerate significant performance hit
>> + * to maximize energy savings.
>> + *
>> + * n
>> + * a numerical value to write to the underlying MSR.
>> + */
>> +void usage(void)
>> +{
>> + printf("%s: [-c cpu] [-v] "
>> + "(-r | 'performance' | 'normal' | 'powersave' | n)\n",
>> + progname);
>> + exit(1);
>> +}
>> +
>> +#define MSR_IA32_ENERGY_PERF_BIAS 0x000001b0
>> +
>> +#define BIAS_PERFORMANCE 0
>> +#define BIAS_BALANCE 6
>> +#define BIAS_POWERSAVE 15
>> +
>> +void cmdline(int argc, char **argv)
>> +{
>> + int opt;
>> +
>> + progname = argv[0];
>> +
>> + while ((opt = getopt(argc, argv, "+rvc:")) != -1) {
>> + switch (opt) {
>> + case 'c':
>> + cpu = atoi(optarg);
>> + break;
>> + case 'r':
>> + read_only = 1;
>> + break;
>> + case 'v':
>> + verbose++;
>> + break;
>> + default:
>> + usage();
>> + }
>> + }
>> + /* if -r, then should be no additional optind */
>> + if (read_only&& (argc> optind))
>> + usage();
>> +
>> + /*
>> + * if no -r , then must be one additional optind
>> + */
>> + if (!read_only) {
>> +
>> + if (argc != optind + 1) {
>> + printf("must supply -r or policy param\n");
>> + usage();
>> + }
>> +
>> + if (!strcmp("performance", argv[optind])) {
>> + new_bias = BIAS_PERFORMANCE;
>> + } else if (!strcmp("normal", argv[optind])) {
>> + new_bias = BIAS_BALANCE;
>> + } else if (!strcmp("powersave", argv[optind])) {
>> + new_bias = BIAS_POWERSAVE;
>> + } else {
>> + char *endptr;
>> +
>> + new_bias = strtoull(argv[optind],&endptr, 0);
>> + if (endptr == argv[optind] ||
>> + new_bias> BIAS_POWERSAVE) {
>> + fprintf(stderr, "invalid value: %s\n",
>> + argv[optind]);
>> + usage();
>> + }
>> + }
>> + }
>> +}
>> +
>> +/*
>> + * validate_cpuid()
>> + * returns on success, quietly exits on failure (make verbose with -v)
>> + */
>> +void validate_cpuid(void)
>> +{
>> + unsigned int eax, ebx, ecx, edx, max_level;
>> + char brand[16];
>> + unsigned int fms, family, model, stepping;
>> +
>> + eax = ebx = ecx = edx = 0;
>> +
>> + asm("cpuid" : "=a" (max_level), "=b" (ebx), "=c" (ecx),
>> + "=d" (edx) : "a" (0));
>> +
>> + if (ebx != 0x756e6547 || edx != 0x49656e69 || ecx != 0x6c65746e) {
>> + if (verbose)
>> + fprintf(stderr, "%.4s%.4s%.4s != GenuineIntel",
>> + (char *)&ebx, (char *)&edx, (char *)&ecx);
>> + exit(1);
>> + }
>> +
>> + asm("cpuid" : "=a" (fms), "=c" (ecx), "=d" (edx) : "a" (1) : "ebx");
>> + family = (fms>> 8)& 0xf;
>> + model = (fms>> 4)& 0xf;
>> + stepping = fms& 0xf;
>> + if (family == 6 || family == 0xf)
>> + model += ((fms>> 16)& 0xf)<< 4;
>> +
>> + if (verbose> 1)
>> + printf("CPUID %s %d levels family:model:stepping "
>> + "0x%x:%x:%x (%d:%d:%d)\n", brand, max_level,
>> + family, model, stepping, family, model, stepping);
>> +
>> + if (!(edx& (1<< 5))) {
>> + if (verbose)
>> + printf("CPUID: no MSR\n");
>> + exit(1);
>> + }
>> +
>> + /*
>> + * Support for MSR_IA32_ENERGY_PERF_BIAS
>> + * is indicated by CPUID.06H.ECX.bit3
>> + */
>> + asm("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a"
>> (6));
>> + if (verbose)
>> + printf("CPUID.06H.ECX: 0x%x\n", ecx);
>> + if (!(ecx& (1<< 3))) {
>> + if (verbose)
>> + printf("CPUID: No MSR_IA32_ENERGY_PERF_BIAS\n");
>> + exit(1);
>> + }
>> + return; /* success */
>> +}
>> +
>> +unsigned long long get_msr(int cpu, int offset)
>> +{
>> + unsigned long long msr;
>> + char msr_path[32];
>> + int retval;
>> + int fd;
>> +
>> + sprintf(msr_path, "/dev/cpu/%d/msr", cpu);
>> + fd = open(msr_path, O_RDONLY);
>> + if (fd< 0) {
>> + printf("Try \"# modprobe msr\"\n");
>> + perror(msr_path);
>> + exit(1);
>> + }
>> +
>> + retval = pread(fd,&msr, sizeof msr, offset);
>> +
>> + if (retval != sizeof msr) {
>> + printf("pread cpu%d 0x%x = %d\n", cpu, offset, retval);
>> + exit(-2);
>> + }
>> + close(fd);
>> + return msr;
>> +}
>> +
>> +unsigned long long put_msr(int cpu, unsigned long long new_msr, int
>> offset)
>> +{
>> + unsigned long long old_msr;
>> + char msr_path[32];
>> + int retval;
>> + int fd;
>> +
>> + sprintf(msr_path, "/dev/cpu/%d/msr", cpu);
>> + fd = open(msr_path, O_RDWR);
>> + if (fd< 0) {
>> + perror(msr_path);
>> + exit(1);
>> + }
>> +
>> + retval = pread(fd,&old_msr, sizeof old_msr, offset);
>> + if (retval != sizeof old_msr) {
>> + perror("pwrite");
>> + printf("pread cpu%d 0x%x = %d\n", cpu, offset, retval);
>> + exit(-2);
>> + }
>> +
>> + retval = pwrite(fd,&new_msr, sizeof new_msr, offset);
>> + if (retval != sizeof new_msr) {
>> + perror("pwrite");
>> + printf("pwrite cpu%d 0x%x = %d\n", cpu, offset, retval);
>> + exit(-2);
>> + }
>> +
>> + close(fd);
>> +
>> + return old_msr;
>> +}
>> +
>> +void print_msr(int cpu)
>> +{
>> + printf("cpu%d: 0x%016llx\n",
>> + cpu, get_msr(cpu, MSR_IA32_ENERGY_PERF_BIAS));
>> +}
>> +
>> +void update_msr(int cpu)
>> +{
>> + unsigned long long previous_msr;
>> +
>> + previous_msr = put_msr(cpu, new_bias, MSR_IA32_ENERGY_PERF_BIAS);
>> +
>> + if (verbose)
>> + printf("cpu%d msr0x%x 0x%016llx -> 0x%016llx\n",
>> + cpu, MSR_IA32_ENERGY_PERF_BIAS, previous_msr, new_bias);
>> +
>> + return;
>> +}
>> +
>> +char *proc_stat = "/proc/stat";
>> +/*
>> + * run func() on every cpu in /dev/cpu
>> + */
>> +void for_every_cpu(void (func)(int))
>> +{
>> + FILE *fp;
>> + int retval;
>> +
>> + fp = fopen(proc_stat, "r");
>> + if (fp == NULL) {
>> + perror(proc_stat);
>> + exit(1);
>> + }
>> +
>> + retval = fscanf(fp, "cpu %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d\n");
>> + if (retval != 0) {
>> + perror("/proc/stat format");
>> + exit(1);
>> + }
>> +
>> + while (1) {
>> + int cpu;
>> +
>> + retval = fscanf(fp,
>> + "cpu%u %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d\n",
>> + &cpu);
>> + if (retval != 1)
>> + return;
>> +
>> + func(cpu);
>> + }
>> + fclose(fp);
>> +}
>> +
>> +int main(int argc, char **argv)
>> +{
>> + cmdline(argc, argv);
>> +
>> + if (verbose> 1)
>> + printf("x86_energy_perf_policy Nov 24, 2010"
>> + " - Len Brown<lenb@kernel.org>\n");
>> + if (verbose> 1&& !read_only)
>> + printf("new_bias %lld\n", new_bias);
>> +
>> + validate_cpuid();
>> +
>> + if (cpu != -1) {
>> + if (read_only)
>> + print_msr(cpu);
>> + else
>> + update_msr(cpu);
>> + } else {
>> + if (read_only)
>> + for_every_cpu(print_msr);
>> + else
>> + for_every_cpu(update_msr);
>> + }
>> +
>> + return 0;
>> +}
>>
> I have 2 questions.
>
> 1. the usage looks too simple. If I haven't read the comments
> in the source codes, I even can't know the exact meaning of these
> parameters. Such as -v, -vv etc. How about adding the comments
> as the part of the usage ?
>
> 2. the paramter "noraml | performance | powersave | n" looks weird.
> why it can't look like other paramter (-r, -v etc.). For example,
> I can't use it such as
> "./x86_energy_perf_policy -c 0 normal -v"
> --

One more question. From the spec, it should write 1 to the MSR 0x1FC[18]
to enable this function after setting the Energy Policy on all threads 
in one package.
