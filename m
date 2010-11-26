Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab0KZULu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 15:11:50 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33160 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab0KZULt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 15:11:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Tb7RsTbhwi/Ux/fwNrurFNRmwaD/rWuvuuRmuV2m3BLHbgpZehwCz3ImxHp2SMi37A
         TQVXwMPVn9iqVg+uUPDKX8Zl+QPNHB213zNhLEdzhA8YUXEWRs6saMEqL/Up1O2VGhBk
         1YBb2Do81F2i372cEjvUMQ7VdicxY5geyQaIA=
Date: Fri, 26 Nov 2010 23:11:43 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        ming.m.lin@intel.com, peterz@infradead.org
Subject: Re: [rfc 1/3] perf, x86: P4 PMU - describe config format
Message-ID: <20101126201143.GC5620@lenovo>
References: <AANLkTik1R-4kvoE81oqTrSm6RZdO005kL_xfbqfyrnFm@mail.gmail.com> <AANLkTi=1nxsKR2e9MAEzbPNt66TUD9Ltd+ug+C7Jhk+Y@mail.gmail.com> <AANLkTin63X+2pOuRYHF0ntnB95g-MWjug-sUYAFGFnxa@mail.gmail.com> <AANLkTikG9swqOxF2GwhvKY__Lbgt1+GgRfra-+DrBsk0@mail.gmail.com> <AANLkTi=jLNwKOqUKay9c9aLVd_7do5n1iCYEUkOfS7G+@mail.gmail.com> <AANLkTintEs9oM+UDzjymAMGfiYCBxPeEtY-NHA55s-Ge@mail.gmail.com> <20101126152744.GA5620@lenovo> <AANLkTikezMvVLD5vkB6OuLtPOMF1JZRyai09uhoWu=0n@mail.gmail.com> <20101126171642.GB5620@lenovo> <AANLkTi=3BqbTkn90s_fhs0v0tp04SCKTHR2XO1qrrjkW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=3BqbTkn90s_fhs0v0tp04SCKTHR2XO1qrrjkW@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 07:05:17PM +0100, Stephane Eranian wrote:
...
> >
> >  Stephane, could you do a test? We need a pinned event which would be
> > running on say cpu0 only and if you set P4_CCCR_THREAD_SINGLE in CCCR
> > and event would be still incrementing -- this mean my theory is correct
> > and this "thread" field means "when" to count, if not -- you're right
> > and "thread" field means "where" instead.
> >
> 
> I think we both agree that active_threads determines when to count
> in your thread based on what is going on in the other thread. It does
> not allow you to directly count the activity in the other thread (unlike
> .any).

 Stephane, perhaps I simply didn't understand you right in previous mails.
Yes, AT (active thread) specify "when" to count depending on logical
cpu activity.

> 
> Imagine you measure function foo() at 10k instr retired when running
> with HT off. You run the same function with HT on and set the mode to
> 10 (only when both). If you get a lower count, it means there was
> nothing going on on the other thread. If you get the same, then it
> means the other thread was busy all along. If you set it to 01 instead
> and get the same count, then you know the other thread was idle all
> along.

 Lets do some general overview first so you might check me ;)
The perf MSRs are shared across threads in core. And events may be either
Thread Independent [TI] (ie there is no way to qualify event affinity to
logical cpu, for example FSB bus activity events) and Thread Specific [TS]
(for example retirement of instructions which could be treated as associated
 with specific logical cpu).

 For TI events we require CAP_SYS_ADMIN and perf "paranoid" level to be
granted because this might be security issue (though at moment I can't
imagine how it's possible to abuse "FSB bus activity", but say for
"trace cache deliver mode" event you can specify /via ESCR mask/ to count
event when second logical cpu is in "build mode", not sure if it is
somehow being abused either).

 So logical cpu filtering is achieved via ESCR Tx bits, and when event
is scheduled-in to run on specific thread, we simply set proper Tx bits
on kernel level, the RAW events have no control over them.

 While with "TS events" the events are filtered according to on which cpu they
are happened I think there is no such way for TI events, and if event
say happened on cpu 1 but measured on cpu 0 and ESCR has T0_ bits set --
you'll observe events from another cpu (but, hey, we require the user
to have special rights to count such events, ie CAP_SYS_ADMIN and perf
"paranoid").

 For instr-retired example, we need to take into account that this
is a TS event and we set ESCR Tx's bits according to cpu on which we
executing, and when event "happens" on different cpu the Tx filer simply
drop such occurence. But what happens if we set "Active Thread" to 'single'
on such event -- it will be counted _only_ when cpu is running alone and
second cpu is in indle state.

> 
> The question is: does this present a security issue? Can you infer
> something about what is going on in the other thread. It is clear
> you can figure out when it did run or not. Is that any different
> than running top? I suspect not, so I think what you have is
> probably okay.
> 

 At moment I can't imagine any issue here.

  Cyrill
