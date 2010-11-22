Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab0KVUNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 15:13:48 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:47836 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab0KVUNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 15:13:45 -0500
Date: Mon, 22 Nov 2010 15:13:24 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Andi Kleen <andi@firstfloor.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH RESEND] tools: add power/x86/x86_energy_perf_policy to
 program MSR_IA32_ENERGY_PERF_BIAS
In-reply-to: <8739r0rxlz.fsf@basil.nowhere.org>
Message-id: <alpine.LFD.2.00.1011221348200.19247@x980>
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
 <alpine.LFD.2.00.1009281143070.14962@localhost.localdomain>
 <alpine.LFD.2.00.1010230035360.29399@localhost.localdomain>
 <alpine.LFD.2.00.1011151103280.2939@x980> <8739r0rxlz.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

Thank you for the review!

responses below.

> > +install :
> > +	install x86_energy_perf_policy /usr/bin/x86_energy_perf_policy
> 
> It's not clear to me how this Makefile ensures it's only
> build on x86. 
> 
> If someone on another architecture does a full tools build
> in the future (I think that is not wired up yet, but should
> eventually) such a mechanism would be needed.

Per the comments from Andrew and others, the concept of a
"full tools build" doesn't actually exit (yet).

So I guess the only assurance that somebody not on x86 would run
make in this directory this utility lives in tools/power/x86/

Note that there are other utilities under tools
which have no Makefile at all...

> ...I would prefer a manpage

I'll be happy to write a manpage.
Is there good example I should follow?

> > +cmdline(int argc, char **argv) {
> 
> No type?

okay,  now void.

> > +	while ((opt = getopt(argc, argv, "+rvc:")) != -1) {
> 
> Maybe it's me, but I prefer having long options too (getopt_long)
> These are easier to memorize.

I'm not inclined to bother, as the use-case for this utility
is to be invoked by another program, and the options available
are really there just for verification/debugging, and don't
really merit being memorized by a human after that task.

> An obvious improvement would be to put the exit() into usage()

done.

> > +			new_bias = atoll(argv[optind]);
> 
> If you used strtoull() you could actually check if the input
> is really a number (end == argv[optind])

done.

> > +	asm("cpuid" : "=a" (max_level), "=b" (ebx), "=c" (ecx),
> > +		"=d" (edx) : "a" (0));
> 
> Strictly for 386/early 486 you would need to check if cpuid
> is available using pushf too. Perhaps it's safer to use cpuinfo

Meh, maybe simpler to crash on 486 and earlier?:-)
I'm not fond of parsing /proc/cpuinfo.

> > +check_dev_msr() {
> 
> Return type missing again

routine deleted.

> > +	struct stat sb;
> > +
> > +	if (stat("/dev/cpu/0/msr", &sb)) {
> > +		printf("no /dev/cpu/0/msr\n");
> 
> This will fail if we eventually implement cpu 0 hotplug...
> Better readdir or similar.

simpler to delete check_dev_msr() and stumble forward
assuming /dev/cpu/*/msr exists, and print a message and
exit if it doesn't.

> > +		printf("Try \"# modprobe msr\"\n");
> > +		exit(-5);
> 
> Again -5 is unusual.

okay, I canged all the exits to 1.

> > +	sprintf(msr_path, "/dev/cpu/%d/msr", cpu);
> > +	fd = open(msr_path, O_RDONLY);
> > +	if (fd < 0) {
> > +		perror(msr_path);
> > +		exit(-1);
> 
> This should be a soft error because the CPU can go away
> any time.

In the highly unlikely scenario that somebody uses
the -r option to excerise the read-only code,
and simultaneously invokes and completes a cpu hot remove
during the execution of this utility,
I think the utility exiting is just as useful,
and less complicated, than handling soft error.
Since in either case, the user would probably
simply re-invoke the utility to see what the
current state of the settled machine is.

> > +/*
> > + * run func() on every cpu in /dev/cpu
> > + */
...
> > +	fp = fopen(proc_stat, "r");
> 
> Using /proc/stat to get the number of CPUs is unusual
> and you don't handle holes in the cpu numbers which
> can happen due to hotplug.

The code does handle holes in cpu number namespace.

The "num_cpus" variable was a hold-over from
an older version that did not, and so I've deleted it.

> I would just readdir or fnmatch the MSR /dev/cpu/* directories.

I used to do that, but Arjan convinced me to use /proc/stat.
turbostat, rdmsr, and wrmsr all use /proc/stat.

thanks,
-Len Brown, Intel Open Source Technology Center




