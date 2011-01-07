Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1AGARP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:17:15 -0500
Received: from mail-qw0-f66.google.com ([209.85.216.66]:40548 "EHLO
	mail-qw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1AGARL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:17:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sQlGzIY4am1UdUgee+GUG/lW5eDlRm8l2YzHeckQ05rV3UC1v2mD5I6vhqWuMiD53n
         2mSBltbCed3k69MPPCJDj5abcQMXrq1ixTyz5WPmGoyZLNNIBJv4FsqsxNjXs+WSbbDE
         cJkGYGgmtPwOBZDF4CtAWLIZ3G5ykDr21Q9LU=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=0cf=JGGiJ6w3nanJTN1zyLvgVt8FUzwTWp2YG@mail.gmail.com>
References: <AANLkTik7tcZo8ka80y=FD-_UxwvB6-R8iRHRq+rkOSo+@mail.gmail.com>
	<4d2654c410489a1b90@agluck-desktop.sc.intel.com>
	<AANLkTi=0cf=JGGiJ6w3nanJTN1zyLvgVt8FUzwTWp2YG@mail.gmail.com>
Date: Thu, 6 Jan 2011 16:17:10 -0800
X-Google-Sender-Auth: BRECB1qJiJmUfo5Rnmuqk0gFTXM
Message-ID: <AANLkTimJMMC=LoD4igGCMdcFaBS9EpHVHh_x5=91_bbE@mail.gmail.com>
Subject: Re: [GIT PULL] x86/apic changes for v2.6.38
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 3:53 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jan 6, 2011 at 3:48 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> Untested on X86.  Builds and boots on ia64 (both normally and with
>> maxcpus=8 to limit the number of cpus).
>>
>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>
> Looks much better to me, and gets rid of that silly #ifdef that I reacted to.
>
> But no hurry, this looks low-priority. So let's make this go through
> the x86 tree and get merged later, after it has passed whatever normal
> tests that the -tip tree goes through. Ok?

yes. x86 is safe. We have apicid_to_node[] array, and already check
apic id with MAX_LOCAL_APIC
in x86 version acpi_numa_processor_affinity_init().

looks ia64 is using struct array with cpu idx for mapping

        node_cpuid[srat_num_cpus].phys_id =
            (pa->apic_id << 8) | (pa->local_sapic_eid);
        /* nid should be overridden as logical node id later */
        node_cpuid[srat_num_cpus].nid = pxm;
        cpu_set(srat_num_cpus, early_cpu_possible_map);
        srat_num_cpus++;

but it does not check the boundary of that array...

struct node_cpuid_s node_cpuid[NR_CPUS]..

so if some one try to boot kernel with small NR_CPUS on bigger IA64
system, could get some variables node_cpuid[]...

Assume Tony will have another patch for IA64 to check that before
apply this patch.

sth like

Index: linux-2.6/arch/ia64/kernel/acpi.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/acpi.c
+++ linux-2.6/arch/ia64/kernel/acpi.c
@@ -477,6 +479,11 @@ acpi_numa_processor_affinity_init(struct
 	if (!(pa->flags & ACPI_SRAT_CPU_ENABLED))
 		return;

+	if (srat_num_cpus >= NR_CPUS) {
+		printk(KERN_WARNING "NR_CPUS (%d) is too small, not all cpus used.
%d\n", NR_CPUS);
+		return;
+	}
+
 	pxm = get_processor_proximity_domain(pa);

 	/* record this node in proximity bitmap */


Thanks

Yinghai
