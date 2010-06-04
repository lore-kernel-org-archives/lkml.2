Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab0FDG5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 02:57:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53233 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab0FDG5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 02:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H04dgalp7Fl8yiDUyDP4WLal0YYceiHDQ9krOJDCWKfpYsHqD8RzaD5ifEv0BJpKbL
         p//OHCK3kS/45EdZSLUgmS+g7zHnzn5va3qUKYxRdl4Y3E/m5dHRcdqJy60PF0e8BKaP
         mLPAbzwAie+8hpo4KNvVSukMFgfgP9OneAmWc=
Date: Thu, 3 Jun 2010 23:56:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/4] input: Introduce buflock, a one-to-many circular
 buffer mechanism
Message-ID: <20100604065658.GE21239@core.coreip.homeip.net>
References: <1275552062-8153-1-git-send-email-rydberg@euromail.se>
 <1275552062-8153-2-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275552062-8153-2-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Thu, Jun 03, 2010 at 10:00:59AM +0200, Henrik Rydberg wrote:
> In spite of the many lock patterns and fifo helpers in the kernel, the
> case of a single writer feeding many readers via a circular buffer
> seems to be uncovered. This patch adds the buflock, a minimalistic
> interface implementing SMP-safe locking for such a buffer. Under
> normal operation, given adequate buffer size, the operation is
> lock-less. The template is given the name buflock to emphasize that
> the locking depends on the buffer read/write clashes.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/input/buflock.h |  133 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 133 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/buflock.h
> 
> diff --git a/drivers/input/buflock.h b/drivers/input/buflock.h
> new file mode 100644
> index 0000000..3a4322c
> --- /dev/null
> +++ b/drivers/input/buflock.h
> @@ -0,0 +1,133 @@
> +#ifndef _BUFLOCK_H
> +#define _BUFLOCK_H
> +/*
> + * Circular buffer lock for single writer, multiple readers
> + *
> + * Copyright (c) 2010 Henrik Rydberg
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +/*
> + * Mechanism for circular buffer locking:
> + *
> + * Single writer does not block.
> + *
> + * Readers block on buffer wrap-around only.
> + *
> + * These locks are particularly suitable when a single writer must not
> + * be starved, and when there are several threads reading the same buffer.
> + *
> + * The structure is similar to seqlocks, with the main difference being
> + * that readers retry only when the writer simultaneously overwrites the
> + * data currently being read.
> + *
> + * In practise, given enough buffer size, the mechanism is lock-less.
> + *
> + * Like seqlocks, buflocks are not very cache friendly, and require the
> + * buffer to be valid in all threads.
> + *
> + * Multiple writers or re-entrant readers require additional locking.
> + *
> + */
> +
> +#include <linux/spinlock.h>
> +
> +struct buflock_writer {
> +	unsigned int head;
> +	unsigned int next_head;
> +};

Since there can be only one writer thread should we just create "struct
buflock" and pull head and next head into it along with the buffer
itself and element size?

Also, maybe we could extend kfifo with the notion of multiple readers?

In any case, it shoudl not live in include/linux/input/ as it may be
useful ouside of input subsystem.

> +
> +struct buflock_reader {
> +	unsigned int head;
> +	unsigned int tail;
> +};
> +
> +/*
> + * Write to buffer without locking

Implies that there is an option of doing so with locking. Juts change to
write. Also please use standard kerneldoc-style markups.

> + *
> + * bw - the buflock_writer keeping track of the write position
> + * buf - the buffer to write to (array of item type)
> + * size - the size of the circular buffer (must be a power of two)
> + * item - the item to write
> + *
> + * There is no locking involved during write, so this method is
> + * suitable to use in interrupt context.

This is a misleading statement. You can say that this operation does not
sleep and thus is suitable for use in atomic contexts.

> + */
> +#define buflock_write(bw, buf, size, item)				\
> +	do {								\
> +		bw.next_head = (bw.head + 1) & ((size) - 1);		\
> +		smp_wmb();						\

Why do we need the write barrier here?

> +		buf[bw.head] = item;					\
> +		smp_wmb();						\

I think this is the only barrier that is needed. You want to make sure
that we advance head only after we complete write. Also, why SMP only?
Can't we get into trouble if we rearrange writes and take interrupt and
schedule away from this thread?

> +		bw.head = bw.next_head;					\
> +		smp_wmb();						\

Why do we need the write barrier here?

> +	} while (0)
> +

This (and the rest) should be a static inline function so that we have
type safety, etc, etc.

> +
> +/*
> + * Syncronize reader with current writer
> + *
> + * br - the buflock_reader keeping track of the read position
> + * bw - the buflock_writer keeping track of the write position
> + *
> + * Synchronize the reader head with the writer head, effectively
> + * telling the reader thread that there is new data to read.
> + *
> + * The reader head will always follow the writer head. As a
> + * consequence, the number of items stored in the read buffer might
> + * decrease during sync, as an effect of wrap-around. To avoid
> + * non-deterministic behavior during polls, the read buffer is
> + * guaranteed to be non-empty after synchronization.
> + *
> + */
> +#define buflock_sync_reader(br, bw)				\
> +	do {							\
> +		if (br.tail != bw.head)				\
> +			br.head = bw.head;			\

Why condition? Simple assignment is cheaper.

> +	} while (0)
> +
> +/*
> + * True if reader is empty
> + *
> + * br - the buflock_reader keeping track of the read position
> + *
> + */
> +#define buflock_reader_empty(br) (br.head == br.tail)
> +
> +/*
> + * Read from buffer, retry during wrap-around
> + *
> + * br - the buflock_reader keeping track of the read position
> + * bw - the buflock_writer keeping track of the write position
> + * buf - the buffer to read from (array of item type)
> + * size - the size of the circular buffer (must be a power of two)
> + * item - the item to read to
> + *
> + * Read the oldest item available in the buffer.
> + *
> + * During normal operation, with adequate buffer size, this method will not
> + * block, regardless of the number of concurrent readers. The method will
> + * only block momentarily during a write to the same position being read
> + * from, which happens when the buffer gets full. In such cases, the value
> + * eventually read will be the new value written to the buffer.
> + *
> + */
> +#define buflock_read(br, bw, buf, size, item)				\
> +	do {								\
> +		unsigned int _h, _nh;					\
> +		do {							\
> +			_h = bw.head;					\
> +			smp_rmb();					\
> +			item = buf[br.tail];				\
> +			smp_rmb();					\
> +			_nh = bw.next_head;				\
> +			smp_rmb();					\
> +		} while (unlikely(br.tail - _h < _nh - _h));		\
> +		br.tail = (br.tail + 1) & ((size) - 1);			\
> +	} while (0)

Again, are we sure we need all these barriers? Spinlock may end up less
expensive... Anyway, Oleg Nesterov knows more than anyone about data
coherency issues (CCed).

-- 
Dmitry
