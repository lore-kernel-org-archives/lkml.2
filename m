Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0FDTnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 15:43:20 -0400
Received: from csmtp3.one.com ([91.198.169.23]:46679 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab0FDTnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 15:43:18 -0400
Message-ID: <4C09574B.3030807@bitmath.org>
Date: Fri, 04 Jun 2010 21:43:07 +0200
From: Henrik Rydberg <rydberg@bitmath.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH 1/4] input: Introduce buflock, a one-to-many circular
 buffer mechanism
References: <1275552062-8153-1-git-send-email-rydberg@euromail.se> <1275552062-8153-2-git-send-email-rydberg@euromail.se> <20100604065658.GE21239@core.coreip.homeip.net> <4C08BCB5.7020201@bitmath.org> <20100604191308.GA10942@redhat.com>
In-Reply-To: <20100604191308.GA10942@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

Thank you very much for looking at this.

> I am puzzled. I don't understand what this patch does at all ;)
> 
> Could you please provide a simple example or answer my questions?

I will do my best. It seem you figured out most of it even without the evdev
example for which it was created. But additional usage documentation ought to be
in place, in other words. Noted.

>>>> + * During normal operation, with adequate buffer size, this method will not
>>>> + * block, regardless of the number of concurrent readers.
> 
> I don't understand this "regardless of the number of concurrent" comment.
> buflock_read(br) modifies br.tail, it can't be used lockless.
> 
> Or, do you mean that every reader should use its own buflock_reader?

Yes.

> If yes. Afaics, we have one buflock_writer, and one buf "connected"
> to this buflock_writer. In that case I don't understand why this
> buf doesn't live in "struct buflock_writer", it can be char[].
> This way both read/write macros do not need buf and size args.
> typeof(item) could be used for read/write into this buf.

Both Dmitry and yourself say the same thing here, also noted. If looking for an
explanation anyways, it would go something like "do not automatically put things
together if not absolutely necessary".

> But still I can't understand how this all works.
> 
>>>> +#define buflock_read(br, bw, buf, size, item)			\
>>>> +	do {								\
>>>> +		unsigned int _h, _nh;					\
>>>> +		do {							\
>>>> +			_h = bw.head;					\
>>>> +			smp_rmb();					\
>>>> +			item = buf[br.tail];				\
>>>> +			smp_rmb();					\
>>>> +			_nh = bw.next_head;				\
>>>> +			smp_rmb();					\
>>>> +		} while (unlikely(br.tail - _h < _nh - _h));		\
>>>> +		br.tail = (br.tail + 1) & ((size) - 1);			\
>>>> +	} while (0)
> 
> How can the reader know there is something new/valid in buf it
> can read?
> 
> I guess it should call buflock_sync_reader() at least once, to
> "attach" to the writer/buf, and then check buflock_reader_empty() ?
> 
> But. If the reader calls buflock_read() constantly, sooner or
> later buflock_reader_empty() becomes T again.
> 
> Probably the reader should call buflock_sync_reader() + check
> buflock_reader_empty() == F every time before buflock_read() ?
> 
> In this case I do not understand why do we have 2 separate
> helpers, and why do we need buflock_reader->head.
> 
> Perhaps it is writer who calls buflock_sync_reader() and tells
> the reader it has the new data? In this case I do not understand
> the "feeding many readers" part.

Yes, the writer thread "synchronizes" the readers. Having separate reader/writer
heads helps minimizing the contact area between threads. There is also a
practical reason, in that the writer is able to choose which readers should get
data. In the input layer, this maps to the notion of grabbing a device.
Admittedly a bit of a special case.

> And in any case I do not understand which guarantees this API
> provides.
> 
> Whatever we do, buflock_read() can race with the writer and read
> the invalid item.

Yep.

> Suppose that buflock_read(br, item) gets the preemption "inside" of
> item = buf[br.tail] asignment.
> 
> The writer calls buflock_write() SIZE times.
> 
> The reader resumes, continues its memcpy() operation, and suceeds.
> 
> But the "item" it returns is not consistent, it is neither the old
> value nor the new.

True. However, one could argue this is a highly unlikely case given the
(current) usage. Or, one could remedy it by not wrapping the indexes modulo SIZE.

> 
> No?

Yes. :-)

Regarding the barriers used in the code, would it be possible to get a picture
of exactly how bad those operations are for performance? Is it true that a
simple spinlock might be faster on average, for instance? Do you see any other
solutions?

Thanks,
Henrik

