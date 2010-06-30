Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0F3Mx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 08:53:28 -0400
Received: from claw.goop.org ([74.207.240.146]:58638 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab0F3Mx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 08:53:27 -0400
Message-ID: <4C2B3E42.1070808@goop.org>
Date: Wed, 30 Jun 2010 14:53:22 +0200
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Ky Srinivasan <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 1/4, v2] x86: enlightenment for ticket spin locks -	 base
 implementation
References: <4C2A1FE902000078000089E1@vpn.id2.novell.com> <1277885133.1868.71.camel@laptop> <4C2B23CD0200007800008BFA@vpn.id2.novell.com> <1277889116.1868.95.camel@laptop> <4C2B2180.6040401@goop.org> <4C2B4C050200007800008CDB@vpn.id2.novell.com>
In-Reply-To: <4C2B4C050200007800008CDB@vpn.id2.novell.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 01:52 PM, Jan Beulich wrote:
> I fail to see that: Depending on the hypervisor's capabilities, the
> two main functions could be much smaller (potentially there wouldn't
> even be a need for the unlock hook in some cases),

What mechanism are you envisaging in that case?

>> That appears to be a mechanism to allow it to take interrupts while
>> spinning on the lock, which is something that stock ticket locks don't
>> allow.  If that's a useful thing to do, it should happen in the generic
>> ticketlock code rather than in the per-hypervisor backend (otherwise we
>> end up with all kinds of subtle differences in lock behaviour depending
>> on the exact environment, which is just going to be messy).  Even if
>> interrupts-while-spinning isn't useful on native hardware, it is going
>> to be equally applicable to all virtual environments.
>>     
> While we do interrupt re-enabling in our pv kernels, I intentionally
> didn't do this here - it complicates the code quite a bit further, and
> that did seem right for an initial submission.
>   

Ah, I was confused by this:
> +	/*
> +	 * If we interrupted another spinlock while it was blocking, make
> +	 * sure it doesn't block (again) without re-checking the lock.
> +	 */
> +	if (spinning.prev)
> +		sync_set_bit(percpu_read(poll_evtchn),
> +			     xen_shared_info->evtchn_pending);
> +
> +

> The list really juts is needed to not pointlessly tickle CPUs that
> won't own the just released lock next anyway (or would own
> it, but meanwhile went for another one where they also decided
> to go into polling mode).

Did you measure that it was a particularly common case which was worth
optimising for?

    J
