Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab1LTQ0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 11:26:49 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:28378 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750771Ab1LTQ0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 11:26:43 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: VCKwrS4VM1njhuTaAkuD2fHYHXidp6aCXro7lomcrjexbiS
 S.IyMJpqQhxavBkhazuEYsqeQgQeSjHonuLYZqiyzxihAA6XsBR4bF6tpM_k
 phbKGA9G5ZCB_zt4ZWlc23aC.Cri77t2M8xAb7CERWPz.1lH2wCN._37q1VM
 wvKdL8zKRsfu1BuWZ4HEHN25WLUm5h6fyITHnyQOD1AKvlvMiDq0uDxwH9L.
 JIFwXW1NSvDPuB5Cxg8uLu2aRXdrsa8ZRt67A7ldqqtZ3qgbe4mn68MkA5WE
 GG8iJogdu9jnE9c1WWtlvO924xeUGhNrj3pPxjAxZQUMIIpc.DIOzhxm.3U9
 u9d.VrTTRAY5HXhh95gsq8o6HrLh0HwPmhaNYpvQFetDk5A--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Dec 2011 10:26:39 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
In-Reply-To: <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1112201016380.21231@router.home>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain> <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com> <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Dec 2011, Pekka Enberg wrote:

> To illustrate the issue, for "per cpu add" we have:
>
> __this_cpu_add()
> this_cpu_add()
> irqsafe_cpu_add()
> percpu_add()
>
> Why do we need all of them?

These are all operations that frequently occur in hot paths of the OS.

On x86 all variants map to the same instruction. These will be issueing
exactly one ASM instruction that is therefore irqsafe and preempt safe.
The single instruction will perform the relocation of the pointer relative
to the current cpu area and then perform the RMV operation without the
cost of an atomic operation.

For non-x86 we have the issue that typically separate instruction have to
be used to perform the relocation relative to the current per cpu area and
the RMW operation. The problem is that an interrupt or reschedule
operation can occur between the address calculation and the RMW operation.
The RMW operation may occur on the wrong processors per cpu
data. So we need some way of preventing the change of processors or
interrupts.

The __this_cpu_add() variant simply does nothing to prevent this. Just
assumes that the caller has taken a lock or disabling interrupts that
provides sufficient measures to prevent the rescheduling on a different
processor.

The this_cpu_add() variant disables preemption, then does the operations
and then reenables preemption. This is usually sufficient since most per
cpu data is not accessed from an interrupt context.

The irqsafe_cpu_add() variant disables interrupts, does the operations and
then reenabled interrupts. It is needed if counters etc are modified from
an interrupt context.

percpu_add() is an older variant of the per cpu operations that is (or
was?) x86 specific. this_cpu_xxx() operations are used in core code.
