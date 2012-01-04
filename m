Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab2ADK5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 05:57:35 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:43873 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2ADK5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 05:57:30 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <4F017AD2.3090504@redhat.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <20111230095147.GA10543@elte.hu> <878vlu4bgh.fsf@linux.vnet.ibm.com> <87pqf5mqg4.fsf@abhimanyu.in.ibm.com> <4F017AD2.3090504@redhat.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Wed, 04 Jan 2012 16:22:54 +0530
Message-ID: <87mxa3zqm1.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12010400-6102-0000-0000-0000009318A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jan 2012 11:37:22 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 12/31/2011 04:21 AM, Nikunj A Dadhania wrote:
> >
> >     GangV2:
> >     27.45%       ebizzy  libc-2.12.so            [.] __memcpy_ssse3_back
> >     12.12%       ebizzy  [kernel.kallsyms]       [k] clear_page
> >      9.22%       ebizzy  [kernel.kallsyms]       [k] __do_page_fault
> >      6.91%       ebizzy  [kernel.kallsyms]       [k] flush_tlb_others_ipi
> >      4.06%       ebizzy  [kernel.kallsyms]       [k] get_page_from_freelist
> >      4.04%       ebizzy  [kernel.kallsyms]       [k] ____pagevec_lru_add
> >
> >     GangBase:
> >     45.08%       ebizzy  [kernel.kallsyms]       [k] flush_tlb_others_ipi
> >     15.38%       ebizzy  libc-2.12.so            [.] __memcpy_ssse3_back
> >      7.00%       ebizzy  [kernel.kallsyms]       [k] clear_page
> >      4.88%       ebizzy  [kernel.kallsyms]       [k] __do_page_fault
> 
> Looping in flush_tlb_others().  Rik, what trace an we run to find out
> why PLE directed yield isn't working as expected?
> 
I tried some experiments by adding a pause_loop_exits stat in the
kvm_vpu_stat.

Here are some observation related to Baseline-only(8vm case)

              | ple_gap=128 | ple_gap=64 | ple_gap=256 | ple_window=2048
--------------+-------------+------------+-------------+----------------
EbzyRecords/s |    2247.50  |    2132.75 |    2086.25  |      1835.62
PauseExits    | 7928154.00  | 6696342.00 | 7365999.00  |  50319582.00

With ple_window = 2048, PauseExits is more than 6times the default case

-----

    From: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>

    Add Pause-loop-exit stats to kvm_vcpu_stat

    Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>


diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b4973f4..be2e7f2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -539,6 +539,7 @@ struct kvm_vcpu_stat {
        u32 hypercalls;
        u32 irq_injections;
        u32 nmi_injections;
+       u32 pause_loop_exits;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 579a0b5..29e90b7 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4897,6 +4897,8 @@ out:
 static int handle_pause(struct kvm_vcpu *vcpu)
 {
        skip_emulated_instruction(vcpu);
+       ++vcpu->stat.pause_loop_exits;
        kvm_vcpu_on_spin(vcpu);
 
        return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c38efd7..87433a8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -149,6 +149,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
        { "mmu_unsync", VM_STAT(mmu_unsync) },
        { "remote_tlb_flush", VM_STAT(remote_tlb_flush) },
        { "largepages", VM_STAT(lpages) },
+       { "pause_loop_exits", VCPU_STAT(pause_loop_exits) },
        { NULL }
 };

