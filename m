Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab0KALiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 07:38:04 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:43371 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754958Ab0KALiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 07:38:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANc9zkxGGOIS/2dsb2JhbAChVXK7LoVFBI9d
Date: Mon, 1 Nov 2010 07:27:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
        Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Optimize relay_alloc_page_array() slightly by using
	vzalloc rather than vmalloc and memset
Message-ID: <20101101112754.GA12762@Krystal>
References: <alpine.LNX.2.00.1010302216550.1572@swampdragon.chaosbits.net> <20101030214704.GA20005@Krystal> <alpine.LNX.2.00.1010302343590.1572@swampdragon.chaosbits.net> <20101031183913.GA26160@Krystal> <20101031174635.88f441fe.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20101031174635.88f441fe.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 07:18:18 up 207 days, 21:08,  3 users,  load average: 0.30, 0.15,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Sun, 31 Oct 2010 14:39:14 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Jesper Juhl (jj@chaosbits.net) wrote:
> > > On Sat, 30 Oct 2010, Mathieu Desnoyers wrote:
> > > 
> > > > * Jesper Juhl (jj@chaosbits.net) wrote:
> > > > > Hi,
> > > > > 
> > > > > We can optimize kernel/relay.c::relay_alloc_page_array() slightly by using 
> > > > > vzalloc. The patch makes these changes:
> > > > > 
> > > > >  - use vzalloc instead of vmalloc+memset.
> > > > >  - remove redundant local variable 'array'.
> > > > >  - declare local 'pa_size' as const.
> > > > 
> > > > Hrm ? How does declaring a local variable as const helps the compiler in
> > > > any way ?
> > > > 
> > > 
> > > Hmm, probably not very much in this case (but it doesn't hurt either ;) - 
> > > actually, removing the const yielded the exact same result, so it's 
> > > "not at all" in this case). 
> > > That bit came from my "build-in" tendency to declare stuff const when it 
> > > obviously doesn't change/nor should. It's a habbit..
> > 
> > Which looks to me like a misunderstanding of the C99 standard. What you
> > do is:
> > 
> > static struct page **relay_alloc_page_array(unsigned int n_pages)
> > {
> > 	const size_t pa_size = n_pages * sizeof(struct page *);
> > 	...
> > }
> > 
> > So the compiler has no choice but to emit code that will fill in the
> > value of pa_size at runtime, because it depends on "n_pages", a
> > parameter received by the function. So pa_size is everything but
> > constant.
> > 
> > The C99 standard, section 6.7.3 (Type qualifiers) states:
> > 
> > "The implementation may place a const object that is not volatile in a
> > read-only region of storage. Moreover, the implementation need not
> > allocate storage for such an object if its address is never used."
> > 
> > So maybe gcc is kind here and it just removes this const specifier
> > without complaining, but a different compiler might be more strict and
> > fail to compile because you would be dynamically assigning a value to a
> > variable placed in read-only storage.
> 
> Such a compiler would be pretty darn useless - that's a quite common
> thing to do.

Just for fun, I grepped kernel/ and arch/x86/ for instances of
"[tab]const". Removing all the "const char *", which is a pointer to
const data (so it's entirely different), I ended up with only a handful
of instances of a similar scenario (const function variable initialized
depending on function arguments). Most of these were in a single
function in vmi_32.c.

> It's also a very *useful* thing to do.  In a long function it's easy to
> lose track of what variable has what value where, and it's easy to add
> bugs by modifying a variable which you didn't realise gets used later
> on.  If the definition has a "const" in front of it then great, that
> settled everything.

I can see it being useful. I was just concerned about whether or not it
respects the standard, which seems like a non-issue to you. I can
therefore only provide my input, feel free to discard it.

> 
> > > 
> > > 
> > > > Moreover, is there anyone still using this code ? LTTng uses the Generic
> > > > Ring Buffer library which completely deprecates relay.c. Perf and Ftrace
> > > > each have their own ring buffers, without dependency on relay.c.
> > > > 
> > > > BLK_DEV_IO_TRACE seems to still select RELAY. Has it completed its
> > > > transition to either Ftrace or Perf ? Depending on Jens, moving blktrace
> > > > relay dependency to the Generic Ring Buffer Library might be a good
> > > > option to consider.
> > > > 
> > > 
> > > I admit I have no idea if this code is actually still used, but as long as 
> > > it's in the kernel I think we should strive to make it as good as possible 
> > > - no? If there are still users this is an improvement, if there are no 
> > > users (who knows if there are out-of-tree ones?) then it should probably 
> > > just go away (but even then this patch does no harm - except for a bit of 
> > > churn).
> > 
> > Another point that I don't like about your patch is the comment:
> > 
> > "Compile tested only."
> > 
> > Please don't break unused code for the sake of trying to slightly
> > optimize it, especially if you don't bother testing your modifications.
> > 
> > So as far as I am concerned, I am Nack-ing this patch. I might possibly
> > nack any further change to relay.c, and hereby propose its replacement
> > by the generic ring buffer library, unless someone comes up with a good
> > reason for keeping it.
> 
> aw, c'mon, read the code.  The patch is good and improves that function
> so much it ain't funny.

I agree that the improvements to the allocation+zeroing are welcome. As
you point out, these are trivial.

> 
> It's a non-runtime-tested, obviously-correct cleanup.  Yes, it would be
> better if it was runtime tested.  But we merge patches on this basis
> all the time and it works out OK.
> 
> If, amazingly, there is some bug in it then someone will hit that bug in
> -next or -rc testing and we'll fix it.  Shrug.  If you're that worried then
> *you* could runtime test it!

I was just concerned about eventual conflicts if relay.c gets removed,
given that there does not seem to be many (any ?) users left. But I
won't be managing the conflicts, so, again, feel free to merge it.

Best regards,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
