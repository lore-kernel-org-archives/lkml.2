Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab2GCUGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 16:06:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55133 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2GCUGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 16:06:13 -0400
MIME-Version: 1.0
In-Reply-To: <1341344200.2413.4.camel@nayuki.kepstin.ca>
References: <20120702224648.GA20361@tassilo.jf.intel.com> <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com>
 <1341323230.3292.10.camel@nayuki.kepstin.ca> <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com>
 <1341337257.2406.1.camel@nayuki.kepstin.ca> <CA+55aFzOD33eWj0FQuZ7RWmF-yYwaeNB-9J-YY+mX4mwP7VXuA@mail.gmail.com>
 <CA+55aFwQqTAHNafGBXaoPCzVYw83OZvbG_hOYEDUxmuoMODO3Q@mail.gmail.com>
 <alpine.LNX.2.00.1207032008350.17304@pobox.suse.cz> <20120703185808.GM11413@one.firstfloor.org>
 <CA+55aFzFQiYhJcBfGD7moL3gC-ocwXJ2-kTjuNrw5hBGGbz4ag@mail.gmail.com> <1341344200.2413.4.camel@nayuki.kepstin.ca>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jul 2012 13:05:51 -0700
X-Google-Sender-Auth: q-dAeYAOH7_md7pBlsft1EQoHoo
Message-ID: <CA+55aFzn+dW+Aj5T_vVP3XG3n3P+7mqJwGQLsWY14yEwduku5Q@mail.gmail.com>
Subject: Re: long boot delays caused by 070ad7e7 floppy change
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 12:36 PM, Calvin Walton <calvin.walton@kepstin.ca> wrote:
> On Tue, 2012-07-03 at 12:12 -0700, Linus Torvalds wrote:
>> What happens if you add a
>>
>>         cancel_delayed_work(&fd_timeout);
>>
>> to before the queue_delayed_work() in __reschedule_timeout()? Does
>> that possibly make the delay really be 3 seconds?
>
> Yes, it does...

Ok. And I see the previous timeout - it's this:

        reschedule_timeout(MAXTIMEOUT, "floppy init");

that sets the fd_timeout to 20 seconds initially.

That whole fd_timeout code is broken, though. I'm not sure what the
floppy init timeout is supposed to do, when the floppy reset code
wants to re-use it.

And yes, the 3-second timeout is still too long.

Doing it asynchronously like Andi does helps a bit, but I suspect we
could make the reset timeout shorter still just to make the initial
"you don't have a floppy drive" code go faster.

That said, why even compile in the floppy driver any more? Even if you
have the hardware, it probably doesn't work after ten years of
gathering dust. Those floppy drives weren't exactly reliable even back
in the days..

Anyway, I looked up the 82078 docs for reset. Holding the reset low
*does* cause an interrupt, but I'm not finding how long the reset
might take. But for the controller it really should be milliseconds,
not seconds, I suspect. Can anybody find the appropriate reset
timeout?

                 Linus
