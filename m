Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab0FDTP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 15:15:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab0FDTPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 15:15:25 -0400
Date: Fri, 4 Jun 2010 21:13:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Henrik Rydberg <rydberg@bitmath.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH 1/4] input: Introduce buflock, a one-to-many circular
	buffer mechanism
Message-ID: <20100604191308.GA10942@redhat.com>
References: <1275552062-8153-1-git-send-email-rydberg@euromail.se> <1275552062-8153-2-git-send-email-rydberg@euromail.se> <20100604065658.GE21239@core.coreip.homeip.net> <4C08BCB5.7020201@bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C08BCB5.7020201@bitmath.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04, Henrik Rydberg wrote:
>
> additional eyes would be very helpful

I am puzzled. I don't understand what this patch does at all ;)

Could you please provide a simple example or answer my questions?

> >> + * During normal operation, with adequate buffer size, this method will not
> >> + * block, regardless of the number of concurrent readers.

I don't understand this "regardless of the number of concurrent" comment.
buflock_read(br) modifies br.tail, it can't be used lockless.

Or, do you mean that every reader should use its own buflock_reader?

If yes. Afaics, we have one buflock_writer, and one buf "connected"
to this buflock_writer. In that case I don't understand why this
buf doesn't live in "struct buflock_writer", it can be char[].
This way both read/write macros do not need buf and size args.
typeof(item) could be used for read/write into this buf.

But still I can't understand how this all works.

> >> +#define buflock_read(br, bw, buf, size, item)			\
> >> +	do {								\
> >> +		unsigned int _h, _nh;					\
> >> +		do {							\
> >> +			_h = bw.head;					\
> >> +			smp_rmb();					\
> >> +			item = buf[br.tail];				\
> >> +			smp_rmb();					\
> >> +			_nh = bw.next_head;				\
> >> +			smp_rmb();					\
> >> +		} while (unlikely(br.tail - _h < _nh - _h));		\
> >> +		br.tail = (br.tail + 1) & ((size) - 1);			\
> >> +	} while (0)

How can the reader know there is something new/valid in buf it
can read?

I guess it should call buflock_sync_reader() at least once, to
"attach" to the writer/buf, and then check buflock_reader_empty() ?

But. If the reader calls buflock_read() constantly, sooner or
later buflock_reader_empty() becomes T again.

Probably the reader should call buflock_sync_reader() + check
buflock_reader_empty() == F every time before buflock_read() ?

In this case I do not understand why do we have 2 separate
helpers, and why do we need buflock_reader->head.

Perhaps it is writer who calls buflock_sync_reader() and tells
the reader it has the new data? In this case I do not understand
the "feeding many readers" part.



And in any case I do not understand which guarantees this API
provides.

Whatever we do, buflock_read() can race with the writer and read
the invalid item.

Suppose that buflock_read(br, item) gets the preemption "inside" of
item = buf[br.tail] asignment.

The writer calls buflock_write() SIZE times.

The reader resumes, continues its memcpy() operation, and suceeds.

But the "item" it returns is not consistent, it is neither the old
value nor the new.

No?

Oleg.

