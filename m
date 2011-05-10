Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab1EJKgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:36:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34801 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab1EJKgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:36:42 -0400
Date: Tue, 10 May 2011 12:36:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Kaywinnit L. Frye" <kaywinnit.lee.frye.2497@gmail.com>,
        linux-kernel@vger.kernel.org,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
Subject: Re: [PATCH] wait: include linux/sched.h
Message-ID: <20110510103628.GE2400@elte.hu>
References: <1304372042-12098-1-git-send-email-kaywinnit.lee.frye.2497@gmail.com>
 <20110506075408.GI23166@elte.hu>
 <1305015103.2914.17.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305015103.2914.17.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2011-05-06 at 09:54 +0200, Ingo Molnar wrote:
> 
> > > diff --git a/include/linux/wait.h b/include/linux/wait.h
> > > index 3efc9f3..667a3d7 100644
> > > --- a/include/linux/wait.h
> > > +++ b/include/linux/wait.h
> > > @@ -22,6 +22,7 @@
> > >  #include <linux/list.h>
> > >  #include <linux/stddef.h>
> > >  #include <linux/spinlock.h>
> > > +#include <linux/sched.h>
> > >  #include <asm/system.h>
> > >  #include <asm/current.h>
> > 
> > I'm quite sure this will break the build all around the place, because sched.h 
> > itself uses wait.h primitives.
> 
> I'm very sure it will, people keep proposing this.
> 
> > To fix these super-headers like sched.h and to make wait.h self-sufficient the 
> > right and cleanest approach would be to split data types and primitive accessor 
> > functions from higher level helper methods (which inevitably mix different 
> > domains) and put them into two separate files.
> > 
> > We have a few such split files in the kernel tree, spinlock_types.h and 
> > spinlock_api.h, and this concept works reasonably well.
> > 
> > So here we'd need wait_types.h and wait_api.h and of course sched_types.h and 
> > sched_api.h.
> > 
> > For simplicity of migration wait_api.h could be wait.h itself and sched_api.h 
> > could be sched.h itself.
> 
> Argh, please don't. I've been arguing against that for a while now.

Yours is not a very well argued argument i have to say ;-)

> The right thing to do is to clean up sched.h and remove a lot of the 
> non-scheduler bits in there, like all the process and signal bits.

That, in fact, is the first half of what i suggested - obviously type splitting 
means first moving unrelated bits out of it.

Lets call it 'purifying' the header.

But, and i talk from first-hand experience here, even if we do that the core 
problem creating header spaghetti still remains, even if a header file is 
'pure': helper/utility inline functions using 'other' types which requires the 
inclusion of those other types - this quickly explodes.

Lets see an example, say we have two types and two headers:

header-A.h:

 type A
 method::A1
 method::A2

header-B.h:

 type B
 method::B1
 method::B2

And header-B also includes helper functions, which often have the form of:

 helper-method::B1()
 {
	type A = method::A1();
	type B;

	if (B.field)
		return A;

	return NULL;
 }

Then this 'imports' type A into type B's header file - although type B does not 
really relate to type A, only the helper method B1 has some (often superficial) 
connection to it.

And if we have a similar helper method in header-A, making use of header-B, we 
have inclusion circular dependency. These are typically worked around via ugly
#define()s. So we have tons of ugly defines and messy dependencyes.

So if we separate "types + type-specific methods" from "helper functions" 
(after all the cleanup you suggested as well, i.e. moving unrelated 
functionality out), we have improved the situation materially: both header-A.h 
and header-B.h become 'pure' and there's also header-B-helpers.h that can 
freely mix type-A and type-B methods.

Once that split is done other types can also thus include header-B.h without 
implicitly including header-A and all of its dependencies.

The end result is that we get a clean hiearchy of types.

Obviously sched.h would include a lot of basic types to begin with, because it 
is a fundamental 'container' type (struct task_struct) sitting at a top, 
highlevel node of the type hierarchy - so the initial step you suggest would 
indeed get us most of the benefits.

Thanks,

	Ingo
