Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab2HUPGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:06:48 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42950 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab2HUPGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:06:44 -0400
Date: Tue, 21 Aug 2012 10:53:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Attilio Rao <attilio.rao@citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH 0/5] X86/XEN: Merge x86_init.paging.pagetable_setup_start
 and x86_init.paging.pagetable_setup_done PVOPS and document the semantic
Message-ID: <20120821145307.GE20289@phenom.dumpdata.com>
References: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 02:14:01AM +0100, Attilio Rao wrote:
> Currently the definition of x86_init.paging.pagetable_setup_start and
> x86_init.paging.pagetable_setup_done is twisted and not really well
> defined (in terms of prototypes desired). More specifically:
> pagetable_setup_start:
>  * it is a nop on x86_32
>  * it is a nop for the XEN case
>  * cleans up the boot time page table in the x86_64 case

Is it safe to call that 'boot time page table' in Xen case?
Since that is what it would be doing? Did you test it with dom0 and
PV guest and with 2GB, 3GB, 4GB, and 8GB layouts? I think those were
the ones that caught earlier mistakes.
> 
> pagetable_setup_done:
>  * it is a nop on x86_32
>  * sets up accessor functions for pagetable manipulation, for the
>    XEN case
>  * it is a nop on x86_64
> 
> Most of this logic can be skipped by creating a new PVOPS that can handle
> pagetable setup and pre/post operations on it.
> The new PVOPS must be called only once, during boot-time setup and
> after the direct mapping for physical memory is available.

Looks like you are missing the other crucial bit of information:
It removes two of the pvops and replaces them with just one.

> 
> Attilio Rao (5):
>   XEN: Remove the base argument from
>     x86_init.paging.pagetable_setup_done PVOPS
>   XEN: Remove the base argument from
>     x86_init.paging.pagetable_setup_start PVOPS
>   X86/XEN: Introduce the x86_init.paging.pagetable_init() PVOPS
>   X86/XEN: Retire now unused x86_init.paging.pagetable_setup_start and
>     x86_init.paging.pagetable_setup_done PVOPS
>   X86/XEN: Add few lines explaining simple semantic for
>     x86_init.paging.pagetable_init PVOPS
> 
>  arch/x86/include/asm/pgtable_types.h |    6 ++----
>  arch/x86/include/asm/x86_init.h      |   11 +++++++----
>  arch/x86/kernel/setup.c              |    4 +---
>  arch/x86/kernel/x86_init.c           |    4 +---
>  arch/x86/mm/init_32.c                |   12 ++++++------
>  arch/x86/xen/mmu.c                   |   18 +++++++-----------
>  6 files changed, 24 insertions(+), 31 deletions(-)
> 
> -- 
> 1.7.2.5
