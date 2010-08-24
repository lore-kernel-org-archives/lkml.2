Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0HXJEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:04:20 -0400
Received: from www84.your-server.de ([213.133.104.84]:37527 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab0HXJES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:04:18 -0400
Subject: Re: [RFC -v2] kfifo writer side lock-less support
From: Stefani Seibold <stefani@seibold.net>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1282639425.2708.40.camel@yhuang-dev>
References: <1282614146.2708.13.camel@yhuang-dev>
	 <1282636558.7357.28.camel@wall-e.seibold.net>
	 <1282639425.2708.40.camel@yhuang-dev>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 24 Aug 2010 11:04:23 +0200
Message-ID: <1282640663.7896.17.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 24.08.2010, 16:43 +0800 schrieb Huang Ying:
> On Tue, 2010-08-24 at 15:55 +0800, Stefani Seibold wrote:
> > Hi Huang,
> > 
> > Am Dienstag, den 24.08.2010, 09:42 +0800 schrieb Huang Ying:
> > > Hi, Stefani,
> > > 
> > > The sample code is attached with the mail too. If it is necessary, I
> > > can put the sample code into samples/kfifo directory if the basic
> > > idea of the patch is accepted.
> > > 
> > 
> > The samples use a own implementation of a record handling. Please use
> > the one provided by the kfifo API.
> >

Again: Fix this.

> The patch adds only 1 field (unsigned int) to struct __kfifo. I think
> that should be acceptable. Because sizeof(struct __kfifo) should be much
> smaller that __kfifo->mask + 1 in most cases.

I don't know what you mean with "because sizeof(struct __kfifo) should
be much smaller that __kfifo->mask + 1 in most cases". I am convinced
that you did not really understand the kfifo code. sizeof(struct
__kfifo) is constant and __kfifo->mask + 1 is the fifo size in elements,
which is not constant. Before you answering study the code first!

And is not acceptable to bload the struct __kfifo, because it will never
need by the most users.

> 
> For macros, only INIT_KFIFO, kfifo_reset and kfifo_put is enlarged a
> little (one instruction?).
> 

No, you add also code to kfifo_avail, so you enlarge two of the most
used macros. And again:

Rule number one - do not increase the code size if the functionality is
not needed and used!

> And yes, I added some new functions and macros. But if I implement
> another ring buffer instead of making kfifo lock-less (for multiple
> writers), I need to implement more functions and macros, the code size
> increment will be larger, isn't it?
> 
> > And there a lot of bugs on a first small review.
> > 
> > Your kfifo_skip_len does not handle record fifos. User of kfifo_put,
> > kfifo_avail will get an increased code size. Your kfifo_is_full isn't
> > longer working correctly. You did not fixed kfifo_in(), so this function
> > will not work. And so on....
> 
> After we reach the consensus on the general idea, we can look at these
> issues one by one.
> 

No, first fix your bugs...

> > > Some idea of the lock-less algorithm in the patch comes from Steven
> > > Rostedt's trace ring buffer implementation.
> > > 
> > > The new xxx_ptr interface and kfifo_iter makes it possible to
> > > write/read content of kfifo in-place in addition to copying out/in.
> > > 
> > 
> > The regular use case of a fifo is that there is one write and one
> > reader. In this case, the current implementation of the kfifo structure
> > is lock less.
> > 
> > So i you need this, than it would be better to use the ring buffer.
> 

But you waste a clean interface designed together with the community.

> I really need multiple-writers and one reader in APEI GHES support, and
> I need lock-less in writer side (because the buffer need to be written
> in NMI handler). So I can not use the original kfifo implementation.
> 

I believe you that you need it, but the question is: Is there more users
who need it. And i am sure, there are no more users or very very few.

So for the protocol a big NAK!

- Stefani


