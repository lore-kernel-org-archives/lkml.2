Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab2IRTul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 15:50:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab2IRTuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 15:50:40 -0400
Date: Tue, 18 Sep 2012 12:50:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: section mismatch for acpi_unmap_lsapic()
Message-Id: <20120918125038.110b8716.akpm@linux-foundation.org>
In-Reply-To: <5057D123.7040109@cn.fujitsu.com>
References: <20120914163809.GA6854@cantor.us.oracle.com>
	<20120917110729.GA1018@gmail.com>
	<5057D123.7040109@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2012 09:40:51 +0800
Wen Congyang <wency@cn.fujitsu.com> wrote:

> At 09/17/2012 07:07 PM, Ingo Molnar Wrote:
> > 
> > * Jerry Snitselaar <dev@snitselaar.org> wrote:
> > 
> >> Commit 13ad20c1 "x86 cpu_hotplug: unmap cpu2node when the cpu is
> >> hotremoved" in linux-next added code to acpi_unmap_lsapic() that
> >> causes section mismatch warnings:
> >>
> >> WARNING: vmlinux.o(.text+0x694f2): Section mismatch in reference from the function acpi_unmap_lsapic()
> >> 	  to the function .cpuinit.text:numa_clear_node()
> >> WARNING: vmlinux.o(.text+0x694eb): Section mismatch in reference from the function acpi_unmap_lsapic() 
> >> 	  to the variable .cpuinit.data:__apicid_to_node
> >>
> >>
> >> Does acpi_unmap_lsapic() need a wrapper like the one that was made for
> >> acpi_map_lsapic() or can it just be annotated __ref ? I guess my
> >> question is would be there be a reason that the wrapper was created
> >> for acpi_map_lsapic() instead of just annotating __ref besides
> >> allowing the code for _apic_map_lsapic() to be dropped when
> >> HOTPLUG_CPU wasn't configured?
> > 
> > That commit comes from -mm AFAICS. Involved parties Cc:-ed.
> 
> Sorry for introducing this warning. numa_clear_node() is in cpuinit
> section, and it will be called in acpi_unmap_lsapic(), so I agree
> to add __ref to this function. Should I need to post another patch
> to fix it or just update the patch?

Either a new patch or a fixup is OK for me (I'll turn a new patch into
a fixup so I and others can see what changed).

People who run git trees prefer fixup patches due to extensive lameness.

I did this:

--- a/arch/x86/kernel/acpi/boot.c~cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix
+++ a/arch/x86/kernel/acpi/boot.c
@@ -689,7 +689,7 @@ int __ref acpi_map_lsapic(acpi_handle ha
 }
 EXPORT_SYMBOL(acpi_map_lsapic);
 
-int acpi_unmap_lsapic(int cpu)
+int __ref acpi_unmap_lsapic(int cpu)
 {
 #ifdef CONFIG_ACPI_NUMA
 	set_apicid_to_node(per_cpu(x86_cpu_to_apicid, cpu), NUMA_NO_NODE);
_

