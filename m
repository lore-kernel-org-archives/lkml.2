Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3AJNH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:07:57 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:46416 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab3AJNHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:07:54 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2013 08:07:54 EST
MIME-Version: 1.0
In-Reply-To: <20130108173119.5e59fac2@annuminas.surriel.com>
References: <20130108172632.1126898a@annuminas.surriel.com>
	<20130108173119.5e59fac2@annuminas.surriel.com>
Date: Thu, 10 Jan 2013 05:01:24 -0800
Message-ID: <CANN689H1eb_h-eX3wiEMczrA9hrX7C9zgwWzg0N7w_UcHHA2MA@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86,smp: keep spinlock delay values per hashed
 spinlock address
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 2:31 PM, Rik van Riel <riel@redhat.com> wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
>
> Eric Dumazet found a regression with the first version of the spinlock
> backoff code, in a workload where multiple spinlocks were contended,
> each having a different wait time.
>
> This patch has multiple delay values per cpu, indexed on a hash
> of the lock address, to avoid that problem.
>
> Eric Dumazet wrote:
>
> I did some tests with your patches with following configuration :
>
> tc qdisc add dev eth0 root htb r2q 1000 default 3
> (to force a contention on qdisc lock, even with a multi queue net
> device)
>
> and 24 concurrent "netperf -t UDP_STREAM -H other_machine -- -m 128"
>
> Machine : 2 Intel(R) Xeon(R) CPU X5660  @ 2.80GHz
> (24 threads), and a fast NIC (10Gbps)
>
> Resulting in a 13 % regression (676 Mbits -> 595 Mbits)
>
> In this workload we have at least two contended spinlocks, with
> different delays. (spinlocks are not held for the same duration)
>
> It clearly defeats your assumption of a single per cpu delay being OK :
> Some cpus are spinning too long while the lock was released.
>
> We might try to use a hash on lock address, and an array of 16 different
> delays so that different spinlocks have a chance of not sharing the same
> delay.
>
> With following patch, I get 982 Mbits/s with same bench, so an increase
> of 45 % instead of a 13 % regression.

Note that these results were with your v1 proposal. With v3 proposal,
on a slightly different machine (2 socket sandybridge) with a similar
NIC, I am not seeing the regression when not using the hash table. I
think this is because v3 got more conservative about mixed spinlock
hold times, and converges towards the shortest of the hold times in
that case.

> -       unsigned delay = __this_cpu_read(spinlock_delay);
> +       u32 hash = hash32_ptr(lock);
> +       u32 slot = hash_32(hash, DELAY_HASH_SHIFT);
> +       struct delay_entry *ent = &__get_cpu_var(spinlock_delay[slot]);
> +       u32 delay = (ent->hash == hash) ? ent->delay : MIN_SPINLOCK_DELAY;

I think we should actually always use ent->delay here. My reasoning is
that I think the base algorithm (from the previous patch) should have
robustness against mixed spinlock hold times. We can't rely on
detecting hash collisions to protect us against varying hold times,
because this case could happen even with a single spinlock. So we need
to make sure the base algorithm is robust and converges towards using
the shorter of the spinlock hold times; if we have that then forcing a
reset to MIN_SPINLOCK_DELAY only hurts since it reduces the delay
below what is otherwise necessary.


Other than that:
Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
