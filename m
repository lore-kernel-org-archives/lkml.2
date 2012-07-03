Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab2GCTNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:13:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47764 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab2GCTNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:13:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120703185808.GM11413@one.firstfloor.org>
References: <20120702224648.GA20361@tassilo.jf.intel.com> <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com>
 <1341323230.3292.10.camel@nayuki.kepstin.ca> <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com>
 <1341337257.2406.1.camel@nayuki.kepstin.ca> <CA+55aFzOD33eWj0FQuZ7RWmF-yYwaeNB-9J-YY+mX4mwP7VXuA@mail.gmail.com>
 <CA+55aFwQqTAHNafGBXaoPCzVYw83OZvbG_hOYEDUxmuoMODO3Q@mail.gmail.com>
 <alpine.LNX.2.00.1207032008350.17304@pobox.suse.cz> <20120703185808.GM11413@one.firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jul 2012 12:12:53 -0700
X-Google-Sender-Auth: uLhUbmD4QYXtC9RfW9dYAvEspvk
Message-ID: <CA+55aFzFQiYhJcBfGD7moL3gC-ocwXJ2-kTjuNrw5hBGGbz4ag@mail.gmail.com>
Subject: Re: long boot delays caused by 070ad7e7 floppy change
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Calvin Walton <calvin.walton@kepstin.ca>,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 11:58 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> [    2.496493] calling  floppy_init+0x0/0xe46 @ 1
> [    2.511303] floppy0: lock_fdc: -1 (out of 8)
> [    2.511346] floppy0: __reschedule_timeout: setting timeout to 750

Ahhah. And you have CONFIG_HZ250 set, don't you?

So it's actually asking for a 3-second timeout like it should.

> [    2.511372] floppy0: reschedule timeout lock fdc
> [   22.501757] floppy0: reschedule timeout do wakeup

But that actual timeout is too damn reliably pretty much exactly 20s
for it to be anything else.

I wonder if 'fd_timeout' had been previously queued already with the
20s timeout, and not canceled. So then the new queuing of a 3-second
timeout doesn't actually do anything, because the
WORK_STRUCT_PENDING_BIT is still set.

So maybe we're missing a cancel somewhere.

What happens if you add a

        cancel_delayed_work(&fd_timeout);

to before the queue_delayed_work() in __reschedule_timeout()? Does
that possibly make the delay really be 3 seconds?

                   Linus
