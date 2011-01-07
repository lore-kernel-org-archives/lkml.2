Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab1AGB1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 20:27:25 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25598 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab1AGB1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 20:27:24 -0500
Date: Thu, 6 Jan 2011 17:21:54 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [GIT PULL] x86/apic changes for v2.6.38
Message-Id: <20110106172154.edee5c66.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTimJMMC=LoD4igGCMdcFaBS9EpHVHh_x5=91_bbE@mail.gmail.com>
References: <AANLkTik7tcZo8ka80y=FD-_UxwvB6-R8iRHRq+rkOSo+@mail.gmail.com>
	<4d2654c410489a1b90@agluck-desktop.sc.intel.com>
	<AANLkTi=0cf=JGGiJ6w3nanJTN1zyLvgVt8FUzwTWp2YG@mail.gmail.com>
	<AANLkTimJMMC=LoD4igGCMdcFaBS9EpHVHh_x5=91_bbE@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011 16:17:10 -0800 Yinghai Lu wrote:

> On Thu, Jan 6, 2011 at 3:53 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Thu, Jan 6, 2011 at 3:48 PM, Luck, Tony <tony.luck@intel.com> wrote:
> >> Untested on X86.  Builds and boots on ia64 (both normally and with
> >> maxcpus=8 to limit the number of cpus).
> >>
> >> Signed-off-by: Tony Luck <tony.luck@intel.com>
> >
> > Looks much better to me, and gets rid of that silly #ifdef that I reacted to.
> >
> > But no hurry, this looks low-priority. So let's make this go through
> > the x86 tree and get merged later, after it has passed whatever normal
> > tests that the -tip tree goes through. Ok?
> 
> yes. x86 is safe. We have apicid_to_node[] array, and already check
> apic id with MAX_LOCAL_APIC
> in x86 version acpi_numa_processor_affinity_init().
> 
> looks ia64 is using struct array with cpu idx for mapping
> 
>         node_cpuid[srat_num_cpus].phys_id =
>             (pa->apic_id << 8) | (pa->local_sapic_eid);
>         /* nid should be overridden as logical node id later */
>         node_cpuid[srat_num_cpus].nid = pxm;
>         cpu_set(srat_num_cpus, early_cpu_possible_map);
>         srat_num_cpus++;
> 
> but it does not check the boundary of that array...
> 
> struct node_cpuid_s node_cpuid[NR_CPUS]..
> 
> so if some one try to boot kernel with small NR_CPUS on bigger IA64
> system, could get some variables node_cpuid[]...
> 
> Assume Tony will have another patch for IA64 to check that before
> apply this patch.
> 
> sth like
> 
> Index: linux-2.6/arch/ia64/kernel/acpi.c
> ===================================================================
> --- linux-2.6.orig/arch/ia64/kernel/acpi.c
> +++ linux-2.6/arch/ia64/kernel/acpi.c
> @@ -477,6 +479,11 @@ acpi_numa_processor_affinity_init(struct
>  	if (!(pa->flags & ACPI_SRAT_CPU_ENABLED))
>  		return;
> 
> +	if (srat_num_cpus >= NR_CPUS) {
> +		printk(KERN_WARNING "NR_CPUS (%d) is too small, not all cpus used.
> %d\n", NR_CPUS);

		                                                        CPUs used.

Don't need %d 2 times.


> +		return;
> +	}
> +
>  	pxm = get_processor_proximity_domain(pa);
> 
>  	/* record this node in proximity bitmap */


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
