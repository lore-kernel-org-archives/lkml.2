Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0FDInq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:43:46 -0400
Received: from csmtp2.one.com ([91.198.169.22]:50295 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab0FDInn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:43:43 -0400
Message-ID: <4C08BCB5.7020201@bitmath.org>
Date: Fri, 04 Jun 2010 10:43:33 +0200
From: Henrik Rydberg <rydberg@bitmath.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/4] input: Introduce buflock, a one-to-many circular
 buffer mechanism
References: <1275552062-8153-1-git-send-email-rydberg@euromail.se> <1275552062-8153-2-git-send-email-rydberg@euromail.se> <20100604065658.GE21239@core.coreip.homeip.net>
In-Reply-To: <20100604065658.GE21239@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,
>> +struct buflock_writer {
>> +	unsigned int head;
>> +	unsigned int next_head;
>> +};
> 
> Since there can be only one writer thread should we just create "struct
> buflock" and pull head and next head into it along with the buffer
> itself and element size?

It is possible, but there are some arguments against it:

1. What type to give the buffer?
2. Static or dynamic buffering?
3. Can size be both a compile-time constant and a variable?

In short, I think that by _not_ including the actual buffer, the method
ultimately becomes more useful.

> Also, maybe we could extend kfifo with the notion of multiple readers?

If merging the data and algorithm as you suggest, that would be a logical step,
yes. To me, the most ideal would be to modify split the kfifo into data, writers
and readers. But that would require api changes.

> 
> In any case, it shoudl not live in include/linux/input/ as it may be
> useful ouside of input subsystem.

Agreed.

> 
>> +
>> +struct buflock_reader {
>> +	unsigned int head;
>> +	unsigned int tail;
>> +};
>> +
>> +/*
>> + * Write to buffer without locking
> 
> Implies that there is an option of doing so with locking. Juts change to
> write. Also please use standard kerneldoc-style markups.

Ok.

> 
>> + *
>> + * bw - the buflock_writer keeping track of the write position
>> + * buf - the buffer to write to (array of item type)
>> + * size - the size of the circular buffer (must be a power of two)
>> + * item - the item to write
>> + *
>> + * There is no locking involved during write, so this method is
>> + * suitable to use in interrupt context.
> 
> This is a misleading statement. You can say that this operation does not
> sleep and thus is suitable for use in atomic contexts.

Ok.

> 
>> + */
>> +#define buflock_write(bw, buf, size, item)				\
>> +	do {								\
>> +		bw.next_head = (bw.head + 1) & ((size) - 1);		\
>> +		smp_wmb();						\
> 
> Why do we need the write barrier here?

   reader_loads_next_head
    -> interrupt modifying next_head then the buffer then the head
   reader_loads_buffer
   reader_loads_head

In this scenario, the reader ends up seeing next_head < head, but the position
written was next_head. The reader will get a false picture of which portion of
the buffer was modified.

> 
>> +		buf[bw.head] = item;					\
>> +		smp_wmb();						\
> 
> I think this is the only barrier that is needed. You want to make sure
> that we advance head only after we complete write. Also, why SMP only?
> Can't we get into trouble if we rearrange writes and take interrupt and
> schedule away from this thread?

This would be true for a single-reader fifo, if we do not care about what
happens when the buffer wraps around. Regarding reordering, my impression was
that this cannot happen across smp_wmb(), but I might very well be wrong.

> 
>> +		bw.head = bw.next_head;					\
>> +		smp_wmb();						\
> 
> Why do we need the write barrier here?

This is following the pattern of seqlocks. My understanding is that since we
will later rely on head being written, the last smp_wmb() is "for the road".

> 
>> +	} while (0)
>> +
> 
> This (and the rest) should be a static inline function so that we have
> type safety, etc, etc.

And this is precisely what I wanted to avoid by not including the buffer in the
buflock structures.

> 
>> +
>> +/*
>> + * Syncronize reader with current writer
>> + *
>> + * br - the buflock_reader keeping track of the read position
>> + * bw - the buflock_writer keeping track of the write position
>> + *
>> + * Synchronize the reader head with the writer head, effectively
>> + * telling the reader thread that there is new data to read.
>> + *
>> + * The reader head will always follow the writer head. As a
>> + * consequence, the number of items stored in the read buffer might
>> + * decrease during sync, as an effect of wrap-around. To avoid
>> + * non-deterministic behavior during polls, the read buffer is
>> + * guaranteed to be non-empty after synchronization.
>> + *
>> + */
>> +#define buflock_sync_reader(br, bw)				\
>> +	do {							\
>> +		if (br.tail != bw.head)				\
>> +			br.head = bw.head;			\
> 
> Why condition? Simple assignment is cheaper.

The condition takes care of a problem that is present also in the current evdev
code: When the buffer is very small and wraps around a lot, it may well be that
a write increases the head so that head == tail. If this happens between a point
where a poll is triggered and the actual data being read, there will be no data
to read. In an application like "cat", this will close the file and the program
will exit.

By ensuring that the writer never creates a situation where head == tail, this
problem is avoided.

> 
>> +	} while (0)
>> +
>> +/*
>> + * True if reader is empty
>> + *
>> + * br - the buflock_reader keeping track of the read position
>> + *
>> + */
>> +#define buflock_reader_empty(br) (br.head == br.tail)
>> +
>> +/*
>> + * Read from buffer, retry during wrap-around
>> + *
>> + * br - the buflock_reader keeping track of the read position
>> + * bw - the buflock_writer keeping track of the write position
>> + * buf - the buffer to read from (array of item type)
>> + * size - the size of the circular buffer (must be a power of two)
>> + * item - the item to read to
>> + *
>> + * Read the oldest item available in the buffer.
>> + *
>> + * During normal operation, with adequate buffer size, this method will not
>> + * block, regardless of the number of concurrent readers. The method will
>> + * only block momentarily during a write to the same position being read
>> + * from, which happens when the buffer gets full. In such cases, the value
>> + * eventually read will be the new value written to the buffer.
>> + *
>> + */
>> +#define buflock_read(br, bw, buf, size, item)				\
>> +	do {								\
>> +		unsigned int _h, _nh;					\
>> +		do {							\
>> +			_h = bw.head;					\
>> +			smp_rmb();					\
>> +			item = buf[br.tail];				\
>> +			smp_rmb();					\
>> +			_nh = bw.next_head;				\
>> +			smp_rmb();					\
>> +		} while (unlikely(br.tail - _h < _nh - _h));		\
>> +		br.tail = (br.tail + 1) & ((size) - 1);			\
>> +	} while (0)
> 
> Again, are we sure we need all these barriers? Spinlock may end up less
> expensive... Anyway, Oleg Nesterov knows more than anyone about data
> coherency issues (CCed).

These barriers I am less certain of, so additional eyes would be very helpful.

Thanks,
Henrik

