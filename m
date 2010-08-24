Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0HXMtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 08:49:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43100 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0HXMtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 08:49:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BFlko5yXDitXYY29RqfkNeOBSOOG6ZYAC/doE0xGkekF/TLTAu62AnazrkLjvivzox
         7SBwf71cE5mBZIBCJ6/MVznfXFG4wZ4F4QagaTFTAGZjlQ8zLPuM1c80MIvssCZdCaVy
         yzjdIVvR9lHpqUamXX0LNjCPWcXXfAnaEXKC8=
Subject: Re: [RFC -v2] kfifo writer side lock-less support
From: Huang Ying <huang.ying.caritas@gmail.com>
Reply-To: huang.ying.caritas@gmail.com
To: Stefani Seibold <stefani@seibold.net>
Cc: Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1282640663.7896.17.camel@wall-e.seibold.net>
References: <1282614146.2708.13.camel@yhuang-dev>
	 <1282636558.7357.28.camel@wall-e.seibold.net>
	 <1282639425.2708.40.camel@yhuang-dev>
	 <1282640663.7896.17.camel@wall-e.seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 20:50:07 +0800
Message-ID: <1282654207.11483.32.camel@caritas-mobile.ml.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 11:04 +0200, Stefani Seibold wrote:
> Am Dienstag, den 24.08.2010, 16:43 +0800 schrieb Huang Ying:
> > On Tue, 2010-08-24 at 15:55 +0800, Stefani Seibold wrote:
> > > Hi Huang,
> > > 
> > > Am Dienstag, den 24.08.2010, 09:42 +0800 schrieb Huang Ying:
> > > > Hi, Stefani,
> > > > 
> > > > The sample code is attached with the mail too. If it is necessary, I
> > > > can put the sample code into samples/kfifo directory if the basic
> > > > idea of the patch is accepted.
> > > > 
> > > 
> > > The samples use a own implementation of a record handling. Please use
> > > the one provided by the kfifo API.
> > >
> 
> Again: Fix this.

I need to access the record inside kfifo "in-place", so I can not use
the original record implementation. Maybe we can unify the two
requirement. But I want to talk about lock-less implementation firstly.

> > The patch adds only 1 field (unsigned int) to struct __kfifo. I think
> > that should be acceptable. Because sizeof(struct __kfifo) should be much
> > smaller that __kfifo->mask + 1 in most cases.
> 
> I don't know what you mean with "because sizeof(struct __kfifo) should
> be much smaller that __kfifo->mask + 1 in most cases". I am convinced
> that you did not really understand the kfifo code. sizeof(struct
> __kfifo) is constant and __kfifo->mask + 1 is the fifo size in elements,
> which is not constant. Before you answering study the code first!
> 
> And is not acceptable to bload the struct __kfifo, because it will never
> need by the most users.

I mean, for most user, __kfifo->mask + 1 > sizeof(struct __kfifo), so
another 4 bytes for each user is relatively small.

> > For macros, only INIT_KFIFO, kfifo_reset and kfifo_put is enlarged a
> > little (one instruction?).
> > 
> 
> No, you add also code to kfifo_avail, so you enlarge two of the most
> used macros. And again:

No. kfifo_avail is only changed, not enlarged. 

> Rule number one - do not increase the code size if the functionality is
> not needed and used!
> 
> > And yes, I added some new functions and macros. But if I implement
> > another ring buffer instead of making kfifo lock-less (for multiple
> > writers), I need to implement more functions and macros, the code size
> > increment will be larger, isn't it?
> > 
> > > And there a lot of bugs on a first small review.
> > > 
> > > Your kfifo_skip_len does not handle record fifos. User of kfifo_put,
> > > kfifo_avail will get an increased code size. Your kfifo_is_full isn't
> > > longer working correctly. You did not fixed kfifo_in(), so this function
> > > will not work. And so on....
> > 
> > After we reach the consensus on the general idea, we can look at these
> > issues one by one.
> > 
> 
> No, first fix your bugs...
> 
> > > > Some idea of the lock-less algorithm in the patch comes from Steven
> > > > Rostedt's trace ring buffer implementation.
> > > > 
> > > > The new xxx_ptr interface and kfifo_iter makes it possible to
> > > > write/read content of kfifo in-place in addition to copying out/in.
> > > > 
> > > 
> > > The regular use case of a fifo is that there is one write and one
> > > reader. In this case, the current implementation of the kfifo structure
> > > is lock less.
> > > 
> > > So i you need this, than it would be better to use the ring buffer.
> > 
> 
> But you waste a clean interface designed together with the community.

Is it good to extend the interface? Maybe there will be other users too.
At least the impact for existing users is quite small.

> > I really need multiple-writers and one reader in APEI GHES support, and
> > I need lock-less in writer side (because the buffer need to be written
> > in NMI handler). So I can not use the original kfifo implementation.
> > 
> 
> I believe you that you need it, but the question is: Is there more users
> who need it. And i am sure, there are no more users or very very few.

There will not be many users. So I try to minimize the performance
impact as much as possible.

> So for the protocol a big NAK!

Sorry to hear this.

Best Regards,
Huang Ying


