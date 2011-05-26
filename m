Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1EZOpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:45:43 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43641 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab1EZOpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=yFLTz4d3ezBNEwFOG/+xomSOlbEtAes5W3hxghE4g8a/yxqsEv1hzVklETsZV7szJX
         /9bjfuoYJIzbrLw3sH+2wZoYU2xE/ReI6s4SN7/XvLgYmexS9DBTILSBfkFrQ6tGPS+h
         BZzmTW9eLTIGqFUjlKkhA1q/D6QbcKO8TlN/o=
MIME-Version: 1.0
In-Reply-To: <20110526125007.GA27083@elte.hu>
References: <1306272750.2497.79.camel@laptop>
	<1306343335.21578.65.camel@twins>
	<1306358128.21578.107.camel@twins>
	<BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
	<1306405979.1200.63.camel@twins>
	<1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
	<1306409575.1200.71.camel@twins>
	<1306412511.1200.90.camel@twins>
	<20110526122623.GA11875@elte.hu>
	<20110526123137.GG24876@n2100.arm.linux.org.uk>
	<20110526125007.GA27083@elte.hu>
Date: Thu, 26 May 2011 15:45:39 +0100
X-Google-Sender-Auth: 7p3_rvIh7D2jjKagLa3BM1icWYE
Message-ID: <BANLkTinUZ7EwN_nBCi_RQ9u8-LBcr_A74g@mail.gmail.com>
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 May 2011 13:50, Ingo Molnar <mingo@elte.hu> wrote:
> * Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>
>> On Thu, May 26, 2011 at 02:26:23PM +0200, Ingo Molnar wrote:
>> >
>> > * Peter Zijlstra <peterz@infradead.org> wrote:
>> >
>> > > Sort this by reverting to the old behaviour for this situation
>> > > and perform a full remote wake-up.
>> >
>> > Btw., ARM should consider switching most of its subarchitectures
>> > to !__ARCH_WANT_INTERRUPTS_ON_CTXSW - enabling irqs during
>> > context switches is silly and now expensive as well.
>>
>> Not going to happen.  The reason we do it is because most of the
>> CPUs have to (slowly) flush their caches during switch_mm(), and to
>> have IRQs off over the cache flush means that we lose IRQs.
>
> How much time does that take on contemporary ARM hardware, typically
> (and worst-case)?

On newer ARMv6 and ARMv7 hardware, we no longer flush the caches at
context switch as we got VIPT (or PIPT-like) caches.

But modern ARM processors use something called ASID to tag the TLB
entries and we are limited to 256. The switch_mm() code checks for
whether we ran out of them to restart the counting. This ASID
roll-over event needs to be broadcast to the other CPUs and issuing
IPIs with the IRQs disabled isn't always safe. Of course, we could
briefly re-enable them at the ASID roll-over time but I'm not sure
what the expectations of the code calling switch_mm() are.

-- 
Catalin
