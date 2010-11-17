Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888Ab0KQJ5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 04:57:43 -0500
Received: from claw.goop.org ([74.207.240.146]:38002 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab0KQJ5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 04:57:42 -0500
Message-ID: <4CE3A714.9010509@goop.org>
Date: Wed, 17 Nov 2010 01:57:40 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Nick Piggin <npiggin@kernel.dk>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Xen-devel <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, xiyou.wangcong@gmail.com,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [Xen-devel] Re: [PATCH 09/14] xen/pvticketlock: Xen implementation
 for PV	 ticket locks
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com><cover.1289940821.git.jeremy.fitzhardinge@citrix.com>	<aa32da076143b8e13c23c1f589d7e6cbedb22907.1289940821.git.jeremy.fitzhardinge@citrix.com>	<4CE39C3C0200007800022AE2@vpn.id2.novell.com> <4CE397E7.2010107@goop.org>
In-Reply-To: <4CE397E7.2010107@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 12:52 AM, Jeremy Fitzhardinge wrote:
> On 11/17/2010 12:11 AM, Jan Beulich wrote:
>>>>> On 16.11.10 at 22:08, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>> +static void xen_lock_spinning(struct arch_spinlock *lock, unsigned want)
>>>  {
>>> -	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
>>> -	struct xen_spinlock *prev;
>>>  	int irq = __get_cpu_var(lock_kicker_irq);
>>> -	int ret;
>>> +	struct xen_lock_waiting *w = &__get_cpu_var(lock_waiting);
>>> +	int cpu = smp_processor_id();
>>>  	u64 start;
>>>  
>>>  	/* If kicker interrupts not initialized yet, just spin */
>>>  	if (irq == -1)
>>> -		return 0;
>>> +		return;
>>>  
>>>  	start = spin_time_start();
>>>  
>>> -	/* announce we're spinning */
>>> -	prev = spinning_lock(xl);
>>> +	w->want = want;
>>> +	w->lock = lock;
>>> +
>>> +	/* This uses set_bit, which atomic and therefore a barrier */
>>> +	cpumask_set_cpu(cpu, &waiting_cpus);
>> Since you don't allow nesting, don't you need to disable
>> interrupts before you touch per-CPU state?
> Yes, I think you're right - interrupts need to be disabled for the bulk
> of this function.

Actually, on second thoughts, maybe it doesn't matter so much.  The main
issue is making sure that the interrupt will make the VCPU drop out of
xen_poll_irq() - if it happens before xen_poll_irq(), it should leave
the event pending, which will cause the poll to return immediately.  I
hope.  Certainly disabling interrupts for some of the function will make
it easier to analyze with respect to interrupt nesting.

Another issue may be making sure the writes and reads of "w->want" and
"w->lock" are ordered properly to make sure that xen_unlock_kick() never
sees an inconsistent view of the (lock,want) tuple.  The risk being that
xen_unlock_kick() sees a random, spurious (lock,want) pairing and sends
the kick event to the wrong VCPU, leaving the deserving one hung.

    J

