Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab1ASAlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 19:41:19 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60952 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab1ASAlR (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 18 Jan 2011 19:41:17 -0500
Date: Tue, 18 Jan 2011 19:39:08 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Greg KH <greg@kroah.com>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86-32: Separate 1:1 pagetables from swapper_pg_dir
Message-ID: <20110119003908.GB7609@dumpdata.com>
References: <20101022162038.GA10343@kroah.com>
 <1289483775-17632-2-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289483775-17632-2-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 02:56:13PM +0100, Joerg Roedel wrote:
> This patch fixes machine crashes which occur when heavily exercising the
> CPU hotplug codepaths on a 32-bit kernel. These crashes are caused by
> AMD Erratum 383 and result in a fatal machine check exception. Here's
> the scenario:
> 
> 1. On 32-bit, the swapper_pg_dir page table is used as the initial page
> table for booting a secondary CPU.
> 
> 2. To make this work, swapper_pg_dir needs a direct mapping of physical
> memory in it (the low mappings). By adding those low, large page (2M)
> mappings (PAE kernel), we create the necessary conditions for Erratum
> 383 to occur.
> 
> 3. Other CPUs which do not participate in the off- and onlining game may
> use swapper_pg_dir while the low mappings are present (when leave_mm is
> called). For all steps below, the CPU referred to is a CPU that is using
> swapper_pg_dir, and not the CPU which is being onlined.
> 
> 4. The presence of the low mappings in swapper_pg_dir can result
> in TLB entries for addresses below __PAGE_OFFSET to be established
> speculatively. These TLB entries are marked global and large.
> 
> 5. When the CPU with such TLB entry switches to another page table, this
> TLB entry remains because it is global.
> 
> 6. The process then generates an access to an address covered by the
> above TLB entry but there is a permission mismatch - the TLB entry
> covers a large global page not accessible to userspace.
> 
> 7. Due to this permission mismatch a new 4kb, user TLB entry gets
> established. Further, Erratum 383 provides for a small window of time
> where both TLB entries are present. This results in an uncorrectable
> machine check exception signalling a TLB multimatch which panics the
> machine.
> 
> There are two ways to fix this issue:
> 
>         1. Always do a global TLB flush when a new cr3 is loaded and the
>         old page table was swapper_pg_dir. I consider this a hack hard
>         to understand and with performance implications
> 
>         2. Do not use swapper_pg_dir to boot secondary CPUs like 64-bit
>         does.
> 
> This patch implements solution 2. It introduces a trampoline_pg_dir
> which has the same layout as swapper_pg_dir with low_mappings. This page
> table is used as the initial page table of the booting CPU. Later in the
> bringup process, it switches to swapper_pg_dir and does a global TLB
> flush. This fixes the crashes in our test cases.
> 
> -v2: switch to swapper_pg_dir right after entering start_secondary() so
> that we are able to access percpu data which might not be mapped in the
> trampoline page table.

You also might want to look at the regression this patch caused when it
was introduced. Mainly this fix:
805e3f495057aa5307ad4e3d6dc7073d4733c691
