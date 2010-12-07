Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab0LGO3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:29:18 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:56810 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab0LGO3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:29:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nR1FZvbV+k69of7fnsr1+PIt64K5PnGnv8SxBQfwtuyAOsRsWnGA+t8DJiQU0OfPdu
         3WMGzzkVN38UcQ2C6FIHjfRrr39cfY4LnDylp/s586Fwbpf8/N9ZMYA5v2hLdap1gdZz
         BoZJkiEIOacNaXuK8h0pgdxBz+9X63Oq+VZh4=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1012070053470.5514@x980>
References: <alpine.LFD.2.00.1010230116590.29399@localhost.localdomain>
	<alpine.LFD.2.00.1010240004180.23060@localhost.localdomain>
	<alpine.LFD.2.00.1010262312090.3209@localhost.localdomain>
	<alpine.LFD.2.00.1011151056380.2939@x980>
	<alpine.LFD.2.00.1011232353440.20657@x980>
	<alpine.LFD.2.00.1012070053470.5514@x980>
Date: Tue, 7 Dec 2010 12:29:10 -0200
Message-ID: <AANLkTi=_dYMw1JVWcu_uyqPQxzo2Ms94DEXYGbEtNZYq@mail.gmail.com>
Subject: Re: [PATCH v4] tools: create power/x86/turbostat
From: Thiago Farina <tfransosi@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-pm@lists.linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 7, 2010 at 4:00 AM, Len Brown <lenb@kernel.org> wrote:
> From: Len Brown <len.brown@intel.com>
>
> turbostat is a tool to help verify proper operation
> of processor power management states on modern x86.
>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
> v4: fix open file descriptor leak, reported by David C. Wong
>
>  tools/power/x86/turbostat/Makefile    |    8 +
>  tools/power/x86/turbostat/turbostat.8 |  172 ++++++
>  tools/power/x86/turbostat/turbostat.c | 1048 +++++++++++++++++++++++++++++++++
>  3 files changed, 1228 insertions(+), 0 deletions(-)
>
> diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
> new file mode 100644
> index 0000000..4c6983d
> --- /dev/null
> +++ b/tools/power/x86/turbostat/turbostat.c
> @@ -0,0 +1,1048 @@
> +/*
> + * turbostat -- show CPU frequency and C-state residency
> + * on modern Intel turbo-capable processors.
> + *
> + * Copyright (c) 2010, Intel Corporation.
> + * Len Brown <len.brown@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <sys/types.h>
> +#include <sys/wait.h>
> +#include <sys/stat.h>
> +#include <sys/resource.h>
> +#include <fcntl.h>
> +#include <signal.h>
> +#include <sys/time.h>
> +#include <stdlib.h>
> +#include <dirent.h>
> +#include <string.h>
> +#include <ctype.h>
> +
> +#define MSR_TSC        0x10
> +#define MSR_NEHALEM_PLATFORM_INFO      0xCE
> +#define MSR_NEHALEM_TURBO_RATIO_LIMIT  0x1AD
> +#define MSR_APERF      0xE8
> +#define MSR_MPERF      0xE7
> +#define MSR_PKG_C2_RESIDENCY   0x60D   /* SNB only */
> +#define MSR_PKG_C3_RESIDENCY   0x3F8
> +#define MSR_PKG_C6_RESIDENCY   0x3F9
> +#define MSR_PKG_C7_RESIDENCY   0x3FA   /* SNB only */
> +#define MSR_CORE_C3_RESIDENCY  0x3FC
> +#define MSR_CORE_C6_RESIDENCY  0x3FD
> +#define MSR_CORE_C7_RESIDENCY  0x3FE   /* SNB only */
> +
> +char *proc_stat = "/proc/stat";
> +unsigned int interval_sec = 5; /* set with -i interval_sec */
> +unsigned int verbose;          /* set with -v */
> +unsigned int skip_c0;
> +unsigned int skip_c1;
> +unsigned int do_nhm_cstates;
> +unsigned int do_snb_cstates;
> +unsigned int has_aperf;
> +unsigned int units = 1000000000;       /* Ghz etc */
> +unsigned int genuine_intel;
> +unsigned int has_invariant_tsc;
> +unsigned int do_nehalem_platform_info;
> +unsigned int do_nehalem_turbo_ratio_limit;
> +unsigned int extra_msr_offset;
> +double bclk;
> +unsigned int show_pkg;
> +unsigned int show_core;
> +unsigned int show_cpu;
> +
> +int aperf_mperf_unstable;
> +int backwards_count;
> +char *progname;
> +int need_reinitialize;
> +
> +int num_cpus;
> +
> +typedef struct per_cpu_counters {
> +       unsigned long long tsc;         /* per thread */
> +       unsigned long long aperf;       /* per thread */
> +       unsigned long long mperf;       /* per thread */
> +       unsigned long long c1;  /* per thread (calculated) */
> +       unsigned long long c3;  /* per core */
> +       unsigned long long c6;  /* per core */
> +       unsigned long long c7;  /* per core */
> +       unsigned long long pc2; /* per package */
> +       unsigned long long pc3; /* per package */
> +       unsigned long long pc6; /* per package */
> +       unsigned long long pc7; /* per package */
> +       unsigned long long extra_msr;   /* per thread */
> +       int pkg;
> +       int core;
> +       int cpu;
> +       struct per_cpu_counters *next;
> +} PCC;
> +

Why the typedef? Isn't preferable to use struct per_cpu_counters all
around (yeah I know it requires more typing, but is less obfuscated).

> +PCC *pcc_even;
> +PCC *pcc_odd;
> +PCC *pcc_delta;
> +PCC *pcc_average;
> +struct timeval tv_even;
> +struct timeval tv_odd;
> +struct timeval tv_delta;
> +
> +unsigned long long get_msr(int cpu, off_t offset)
> +{
> +       ssize_t retval;
> +       unsigned long long msr;
> +       char pathname[32];
> +       int fd;
> +
> +       sprintf(pathname, "/dev/cpu/%d/msr", cpu);
> +       fd = open(pathname, O_RDONLY);
> +       if (fd < 0) {
> +               perror(pathname);
> +               need_reinitialize = 1;
> +               return 0;
> +       }
> +
> +       retval = pread(fd, &msr, sizeof msr, offset);
> +       if (retval != sizeof msr) {
> +               fprintf(stderr, "cpu%d pread(..., 0x%zx) = %jd\n",
> +                       cpu, offset, retval);
> +               exit(-2);
> +       }
> +
> +       close(fd);
> +       return msr;
> +}
> +
> +void print_header()
use void in the paramenter? Also make this static?

> +
> +#define SUBTRACT_COUNTER(after, before, delta) (delta = (after - before), (before > after))
> +
> +
Remove this extra blank line?

> +
> +void get_counters(PCC *pcc)
> +{
> +       for ( ; pcc; pcc = pcc->next) {
> +               pcc->tsc = get_msr(pcc->cpu, MSR_TSC);
> +               if (do_nhm_cstates)
> +                       pcc->c3 = get_msr(pcc->cpu, MSR_CORE_C3_RESIDENCY);
> +               if (do_nhm_cstates)
> +                       pcc->c6 = get_msr(pcc->cpu, MSR_CORE_C6_RESIDENCY);
> +               if (do_snb_cstates)
> +                       pcc->c7 = get_msr(pcc->cpu, MSR_CORE_C7_RESIDENCY);
> +               if (has_aperf)
> +                       pcc->aperf = get_msr(pcc->cpu, MSR_APERF);
> +               if (has_aperf)
> +                       pcc->mperf = get_msr(pcc->cpu, MSR_MPERF);
> +               if (do_snb_cstates)
> +                       pcc->pc2 = get_msr(pcc->cpu, MSR_PKG_C2_RESIDENCY);
> +               if (do_nhm_cstates)
> +                       pcc->pc3 = get_msr(pcc->cpu, MSR_PKG_C3_RESIDENCY);
> +               if (do_nhm_cstates)
> +                       pcc->pc6 = get_msr(pcc->cpu, MSR_PKG_C6_RESIDENCY);
> +               if (do_snb_cstates)
> +                       pcc->pc7 = get_msr(pcc->cpu, MSR_PKG_C7_RESIDENCY);
> +               if (extra_msr_offset)
> +                       pcc->extra_msr = get_msr(pcc->cpu, extra_msr_offset);
> +       }
> +}
> +
> +
Remove this blank line too?

> +void print_nehalem_info()
> +{
Add void into the parameter?

> +       unsigned long long msr;
> +       unsigned int ratio;
> +
> +       if (!do_nehalem_platform_info)
> +               return;
> +
> +       msr = get_msr(0, MSR_NEHALEM_PLATFORM_INFO);
> +
> +       ratio = (msr >> 40) & 0xFF;
> +       fprintf(stderr, "%d * %.0f = %.0f MHz max efficiency\n",
> +               ratio, bclk, ratio * bclk);
> +
> +       ratio = (msr >> 8) & 0xFF;
> +       fprintf(stderr, "%d * %.0f = %.0f MHz TSC frequency\n",
> +               ratio, bclk, ratio * bclk);
> +
> +       if (verbose > 1)
> +               fprintf(stderr, "MSR_NEHALEM_PLATFORM_INFO: 0x%llx\n", msr);
> +
> +       if (!do_nehalem_turbo_ratio_limit)
> +               return;
> +
> +       msr = get_msr(0, MSR_NEHALEM_TURBO_RATIO_LIMIT);
> +
> +       ratio = (msr >> 24) & 0xFF;
> +       if (ratio)
> +               fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 4 active cores\n",
> +                       ratio, bclk, ratio * bclk);
> +
> +       ratio = (msr >> 16) & 0xFF;
> +       if (ratio)
> +               fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 3 active cores\n",
> +                       ratio, bclk, ratio * bclk);
> +
> +       ratio = (msr >> 8) & 0xFF;
> +       if (ratio)
> +               fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 2 active cores\n",
> +                       ratio, bclk, ratio * bclk);
> +
> +       ratio = (msr >> 0) & 0xFF;
> +       if (ratio)
> +               fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 1 active cores\n",
> +                       ratio, bclk, ratio * bclk);
> +
> +}
> +
> +void free_counter_list(PCC *list)
> +{
> +       PCC *p;
> +
> +       for (p = list; p; ) {
> +               PCC *free_me;
> +
> +               free_me = p;
> +               p = p->next;
> +               free(free_me);
> +       }
> +       return;
Why the return here? Isn't redundant?

> +
> +void insert_cpu_counters(PCC **list, PCC *new)
> +{
> +       PCC *prev;
> +
> +       /*
> +        * list was empty
> +        */
> +       if (*list == NULL) {
> +               new->next = *list;
> +               *list = new;
> +               return;
> +       }
> +
> +       show_cpu = 1;   /* there is more than one CPU */
> +
> +       /*
> +        * insert on front of list.
> +        * It is sorted by ascending package#, core#, cpu#
> +        */
> +       if (((*list)->pkg > new->pkg) ||
> +           (((*list)->pkg == new->pkg) && ((*list)->core > new->core)) ||
> +           (((*list)->pkg == new->pkg) && ((*list)->core == new->core) && ((*list)->cpu > new->cpu))) {
> +               new->next = *list;
> +               *list = new;
> +               return;
> +       }
> +
> +       prev = *list;
> +
> +       while (prev->next && (prev->next->pkg < new->pkg)) {
> +               prev = prev->next;
> +               show_pkg = 1;   /* there is more than 1 package */
> +       }
> +
> +       while (prev->next && (prev->next->pkg == new->pkg)
> +               && (prev->next->core < new->core)) {
> +               prev = prev->next;
> +               show_core = 1;  /* there is more than 1 core */
> +       }
> +
> +       while (prev->next && (prev->next->pkg == new->pkg)
> +               && (prev->next->core == new->core)
> +               && (prev->next->cpu < new->cpu)) {
> +               prev = prev->next;
> +       }
> +
> +       /*
> +        * insert after "prev"
> +        */
> +       new->next = prev->next;
> +       prev->next = new;
> +
> +       return;
Same thing here about the return.

> +
> +int get_physical_package_id(int cpu)
> +{
> +       char path[64];
> +       FILE *filep;
> +       int pkg;
> +
> +       sprintf(path, "/sys/devices/system/cpu/cpu%d/topology/physical_package_id", cpu);
> +       filep = fopen(path, "r");
> +       if (filep == NULL) {
> +               perror(path);
> +               exit(1);
> +       }
> +       fscanf(filep, "%d", &pkg);
> +       fclose(filep);
> +       return pkg;
> +}
> +
> +int get_core_id(int cpu)
> +{
> +       char path[64];
> +       FILE *filep;
> +       int core;
> +
> +       sprintf(path, "/sys/devices/system/cpu/cpu%d/topology/core_id", cpu);
> +       filep = fopen(path, "r");
> +       if (filep == NULL) {
> +               perror(path);
> +               exit(1);
> +       }
> +       fscanf(filep, "%d", &core);
> +       fclose(filep);
> +       return core;
> +}
> +
> +/*
> + * run func(index, cpu) on every cpu in /proc/stat
> + */
> +
> +int for_all_cpus(void (func)(int, int, int))
> +{
> +       FILE *fp;
> +       int cpu_count;
> +       int retval;
> +
> +       fp = fopen(proc_stat, "r");
> +       if (fp == NULL) {
> +               perror(proc_stat);
> +               exit(1);
> +       }
> +
> +       retval = fscanf(fp, "cpu %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d\n");
> +       if (retval != 0) {
> +               perror("/proc/stat format");
> +               exit(1);
> +       }
> +
> +       for (cpu_count = 0; ; cpu_count++) {
> +               int cpu;
> +
> +               retval = fscanf(fp, "cpu%u %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d\n", &cpu);
> +               if (retval != 1)
> +                       break;
> +
> +               func(get_physical_package_id(cpu), get_core_id(cpu), cpu);
> +       }
> +       fclose(fp);
> +       return cpu_count;
> +}
> +
> +void re_initialize(void)
> +{
> +       printf("turbostat: topology changed, re-initializing.\n");
> +       free_all_counters();
> +       num_cpus = for_all_cpus(alloc_new_cpu_counters);
> +       need_reinitialize = 0;
> +       printf("num_cpus is now %d\n", num_cpus);
> +}
> +
> +void dummy(int pkg, int core, int cpu) { return; }
> +/*
> + * check to see if a cpu came on-line
> + */
> +void verify_num_cpus()
Use void on parameter?

> +{
> +       int new_num_cpus;
> +
> +       new_num_cpus = for_all_cpus(dummy);
> +
> +       if (new_num_cpus != num_cpus) {
> +               if (verbose)
> +                       printf("num_cpus was %d, is now  %d\n",
> +                               num_cpus, new_num_cpus);
> +               need_reinitialize = 1;
> +       }
> +
> +       return;
> +}
No need of this return, right?
