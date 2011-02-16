Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab1BPJ6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 04:58:30 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39687 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248Ab1BPJ6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 04:58:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Hv7eekvt10J0aSmxFlrzItT7AOjatb2/nXjFnc/uHf+S6GJVnHs1G4+Zb8Umu+Y4t5
         DtArekZrfEGIVGSe6IFrj0JyZfd+9A6UP+1BY9oiRjbFP68Cc5SGJfaazwhrwqOj5NcB
         lUbmVfJgFwO7sh7y0Gt/6lheiSyICVQbbZ/HE=
MIME-Version: 1.0
Date: Wed, 16 Feb 2011 17:58:24 +0800
Message-ID: <AANLkTi=Bu2uj5=G_BM5C9AKm9C=dfHkU5Gxb0AwQizKY@mail.gmail.com>
Subject: GMP and rwlock: Dead ocurred again on TILEPro
From: Cypher Wu <cypher.w@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rwlock and spinlock of TILEPro platform use TNS instruction to
test the value of lock, but if interrupt is not masked, read_lock()
have another chance to deadlock while read_lock() called in bh of
interrupt.

The original code:
void __raw_read_lock_slow(raw_
rwlock_t *rwlock, u32 val)
{
    u32 iterations = 0;
    do {
        if (!(val & 1))
            rwlock->lock = val;
        delay_backoff(iterations++);
        val = __insn_tns((int *)&rwlock->lock);
    } while ((val << RD_COUNT_WIDTH) != 0);
    rwlock->lock = val + (1 << RD_COUNT_SHIFT);
}

I've modified it to get some information:
void __raw_read_lock_slow(raw_rwlock_t *rwlock, u32 val)
{
    u32 iterations = 0;
    do {
        if (!(val & 1))
        {
            rwlock->lock = val;
            iterations = 0;
        }
        delay_backoff(iterations++);
        if (iterations > 0x1000000)
        {
            dump_stack();
            iterations = 0;
        }

        val = __insn_tns((int *)&rwlock->lock);
    } while ((val << RD_COUNT_WIDTH) != 0);
    rwlock->lock = val + (1 << RD_COUNT_SHIFT);
}

And this is the stack info:

Starting stack dump of tid 837, pid 837 (ff0) on cpu 55 at cycle 10180633928773
 frame 0: 0xfd3bfbe0 dump_stack+0x0/0x20 (sp 0xe4b5f9d8)
 frame 1: 0xfd3c0b50 __raw_read_lock_slow.cold+0x50/0x90 (sp 0xe4b5f9d8)
 frame 2: 0xfd184a58 igmpv3_send_cr+0x60/0x440 (sp 0xe4b5f9f0)
 frame 3: 0xfd3bd928 igmp_ifc_timer_expire+0x30/0x90 (sp 0xe4b5fa20)
 frame 4: 0xfd047698 run_timer_softirq+0x258/0x3c8 (sp 0xe4b5fa30)
 frame 5: 0xfd0563f8 __do_softirq+0x138/0x220 (sp 0xe4b5fa70)
 frame 6: 0xfd097d48 do_softirq+0x88/0x110 (sp 0xe4b5fa98)
 frame 7: 0xfd1871f8 irq_exit+0xf8/0x120 (sp 0xe4b5faa8)
 frame 8: 0xfd1afda0 do_timer_interrupt+0xa0/0xf8 (sp 0xe4b5fab0)
 frame 9: 0xfd187b98 handle_interrupt+0x2d8/0x2e0 (sp 0xe4b5fac0)
 <interrupt 25 while in kernel mode>
 frame 10: 0xfd0241c8 _read_lock+0x8/0x40 (sp 0xe4b5fc38)
 frame 11: 0xfd1bb008 ip_mc_del_src+0xc8/0x378 (sp 0xe4b5fc40)
 frame 12: 0xfd2681e8 ip_mc_leave_group+0xf8/0x1e0 (sp 0xe4b5fc70)
 frame 13: 0xfd0a4d70 do_ip_setsockopt+0xe48/0x1560 (sp 0xe4b5fc90)
 frame 14: 0xfd2b4168 sys_setsockopt+0x150/0x170 (sp 0xe4b5fe98)
 frame 15: 0xfd14e550 handle_syscall+0x2d0/0x320 (sp 0xe4b5fec0)
 <syscall while in user mode>
 frame 16: 0x3342a0 (sp 0xbfddfb00)
 frame 17: 0x16130 (sp 0xbfddfb08)
 frame 18: 0x16640 (sp 0xbfddfb38)
 frame 19: 0x16ee8 (sp 0xbfddfc58)
 frame 20: 0x345a08 (sp 0xbfddfc90)
 frame 21: 0x10218 (sp 0xbfddfe48)
Stack dump complete

I don't know the clear definition of rwlock & spinlock in Linux, but
the implementation of other platforms
like x86, PowerPC, ARM don't have that issue. The use of TNS cause a
race condition between system
call and interrupt.

Through the call tree of packet sending, there are also some other
rwlock will be tried, say
read_lock(&fib_hash_lock) in fn_hash_lookup() which is called in
ip_route_output_slow(). I've seen deadlock
on fib_hash_lock, but haven't reproduced with that debug information yet.

Maybe IGMP is not the only one, TCP timer will retransmit data and
will also call read_lock(&fib_hash_lock).

--
Cyberman Wu
