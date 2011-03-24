Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab1CXQrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:47:21 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:45153 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1CXQrU convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:11:1>);
	Thu, 24 Mar 2011 12:47:20 -0400
Message-Id: <4D8B83DA02000078000381DE@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 24 Mar 2011 16:48:10 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Borislav Petkov" <bp@amd64.org>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Nick Piggin" <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Ingo Molnar" <mingo@redhat.com>, "Jack Steiner" <steiner@sgi.com>,
        <tee@sgi.com>, "Nikanth Karthikesan" <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in
	 test_and_set_bit_lock if possible
References: <201103241026.01624.knikanth@suse.de>
 <20110324085647.GI30812@elte.hu> <20110324145221.GC31194@aftab>
In-Reply-To: <20110324145221.GC31194@aftab>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.03.11 at 15:52, Borislav Petkov <bp@amd64.org> wrote:

(haven't seen Ingo's original reply, so responding here)

> On Thu, Mar 24, 2011 at 04:56:47AM -0400, Ingo Molnar wrote:
>> 
>> * Nikanth Karthikesan <knikanth@suse.de> wrote:
>> 
>> > On x86_64 SMP with lots of CPU atomic instructions which assert the LOCK #
>> > signal can stall other CPUs. And as the number of cores increase this 
> penalty
>> > scales proportionately. So it is best to try and avoid atomic instructions
>> > wherever possible. test_and_set_bit_lock() can avoid using LOCK_PREFIX if 
> it
>> > finds the bit set already.
>> > 
>> > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> [..]
> 
>> > + * test_and_set_bit_lock - Set a bit and return its old value for lock
>> > + * @nr: Bit to set
>> > + * @addr: Address to count from
>> > + *
>> > + * This is the same as test_and_set_bit on x86. But atomic operation is
>> > + * avoided, if the bit was already set.
>> > + */
>> > +static __always_inline int
>> > +test_and_set_bit_lock(int nr, volatile unsigned long *addr)
>> > +{
>> > +#ifdef CONFIG_SMP
>> > +	barrier();
>> > +	if (test_bit(nr, addr))
>> > +		return 1;
>> > +#endif
>> > +	return test_and_set_bit(nr, addr);
>> > +}
>>
>> On modern x86 CPUs there's no "#LOCK signal" anymore - it's replaced
>> by a M[O]ESI cache coherency bus. I'd expect modern x86 CPUs to be
>> pretty fast when the cacheline is local and the bit is set already.

Are you certain? Iirc the lock prefix implies minimally a read-for-
ownership (if CPUs are really smart enough to optimize away the
write - I wonder whether that would be correct at all when it
comes to locked operations), which means a cacheline can still be
bouncing heavily.

>> So you really need to back up your patch with actual hard numbers.
>> Putting this code into user-space and using pthreads to loop on
>> the same global variable and testing the before/after effect would
>> be sufficient i think. You can use 'perf stat --repeat 10' kind of
>> measurements to see whether there's any improvement larger than the
>> noise of the measurement.
> 
> and Ingo's question is right on the money - is this speedup noticeable
> or does it simply disappear in the noise?

This cacheline bouncing was actually observed and measured
on SGI UV systems, but I'm not certain we're permitted to publish
that data. I'm copying the two SGI guys who had reported that
issue (and the special case fix, which Nikanth simply generalized)
to us, for them to decide.

Jan

