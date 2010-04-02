Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab0DBUuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 16:50:15 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:60072 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab0DBUuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 16:50:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Unnc6kg6RtFFuFYOD7wV5fW7B/S0hIWJPSB6eR8Y05WxRzMNx81zljvpbB0hdFLppM
         GdbLxvL6BZ7I3+etgna7Tg4FgasBGeqOMOeN+mOttw7Eq/Rc4/RSa8R1gevYy2CvNPVO
         S7N2BWhTkVOLCuDYz9b5K2CLQ2EEftzdB/4No=
MIME-Version: 1.0
In-Reply-To: <20100402201648.GA15498@elte.hu>
References: <b4198de61003282037p502e9fbfi62123088b9d73923@mail.gmail.com>
	 <1269858302.12097.272.camel@laptop> <20100402201648.GA15498@elte.hu>
Date: Fri, 2 Apr 2010 16:50:10 -0400
Message-ID: <g2rb4198de61004021350tf509b5c3k22dfa8f2e24fedc8@mail.gmail.com>
Subject: Re: Discrepancy between comments for sched_find_first_bit
From: Matt Turner <mattst88@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 2, 2010 at 4:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>> On Sun, 2010-03-28 at 23:37 -0400, Matt Turner wrote:
>> > include/asm-generic/bitops/sched.h says
>> > /*
>> >  * Every architecture must define this function. It's the fastest
>> >  * way of searching a 100-bit bitmap.  It's guaranteed that at least
>> >  * one of the 100 bits is cleared.
>> >  */
>> >
>> > arch/alpha/include/asm/bitops.h says
>> > /*
>> >  * Every architecture must define this function. It's the fastest
>> >  * way of searching a 140-bit bitmap where the first 100 bits are
>> >  * unlikely to be set. It's guaranteed that at least one of the 140
>> >  * bits is set.
>> >  */
>> >
>> > Is the guarantee that one of the first 100-bits set (and that the last
>> > 40 are useless?), or 140-bits? If it's just the first 100 bits we care
>> > about, then the alpha version needs to be fixed.
>> >
>> > I'm just checking this out, because gcc produces horrendous code for
>> > sched_find_first_bit on alpha. I rewrote it in assembly and it's
>> > better than 4 times faster.
>> >
>> > Also, is it even worth optimizing that function? It looks like it's
>> > only used in kernel/sched_rt.c.
>>
>> (might help if you CC the scheduler people on scheduler functions :-)
>>
>> Right, so it used to be 140 bits with the old O(1) scheduler, currently
>> (as you noted) sched_rt is the only user left and will therefore only
>> care about the first 100 bits.
>>
>> As it stands I think it might still make sense to optimize this as for
>> rt loads it still on a hot path.
>>
>> As to the 100 vs 140 length, would it really make much of difference to
>> shorten the implementation to 100? If not I'd leave it at 140.
>>
>> Ingo, any comments?
>
> I guess getting below the 128 bits boundary would shave an instruction and a
> branch off or so?
>
>        Ingo
>

That's right. I should be able to get rid of a cmov, which kind of
counts as two instructions in EV6 scheduling.

So I should send a patch to reduce this to the first 100 (128) bits?

Thanks guys,
Matt
