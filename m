Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1LMXR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 18:17:27 -0500
Received: from www.linutronix.de ([62.245.132.108]:59082 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab1LMXR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 18:17:26 -0500
Date: Wed, 14 Dec 2011 00:17:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@linux.intel.com>
cc: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] DEBUGFS: Add per cpu counters
In-Reply-To: <20111213225617.GC7633@tassilo.jf.intel.com>
Message-ID: <alpine.LFD.2.02.1112140003550.3020@ionos>
References: <1323812733-7520-1-git-send-email-andi@firstfloor.org> <1323812733-7520-2-git-send-email-andi@firstfloor.org> <alpine.LFD.2.02.1112132336440.3020@ionos> <20111213225617.GC7633@tassilo.jf.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011, Andi Kleen wrote:
> On Tue, Dec 13, 2011 at 11:43:16PM +0100, Thomas Gleixner wrote:
> > On Tue, 13 Dec 2011, Andi Kleen wrote:
> > >  									\
> > > +	__debugfs	: AT(ADDR(__debugfs) - LOAD_OFFSET) {		\
> > > +		VMLINUX_SYMBOL(__start___debugfs) = .;			\
> > > +		*(__debugfs)						\
> > > +		VMLINUX_SYMBOL(__stop___debugfs) = .;			\
> > > +	}								\
> > > +									\
> > 
> > ....
> >   
> > > +struct debugfs_counter {
> > > +	unsigned __percpu *ptr;
> > > +	const char *fn;
> > > +	const char *name;
> > > +} __attribute__((aligned(sizeof(char *))));
> > > +
> > > +/* Note: static doesn't work unlike DEFINE_PERCPU. Sorry. */
> > > +#define DEFINE_DEBUGFS_COUNTER(name_, file)				\
> > > +	DEFINE_PER_CPU(unsigned, name_ ## _counter);			\
> > > +	struct debugfs_counter name_ ## _pcpu_counter __used		\
> > > +	__attribute__((aligned(sizeof(char *)),section("__debugfs"),unused)) \
> > > +	= { .ptr = &name_ ## _counter, .fn = file, .name = #name_ }; \
> > 
> > Sigh, we had that section forms an array problem more than once
> > already. Why do you invent another variant and think that it will not
> > explode?
> 
> I did three or four different sections like this in the past and as far
> as I know none of them has exploded so far in production use.
> 
> Can you be more specific? Where exactly do you think this will
> not work?

Can you actually read and understand what I wrote below?
 
> > Your alignment magic does not guarantee at all that the structs will
> > form an array. The "aligned" attribute guarantees only the _MINIMUM_
> > alignment for a structure, but the compiler and the linker are free to
> > align on larger multiples.
> 
> > 
> > See commit 654986462 for details.
> 
> Doesn't give a lot of details actually.

There are enough details to figure it out. http://www.jfgit.com might
help.

>  Which target?

The target is irrelevant.

> Note that my structure only has pointers, so there is not a lot 
> of potential for "evil" alignment.

That does NOT matter at ALL. Also whether you did that in the past or
not is completely irrelevant. Its also totally irrelevant whether your
structure only has pointers or not.

There is NO GUARANTEE that this will end up in a linear array with a
stride of the struct size. Period.

Just get it.

Thanks,

	tglx
