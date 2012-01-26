Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2AZBcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 20:32:20 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:56493 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab2AZBcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 20:32:18 -0500
X-Nat-Received: from [202.181.97.72]:56107 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1327541522.15982
Message-Id: <201201260132.q0Q1W1sZ096210@www262.sakura.ne.jp>
Subject: Re: [PATCH v4] kmod: Avoid deadlock by recursive kmod call.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: akpm@linux-foundation.org
Cc: arjan@linux.intel.com, richard@nod.at, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 26 Jan 2012 10:32:01 +0900
References: <201112270701.pBR713wO005588@www262.sakura.ne.jp> <201201040743.q047h9OD055670@www262.sakura.ne.jp> <201201042208.JHG52695.OLStHFQOFFMVJO@I-love.SAKURA.ne.jp> <201201062139.JFC73472.SMQFOFOFHLVOtJ@I-love.SAKURA.ne.jp> <20120118164558.a10d7821.akpm@linux-foundation.org> <201201190207.q0J27Mr5099912@www262.sakura.ne.jp> <201201240432.q0O4WeMu031016@www262.sakura.ne.jp> <20120125164059.05a3bf39.akpm@linux-foundation.org>
In-Reply-To: <20120125164059.05a3bf39.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 25012012 #6702123, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> > Since __call_usermodehelper() is exclusively called (am I right?), we don't
> > need to use per "struct task_struct" flag.
> 
> The locking for the new kmod_thread_locker global is quite unobvious. 
> From a quick look I can't say that I obviously agree with the above
> claim.

Should we use semaphore in order to utilize lockdep?

> 
> Maybe it relies upon there only ever being a single khelper thread,
> system wide?

Yes. This patch relies on khelper being singlethreaded.

   khelper_wq = create_singlethread_workqueue("khelper");

Below output (taken without this patch) shows that __call_usermodehelper() is
called with khelper lock held.

[   95.333533] INFO: task kworker/u:0:5 blocked for more than 20 seconds.
[   95.342879] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[   95.493057] kworker/u:0     D 67af850a  6084     5      2 0x00000000
[   95.570863]  f61a1d1c 00000046 00000000 67af850a 0000011c 0000019a 00000000 f61a1ca8
[   95.585696]  c1070315 f619e120 f62e8560 00000003 00000002 f619e5d0 00000330 00000000
[   95.669557]  b194689f c174b8e0 f23ffd78 00000000 f6b458e0 f6b458e0 f619e120 0000019a
[   95.752002] Call Trace:
[   95.823457]  [<c1070315>] ? validate_chain+0x3d5/0x520
[   95.830678]  [<c1070315>] ? validate_chain+0x3d5/0x520
[   95.906497]  [<c139efa5>] schedule+0x55/0x60
[   95.980630]  [<c139f6ec>] schedule_timeout+0x19c/0x1b0
[   96.059353]  [<c106d833>] ? lock_release_holdtime+0x73/0xb0
[   96.134561]  [<c1071082>] ? mark_held_locks+0x92/0xf0
[   96.141343]  [<c13a17a2>] ? _raw_spin_unlock_irq+0x22/0x30
[   96.217468]  [<c1071220>] ? trace_hardirqs_on_caller+0x90/0x100
[   96.293072]  [<c107129b>] ? trace_hardirqs_on+0xb/0x10
[   96.369510]  [<c139f094>] wait_for_common+0xe4/0x120
[   96.443832]  [<c1038fd0>] ? put_prev_task+0x40/0x40
[   96.450638]  [<c1071220>] ? trace_hardirqs_on_caller+0x90/0x100
[   96.526705]  [<c1038fd0>] ? put_prev_task+0x40/0x40
[   96.601386]  [<c1037f56>] ? wake_up_new_task+0xe6/0x1c0
[   96.680872]  [<c139f0e2>] wait_for_completion+0x12/0x20
[   96.755649]  [<c103f429>] do_fork+0x169/0x250
[   96.761904]  [<c139efce>] ? wait_for_common+0x1e/0x120
[   96.851797]  [<c100a488>] kernel_thread+0x88/0xa0
[   96.925236]  [<c1054310>] ? __request_module+0x130/0x130
[   96.935826]  [<c1054310>] ? __request_module+0x130/0x130
[   97.013681]  [<c13a2db4>] ? common_interrupt+0x34/0x34
[   97.086563]  [<c1054558>] __call_usermodehelper+0x28/0x90
[   97.152805]  [<c1056099>] process_one_work+0x149/0x3b0
[   97.158095]  [<c1056028>] ? process_one_work+0xd8/0x3b0
[   97.217462]  [<c1074149>] ? __lock_acquired+0x119/0x1c0
[   97.278057]  [<c1054530>] ? wait_for_helper+0xa0/0xa0
[   97.283217]  [<c105635c>] ? worker_thread+0x1c/0x200
[   97.342278]  [<c10563e6>] worker_thread+0xa6/0x200
[   97.347193]  [<c105b8c5>] kthread+0x75/0x80
[   97.405213]  [<c1056340>] ? process_scheduled_works+0x40/0x40
[   97.463717]  [<c105b850>] ? kthread_data+0x20/0x20
[   97.468829]  [<c13a2dba>] kernel_thread_helper+0x6/0xd
[   97.528077] 2 locks held by kworker/u:0/5:
[   97.532442]  #0:  (khelper){.+.+.+}, at: [<c1056028>] process_one_work+0xd8/0x3b0
[   97.593214]  #1:  ((&sub_info->work)){+.+.+.}, at: [<c1056028>] process_one_work+0xd8/0x3b0
[   97.656084] INFO: task modprobe:1158 blocked for more than 20 seconds.
[   97.716441] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[   97.778390] modprobe        D 0000011c  6088  1158      1 0x00000000
[   97.838302]  f1c13d68 00000046 67abe0ee 0000011c 0000019a 00000000 34dfa000 c16074e0
[   97.850432]  000002dc f3fd25a0 f62142a0 00000000 67abe8f0 0000011c 0000019a 00000000
[   97.913373]  34dfa000 c174b8e0 f63edd78 00000000 f65458e0 f65458e0 f3fd25a0 0000019a
[   97.976795] Call Trace:
[   97.979423]  [<c1070315>] ? validate_chain+0x3d5/0x520
[   98.038568]  [<c139efa5>] schedule+0x55/0x60
[   98.095457]  [<c139f6ec>] schedule_timeout+0x19c/0x1b0
[   98.100976]  [<c106d833>] ? lock_release_holdtime+0x73/0xb0
[   98.159662]  [<c139f08d>] ? wait_for_common+0xdd/0x120
[   98.164966]  [<c13a17a2>] ? _raw_spin_unlock_irq+0x22/0x30
[   98.223160]  [<c1071220>] ? trace_hardirqs_on_caller+0x90/0x100
[   98.283620]  [<c107129b>] ? trace_hardirqs_on+0xb/0x10
[   98.289086]  [<c139f094>] wait_for_common+0xe4/0x120
[   98.342483]  [<c1038fd0>] ? put_prev_task+0x40/0x40
[   98.346653]  [<c1038fd0>] ? put_prev_task+0x40/0x40
[   98.394918]  [<c1055389>] ? queue_work_on+0x39/0x40
[   98.399412]  [<c139f0e2>] wait_for_completion+0x12/0x20
[   98.447573]  [<c1054838>] call_usermodehelper_exec+0x88/0x90
[   98.452396]  [<c1070101>] ? validate_chain+0x1c1/0x520
[   98.501567]  [<c139efce>] ? wait_for_common+0x1e/0x120
[   98.506082]  [<c105475f>] ? call_usermodehelper_setup+0x5f/0x90
[   98.554976]  [<c11b91d8>] kobject_uevent_env+0x3d8/0x490
[   98.559546]  [<c11b8d70>] ? kobject_action_type+0x90/0x90
[   98.608237]  [<c11b929a>] kobject_uevent+0xa/0x10
[   98.612311]  [<c107e3c8>] mod_sysfs_setup+0x88/0xc0
[   98.660562]  [<c107ff6d>] load_module+0x1ad/0x240
[   98.664596]  [<c1080051>] sys_init_module+0x41/0x1c0
[   98.715885]  [<c1071220>] ? trace_hardirqs_on_caller+0x90/0x100
[   98.764376]  [<c11c21e4>] ? trace_hardirqs_on_thunk+0xc/0x10
[   98.769215]  [<c13a2049>] syscall_call+0x7/0xb
[   98.817009] no locks held by modprobe/1158.
[   98.820564] INFO: task kworker/u:0:1159 blocked for more than 20 seconds.
[   98.870372] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[   98.877038] kworker/u:0     D 0000011c  6644  1159      5 0x00000000
[   98.926711]  f22a1cf4 00000046 c18cf200 0000011c 0000019a 00000000 34dfa000 c16074e0
[   98.970856]  00000000 f38b08e0 c15557e0 00000000 f38b0908 00000001 f38b0d40 f22a1c88
[   98.977575]  c106febb c174b8e0 f63edd78 00000000 f65458e0 f65458e0 f38b08e0 00000001
[   99.022205] Call Trace:
[   99.024099]  [<c106febb>] ? check_prevs_add+0xab/0x100
[   99.065494]  [<c10701e7>] ? validate_chain+0x2a7/0x520
[   99.069244]  [<c139efa5>] schedule+0x55/0x60
[   99.072374]  [<c139f6ec>] schedule_timeout+0x19c/0x1b0
[   99.113619]  [<c106d833>] ? lock_release_holdtime+0x73/0xb0
[   99.117657]  [<c1071082>] ? mark_held_locks+0x92/0xf0
[   99.159953]  [<c13a17a2>] ? _raw_spin_unlock_irq+0x22/0x30
[   99.163931]  [<c1071220>] ? trace_hardirqs_on_caller+0x90/0x100
[   99.168162]  [<c107129b>] ? trace_hardirqs_on+0xb/0x10
[   99.209277]  [<c139f094>] wait_for_common+0xe4/0x120
[   99.212890]  [<c1038fd0>] ? put_prev_task+0x40/0x40
[   99.253976]  [<c1038fd0>] ? put_prev_task+0x40/0x40
[   99.257568]  [<c1055389>] ? queue_work_on+0x39/0x40
[   99.261105]  [<c139f0e2>] wait_for_completion+0x12/0x20
[   99.302652]  [<c1054838>] call_usermodehelper_exec+0x88/0x90
[   99.306783]  [<c1070101>] ? validate_chain+0x1c1/0x520
[   99.348505]  [<c139efce>] ? wait_for_common+0x1e/0x120
[   99.353139]  [<c105475f>] ? call_usermodehelper_setup+0x5f/0x90
[   99.395366]  [<c10542c2>] __request_module+0xe2/0x130
[   99.400335]  [<c10dabc8>] ? search_binary_handler+0x158/0x2a0
[   99.442201]  [<c10738b7>] ? __lock_release+0x47/0x70
[   99.445882]  [<c10dabc8>] ? search_binary_handler+0x158/0x2a0
[   99.449998]  [<c11151c0>] ? randomize_stack_top+0x50/0x50
[   99.753876]  [<c11151c0>] ? randomize_stack_top+0x50/0x50
[   99.757523]  [<c10dac64>] search_binary_handler+0x1f4/0x2a0
[   99.794255]  [<c10daaae>] ? search_binary_handler+0x3e/0x2a0
[   99.797829]  [<c10daeab>] do_execve_common+0x19b/0x270
[   99.801079]  [<c10daf94>] do_execve+0x14/0x20
[   99.837998]  [<c100a4e2>] sys_execve+0x42/0x60
[   99.840850]  [<c13a2903>] ptregs_execve+0x13/0x18
[   99.843811]  [<c13a2049>] ? syscall_call+0x7/0xb
[   99.879826]  [<c1007182>] ? kernel_execve+0x22/0x40
[   99.883203]  [<c105444a>] ? ____call_usermodehelper+0x13a/0x160
[   99.887070]  [<c1054310>] ? __request_module+0x130/0x130
[   99.923601]  [<c13a2dba>] ? kernel_thread_helper+0x6/0xd
[   99.926983] 1 lock held by kworker/u:0/1159:
[   99.929732]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<c10da618>] prepare_bprm_creds+0x28/0x70

If khelper becomes multithreaded, this patch will become unnecessary.

>               If so then, err, maybe this is OK.  But I think the
> analysis should be fully spelled out in the changelog and described in
> the code in some manner which will prevent us from accidentally
> breaking this exclusivity as the code evolves.
> 
> Does this look truthful and complete?
> 
Yes, thank you.

Maybe kmod_thread_blocker conveys better than kmod_thread_locker?

> --- a/kernel/kmod.c~kmod-avoid-deadlock-by-recursive-kmod-call-fix
> +++ a/kernel/kmod.c
> @@ -44,6 +44,12 @@
>  extern int max_threads;
>  
>  static struct workqueue_struct *khelper_wq;
> +
> +/*
> + * kmod_thread_locker is used for deadlock avoidance.  There is no explicit
> + * locking to protect this global - it is private to the singleton khelper
> + * thread and should only ever be modified by that thread.
> + */
>  static const struct task_struct *kmod_thread_locker;
>  
>  #define CAP_BSET	(void *)1
> _
> 
