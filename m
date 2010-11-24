Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0KXVuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 16:50:13 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43794 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab0KXVuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 16:50:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UWkkydevPllEO6BDt+jAeh09kVe7fQV9OUtlOo0qrKNcbaI8FdXb5tpjIQsM+PisHg
         VhGuA3E8IomoUPsBb7NwqlShV93wcwRwDED8ixbnMi2T1wVU5Qmp4V/x9+zcsETaA3YG
         QSspkMYKVzSVdq77sbMl2pXIvj10kKO0cIpfk=
MIME-Version: 1.0
In-Reply-To: <20101124211937.GD8469@linux.vnet.ibm.com>
References: <AANLkTinFhEf1XVSRYuL+JL=JETLZ6cz3GYCR8CL3ex8X@mail.gmail.com>
	<20101124062212.GA2165@linux.vnet.ibm.com>
	<AANLkTimjZnAfeuAXU7oXPRG5=qJ2d7aZVoozSm88kXMT@mail.gmail.com>
	<20101124144240.GC2165@linux.vnet.ibm.com>
	<AANLkTi=EA09DACMNLUpTU8qH5wFPdXvOMQzJeejXX170@mail.gmail.com>
	<20101124161513.GA2207@linux.vnet.ibm.com>
	<AANLkTikbZUO6MbSC=uWYp4JRCdHPHrr5Z2_=to1YsC1X@mail.gmail.com>
	<20101124182051.GF2207@linux.vnet.ibm.com>
	<20101124202236.GA7989@linux.vnet.ibm.com>
	<AANLkTi=DmGiYK5r0cuzQkLFF3V4XaG=CGvcDh2S4M2t+@mail.gmail.com>
	<20101124211937.GD8469@linux.vnet.ibm.com>
Date: Wed, 24 Nov 2010 22:50:08 +0100
Message-ID: <AANLkTin_vEnzB61p24jUcK0uaZ6Od2-1RCWfka3W91US@mail.gmail.com>
Subject: Re: [PATCH 1/2] rcu: Don't chase unnecessary quiescent states after
 extended grace periods
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/24 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Wed, Nov 24, 2010 at 09:45:08PM +0100, Frederic Weisbecker wrote:
>> 2010/11/24 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
>> > I take it back.  I queued the following -- your code, but updated
>> > comment and commit message.  Please let me know if I missed anything.
>> >
>> >                                                        Thanx, Paul
>> >
>> > ------------------------------------------------------------------------
>> >
>> > commit 1d9d947bb882371a0877ba05207a0b996dcb38ee
>> > Author: Frederic Weisbecker <fweisbec@gmail.com>
>> > Date:   Wed Nov 24 01:31:12 2010 +0100
>> >
>> >    rcu: Don't chase unnecessary quiescent states after extended grace periods
>> >
>> >    When a CPU is in an extended quiescent state, including offline and
>> >    dyntick-idle mode, other CPUs will detect the extended quiescent state
>> >    and respond to the the current grace period on that CPU's behalf.
>> >    However, the locking design prevents those other CPUs from updating
>> >    the first CPU's rcu_data state.
>> >
>> >    Therefore, when this CPU exits its extended quiescent state, it must
>> >    update its rcu_data state.  Because such a CPU will usually check for
>> >    the completion of a prior grace period before checking for the start of a
>> >    new grace period, the rcu_data ->completed field will be updated before
>> >    the rcu_data ->gpnum field.  This means that if RCU is currently idle,
>> >    the CPU will usually enter __note_new_gpnum() with ->completed set to
>> >    the current grace-period number, but with ->gpnum set to some long-ago
>> >    grace period number.  Unfortunately, __note_new_gpnum() will then insist
>> >    that the current CPU needlessly check for a new quiescent state.  This
>> >    checking can result in this CPU needlessly taking several scheduling-clock
>> >    interrupts.
>>
>>
>> So I'm all ok for the commit and the comments updated. But just a doubt about
>> the about sentence.
>>
>> The effect seems more that there will be one extra softirq. But not an
>> extra tick
>> because before sleeping, the CPU will check rcu_needs_cpu() which
>> doesn't check for
>> the need of noting a quiescent state, IIRC...
>>
>> And I think the softirq will be only raised on the next tick.
>>
>> Hm?
>
> Good point!  This paragraph now reads:
>
>        Therefore, when this CPU exits its extended quiescent state,
>        it must update its rcu_data state.  Because such a CPU will
>        usually check for the completion of a prior grace period
>        before checking for the start of a new grace period, the
>        rcu_data ->completed field will be updated before the rcu_data
>        ->gpnum field.  This means that if RCU is currently idle, the
>        CPU will usually enter __note_new_gpnum() with ->completed set
>        to the current grace-period number, but with ->gpnum set to some
>        long-ago grace period number.  Unfortunately, __note_new_gpnum()
>        will then insist that the current CPU needlessly check for a new
>        quiescent state.  This checking can result in this CPU needlessly
>        taking an additional softirq for unnecessary RCU processing.
>
> Fair enough?


Perfect! :)

Thanks a lot!
