Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab0JHQj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 12:39:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367Ab0JHQj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 12:39:26 -0400
Subject: Re: Linux 2.6.36-rc7
From: Eric Paris <eparis@redhat.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
In-Reply-To: <201010081406.10190.agruen@suse.de>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
	 <20101007190741.2dc62626@lxorguk.ukuu.org.uk>
	 <1286473768.2656.21.camel@dhcp231-98.rdu.redhat.com>
	 <201010081406.10190.agruen@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 12:38:28 -0400
Message-ID: <1286555908.2682.62.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 14:06 +0200, Andreas Gruenbacher wrote:
> On Thursday 07 October 2010 19:49:28 Eric Paris wrote:
> > The safest thing would probably be to punt the syscalls to 2.6.37.
> > Which is sad since I know a number of people are already working against
> > them, but maybe that proves it's the best approach?
> 
> I agree with removing the syscalls from 2.6.36 because of the following 
> reasons:

I disagree with all of your reasons and have argued my position on this
topic repeatedly and don't see the need to refute your claims again.

However, THIS is potentially a real ABI problem and something which
deals with the interface.  Alan seemed to lean towards pulling the
syscalls.  It is relatively easily solved without changing the interface
or breaking userspace in 2.6.37.  We use some set of the flags bits as a
priority (we only use 2 of the 32 bits today so we have plenty) and
order groups with highest priority first, 0 priority last, and 2+ groups
with the same priority have unpredictable ordering.  I'd then call
priorities other than 0 a 2.6.37 feature.  If we do it in flags I think
that leaves us with say 8 bits and thus 255 priorities.  Maybe people
want more, if so, that's a interface change to add a new argument.

Now if Alan would still like me to pull, if anyone has any other 11th
hour interface problems, or if 255 priorities doesn't seem like enough
to someone I am wondering what the best way to unhook is.  Just make the
functions return -ENOSYS as the first line or actually troll through all
of the arches and explicily unhook and rehook to sys_ni_syscall?  I
started on the latter, but it seems to be a rather large patch at this
point...

-Eric

------

I said I wouldn't refute your claims but I can't help myself on one
account which I think might mislead people.

 * Some weaknesses in the interface design were only identified and fixed late
   in the -rc phase, changing the ABI.  There may be more issues, like the
   priority discussion.  This might leave us with a broken ABI we would need
   to support forever.

Between rc2 and rc3 we switched the order and size of a couple of fields
to help alignment, it did break ABI, but it wasn't an interface failing.
See: 0fb85621df4f.  It also lead to an interesting idea about a new type
for linux/types.h which both fanotify and the networking could make use
of (but isn't picked up, I'm not sure we know who is in charge of
types.h)

I concede the interface may in fact not be perfect for every user.  I
have ask for ideas and feedback on proposals for literally (not
figuratively) years.  It has gone through many iterations.  The
interface has been in Linus's kernel for some months and I know of
numerous people who are starting to code to it and haven't (until now)
found interface failings.  We can talk about how problems might be out
there but if they haven't been found after all this time I doubt just
waiting longer is going to change anything.

