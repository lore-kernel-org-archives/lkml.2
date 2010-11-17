Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab0KQPZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:25:37 -0500
Received: from claw.goop.org ([74.207.240.146]:52590 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758137Ab0KQPZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:25:36 -0500
Message-ID: <4CE3F3ED.2060501@goop.org>
Date: Wed, 17 Nov 2010 07:25:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Xen-devel <xen-devel@lists.xensource.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@novell.com>, Eric Dumazet <dada1@cosmosbay.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [Xen-devel] Re: [PATCH 13/14] x86/ticketlock: add slowpath logic
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>	<97ed99ae9160bdb6477284b333bd6708fb7a19cb.1289940821.git.jeremy.fitzhardinge@citrix.com> <1289996503.2109.728.camel@laptop>
In-Reply-To: <1289996503.2109.728.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 04:21 AM, Peter Zijlstra wrote:
> On Tue, 2010-11-16 at 13:08 -0800, Jeremy Fitzhardinge wrote:
>> Maintain a flag in both LSBs of the ticket lock which indicates whether
>> anyone is in the lock slowpath and may need kicking when the current
>> holder unlocks.  The flags are set when the first locker enters
>> the slowpath, and cleared when unlocking to an empty queue.
> So here you say you set both LSBs in order to keep head == tail working,
> but the code seems to suggest you only use the tail LSB.
>
> I think I see why using only one LSB is sufficient, but some consistency
> would be nice :-)

I tried that initially, but it turned out more messy.  The problem is
that the flag can change while you're spinning on the lock, so you need
to mask it out every time you read tail before you can compare it to
head; if head has the flag set too, you just need to mask it out of
there as well:

	ticket = xadd(lock, 2 << TICKET_SHIFT);
	ticket.tail &= ~TICKET_SLOW_FLAGS;

	while (ticket.head != ticket.tail) {
		relax();
		ticket.head = lock->head /* & ~TICKET_SLOW_FLAGS */;
	}

IOW setting both doesn't help anything, and just requires an extra mask
in the spin loop (and anywhere else that uses 'head').

And hey, extra bit.  Bound to be useful for something.

    J
