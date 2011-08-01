Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1HATjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 15:39:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675Ab1HATjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 15:39:49 -0400
Date: Mon, 1 Aug 2011 12:39:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Bob Pearson" <rpearson@systemfabricworks.com>
Cc: "'frank zago'" <fzago@systemfabricworks.com>,
        <linux-kernel@vger.kernel.org>, "'Roland Dreier'" <roland@kernel.org>
Subject: Re: [PATCH] add slice by 8 algorithm to crc32.c
Message-Id: <20110801123914.5a643eb3.akpm@linux-foundation.org>
In-Reply-To: <034001cc4d91$7f232c70$7d698550$@systemfabricworks.com>
References: <4E27547E.4000100@systemfabricworks.com>
	<20110728151619.8b4cc4e3.akpm@linux-foundation.org>
	<034001cc4d91$7f232c70$7d698550$@systemfabricworks.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jul 2011 20:47:36 -0500
"Bob Pearson" <rpearson@systemfabricworks.com> wrote:

> > 
> > > +
> > > +	init_bytes = (uintptr_t)p32 - (uintptr_t)p8;
> > 
> > Please take a look at the types of init_bytes and end_bytes.
> > ptrdiff_t, size_t and uint would all eb more appropriate than `int'.
> 
> Is there a performance difference on 32 bit machines from using a long to
> hold something that is in the range [0,7]? Which of these would you
> recommend?

I'm not aware of 64-bit being any faster than 32-bit on any machine. 
But I'm not aware of much.

Making this a signed quantity was inappropriate.  unsigned int, perhaps.

IMO, unsigned should have been the default in C - negative numbers are
relatively rare.  Whatever.

> > > +	p32 = (u32 *)(((uintptr_t)p8 + 3) & ~3);
> > 
> > ALIGN()?
> 
> Sure.
> 
> > 
> > > +	init_bytes = (uintptr_t)p32 - (uintptr_t)p8;
> > > +	if (init_bytes > len)
> > > +		init_bytes = len;
> > 
> > max()?
> 
> Maybe. First line is the main thought and the if handles the exception where
> the unrolled loop doesn't have a middle. Happy to oblige though. How about
> an unlikely in the if?

Don't care much ;) It's just that the reader looks at those two lines,
absorbs them then says "ah, it's taking the minimum".  If it had just
used "min()" then review and reading are more efficient, and reliable.  Plus min()
has typechecking features which can catch slipups.

