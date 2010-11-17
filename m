Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913Ab0KQIw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:52:57 -0500
Received: from claw.goop.org ([74.207.240.146]:36937 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758221Ab0KQIw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:52:56 -0500
Message-ID: <4CE397E7.2010107@goop.org>
Date: Wed, 17 Nov 2010 00:52:55 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Eric Dumazet <dada1@cosmosbay.com>, xiyou.wangcong@gmail.com,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Avi Kivity <avi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 09/14] xen/pvticketlock: Xen implementation for PV	 ticket
 locks
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com><cover.1289940821.git.jeremy.fitzhardinge@citrix.com> <aa32da076143b8e13c23c1f589d7e6cbedb22907.1289940821.git.jeremy.fitzhardinge@citrix.com> <4CE39C3C0200007800022AE2@vpn.id2.novell.com>
In-Reply-To: <4CE39C3C0200007800022AE2@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 12:11 AM, Jan Beulich wrote:
>>>> On 16.11.10 at 22:08, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> +static void xen_lock_spinning(struct arch_spinlock *lock, unsigned want)
>>  {
>> -	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
>> -	struct xen_spinlock *prev;
>>  	int irq = __get_cpu_var(lock_kicker_irq);
>> -	int ret;
>> +	struct xen_lock_waiting *w = &__get_cpu_var(lock_waiting);
>> +	int cpu = smp_processor_id();
>>  	u64 start;
>>  
>>  	/* If kicker interrupts not initialized yet, just spin */
>>  	if (irq == -1)
>> -		return 0;
>> +		return;
>>  
>>  	start = spin_time_start();
>>  
>> -	/* announce we're spinning */
>> -	prev = spinning_lock(xl);
>> +	w->want = want;
>> +	w->lock = lock;
>> +
>> +	/* This uses set_bit, which atomic and therefore a barrier */
>> +	cpumask_set_cpu(cpu, &waiting_cpus);
> Since you don't allow nesting, don't you need to disable
> interrupts before you touch per-CPU state?

Yes, I think you're right - interrupts need to be disabled for the bulk
of this function.

    J
