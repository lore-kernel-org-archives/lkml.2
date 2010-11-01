Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab0KAAqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 20:46:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754651Ab0KAAqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 20:46:36 -0400
Date: Sun, 31 Oct 2010 17:46:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
        Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Optimize relay_alloc_page_array() slightly by using
 vzalloc rather than vmalloc and memset
Message-Id: <20101031174635.88f441fe.akpm@linux-foundation.org>
In-Reply-To: <20101031183913.GA26160@Krystal>
References: <alpine.LNX.2.00.1010302216550.1572@swampdragon.chaosbits.net>
	<20101030214704.GA20005@Krystal>
	<alpine.LNX.2.00.1010302343590.1572@swampdragon.chaosbits.net>
	<20101031183913.GA26160@Krystal>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Oct 2010 14:39:14 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Jesper Juhl (jj@chaosbits.net) wrote:
> > On Sat, 30 Oct 2010, Mathieu Desnoyers wrote:
> > 
> > > * Jesper Juhl (jj@chaosbits.net) wrote:
> > > > Hi,
> > > > 
> > > > We can optimize kernel/relay.c::relay_alloc_page_array() slightly by using 
> > > > vzalloc. The patch makes these changes:
> > > > 
> > > >  - use vzalloc instead of vmalloc+memset.
> > > >  - remove redundant local variable 'array'.
> > > >  - declare local 'pa_size' as const.
> > > 
> > > Hrm ? How does declaring a local variable as const helps the compiler in
> > > any way ?
> > > 
> > 
> > Hmm, probably not very much in this case (but it doesn't hurt either ;) - 
> > actually, removing the const yielded the exact same result, so it's 
> > "not at all" in this case). 
> > That bit came from my "build-in" tendency to declare stuff const when it 
> > obviously doesn't change/nor should. It's a habbit..
> 
> Which looks to me like a misunderstanding of the C99 standard. What you
> do is:
> 
> static struct page **relay_alloc_page_array(unsigned int n_pages)
> {
> 	const size_t pa_size = n_pages * sizeof(struct page *);
> 	...
> }
> 
> So the compiler has no choice but to emit code that will fill in the
> value of pa_size at runtime, because it depends on "n_pages", a
> parameter received by the function. So pa_size is everything but
> constant.
> 
> The C99 standard, section 6.7.3 (Type qualifiers) states:
> 
> "The implementation may place a const object that is not volatile in a
> read-only region of storage. Moreover, the implementation need not
> allocate storage for such an object if its address is never used."
> 
> So maybe gcc is kind here and it just removes this const specifier
> without complaining, but a different compiler might be more strict and
> fail to compile because you would be dynamically assigning a value to a
> variable placed in read-only storage.

Such a compiler would be pretty darn useless - that's a quite common
thing to do.

It's also a very *useful* thing to do.  In a long function it's easy to
lose track of what variable has what value where, and it's easy to add
bugs by modifying a variable which you didn't realise gets used later
on.  If the definition has a "const" in front of it then great, that
settled everything.

> > 
> > 
> > > Moreover, is there anyone still using this code ? LTTng uses the Generic
> > > Ring Buffer library which completely deprecates relay.c. Perf and Ftrace
> > > each have their own ring buffers, without dependency on relay.c.
> > > 
> > > BLK_DEV_IO_TRACE seems to still select RELAY. Has it completed its
> > > transition to either Ftrace or Perf ? Depending on Jens, moving blktrace
> > > relay dependency to the Generic Ring Buffer Library might be a good
> > > option to consider.
> > > 
> > 
> > I admit I have no idea if this code is actually still used, but as long as 
> > it's in the kernel I think we should strive to make it as good as possible 
> > - no? If there are still users this is an improvement, if there are no 
> > users (who knows if there are out-of-tree ones?) then it should probably 
> > just go away (but even then this patch does no harm - except for a bit of 
> > churn).
> 
> Another point that I don't like about your patch is the comment:
> 
> "Compile tested only."
> 
> Please don't break unused code for the sake of trying to slightly
> optimize it, especially if you don't bother testing your modifications.
> 
> So as far as I am concerned, I am Nack-ing this patch. I might possibly
> nack any further change to relay.c, and hereby propose its replacement
> by the generic ring buffer library, unless someone comes up with a good
> reason for keeping it.

aw, c'mon, read the code.  The patch is good and improves that function
so much it ain't funny.

It's a non-runtime-tested, obviously-correct cleanup.  Yes, it would be
better if it was runtime tested.  But we merge patches on this basis
all the time and it works out OK.

If, amazingly, there is some bug in it then someone will hit that bug in
-next or -rc testing and we'll fix it.  Shrug.  If you're that worried then
*you* could runtime test it!  

