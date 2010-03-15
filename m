Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965141Ab0COO7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:59:50 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:59488 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965098Ab0COO7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:59:49 -0400
Date: Mon, 15 Mar 2010 10:58:00 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kfifo has temporarily invalid in pointer?
Message-ID: <alpine.LFD.2.00.1003151044590.8729@localhost>
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


  (i am not trying to be annoyingly obsessive about the kernel kfifo,
i am merely succeeding.)

  what appears to be a bit of an oddity WRT kfifo:  since a kfifo is
defined with a fixed buffer size, it obviously enqueues and dequeues
in a circular fashion.  so, the code to add some data to a kfifo (from
kernel/kfifo.c):

=====
unsigned int kfifo_in(struct kfifo *fifo, const void *from,
                                unsigned int len)
{
        len = min(kfifo_avail(fifo), len);

        __kfifo_in_data(fifo, from, len, 0);
        __kfifo_add_in(fifo, len);
        return len;
}
=====

 fair enough -- that first routine adds the data itself, while the
second one correspondingly bumps up the pointer, which could
conceivably wrap around to follow the data, correct?  but from
include/linux.kfifo.h:

=====
static inline void __kfifo_add_in(struct kfifo *fifo,
                                unsigned int off)
{
        smp_wmb();
        fifo->in += off;
}
=====

  note that there is no attempt to check for wraparound -- the new
value of "fifo->in" could (theoretically) be off the end of the
kfifo's buffer.  to make a long story short, when one subsequently
tries to *dequeue* data, one eventually invokes:

=====
static inline void __kfifo_out_data(struct kfifo *fifo,
                void *to, unsigned int len, unsigned int off)
{
        unsigned int l;

        /*
         * Ensure that we sample the fifo->in index -before- we
         * start removing bytes from the kfifo.
         */

        smp_rmb();

        off = __kfifo_off(fifo, fifo->out + off);   <----- there
        ... snip...
=====

where __kfifo_off is defined as:

=====
static inline unsigned int __kfifo_off(struct kfifo *fifo, unsigned int off)
{
        return off & (fifo->size - 1);
}
=====

which is clearly what takes a given offset and *now* adjusts it if it
represents a wraparound.

  but that seems to suggest that, between the time data is enqueued
which represents a circular wraparound and the time that data is
dequeued, the value of fifo->in is temporarily rubbish -- it might
have a value that's off the end of the kfifo buffer, no?

  admittedly, the code seems to work in that it always takes the above
into account, but it would seem to make a mess of debugging, since if
you were printing out the contents of a kfifo, you could conceivably
read a value of fifo->in that's larger than the buffer size.

  am i reading this correctly?  should i care?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
