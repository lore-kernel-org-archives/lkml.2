Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936861Ab0COVYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:24:43 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:35014 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936852Ab0COVYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:24:41 -0400
Date: Mon, 15 Mar 2010 17:22:49 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kfifo:  possible weird violation of what should be invariant
Message-ID: <alpine.LFD.2.00.1003151702040.3329@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  since i may not have explained myself clearly the first time, let me
try again.  based on my perusal of the current implementation of the
kfifo code, it seems that there's a really strange and potentially
confusing violation of a property that really should be invariant, so
you can tell me if i'm out to lunch here.

  the actual definition of the structure kind of gives it away:

struct kfifo {
        unsigned char *buffer;  /* the buffer holding the data */
        unsigned int size;      /* the size of the allocated buffer */
        unsigned int in;        /* data is added at offset (in % size) */
        unsigned int out;       /* data is extracted from off. (out % size) */
};

  note the comments, which explain that the two offsets into the
allocated buffer need not actually lie in that range.  they could
potentially be larger, but must always be checked modulo the "size"
value.  why those two values aren't consistently checked and forced to
exist within the range [0 - buffer size-1] isn't at all clear, but it
seems that allowing them to, even temporarily, be outside the range
might make debugging more entertaining than it has to be.

  as a concrete example, consider once again the basic kfifo_in()
routine, which enqueues data to the kfifo:

unsigned int kfifo_in(struct kfifo *fifo, const void *from,
                                unsigned int len)
{
        len = min(kfifo_avail(fifo), len);

        __kfifo_in_data(fifo, from, len, 0);
        __kfifo_add_in(fifo, len);
        return len;
}

  the above makes perfect sense -- add the passed data to the current
offset of zero (relative to the "in" pointer), then immediately bump
up the "in" pointer to reflect the new available offset for enqueueing
more data.

  as i read it, the __kfifo_in_data() routine properly checks if you
need to wraparound, and will enqueue the data properly, taking the
possible wraparound into account.  but the subsequent __kfifo_add_in()
routine ignores possible wraparound entirely:

static inline void __kfifo_add_in(struct kfifo *fifo,
                                unsigned int off)
{
        smp_wmb();
        fifo->in += off;
}

  it simply adds the size of the enqueued data to the current fifo
"in" pointer, even if that forces it to exceed the size of the kfifo
buffer. in short, the new value of fifo->in is clearly nonsensical, is
it not?

  admittedly, that doesn't last long as the next time something is
enqueued or dequeued, there's a reference to __kfifo_off(), which
recalculates offset thusly:

static inline unsigned int __kfifo_off(struct kfifo *fifo, unsigned int off)
{
        return off & (fifo->size - 1);
}

  clearly, that performs the necessary module operation to reset
any offset back within the valid range but, in the meantime, for
however long it was between operations, the value of fifo->in is, as i
said, nonsensical.

  sure, the code seems to work, but allowing the internal values of a
kfifo to contain invalid values on a regular basis would seem to make
a mess of, say, tracing or debugging.  making sure that offset values
actually lie within their valid range would seem to be one of those
ASSERT() things that should always be true, should it not?  is there a
reason the design is like this?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
