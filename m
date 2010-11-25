Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab0KYGxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 01:53:42 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44666 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab0KYGxi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 01:53:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q0jQZ9Jiddwalusz5W7im8m7a/ArGaz75ErT3ErGcW/6wm+wcCJdQ2gY5lDTzE/fKH
         t1gwYE+M2eqHzjXiR0YpHPAhVdMxePGGY/D9xyzdWgkVHfb8PM0DET7OY6bMmKUrvtps
         m4epNJuVTwNk8B1dKnjYh2ORdf2/z1MkfSCl4=
MIME-Version: 1.0
In-Reply-To: <6340.1290665937@localhost>
References: <6340.1290665937@localhost>
Date: Thu, 25 Nov 2010 14:53:37 +0800
Message-ID: <AANLkTim2_eEMsryEh0GXk8d-v_ZSOvqJ3-xSf55xCc5L@mail.gmail.com>
Subject: Re: 2.6.37-rc3-mmotm1123 - arch/x86/kernel/cpu/mcheck/mce.c:1628
 invoked rcu_dereference_check() without protection!
From: huang ying <huang.ying.caritas@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 2:18 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> (Appears to have been present in -rc2-mmotm1117 as well, and maybe earlier. I
> suspect mcelog wasn't getting run at boot due to my fighting with systemd, so I
> didn't see it).
>
> [  146.195836] ===================================================
> [  146.195839] [ INFO: suspicious rcu_dereference_check() usage. ]
> [  146.195841] ---------------------------------------------------
> [  146.195844] arch/x86/kernel/cpu/mcheck/mce.c:1628 invoked rcu_dereference_check() without protection!

The warning comes from the rcu_dereference_check_mce() in mce_poll().
It seems that we do not need rcu_dereference_check_mce() here. Because
we only check the value of mcelog.next, but do not use that value to
access the content of the array.

Best Regards,
Huang Ying

> [  146.195847]
> [  146.195847] other info that might help us debug this:
> [  146.195848]
> [  146.195850]
> [  146.195850] rcu_scheduler_active = 1, debug_locks = 1
> [  146.195853] no locks held by mcelog/3806.
> [  146.195855]
> [  146.195855] stack backtrace:
> [  146.195858] Pid: 3806, comm: mcelog Tainted: G        W   2.6.37-rc3-mmotm1123 #4
> [  146.195860] Call Trace:
> [  146.195869]  [<ffffffff81069538>] lockdep_rcu_dereference+0x9d/0xa5
> [  146.195875]  [<ffffffff810139ea>] mce_poll+0x66/0x74
> [  146.195880]  [<ffffffff8110a62e>] do_sys_poll+0x23b/0x3a5
> [  146.195885]  [<ffffffff811095ad>] ? __pollwait+0x0/0xc7
> [  146.195889]  [<ffffffff81109674>] ? pollwake+0x0/0x4f
> [  146.195893]  [<ffffffff81109674>] ? pollwake+0x0/0x4f
> [  146.195898]  [<ffffffff81094c0e>] ? __rcu_read_unlock+0x28f/0x2ab
> [  146.195903]  [<ffffffff810d565f>] ? __do_fault+0x256/0x3e5
> [  146.195908]  [<ffffffff81068775>] ? look_up_lock_class+0x5f/0xc4
> [  146.195912]  [<ffffffff810d565f>] ? __do_fault+0x256/0x3e5
> [  146.195916]  [<ffffffff81068c42>] ? register_lock_class+0x1e/0x2d3
> [  146.195921]  [<ffffffff810a5c05>] ? trace_preempt_on+0x15/0x28
> [  146.195925]  [<ffffffff810d5755>] ? __do_fault+0x34c/0x3e5
> [  146.195931]  [<ffffffff8155adbc>] ? _raw_spin_unlock+0x30/0x69
> [  146.195935]  [<ffffffff8106a45e>] ? mark_lock+0x2d/0x1d8
> [  146.195940]  [<ffffffff810ba69c>] ? unlock_page+0x25/0x2a
> [  146.195944]  [<ffffffff8106ab57>] ? __lock_acquire+0x54e/0xd4e
> [  146.195948]  [<ffffffff810d790d>] ? handle_mm_fault+0x193/0x7c3
> [  146.195953]  [<ffffffff8104acaa>] ? sigprocmask+0x2f/0xc5
> [  146.195957]  [<ffffffff8104acaa>] ? sigprocmask+0x2f/0xc5
> [  146.195962]  [<ffffffff810d4cc0>] ? might_fault+0x4e/0x9e
> [  146.195966]  [<ffffffff8155aea0>] ? _raw_spin_unlock_irq+0x2b/0x70
> [  146.195970]  [<ffffffff810a5c05>] ? trace_preempt_on+0x15/0x28
> [  146.195974]  [<ffffffff8104ad35>] ? sigprocmask+0xba/0xc5
> [  146.195978]  [<ffffffff8155aeab>] ? _raw_spin_unlock_irq+0x36/0x70
> [  146.195983]  [<ffffffff8155e378>] ? sub_preempt_count+0x35/0x49
> [  146.195987]  [<ffffffff8155aed7>] ? _raw_spin_unlock_irq+0x62/0x70
> [  146.195992]  [<ffffffff8110a973>] sys_ppoll+0xd3/0x13c
> [  146.195996]  [<ffffffff8106bc89>] ? trace_hardirqs_on_caller+0x117/0x13b
> [  146.196087]  [<ffffffff8155a60b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [  146.196094]  [<ffffffff8100277b>] system_call_fastpath+0x16/0x1b
>
>
