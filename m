Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab1B1TT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 14:19:56 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47895 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab1B1TTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 14:19:55 -0500
Message-ID: <4D6BECA3.2020300@kernel.org>
Date: Mon, 28 Feb 2011 10:42:43 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 0/2] x86: cleanup highmap after brk is concluded
References: <alpine.DEB.2.00.1102281755270.2917@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1102281755270.2917@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D6BF54E.0035,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2011 10:24 AM, Stefano Stabellini wrote:
> Hi all,
> a little while ago I sent a patch titled "x86/mm/init: respect memblock
> reserved regions when destroying mappings"
> (https://lkml.org/lkml/2011/1/31/232) to fix a serious boot crash
> problem on Xen (full logs attached):
> 
> Pid: 0, comm: swapper Not tainted 2.6.38-rc6+ #1270 Hewlett-Packard HP xw8600 Workstation/0A98h
> RIP: e030:[<ffffffff81008314>]  [<ffffffff81008314>] get_phys_to_machine+0x44/0x50
> RSP: e02b:ffffffff82001ca0  EFLAGS: 00010002
> RAX: ffffffff824ce000 RBX: 0000000126004067 RCX: 0000000000000010
> RDX: 0000000000000000 RSI: 00000001cfdc2000 RDI: 0000000000000004
> RBP: ffffffff82001ca0 R08: 0000000000000020 R09: 0000000000000000
> R10: 0000000000000007 R11: 00000000ffffffff R12: 0000000000126004
> R13: 0000000000002004 R14: ffff880100000000 R15: ffff8801cfdc2000
> FS:  0000000000000000(0000) GS:ffffffff82162000(0000) knlGS:0000000000000000
> CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000002003000 CR4: 0000000000002660
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
> Process swapper (pid: 0, threadinfo ffffffff82000000, task ffffffff8200b020)
> Stack:
>  ffffffff82001cd0 ffffffff8100582c ffffffff81dce1bc ffffffff82001e10
>  00000001cfdc2000 ffffffff82003880 ffffffff82001ce0 ffffffff8100587e
>  ffffffff82001d98 ffffffff8100498f 00000000ffffffff 0000000000000007
> Call Trace:
>  [<ffffffff8100582c>] pte_mfn_to_pfn+0x8c/0xb0
>  [<ffffffff8100587e>] xen_pgd_val+0xe/0x10
>  [<ffffffff8100498f>] __raw_callee_save_xen_pgd_val+0x11/0x1e
>  [<ffffffff813ba570>] ? xenboot_write_console+0x0/0xd0
>  [<ffffffff821c24b8>] ? kernel_physical_mapping_init+0x83/0x1db
>  [<ffffffff8195469f>] init_memory_mapping+0x31f/0x6d0
>  [<ffffffff821989fd>] ? memblock_reserve+0x1b/0x21
>  [<ffffffff8217de95>] setup_arch+0xa59/0xd89
>  [<ffffffff819b9c90>] ? _raw_spin_unlock_irqrestore+0x20/0x30
>  [<ffffffff810074bd>] ? __raw_callee_save_xen_irq_disable+0x11/0x1e
>  [<ffffffff82177b35>] start_kernel+0xc6/0x4df
>  [<ffffffff821772c5>] x86_64_start_reservations+0xa5/0xc9
>  [<ffffffff8217b6fa>] xen_start_kernel+0x5d3/0x6a9
> 
> 
> Even though a clear solution wasn't reached in the following discussion,
> Yinghai Lu sent a patch to move cleanup_highmap() after reserve_brk() so
> that we don't have to clear the initial mappings in two steps.
> The patch is a nice cleanup and with few small changes to honour the
> variable max_pfn_mapped can be used to fix the boot issue on Xen: all we
> have to do is setting max_pfn_mapped to the last valid pfn mapped on Xen
> that is the page baking _end.
> 
> 
> The list of patches with diffstat follows, comments and suggestions are
> very welcome:
> 
> Stefano Stabellini (1):
>       xen: set max_pfn_mapped to the last pfn mapped
> 
> Yinghai Lu (1):
>       x86: Cleanup highmap after brk is concluded
> 
>  arch/x86/kernel/head64.c |    3 ---
>  arch/x86/kernel/setup.c  |    6 ++++++
>  arch/x86/mm/init.c       |   19 -------------------
>  arch/x86/mm/init_64.c    |   11 ++++++-----
>  arch/x86/xen/mmu.c       |   13 +++++++------
>  5 files changed, 19 insertions(+), 33 deletions(-)
> 
> 
> A git branch based on 2.6.38-rc6 is available here:
> 
Can you please rebase them on top of tip/x86/mm?

http://people.redhat.com/mingo/tip.git/readme.txt

Thanks

Yinghai Lu
