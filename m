Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab1DVH1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 03:27:31 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65382 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab1DVH13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 03:27:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rT4ZRzKrSvDDD5FFQ9MZVL2gvN1+ptGpvdL3DlMNSxw9O1SzzCQzqI5o0fmjNBOSIa
         iln2F+sOAx673Q42HCeSrsLekVE1X0+DwnHd22TAm0MBsps20iiqEYwbFpoMUcvwtnAQ
         GQjTP1k2ha2E3xK8QHyUEkgc4eCc0BJF8O2+I=
MIME-Version: 1.0
In-Reply-To: <BANLkTikYwWe6E6mb3PLE3L7a3VHWdtEvfQ@mail.gmail.com>
References: <20110417094505.865828233@chello.nl>
	<201104180341.p3I3fnxc000638@www262.sakura.ne.jp>
	<BANLkTikYwWe6E6mb3PLE3L7a3VHWdtEvfQ@mail.gmail.com>
Date: Fri, 22 Apr 2011 15:27:27 +0800
Message-ID: <BANLkTimMYTSFvzz-1ycu338zWJ4iSAu3AA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/7] lockdep: Support recurise-read locks
From: Yong Zhang <yong.zhang0@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: a.p.zijlstra@chello.nl, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 3:19 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> 2011/4/18 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>:
>> (Continued from https://lkml.org/lkml/2011/3/31/240 "Re: [RFC] seqlock,lockdep: Add lock primitives to read_seqbegin().")
>> Test results for above program:
>>
>> "cat /proc/locktest1 /proc/locktest2" => Detect fail
>> "cat /proc/locktest2 /proc/locktest1" => Detect fail
>> "cat /proc/locktest3 /proc/locktest4" => Detect fail
>> "cat /proc/locktest4 /proc/locktest3" => Detect fail
>>
>> If I change from rwlock_acquire_read() to spin_acquire() in read_seqbegin2()
>> and from rwlock_release() to spin_release() in read_seqretry2():
>>
>> "cat /proc/locktest1 /proc/locktest2" => Detect fail
>> "cat /proc/locktest2 /proc/locktest1" => Detect OK (shown below)
>> "cat /proc/locktest3 /proc/locktest4" => Detect fail
>> "cat /proc/locktest4 /proc/locktest3" => Detect OK (shown below)
>>
>> Guessing from my testcases, read_seqbegin2() will fail to detect the problem
>> unless we use spin_acquire()/spin_release() rather than
>> rwlock_acquire_read()/rwlock_release().
>>
>> Also, something is still wrong because lockdep fails to detect the problem
>> for "cat /proc/locktest1 /proc/locktest2" and
>> "cat /proc/locktest3 /proc/locktest4" cases.
>
> It fails because we never add the recursive read to prev->after evev if
> it passed the validation.
>
> check_prev_add()::1671
>        /*
>         * For recursive read-locks we do all the dependency checks,
>         * but we dont store read-triggered dependencies (only
>         * write-triggered dependencies). This ensures that only the
>         * write-side dependencies matter, and that if for example a
>         * write-lock never takes any other locks, then the reads are
>         * equivalent to a NOP.
>         */
>        if (next->read == 2 || prev->read == 2)

And the semantic doesn't change in Peter's patch.

>                return 1;
>
> So we have no chain after opening locktest1 or locktest3.
>
> But adding recursive read to prev->after will introduce spurious
> lockdep warnings.
>
> Thanks,
> Yong
>
>>
>> [   83.551455]
>> [   83.551457] =======================================================
>> [   83.555293] [ INFO: possible circular locking dependency detected ]
>> [   83.555293] 2.6.39-rc3-00228-gd733ed6-dirty #259
>> [   83.555293] -------------------------------------------------------
>> [   83.555293] cat/2768 is trying to acquire lock:
>> [   83.555293]  (brlock1_lock_dep_map){++++..}, at: [<e08150b0>] brlock1_local_lock+0x0/0x90 [locktest]
>> [   83.555293]
>> [   83.555293] but task is already holding lock:
>> [   83.555293]  (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e08154dd>] locktest_open1+0xd/0x40 [locktest]
>> [   83.555293]
>> [   83.555293] which lock already depends on the new lock.
>> [   83.555293]
>> [   83.555293]
>> [   83.555293] the existing dependency chain (in reverse order) is:
>> [   83.555293]
>> [   83.555293] -> #1 (&(&(&seqlock1)->lock)->rlock){+.+...}:
>> [   83.635281]        [<c106c499>] check_prevs_add+0xb9/0x110
>> [   83.635281]        [<c106c840>] validate_chain+0x320/0x5a0
>> [   83.635281]        [<c106e927>] __lock_acquire+0x2a7/0x8f0
>> [   83.635281]        [<c107001a>] lock_acquire+0x7a/0xa0
>> [   83.635281]        [<e0815555>] locktest_open2+0x45/0x70 [locktest]
>> [   83.635281]        [<c1118355>] proc_reg_open+0x65/0xe0
>> [   83.635281]        [<c10ce78f>] __dentry_open+0x16f/0x2e0
>> [   83.635281]        [<c10ce9fe>] nameidata_to_filp+0x5e/0x70
>> [   83.635281]        [<c10dc1d8>] do_last+0xf8/0x6c0
>> [   83.635281]        [<c10dc846>] path_openat+0xa6/0x340
>> [   83.635281]        [<c10dcb10>] do_filp_open+0x30/0x80
>> [   83.635281]        [<c10cefa1>] do_sys_open+0x101/0x1a0
>> [   83.635281]        [<c10cf069>] sys_open+0x29/0x40
>> [   83.635281]        [<c13b43c1>] syscall_call+0x7/0xb
>> [   83.635281]
>> [   83.635281] -> #0 (brlock1_lock_dep_map){++++..}:
>> [   83.635281]        [<c106c34c>] check_prev_add+0x78c/0x820
>> [   83.635281]        [<c106c499>] check_prevs_add+0xb9/0x110
>> [   83.635281]        [<c106c840>] validate_chain+0x320/0x5a0
>> [   83.635281]        [<c106e927>] __lock_acquire+0x2a7/0x8f0
>> [   83.635281]        [<c107001a>] lock_acquire+0x7a/0xa0
>> [   83.635281]        [<e08150e3>] brlock1_local_lock+0x33/0x90 [locktest]
>> [   83.635281]        [<e08154e8>] locktest_open1+0x18/0x40 [locktest]
>> [   83.635281]        [<c1118355>] proc_reg_open+0x65/0xe0
>> [   83.635281]        [<c10ce78f>] __dentry_open+0x16f/0x2e0
>> [   83.635281]        [<c10ce9fe>] nameidata_to_filp+0x5e/0x70
>> [   83.635281]        [<c10dc1d8>] do_last+0xf8/0x6c0
>> [   83.635281]        [<c10dc846>] path_openat+0xa6/0x340
>> [   83.635281]        [<c10dcb10>] do_filp_open+0x30/0x80
>> [   83.635281]        [<c10cefa1>] do_sys_open+0x101/0x1a0
>> [   83.635281]        [<c10cf069>] sys_open+0x29/0x40
>> [   83.635281]        [<c13b43c1>] syscall_call+0x7/0xb
>> [   83.635281]
>> [   83.635281] other info that might help us debug this:
>> [   83.635281]
>> [   83.635281] 1 lock held by cat/2768:
>> [   83.635281]  #0:  (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e08154dd>] locktest_open1+0xd/0x40 [locktest]
>> [   83.635281]
>> [   83.635281] stack backtrace:
>> [   83.635281] Pid: 2768, comm: cat Not tainted 2.6.39-rc3-00228-gd733ed6-dirty #259
>> [   83.635281] Call Trace:
>> [   83.635281]  [<c106ade6>] print_circular_bug+0xc6/0xd0
>> [   83.635281]  [<c106c34c>] check_prev_add+0x78c/0x820
>> [   83.635281]  [<c1005d3b>] ? print_context_stack+0x3b/0xa0
>> [   83.635281]  [<c1004fa1>] ? dump_trace+0x81/0xe0
>> [   83.635281]  [<c106c499>] check_prevs_add+0xb9/0x110
>> [   83.635281]  [<c106c840>] validate_chain+0x320/0x5a0
>> [   83.635281]  [<c106df7c>] ? mark_lock+0x21c/0x3c0
>> [   83.635281]  [<c106e927>] __lock_acquire+0x2a7/0x8f0
>> [   83.635281]  [<c107001a>] lock_acquire+0x7a/0xa0
>> [   83.635281]  [<e08150b0>] ? brlock1_lock_init+0xb0/0xb0 [locktest]
>> [   83.635281]  [<e08154d0>] ? brlock1_global_unlock+0xa0/0xa0 [locktest]
>> [   83.635281]  [<e08150e3>] brlock1_local_lock+0x33/0x90 [locktest]
>> [   83.635281]  [<e08150b0>] ? brlock1_lock_init+0xb0/0xb0 [locktest]
>> [   83.635281]  [<e08154e8>] locktest_open1+0x18/0x40 [locktest]
>> [   83.635281]  [<c1118355>] proc_reg_open+0x65/0xe0
>> [   83.635281]  [<c10ce78f>] __dentry_open+0x16f/0x2e0
>> [   83.635281]  [<c10ce9fe>] nameidata_to_filp+0x5e/0x70
>> [   83.635281]  [<c11182f0>] ? proc_reg_mmap+0x80/0x80
>> [   83.635281]  [<c10dc1d8>] do_last+0xf8/0x6c0
>> [   83.635281]  [<c10db00c>] ? path_init+0x2cc/0x3c0
>> [   83.635281]  [<c10dc846>] path_openat+0xa6/0x340
>> [   83.635281]  [<c106d80b>] ? trace_hardirqs_off+0xb/0x10
>> [   83.635281]  [<c10dcb10>] do_filp_open+0x30/0x80
>> [   83.635281]  [<c13b3a5d>] ? _raw_spin_unlock+0x1d/0x20
>> [   83.635281]  [<c10e9f11>] ? alloc_fd+0xe1/0x1a0
>> [   83.635281]  [<c10cefa1>] do_sys_open+0x101/0x1a0
>> [   83.635281]  [<c10cfc8b>] ? vfs_write+0x10b/0x130
>> [   83.635281]  [<c10cf069>] sys_open+0x29/0x40
>> [   83.635281]  [<c13b43c1>] syscall_call+0x7/0xb
>>
>>
>>
>> [   82.758647]
>> [   82.758649] =======================================================
>> [   82.762520] [ INFO: possible circular locking dependency detected ]
>> [   82.762520] 2.6.39-rc3-00228-gd733ed6-dirty #259
>> [   82.762520] -------------------------------------------------------
>> [   82.762520] cat/2768 is trying to acquire lock:
>> [   82.762520]  (rwlock1){++++..}, at: [<e081559d>] locktest_open3+0x1d/0x40 [locktest]
>> [   82.762520]
>> [   82.762520] but task is already holding lock:
>> [   82.762520]  (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e081558d>] locktest_open3+0xd/0x40 [locktest]
>> [   82.762520]
>> [   82.762520] which lock already depends on the new lock.
>> [   82.762520]
>> [   82.762520]
>> [   82.762520] the existing dependency chain (in reverse order) is:
>> [   82.762520]
>> [   82.762520] -> #1 (&(&(&seqlock1)->lock)->rlock){+.+...}:
>> [   82.841627]        [<c106c499>] check_prevs_add+0xb9/0x110
>> [   82.841627]        [<c106c840>] validate_chain+0x320/0x5a0
>> [   82.841627]        [<c106e927>] __lock_acquire+0x2a7/0x8f0
>> [   82.841627]        [<c107001a>] lock_acquire+0x7a/0xa0
>> [   82.841627]        [<e081560a>] locktest_open4+0x4a/0x90 [locktest]
>> [   82.841627]        [<c1118355>] proc_reg_open+0x65/0xe0
>> [   82.841627]        [<c10ce78f>] __dentry_open+0x16f/0x2e0
>> [   82.841627]        [<c10ce9fe>] nameidata_to_filp+0x5e/0x70
>> [   82.841627]        [<c10dc1d8>] do_last+0xf8/0x6c0
>> [   82.841627]        [<c10dc846>] path_openat+0xa6/0x340
>> [   82.841627]        [<c10dcb10>] do_filp_open+0x30/0x80
>> [   82.841627]        [<c10cefa1>] do_sys_open+0x101/0x1a0
>> [   82.841627]        [<c10cf069>] sys_open+0x29/0x40
>> [   82.841627]        [<c13b43c1>] syscall_call+0x7/0xb
>> [   82.841627]
>> [   82.841627] -> #0 (rwlock1){++++..}:
>> [   82.841627]        [<c106c34c>] check_prev_add+0x78c/0x820
>> [   82.841627]        [<c106c499>] check_prevs_add+0xb9/0x110
>> [   82.841627]        [<c106c840>] validate_chain+0x320/0x5a0
>> [   82.841627]        [<c106e927>] __lock_acquire+0x2a7/0x8f0
>> [   82.841627]        [<c107001a>] lock_acquire+0x7a/0xa0
>> [   82.841627]        [<c13b3ba9>] _raw_read_lock+0x39/0x70
>> [   82.841627]        [<e081559d>] locktest_open3+0x1d/0x40 [locktest]
>> [   82.841627]        [<c1118355>] proc_reg_open+0x65/0xe0
>> [   82.841627]        [<c10ce78f>] __dentry_open+0x16f/0x2e0
>> [   82.841627]        [<c10ce9fe>] nameidata_to_filp+0x5e/0x70
>> [   82.841627]        [<c10dc1d8>] do_last+0xf8/0x6c0
>> [   82.841627]        [<c10dc846>] path_openat+0xa6/0x340
>> [   82.841627]        [<c10dcb10>] do_filp_open+0x30/0x80
>> [   82.841627]        [<c10cefa1>] do_sys_open+0x101/0x1a0
>> [   82.841627]        [<c10cf069>] sys_open+0x29/0x40
>> [   82.841627]        [<c13b43c1>] syscall_call+0x7/0xb
>> [   82.841627]
>> [   82.841627] other info that might help us debug this:
>> [   82.841627]
>> [   82.841627] 1 lock held by cat/2768:
>> [   82.841627]  #0:  (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e081558d>] locktest_open3+0xd/0x40 [locktest]
>> [   82.841627]
>> [   82.841627] stack backtrace:
>> [   82.841627] Pid: 2768, comm: cat Not tainted 2.6.39-rc3-00228-gd733ed6-dirty #259
>> [   82.841627] Call Trace:
>> [   82.841627]  [<c106ade6>] print_circular_bug+0xc6/0xd0
>> [   82.841627]  [<c106c34c>] check_prev_add+0x78c/0x820
>> [   82.841627]  [<c1005d3b>] ? print_context_stack+0x3b/0xa0
>> [   82.841627]  [<c1004fa1>] ? dump_trace+0x81/0xe0
>> [   82.841627]  [<c106c499>] check_prevs_add+0xb9/0x110
>> [   82.841627]  [<c106c840>] validate_chain+0x320/0x5a0
>> [   82.841627]  [<c106df7c>] ? mark_lock+0x21c/0x3c0
>> [   82.841627]  [<c106e927>] __lock_acquire+0x2a7/0x8f0
>> [   82.841627]  [<c107001a>] lock_acquire+0x7a/0xa0
>> [   82.841627]  [<e081559d>] ? locktest_open3+0x1d/0x40 [locktest]
>> [   82.841627]  [<e0815580>] ? locktest_open2+0x70/0x70 [locktest]
>> [   82.841627]  [<c13b3ba9>] _raw_read_lock+0x39/0x70
>> [   82.841627]  [<e081559d>] ? locktest_open3+0x1d/0x40 [locktest]
>> [   82.841627]  [<e081559d>] locktest_open3+0x1d/0x40 [locktest]
>> [   82.841627]  [<c1118355>] proc_reg_open+0x65/0xe0
>> [   82.841627]  [<c10ce78f>] __dentry_open+0x16f/0x2e0
>> [   82.841627]  [<c10ce9fe>] nameidata_to_filp+0x5e/0x70
>> [   82.841627]  [<c11182f0>] ? proc_reg_mmap+0x80/0x80
>> [   82.841627]  [<c10dc1d8>] do_last+0xf8/0x6c0
>> [   82.841627]  [<c10db00c>] ? path_init+0x2cc/0x3c0
>> [   82.841627]  [<c10dc846>] path_openat+0xa6/0x340
>> [   82.841627]  [<c106d80b>] ? trace_hardirqs_off+0xb/0x10
>> [   82.841627]  [<c10dcb10>] do_filp_open+0x30/0x80
>> [   82.841627]  [<c13b3a5d>] ? _raw_spin_unlock+0x1d/0x20
>> [   82.841627]  [<c10e9f11>] ? alloc_fd+0xe1/0x1a0
>> [   82.841627]  [<c10cefa1>] do_sys_open+0x101/0x1a0
>> [   82.841627]  [<c10cfc8b>] ? vfs_write+0x10b/0x130
>> [   82.841627]  [<c10cf069>] sys_open+0x29/0x40
>> [   82.841627]  [<c13b43c1>] syscall_call+0x7/0xb
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>
>
> --
> Only stand for myself
>



-- 
Only stand for myself
