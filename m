Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2GRSvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 14:51:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35950 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab2GRSvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 14:51:11 -0400
MIME-Version: 1.0
In-Reply-To: <1340402778-28939-1-git-send-email-msb@chromium.org>
References: <1340402778-28939-1-git-send-email-msb@chromium.org>
Date: Wed, 18 Jul 2012 11:51:09 -0700
X-Google-Sender-Auth: t3FipOACQ5TIsxyFBI1WQvFBLC8
Message-ID: <CACBanvprYt0-W0GPpxKxm-VeFpQN+XkD2YvoTs-qCKHDjiWXMw@mail.gmail.com>
Subject: Re: [PATCH v2] x86, mm: only wait for flushes from online cpus
From: Mandeep Singh Baines <msb@chromium.org>
To: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Shaohua Li <shaohua.li@intel.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Christoph Lameter <cl@gentwo.org>, Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 3:06 PM, Mandeep Singh Baines <msb@chromium.org> wrote:
> A cpu in the mm_cpumask could go offline before we send the invalidate
> IPI causing us to wait forever. Avoid this by only waiting for online
> cpus.
>
> We are seeing a softlockup reporting during shutdown. The stack
> trace shows us that we are inside default_send_IPI_mask_logical:
>

I can confirm that after making this change, we no longer see this crash.

>  BUG: soft lockup - CPU#0 stuck for 11s! [lmt-udev:23605]
>  Pid: 23605, comm: lmt-udev Tainted: G        WC   3.2.7 #1
>  EIP: 0060:[<8101eec6>] EFLAGS: 00000202 CPU: 0
>  EIP is at flush_tlb_others_ipi+0x8a/0xba
>  Call Trace:
>   [<8101f0bb>] flush_tlb_mm+0x5e/0x62
>   [<8101e36c>] pud_populate+0x2c/0x31
>   [<8101e409>] pgd_alloc+0x98/0xc7
>   [<8102c881>] mm_init.isra.38+0xcc/0xf3
>   [<8102cbc2>] dup_mm+0x68/0x34e
>   [<8139bbae>] ? _cond_resched+0xd/0x21
>   [<810a5b7c>] ? kmem_cache_alloc+0x26/0xe2
>   [<8102d421>] ? copy_process+0x556/0xda6
>   [<8102d641>] copy_process+0x776/0xda6
>   [<8102dd5e>] do_fork+0xcb/0x1d4
>   [<810a8c96>] ? do_sync_write+0xd3/0xd3
>   [<810a94ab>] ? vfs_read+0x95/0xa2
>   [<81008850>] sys_clone+0x20/0x25
>   [<8139d8c5>] ptregs_clone+0x15/0x30
>   [<8139d7f7>] ? sysenter_do_call+0x12/0x26
>
> Before the softlock, we see the following kernel warning:
>
>  WARNING: at ../../arch/x86/kernel/apic/ipi.c:113 default_send_IPI_mask_logical+0x58/0x73()
>  Pid: 23605, comm: lmt-udev Tainted: G         C   3.2.7 #1
>  Call Trace:
>   [<8102e666>] warn_slowpath_common+0x68/0x7d
>   [<81016c36>] ? default_send_IPI_mask_logical+0x58/0x73
>   [<8102e68f>] warn_slowpath_null+0x14/0x18
>   [<81016c36>] default_send_IPI_mask_logical+0x58/0x73
>   [<8101eec2>] flush_tlb_others_ipi+0x86/0xba
>   [<8101f0bb>] flush_tlb_mm+0x5e/0x62
>   [<8101e36c>] pud_populate+0x2c/0x31
>   [<8101e409>] pgd_alloc+0x98/0xc7
>   [<8102c881>] mm_init.isra.38+0xcc/0xf3
>   [<8102cbc2>] dup_mm+0x68/0x34e
>   [<8139bbae>] ? _cond_resched+0xd/0x21
>   [<810a5b7c>] ? kmem_cache_alloc+0x26/0xe2
>   [<8102d421>] ? copy_process+0x556/0xda6
>   [<8102d641>] copy_process+0x776/0xda6
>   [<8102dd5e>] do_fork+0xcb/0x1d4
>   [<810a8c96>] ? do_sync_write+0xd3/0xd3
>   [<810a94ab>] ? vfs_read+0x95/0xa2
>   [<81008850>] sys_clone+0x20/0x25
>   [<8139d8c5>] ptregs_clone+0x15/0x30
>   [<8139d7f7>] ? sysenter_do_call+0x12/0x26
>
> So we are sending an IPI to a cpu which is now offline. Once a cpu is offline,
> it will no longer respond to IPIs. This explains the softlockup.
>
> Addresses http://crosbug.com/31737
>
> Changes in V2:
>   * bitmap_and is not atomic so use a temporary bitmask
>
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Christoph Lameter <cl@gentwo.org>
> Cc: Olof Johansson <olofj@chromium.org>
> ---
>  arch/x86/mm/tlb.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> index d6c0418..231a0b9 100644
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -185,6 +185,8 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
>         f->flush_mm = mm;
>         f->flush_va = va;
>         if (cpumask_andnot(to_cpumask(f->flush_cpumask), cpumask, cpumask_of(smp_processor_id()))) {
> +               DECLARE_BITMAP(tmp_cpumask, NR_CPUS);
> +
>                 /*
>                  * We have to send the IPI only to
>                  * CPUs affected.
> @@ -192,8 +194,13 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
>                 apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
>                               INVALIDATE_TLB_VECTOR_START + sender);
>
> -               while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
> +               /* Only wait for online cpus */
> +               do {
> +                       cpumask_and(to_cpumask(tmp_cpumask),
> +                                   to_cpumask(f->flush_cpumask),
> +                                   cpu_online_mask);
>                         cpu_relax();
> +               } while (!cpumask_empty(to_cpumask(tmp_cpumask)));
>         }
>
>         f->flush_mm = NULL;
> --
> 1.7.7.3
>
