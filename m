Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1EEJy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 05:54:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47691 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1EEJy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 05:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZdPm1IBfxpTqE4a/kAxRRL2fSEuNbuTS6JJacg92ChkiAIXFg8r93wbsn5X7pWYlmd
         6p79cmEMV54Zs62/5KQNnhwCHVOA1TU7GHe8gLJTdfVdJZu1AVccHgwQ3PzHjcY7woWE
         UO9Ol3ydsdJ1AYgC9myEyWzh5ZcBA3uWFQ0is=
Date: Thu, 5 May 2011 11:54:21 +0200
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110505095421.GD30950@htj.dyndns.org>
References: <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com>
 <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com>
 <alpine.DEB.2.00.1105041341550.5495@router.home>
 <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com>
 <alpine.DEB.2.00.1105041421280.5495@router.home>
 <BANLkTi=efcVkGb+DReZ+i1p5j4QXJYjKjQ@mail.gmail.com>
 <alpine.DEB.2.00.1105041454190.5495@router.home>
 <BANLkTik7AHGr7+BG8nE16j-ayctD0LOH=w@mail.gmail.com>
 <BANLkTimvxOMuPJ0W0npo5i3gwFqdRw74Pw@mail.gmail.com>
 <alpine.LFD.2.02.1105042325500.3005@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105042325500.3005@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, May 04, 2011 at 11:40:33PM +0200, Thomas Gleixner wrote:
> Yeah, I tripped over that as well. And the new shiny extra
> CONFIG_CMPXCHG_DOUBLE misfeature Christoph nailed together is just
> ignoring it as well. It's just more useless #ifdef and CONFIG bloat.
> 
> That whole this_cpu_* stuff seems to be designed by committee. A quick
> grep shows that max. 10% of the implemented macro hell is actually
> used. Can we get rid of all unused ones and bring them back when they
> are actually required?

What happened there was more of lack of design rather than too much
design.  At first it were a few ops with only two variants -
preemption protected default one and __ prefixed unprotected one.
Then came the irqsafe ops and then the whole kinda exploded on itself
with all the different ops.

Cleaning up percpu accessors has been on my todo list for some time
now.  The this_cpu_*() thing is still in its infancy and there aren't
many users and the existing ones are mostly in the core, so cleaning
things up should be relatively easy.  Things which I've been
considering are...

1. Static and dynamic accessors.

We have two sets of percpu accessors.  Originally, one set was for
static percpu variables and the other for dynamic ones.  Since the
percpu allocator reimplementation, there's no distinction between
static and dynamic and the new this_cpu_*() functions don't
distinguish them.  We need to unify the duplicate ones.  There's
nothing much to decide about this.  It just needs to be done.

2. this_cpu_*()

This one is more tricky.  General cleanup aside...

this_cpu_*() ops currently come in three flavors and the naming
convention is rather confusing.  __this_cpu for no protection,
this_cpu for preemtion disabled and irqsafe_cpu for irq protected.
IIUC it was intended to loosely match the naming convention of
spinlocks but I'm not sure whether that's beneficial in this case.

The biggest problem, as shown by this bug, is that it's error-prone.
Percpu ops as they currently stand don't have lockdep protection for
accessing contexts.  There's nothing protecting percpu vars being
accessed from wrong contexts.  I think adding lockdep protection
should be doable and should be done, but it would be much better if
it's safer by default.

The problem is aggravated by the fact that, on x86 where most of
developement and testing happens, there's no difference between
__this_cpu_*(), this_cpu_*() and irqsafe_cpu_*().  They're one and the
same, so testing coverage suffers.  We can avoid this by adding a
debug option which forces the generic versions whether the arch ones
are there or not, but it does raise the question - do we really need
all these different confusing variants?

For x86, it doesn't matter.  There are some corner cases with
cmpxchg_[double] but I don't think we would be in any trouble just
using the generic ones for them.  The problem is with other archs
where local atomic ops haven't been or, for most load-store
architectures, can't be implemented.  We might say "eh... screw them"
and let them use the generic ones but the problem is that this_cpu_*()
tend to be used in extremely hot paths where extra irq on/off's can
show up as significant overhead.

The thing that I want gone the most is the irqsafe_ variant.  It would
be much nicer/safer if this_cpu_*() is atomic against everything.  If
the caller is gonna take care of exclusion from the enclosing area
(this is a valid use case when there's a series of operations to be
done including but not limited to multiple this_cpu ops), it can use
__this_cpu_*() ones.

The reason to disable preemtion instead of IRQ is two-fold - First,
preemption can be disabled for longer period than IRQ.  Second,
depending on CPU, toggling preemption is significantly cheaper than
toggling preemption.  For this_cpu ops, the first one doesn't apply.
It's always very short, so the only thing that needs to be considered
is the overhead of toggling protection.

So, to avoid suffering performance penalty from this_cpu_*()
conversion, architectures can choose one of the followings.

1. Implement arch specific this_cpu_*() ops.  This would be the better
   way but unfortunately many architectures simply can't.  :-(

2. Make irq toggling as cheap as preemption toggling.  This can be
   achieved by implementing IRQ masking in software.  I played with it
   a bit on x86 last year.  I didn't get to finish it and it would
   have taken me some time to iron out weird failures but it didn't
   seem too difficult and as irq on/off is quite expensive on a lot of
   CPUs, this might bring overall performance benefit.

For many archs, #2 would be the only choice and if we're gonna do that
I think it would be best to do it on x86 too.  It involves changes to
common code too and x86 has the highest test/development coverage.

I don't feel brave enough to remove preemption protected ones without
first somehow taking care of non-x86 archs.  The preemption disabled
ones are used for statistics in net, block, irq and fs and simply
switching to irq protected ones is likely to noticeably hurt many
non-x86 archs.  Maybe the ones which really matter can implement at
least _add() and we can get away without doing soft irq masking.

Anyways, that's what I've been thinking.  I'll get to it in the next
devel cycle or the one after that.  What do you guys think about soft
irq masking idea?

Thanks.

--
tejun
