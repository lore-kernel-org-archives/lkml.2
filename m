Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab1LMW41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 17:56:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:8696 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab1LMW40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 17:56:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95831280"
Date: Tue, 13 Dec 2011 14:56:17 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] DEBUGFS: Add per cpu counters
Message-ID: <20111213225617.GC7633@tassilo.jf.intel.com>
References: <1323812733-7520-1-git-send-email-andi@firstfloor.org>
 <1323812733-7520-2-git-send-email-andi@firstfloor.org>
 <alpine.LFD.2.02.1112132336440.3020@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1112132336440.3020@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 11:43:16PM +0100, Thomas Gleixner wrote:
> On Tue, 13 Dec 2011, Andi Kleen wrote:
> >  									\
> > +	__debugfs	: AT(ADDR(__debugfs) - LOAD_OFFSET) {		\
> > +		VMLINUX_SYMBOL(__start___debugfs) = .;			\
> > +		*(__debugfs)						\
> > +		VMLINUX_SYMBOL(__stop___debugfs) = .;			\
> > +	}								\
> > +									\
> 
> ....
>   
> > +struct debugfs_counter {
> > +	unsigned __percpu *ptr;
> > +	const char *fn;
> > +	const char *name;
> > +} __attribute__((aligned(sizeof(char *))));
> > +
> > +/* Note: static doesn't work unlike DEFINE_PERCPU. Sorry. */
> > +#define DEFINE_DEBUGFS_COUNTER(name_, file)				\
> > +	DEFINE_PER_CPU(unsigned, name_ ## _counter);			\
> > +	struct debugfs_counter name_ ## _pcpu_counter __used		\
> > +	__attribute__((aligned(sizeof(char *)),section("__debugfs"),unused)) \
> > +	= { .ptr = &name_ ## _counter, .fn = file, .name = #name_ }; \
> 
> Sigh, we had that section forms an array problem more than once
> already. Why do you invent another variant and think that it will not
> explode?

I did three or four different sections like this in the past and as far
as I know none of them has exploded so far in production use.

Can you be more specific? Where exactly do you think this will
not work?

> Your alignment magic does not guarantee at all that the structs will
> form an array. The "aligned" attribute guarantees only the _MINIMUM_
> alignment for a structure, but the compiler and the linker are free to
> align on larger multiples.

> 
> See commit 654986462 for details.

Doesn't give a lot of details actually. Which target?

Note that my structure only has pointers, so there is not a lot 
of potential for "evil" alignment.

-Andi
