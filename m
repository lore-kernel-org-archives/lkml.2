Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab0CZCnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 22:43:16 -0400
Received: from mail-qy0-f188.google.com ([209.85.221.188]:58269 "EHLO
	mail-qy0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab0CZCnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 22:43:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h7FGHQ6Oj5RNbbp9cfUzBPxhSGwVYirEQ0nl5x6MYYfSsw1H++TBpHLGsZqo4THLxn
         ccXKgQ7Mg9rmaQPeTlOsqEiEMNrB/o29uVDne8T1XrfGR55IOOC+vBL/+7F3w0fUn6IK
         WBz2uF6pkksWXRETeNallIsDshh166Wypon08=
MIME-Version: 1.0
In-Reply-To: <6397.1269516539@redhat.com>
References: <1264740107.20211.53.camel@pasglop> <6397.1269516539@redhat.com>
Date: Fri, 26 Mar 2010 10:43:12 +0800
Message-ID: <2375c9f91003251943r4663ae51r5791acc374b6ccc4@mail.gmail.com>
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 7:28 PM, David Howells <dhowells@redhat.com> wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>
>> Johannes and I see this on our quad G5s... it -could- be similar to
>> one reported a short while ago by Xiaotian Feng <xtfeng@gmail.com>
>> under the subject [2.6.33-rc4] sysfs lockdep warnings on cpu hotplug.
>>
>> Basically, the machine deadlocks right after printing the following
>> when doing a shutdown:
>>
>> halt/4071 is trying to acquire lock:
>>  (s_active){++++.+}, at: [<c0000000001ef868>] .sysfs_addrm_finish+0x58/0xc0
>>
>> but task is already holding lock:
>>  (&per_cpu(cpu_policy_rwsem, cpu)){+.+.+.}, at: [<c0000000004cd6ac>] .lock_policy_rwsem_write+0x84/0xf4
>>
>> which lock already depends on the new lock.
>>
>> the existing dependency chain (in reverse order) is:
>>
>> <nothing else ... machine deadlocked here>
>
> I see this now, with full backtrace:
>
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.34-rc2-cachefs #115
> -------------------------------------------------------
> halt/2291 is trying to acquire lock:
>  (s_active#31){++++.+}, at: [<ffffffff81104950>] sysfs_addrm_finish+0x31/0x5a
>
> but task is already holding lock:
>  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<ffffffff812a3a92>] lock_policy_rwsem_write+0x4a/0x7b
>
> which lock already depends on the new lock.
>


I already send a patch for this:

https://patchwork.kernel.org/patch/83558/

It is still in -mm tree, I think.

Thanks!

>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
>       [<ffffffff81053da2>] __lock_acquire+0x1343/0x16cd
>       [<ffffffff81054183>] lock_acquire+0x57/0x6d
>       [<ffffffff813637b6>] down_write+0x3f/0x62
>       [<ffffffff812a3a92>] lock_policy_rwsem_write+0x4a/0x7b
>       [<ffffffff812a3b36>] store+0x39/0x79
>       [<ffffffff81103589>] sysfs_write_file+0x103/0x13f
>       [<ffffffff810afddc>] vfs_write+0xad/0x172
>       [<ffffffff810aff5a>] sys_write+0x45/0x6c
>       [<ffffffff81001eeb>] system_call_fastpath+0x16/0x1b
>
> -> #0 (s_active#31){++++.+}:
>       [<ffffffff81053a59>] __lock_acquire+0xffa/0x16cd
>       [<ffffffff81054183>] lock_acquire+0x57/0x6d
>       [<ffffffff81104086>] sysfs_deactivate+0x8c/0xc9
>       [<ffffffff81104950>] sysfs_addrm_finish+0x31/0x5a
>       [<ffffffff81104a33>] sysfs_remove_dir+0x75/0x88
>       [<ffffffff811bafae>] kobject_del+0x16/0x37
>       [<ffffffff811bb00d>] kobject_release+0x3e/0x66
>       [<ffffffff811bbd71>] kref_put+0x43/0x4d
>       [<ffffffff811baf29>] kobject_put+0x47/0x4b
>       [<ffffffff812a39b2>] __cpufreq_remove_dev+0x1da/0x236
>       [<ffffffff8136178e>] cpufreq_cpu_callback+0x62/0x7a
>       [<ffffffff81048362>] notifier_call_chain+0x32/0x5e
>       [<ffffffff810483ed>] __raw_notifier_call_chain+0x9/0xb
>       [<ffffffff81351736>] _cpu_down+0x90/0x29e
>       [<ffffffff810311d3>] disable_nonboot_cpus+0x6f/0x105
>       [<ffffffff8103f845>] kernel_power_off+0x21/0x3b
>       [<ffffffff8103facd>] sys_reboot+0x103/0x16a
>       [<ffffffff81001eeb>] system_call_fastpath+0x16/0x1b
>
> other info that might help us debug this:
>
> 4 locks held by halt/2291:
>  #0:  (reboot_mutex){+.+.+.}, at: [<ffffffff8103fa5b>] sys_reboot+0x91/0x16a
>  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff81031102>] cpu_maps_update_begin+0x12/0x14
>  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8103113d>] cpu_hotplug_begin+0x27/0x4e
>  #3:  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<ffffffff812a3a92>] lock_policy_rwsem_write+0x4a/0x7b
>
> stack backtrace:
> Pid: 2291, comm: halt Not tainted 2.6.34-rc2-cachefs #115
> Call Trace:
>  [<ffffffff81052522>] print_circular_bug+0xae/0xbd
>  [<ffffffff81053a59>] __lock_acquire+0xffa/0x16cd
>  [<ffffffff81054183>] lock_acquire+0x57/0x6d
>  [<ffffffff81104950>] ? sysfs_addrm_finish+0x31/0x5a
>  [<ffffffff81044acf>] ? __init_waitqueue_head+0x35/0x46
>  [<ffffffff81104086>] sysfs_deactivate+0x8c/0xc9
>  [<ffffffff81104950>] ? sysfs_addrm_finish+0x31/0x5a
>  [<ffffffff811044a3>] ? release_sysfs_dirent+0x9e/0xbe
>  [<ffffffff81104950>] sysfs_addrm_finish+0x31/0x5a
>  [<ffffffff81104a33>] sysfs_remove_dir+0x75/0x88
>  [<ffffffff811bafae>] kobject_del+0x16/0x37
>  [<ffffffff811bb00d>] kobject_release+0x3e/0x66
>  [<ffffffff811bafcf>] ? kobject_release+0x0/0x66
>  [<ffffffff811bbd71>] kref_put+0x43/0x4d
>  [<ffffffff811baf29>] kobject_put+0x47/0x4b
>  [<ffffffff812a39b2>] __cpufreq_remove_dev+0x1da/0x236
>  [<ffffffff8136178e>] cpufreq_cpu_callback+0x62/0x7a
>  [<ffffffff81048362>] notifier_call_chain+0x32/0x5e
>  [<ffffffff810483ed>] __raw_notifier_call_chain+0x9/0xb
>  [<ffffffff81351736>] _cpu_down+0x90/0x29e
>  [<ffffffff810311d3>] disable_nonboot_cpus+0x6f/0x105
>  [<ffffffff8103f845>] kernel_power_off+0x21/0x3b
>  [<ffffffff8103facd>] sys_reboot+0x103/0x16a
>  [<ffffffff813636d9>] ? do_nanosleep+0x78/0xb2
>  [<ffffffff8104797d>] ? hrtimer_nanosleep+0xab/0x118
>  [<ffffffff810473a6>] ? hrtimer_wakeup+0x0/0x21
>  [<ffffffff81364e29>] ? retint_swapgs+0xe/0x13
>  [<ffffffff81051e4e>] ? trace_hardirqs_on_caller+0x10c/0x130
>  [<ffffffff8107496a>] ? audit_syscall_entry+0x17d/0x1b0
>  [<ffffffff81364354>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff81001eeb>] system_call_fastpath+0x16/0x1b
> Broke affinity for irq 4
> lockdep: fixing up alternatives.
> SMP alternatives: switching to UP code
> Power down.
> acpi_power_off called
>
>
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
