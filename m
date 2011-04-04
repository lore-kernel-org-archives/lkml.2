Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1DDSaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 14:30:24 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58516 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab1DDSaW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 14:30:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hMGIzBN6CKsWBXpVoLqgI76rDfa7jH4Q4AmYyiTuP8ZP0c3AoXTYsSr7cR7Tv9xdMK
         jx1ZWkRG9y38egXf2m2w==
MIME-Version: 1.0
In-Reply-To: <BANLkTi=UZcocVk_16MbbV432g9a3nDFauA@mail.gmail.com>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils>
	<AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com>
	<AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com>
	<alpine.LSU.2.00.1103182158200.18771@sister.anvils>
	<BANLkTinoNMudwkcOOgU5d+imPUfZhDbWWQ@mail.gmail.com>
	<AANLkTimfArmB7judMW7Qd4ATtVaR=yTf_-0DBRAfCJ7w@mail.gmail.com>
	<BANLkTi=Limr3NUaG7RLoQLv5TuEDmm7Rqg@mail.gmail.com>
	<BANLkTi=UZcocVk_16MbbV432g9a3nDFauA@mail.gmail.com>
Date: Mon, 4 Apr 2011 11:30:16 -0700
Message-ID: <BANLkTi=KTdLRC_hRvxfpFoMSbz=vOjpObw@mail.gmail.com>
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
From: Hugh Dickins <hughd@google.com>
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Michel Lespinasse <walken@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 5:46 AM, Robert Święcki <robert@swiecki.net> wrote:
> On Sat, Apr 2, 2011 at 3:46 AM, Hugh Dickins <hughd@google.com> wrote:
>> On Fri, Apr 1, 2011 at 8:44 AM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> On Fri, Apr 1, 2011 at 7:34 AM, Robert Święcki <robert@swiecki.net> wrote:
>>>>
>>>> Hey, I'll apply your patch and check it out. In the meantime I
>>>> triggered another Oops (NULL-ptr deref via sys_mprotect).
>>>>
>>>> The oops is here:
>>>>
>>>> http://alt.swiecki.net/linux_kernel/sys_mprotect-2.6.38.txt
>>>
>>> That's not a NULL pointer dereference. That's a BUG_ON().
>>>
>>> And for some reason you've turned off the BUG_ON() messages, saving
>>> some tiny amount of memory.
>>>
>>> Anyway, it looks like the first BUG_ON() in vma_prio_tree_add(), so it
>>> would be this one:
>>>
>>>        BUG_ON(RADIX_INDEX(vma) != RADIX_INDEX(old));
>>>
>>> but it is possible that gcc has shuffled things around (so it _might_
>>> be the HEAP_INDEX() one). If you had CONFIG_DEBUG_BUGVERBOSE=y, you'd
>>> get a filename and line number. One reason I hate -O2 in cases like
>>> this is that the basic block movement makes it way harder to actually
>>> debug things. I would suggest using -Os too (CONFIG_OPTIMIZE_FOR_SIZE
>>> or whatever it's called).
>>>
>>> Anyway, I do find it worrying. The vma code shouldn't be this fragile.  Hugh?
>>>
>>> I do wonder what triggers this. Is it a huge-page vma? We seem to be
>>> lacking the check to see that mprotect() is on a hugepage boundary -
>>> and that seems bogus. Or am I missing some check? The new transparent
>>> hugepage support splits the page, but what if it's a _static_ hugepage
>>> thing?
>>>
>>> But why would that affect the radix_index thing? I have no idea. I'd
>>> like to blame the anon_vma rewrites last year, but I can't see why
>>> that should matter either. Again, hugepages had some special rules, I
>>> think (and that would explain why nobody normal sees this).
>>>
>>> Guys, please give this one a look.
>>
>> I do intend to look, but I think it makes more sense to wait until
>> Robert has reproduced it (or something like it) with my debugging
>> patch in.
>
> Hi Hugh,
>
> I did two things, included your patch, and compiled with
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y; the kernel didn't BUG() or Oopssed for
> ~2 days under fuzzing (with getdents and readdir syscalls disabled in
> the fuzzer). I don't think -Os has any bigger influence on how mm
> internally works therefore I must attribute the change to your patch
> (was it patch which fixes something or merely dumps vma structures in
> case of any problem?).

I'm sorry, I should have explained the patch a little more.  Along
with dumping out the vma structs, it does change the BUG or BUGs there
to WARN_ONs, allowing the system to continue if it's not too badly
corrupted, though leaking some structure memory (if the structs have
been reused, it's probably not safe to assume we still have ownership
of them).  So if the problem has occurred again, it should be leaving
WARNING messages and vma struct dumps in your /var/log/messages -
please look for them and send them in if found.

Perhaps we should simply include the patch in mainline kernel: it
doesn't do much good just lingering in mmotm, but seems to be helping
your system to limp along longer.

>
>
> ==============
> BTW, another problem arose in the meantime, not sure if anyhow related
> to things we're discussing here, although 'btc 0' in kdb shows that
> processor 0 hangs in sys_mlock - I did it in two different moments, to
> exclude any coincidences. After those 2 days of fuzzing, 'ps wuax'
> stopped working, i.e. it prints some output, then stops, cannot be
> killed with -SIGKILL etc. I'll let it run for the time being, I can
> dump more data in this PID 17750 if anybody wants:
>
> strace:
>
> # strace -f ps wwuax
> ....
> open("/proc/17750/status", O_RDONLY)    = 6
> read(6, "Name:\tiknowthis\nState:\tD (disk s"..., 1023) = 777
> close(6)                                = 0
> open("/proc/17750/cmdline", O_RDONLY)   = 6
> read(6,
>
> Process 17750 also cannot be killed. Attaching more data:
>
> # cat /proc/17750/status
> Name:   iknowthis
> State:  D (disk sleep)
> Tgid:   17750
> Pid:    17750
> PPid:   1
> TracerPid:      0
> Uid:    1001    1001    1001    1001
> Gid:    1001    1001    1001    1001
> FDSize: 64
> Groups: 1001
> VmPeak:     7752 kB
> VmSize:     5760 kB
> VmLck:        32 kB
> VmHWM:      4892 kB
> VmRSS:      3068 kB
> VmData:     2472 kB
> VmStk:       408 kB
> VmExe:       160 kB
> VmLib:      2684 kB
> VmPTE:        44 kB
> VmSwap:        0 kB
> Threads:        1
> SigQ:   218/16382
> SigPnd: 0000000000000b00
> ShdPnd: 0000400000000503
> SigBlk: 0000000000000000
> SigIgn: 0000000001001000
> SigCgt: 0000000000000000
> CapInh: 0000000000000000
> CapPrm: 0000000000000000
> CapEff: 0000000000000000
> CapBnd: ffffffffffffffff
> Cpus_allowed:   01
> Cpus_allowed_list:      0
> Mems_allowed:   00000000,00000001
> Mems_allowed_list:      0
> voluntary_ctxt_switches:        43330
> nonvoluntary_ctxt_switches:     4436
>
> # cat /proc/17750/wchan
> call_rwsem_down_write_failed
>
> # cat /proc/17750/maps (hangs)
>
> (from kdb)
>
> [0]kdb> btp 17750
> Stack traceback for pid 17750
> 0xffff88011e772dc0    17750        1  0    0   D  0xffff88011e773240  iknowthis
> <c> ffff88011cbcfb88<c> 0000000000000086<c> ffff88011cbcfb08<c>
> ffff88011cbcffd8<c>
> <c> 0000000000013f00<c> ffff88011e772dc0<c> ffff88011e773180<c>
> ffff88011e773178<c>
> <c> ffff88011cbce000<c> ffff88011cbcffd8<c> 0000000000013f00<c>
> 0000000000013f00<c>
> Call Trace:
>  [<ffffffff81e286ad>] rwsem_down_failed_common+0xdb/0x10d
>  [<ffffffff81e286f2>] rwsem_down_write_failed+0x13/0x15
>  [<ffffffff81416953>] call_rwsem_down_write_failed+0x13/0x20
>  [<ffffffff81e27da0>] ? down_write+0x25/0x27
>  [<ffffffff8115f041>] do_coredump+0x14f/0x9a5
>  [<ffffffff8114d4e2>] ? T.1006+0x17/0x32
>  [<ffffffff810a45f0>] ? __dequeue_signal+0xfa/0x12f
>  [<ffffffff8108a79c>] ? get_parent_ip+0x11/0x42
>  [<ffffffff810a6406>] get_signal_to_deliver+0x3be/0x3e6
>  [<ffffffff8103e0c1>] do_signal+0x72/0x67d
>  [<ffffffff81096807>] ? child_wait_callback+0x0/0x58
>  [<ffffffff81e28c28>] ? _raw_spin_unlock_irq+0x36/0x41
>  [<ffffffff8108bb06>] ? finish_task_switch+0x4b/0xb9
>  [<ffffffff8108c3ed>] ? schedule_tail+0x38/0x68
>  [<ffffffff8103eb43>] ? ret_from_fork+0x13/0x80
>  [<ffffffff8103e6f8>] do_notify_resume+0x2c/0x6e
>
> [0]kdb>  btc 0
> Stack traceback for pid 10350
> 0xffff88011b6badc0    10350        1  1    0   R  0xffff88011b6bb240 *iknowthis2
> <c> ffff8800cfc03db8<c> 0000000000000000<c>
> Call Trace:
>  <#DB>  <<EOE>>  <IRQ>  [<ffffffff81518b03>] ? __handle_sysrq+0xbf/0x15c
>  [<ffffffff81518d7d>] ? handle_sysrq+0x2c/0x2e
>  [<ffffffff8152bd90>] ? serial8250_handle_port+0x157/0x2b2
>  [<ffffffff810a1be8>] ? run_timer_softirq+0x2b3/0x2c2
>  [<ffffffff8152bf4c>] ? serial8250_interrupt+0x61/0x111
>  [<ffffffff810e6e52>] ? handle_IRQ_event+0x78/0x150
>  [<ffffffff810ea044>] ? move_native_irq+0x19/0x6d
>  [<ffffffff810e8d90>] ? handle_edge_irq+0xe3/0x12f
>  [<ffffffff8104198f>] ? handle_irq+0x88/0x91
>  [<ffffffff81e297a5>] ? do_IRQ+0x4d/0xb3
>  [<ffffffff81e29193>] ? ret_from_intr+0x0/0x15
>  <EOI>  [<ffffffff811336aa>] ? __mlock_vma_pages_range+0x49/0xad
>  [<ffffffff8113370a>] ? __mlock_vma_pages_range+0xa9/0xad
>  [<ffffffff811337c0>] ? do_mlock_pages+0xb2/0x118
>  [<ffffffff81134002>] ? sys_mlock+0xe8/0xf6
>  [<ffffffff8107d7e3>] ? ia32_sysret+0x0/0x5
>
> [0]kdb> btc 1
> Stack traceback for pid 9409
> 0xffff88011c9816e0     9409        1  1    1   R  0xffff88011c981b60  iknowthis2
> <c> ffff88011dc21ec8

Sorry, I've no time to think about this one at the moment (at LSF).
Does this look similar to what you previously reported on mlock?

Hugh
