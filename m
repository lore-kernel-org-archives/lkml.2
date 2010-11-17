Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175Ab0KQLfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 06:35:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35469 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962Ab0KQLfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 06:35:54 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Len Brown <lenb@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH RESEND] tools: add power/x86/x86_energy_perf_policy to program MSR_IA32_ENERGY_PERF_BIAS
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
	<alpine.LFD.2.00.1009281143070.14962@localhost.localdomain>
	<alpine.LFD.2.00.1010230035360.29399@localhost.localdomain>
	<alpine.LFD.2.00.1011151103280.2939@x980>
Date: Wed, 17 Nov 2010 12:35:52 +0100
In-Reply-To: <alpine.LFD.2.00.1011151103280.2939@x980> (Len Brown's message of
	"Mon, 15 Nov 2010 11:07:04 -0500 (EST)")
Message-ID: <8739r0rxlz.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:
> @@ -0,0 +1,7 @@
> +x86_energy_perf_policy : x86_energy_perf_policy.c
> +
> +clean :
> +	rm -f x86_energy_perf_policy
> +
> +install :
> +	install x86_energy_perf_policy /usr/bin/x86_energy_perf_policy

It's not clear to me how this Makefile ensures it's only
build on x86. 

If someone on another architecture does a full tools build
in the future (I think that is not wired up yet, but should
eventually) such a mechanism would be needed.


> +
> +/*
> + * Usage:

...

This full comment and parts of the following comments describing the
semantics need to be available somewhere to the user who may not have
easy access to the source. Can you make it display in usage or convert
it to a manpage? I would prefer a manpage

> +
> +cmdline(int argc, char **argv) {

No type?

> +	int opt;
> +
> +	progname = argv[0];
> +
> +	while ((opt = getopt(argc, argv, "+rvc:")) != -1) {

Maybe it's me, but I prefer having long options too (getopt_long)
These are easier to memorize.

> +
> +	/*
> +	 * if no -r , then must be one additional optind
> +	 */
> +	if (!read_only) {
> +
> +		if (argc != optind + 1) {
> +			printf("must supply -r or policy param\n");
> +			usage();
> +			exit(-1);

-1 is an unusual exit code. Better use 1.

An obvious improvement would be to put the exit() into usage()

> +			}
> +
> +		if (!strcmp("performance", argv[optind])) {
> +			new_bias = BIAS_PERFORMANCE;
> +		} else if (!strcmp("normal", argv[optind])) {
> +			new_bias = BIAS_BALANCE;
> +		} else if (!strcmp("powersave", argv[optind])) {
> +			new_bias = BIAS_POWERSAVE;
> +		} else {
> +			new_bias = atoll(argv[optind]);

If you used strtoull() you could actually check if the input
is really a number (end == argv[optind])

> +	eax = ebx = ecx = edx = 0;
> +
> +	asm("cpuid" : "=a" (max_level), "=b" (ebx), "=c" (ecx),
> +		"=d" (edx) : "a" (0));

Strictly for 386/early 486 you would need to check if cpuid
is available using pushf too. Perhaps it's safer to use cpuinfo

> +
> +check_dev_msr() {

Return type missing again

> +	struct stat sb;
> +
> +	if (stat("/dev/cpu/0/msr", &sb)) {
> +		printf("no /dev/cpu/0/msr\n");

This will fail if we eventually implement cpu 0 hotplug...
Better readdir or similar.

> +		printf("Try \"# modprobe msr\"\n");
> +		exit(-5);

Again -5 is unusual.


> +	char msr_path[32];
> +	int retval;
> +	int fd;
> +
> +	sprintf(msr_path, "/dev/cpu/%d/msr", cpu);
> +	fd = open(msr_path, O_RDONLY);
> +	if (fd < 0) {
> +		perror(msr_path);
> +		exit(-1);

This should be a soft error because the CPU can go away
any time.


> +/*
> + * run func() on every cpu in /dev/cpu
> + */
> +void for_every_cpu(void (func)(int))
> +{
> +	FILE *fp;
> +	int cpu_count;
> +	int retval;
> +
> +	fp = fopen(proc_stat, "r");

Using /proc/stat to get the number of CPUs is unusual
and you don't handle holes in the cpu numbers which
can happen due to hotplug.

I would just readdir or fnmatch the MSR /dev/cpu/* directories.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
