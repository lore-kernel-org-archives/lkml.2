Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746Ab0KQKeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 05:34:46 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:57835 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933591Ab0KQKeo convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:12:1>);
	Wed, 17 Nov 2010 05:34:44 -0500
Message-Id: <4CE3BDCF0200007800022BF1@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 17 Nov 2010 10:34:39 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
        "Eric Dumazet" <dada1@cosmosbay.com>, <xiyou.wangcong@gmail.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Nick Piggin" <npiggin@kernel.dk>,
        "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
        "Linux Virtualization" <virtualization@lists.linux-foundation.org>,
        "Xen-devel" <xen-devel@lists.xensource.com>,
        "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
        "Avi Kivity" <avi@redhat.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [PATCH 09/14] xen/pvticketlock: Xen
	 implementation for PV ticket locks
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com><cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <aa32da076143b8e13c23c1f589d7e6cbedb22907.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <4CE39C3C0200007800022AE2@vpn.id2.novell.com> <4CE397E7.2010107@goop.org>
 <4CE3A714.9010509@goop.org>
In-Reply-To: <4CE3A714.9010509@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.11.10 at 10:57, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On 11/17/2010 12:52 AM, Jeremy Fitzhardinge wrote:
>> On 11/17/2010 12:11 AM, Jan Beulich wrote:
>>>>>> On 16.11.10 at 22:08, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>> +static void xen_lock_spinning(struct arch_spinlock *lock, unsigned want)
>>>>  {
>>>> -	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
>>>> -	struct xen_spinlock *prev;
>>>>  	int irq = __get_cpu_var(lock_kicker_irq);
>>>> -	int ret;
>>>> +	struct xen_lock_waiting *w = &__get_cpu_var(lock_waiting);
>>>> +	int cpu = smp_processor_id();
>>>>  	u64 start;
>>>>  
>>>>  	/* If kicker interrupts not initialized yet, just spin */
>>>>  	if (irq == -1)
>>>> -		return 0;
>>>> +		return;
>>>>  
>>>>  	start = spin_time_start();
>>>>  
>>>> -	/* announce we're spinning */
>>>> -	prev = spinning_lock(xl);
>>>> +	w->want = want;
>>>> +	w->lock = lock;
>>>> +
>>>> +	/* This uses set_bit, which atomic and therefore a barrier */
>>>> +	cpumask_set_cpu(cpu, &waiting_cpus);
>>> Since you don't allow nesting, don't you need to disable
>>> interrupts before you touch per-CPU state?
>> Yes, I think you're right - interrupts need to be disabled for the bulk
>> of this function.
> 
> Actually, on second thoughts, maybe it doesn't matter so much.  The main
> issue is making sure that the interrupt will make the VCPU drop out of
> xen_poll_irq() - if it happens before xen_poll_irq(), it should leave
> the event pending, which will cause the poll to return immediately.  I
> hope.  Certainly disabling interrupts for some of the function will make
> it easier to analyze with respect to interrupt nesting.

That's not my main concern. Instead, what if you get interrupted
anywhere here, the interrupt handler tries to acquire another
spinlock and also has to go into the slow path? It'll overwrite part
or all of the outer context's state.

> Another issue may be making sure the writes and reads of "w->want" and
> "w->lock" are ordered properly to make sure that xen_unlock_kick() never
> sees an inconsistent view of the (lock,want) tuple.  The risk being that
> xen_unlock_kick() sees a random, spurious (lock,want) pairing and sends
> the kick event to the wrong VCPU, leaving the deserving one hung.

Yes, proper operation sequence (and barriers) is certainly
required here. If you allowed nesting, this may even become
simpler (as you'd have a single write making visible the new
"head" pointer, after having written all relevant fields of the
new "head" structure).

Jan

