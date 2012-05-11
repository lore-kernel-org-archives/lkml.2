Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab2EKHT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 03:19:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:44560 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab2EKHT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 03:19:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151718841"
Message-ID: <4FACBD9B.8070407@linux.intel.com>
Date: Fri, 11 May 2012 15:19:55 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] x86/mce: Only restart instruction after machine check
 recovery if it is safe
References: <cover.1336674796.git.tony.luck@intel.com> <e6fa674d2f4ded80201f733d06b234b21559f0fe.1336674796.git.tony.luck@intel.com>
In-Reply-To: <e6fa674d2f4ded80201f733d06b234b21559f0fe.1336674796.git.tony.luck@intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/5/11 2:01, Tony Luck 写道:
> Section 15.3.1.2 of the software developer manual has this to say
> about the RIPV bit in the IA32_MCG_STATUS register:
> 
> RIPV (restart IP valid) flag, bit 0 — Indicates (when set) that
> program execution can be restarted reliably at the instruction
> pointed to by the instruction pointer pushed on the stack when the
> machine-check exception is generated.  When clear, the program
> cannot be reliably restarted at the pushed instruction pointer.
> 
> We need to save the state of this bit in do_machine_check() and use
> it in mce_notify_process() to force a signal; even if
> memory_failure() says it made a complete recovery ... e.g. replaced
> a clean LRU page).
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com> --- 
> arch/x86/kernel/cpu/mcheck/mce.c |    9 ++++++--- 1 files changed,
> 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c
> b/arch/x86/kernel/cpu/mcheck/mce.c index 66e1c51..3b8ebdc 100644 
> --- a/arch/x86/kernel/cpu/mcheck/mce.c +++
> b/arch/x86/kernel/cpu/mcheck/mce.c @@ -947,9 +947,10 @@ struct
> mce_info { atomic_t		inuse; struct task_struct	*t; __u64			paddr; +
> int			restartable; } mce_info[MCE_INFO_MAX];
> 
> -static void mce_save_info(__u64 addr) +static void
> mce_save_info(__u64 addr, int c) { struct mce_info *mi;
> 
> @@ -957,6 +958,7 @@ static void mce_save_info(__u64 addr) if
> (atomic_cmpxchg(&mi->inuse, 0, 1) == 0) { mi->t = current; 
> mi->paddr = addr; +			mi->restartable = c; return; } } @@ -1136,7
> +1138,7 @@ void do_machine_check(struct pt_regs *regs, long
> error_code) mce_panic("Fatal machine check on current CPU", &m,
> msg); if (worst == MCE_AR_SEVERITY) { /* schedule action before
> return to userland */ -			mce_save_info(m.addr); +
> mce_save_info(m.addr, m.mcgstatus & MCG_STATUS_RIPV); 
> set_thread_flag(TIF_MCE_NOTIFY); } else if (kill_it) { 
> force_sig(SIGBUS, current); @@ -1185,7 +1187,8 @@ void
> mce_notify_process(void)
> 
> pr_err("Uncorrected hardware memory error in user-access at %llx", 
> mi->paddr); -	if (memory_failure(pfn, MCE_VECTOR,
> MF_ACTION_REQUIRED) < 0) { +	if (memory_failure(pfn, MCE_VECTOR,
> MF_ACTION_REQUIRED) < 0 || +			   mi->restartable == 0) { 
> pr_err("Memory error not recovered"); force_sig(SIGBUS, current); 
> }

How about using following condition to decrease the execution time?
if (mi->restartable == 0 ||
    memory_failure(pfn, MCE_VECTOR, MF_ACTION_REQUIRED) < 0)

Since restart operation is impossible, whether recovery operation can
be avoided?
