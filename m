Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0HXInu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:43:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:51102 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab0HXInr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:43:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,262,1280732400"; 
   d="scan'208";a="599610253"
Subject: Re: [RFC -v2] kfifo writer side lock-less support
From: Huang Ying <ying.huang@intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1282636558.7357.28.camel@wall-e.seibold.net>
References: <1282614146.2708.13.camel@yhuang-dev>
	 <1282636558.7357.28.camel@wall-e.seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 16:43:45 +0800
Message-ID: <1282639425.2708.40.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 15:55 +0800, Stefani Seibold wrote:
> Hi Huang,
> 
> Am Dienstag, den 24.08.2010, 09:42 +0800 schrieb Huang Ying:
> > Hi, Stefani,
> > 
> > The sample code is attached with the mail too. If it is necessary, I
> > can put the sample code into samples/kfifo directory if the basic
> > idea of the patch is accepted.
> > 
> 
> The samples use a own implementation of a record handling. Please use
> the one provided by the kfifo API.
> 
> > This patch add lock-less support for kfifo writer side amongst
> > different contexts on one CPU, such as NMI, IRQ, soft_irq, process,
> > etc. This makes kfifo can be used to implement per-CPU lock-less data
> > structure.
> > 
> > The different contexts on one CPU have some kind of preemption
> > priority as follow:
> > 
> > process -> soft_irq -> IRQ -> NMI
> > 
> > Where preemption priority increases from left to right. That is, the
> > right side context can preempt left side context, but not in the
> > reverse direction, that means the right side context will run to the
> > end before return to the left side context. The lock-less algorithm
> > used in the patch take advantage of this.
> > 
> > The algorithm works in reserve/commit style, where "reserve" only
> > allocate the space, while "commit" really makes the data into buffer,
> > data is prepared in between. cmpxchg is used in "reserve", this
> > guarantees different spaces will be allocated for different
> > contexts. Only the "commit" in lowest context will commit all
> > allocated spaces. Because all contexts preempting lowest context
> > between "reserve" and "commit" will run to the end, all data put into
> > buffer are valid.
> > 
> 
> I don't like it, because it handles a very rare use case. The batch is
> bloating the code of the fifo API and the macros, so user of this get
> also an increase of the code size. most and increase the size of the
> kfifo structure. Most of the user, i think more than 99 percent will not
> need it.

The patch adds only 1 field (unsigned int) to struct __kfifo. I think
that should be acceptable. Because sizeof(struct __kfifo) should be much
smaller that __kfifo->mask + 1 in most cases.

For macros, only INIT_KFIFO, kfifo_reset and kfifo_put is enlarged a
little (one instruction?).

And yes, I added some new functions and macros. But if I implement
another ring buffer instead of making kfifo lock-less (for multiple
writers), I need to implement more functions and macros, the code size
increment will be larger, isn't it?

> And there a lot of bugs on a first small review.
> 
> Your kfifo_skip_len does not handle record fifos. User of kfifo_put,
> kfifo_avail will get an increased code size. Your kfifo_is_full isn't
> longer working correctly. You did not fixed kfifo_in(), so this function
> will not work. And so on....

After we reach the consensus on the general idea, we can look at these
issues one by one.

> > Some idea of the lock-less algorithm in the patch comes from Steven
> > Rostedt's trace ring buffer implementation.
> > 
> > The new xxx_ptr interface and kfifo_iter makes it possible to
> > write/read content of kfifo in-place in addition to copying out/in.
> > 
> 
> The regular use case of a fifo is that there is one write and one
> reader. In this case, the current implementation of the kfifo structure
> is lock less.
> 
> So i you need this, than it would be better to use the ring buffer.

I really need multiple-writers and one reader in APEI GHES support, and
I need lock-less in writer side (because the buffer need to be written
in NMI handler). So I can not use the original kfifo implementation.

> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> I was never CC by a mail where Andi has signed off this patch. It would
> be great if i will get some infos why he like it.
> 
> But i think you will never get an ACK for this by me, because it bloats
> the most-used functions of the hand optimized kfifo API.
> 
> Rule number one: do not increase the code size if the functionality is
> not needed and used!

There is at least one user. I will post the corresponding patches later.

Best Regards,
Huang Ying


