Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab1IIDS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 23:18:58 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47601 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251Ab1IIDSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 23:18:55 -0400
X-Sasl-enc: qtacPBHTxrdkUQW74g1NaVFe83RF0DRFX5uRNmzNAm+D 1315538334
Subject: Re: [PATCH] vfs: automount should ignore LOOKUP_FOLLOW
From: Ian Kent <raven@themaw.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Leonardo Chiquitto <leonardo.lists@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        autofs@linux.kernel.org
In-Reply-To: <87bouv17dc.fsf@tucsk.pomaz.szeredi.hu>
References: <87liu37z3x.fsf@tucsk.pomaz.szeredi.hu>
	 <17416.1315240659@redhat.com> <87hb4q9b3r.fsf@tucsk.pomaz.szeredi.hu>
	 <1315281208.3210.26.camel@perseus.themaw.net>
	 <87mxeixfaq.fsf@tucsk.pomaz.szeredi.hu>
	 <1315319903.3210.51.camel@perseus.themaw.net>
	 <87ipp5y912.fsf@tucsk.pomaz.szeredi.hu>
	 <1315485406.3476.9.camel@perseus.themaw.net>
	 <87bouv17dc.fsf@tucsk.pomaz.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Sep 2011 11:18:48 +0800
Message-ID: <1315538328.3952.27.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-08 at 15:38 +0200, Miklos Szeredi wrote:
> Ian Kent <raven@themaw.net> writes:
> 
> > On Tue, 2011-09-06 at 17:39 +0200, Miklos Szeredi wrote:
> >> Ian Kent <raven@themaw.net> writes:
> >> 
> >> > On Tue, 2011-09-06 at 10:09 +0200, Miklos Szeredi wrote:
> >> >> Ian Kent <raven@themaw.net> writes:
> >> >> 
> >> >> > On Mon, 2011-09-05 at 19:02 +0200, Miklos Szeredi wrote:
> >> >> >> 
> >> >> >> If automounting on lstat(2) is the correct behavior (is it?  why?)  then at
> >> >> >> least it should be enabled by a global switch or mount option, IMO.
> >> >> >
> >> >> > Ideally we wouldn't need to take special precautions for these
> >> >> > operations at all but we can't, especially for GUI environments that
> >> >> > constantly scan file systems on mount/umount activity.
> >> >> >
> >> >> > Historically for autofs, neither stat(2) or lstat(2) would trigger a
> >> >> > mount. With the current implementation stat(2) now does but lstat(2)
> >> >> > doesn't which is a step in the right direction IMHO. So, I recommend we
> >> >> > continue to encourage user space to make the needed changes so we
> >> >> > continue to move in the right direction, and yes, I acknowledge it is a
> >> >> > pain but it'll never get done otherwise.
> >> >> 
> >> >> I'm not quite convinced.  What's the advantage of triggering automount
> >> >> on stat(2)?
> >> >
> >> > You get the information of the directory of the mounted fs and for many
> >> > peoples purposes automounting should be transparent so that would be
> >> > best.
> >> 
> >> The same is true for lstat(2).
> >> 
> >> >  
> >> >> 
> >> >> Has anybody complained that stat(2) on the mountpoint doesn't cause an
> >> >> automount?
> >> >
> >> > Yes, based on the reasoning above.
> >> 
> >> Would any of those complaints go away if stat(2) did cause an
> >> automount and lstat(2) didn't?
> >
> > Ummm .... please forgive me, I'm confused over which of these cause an
> > automount to occur, again.
> >
> > Much of what I've said previously is wrong because stat(2) does cause
> > the automount and lstat(2) doesn't, which is, I think, the way it should
> > be, semantically (see bug
> > https://bugzilla.redhat.com/show_bug.cgi?id=692823 for example).
> >
> > I'll go back and check the code "again", just to be doubly sure, which I
> > need to do given my constant confusion on this, oops!
> 
> Sloppy wording on my part is probably responsible for some of the
> confusion.
> 
> Yes, 2.6.38 and later kernels do trigger on stat(2) but not on lstat(2).
> 
> My question is this:  does this behavior improve anything compared to
> kernels before 2.6.38?  Because I don't see that it does, in fact it's
> just causing regressions.

OK, I think I'm back on track wrt. the discussion now.

I know I've come out against the change so far but the reality is that
this has always been an issue and, from what your saying there are some
user space applications that are unhappy with it to a significant degree
(I'm actually not yet aware of these reports).

So I support your recommended change. Certainly for the autofs case it
will do nothing more than restore the original behavior, but since
autofs isn't the only user of this functionality now I have recommend we
ask the other subsystem maintainers what impact it would have for them.
I think that's AFS, CIFS and NFS (I'm not adding to the cc since I'm not
sure who to add for CIFS, can someone else reply with the proper ccs
please).

> 
> You say it's a step in the right direction but I don't see why.  Either
> we want stat *and* lstat to both be correct and trigger the automount or
> we are satisfied with the incorrect but well established practice of not
> triggering on (l)stat.

I say it's a step in the right direction only because of what I think
should be "correct" behavior and my interpretation simply doesn't quite
match yours, sorry, ;)

My interpretation is still that (forgive the repetition), in an ideal
world, follow type walks should trigger automounts to occur and no
follow walks should not purely due to the behavioral similarity between
automounts and sym-links.

> 
> The middle ground makes no sense IMO, there's nothing gained by the
> differentiated behavior based on LOOKUP_FOLLOW.

Right, but I don't see it as middle ground, I see it as "correct"
behavior.

I also find the "both follow and no follow walks should trigger mounts"
sensible. Unfortunately that can't work at all without sufficient
context to be able to know when to and when not to trigger a mount and
that just isn't possible AFAICS.

> 
> Can you explain why it's better if stat() tiggers automounts and gives a
> correct result but lstat() doesn't?

Again, my interpretation of what I think is "correct" which is not
necessarily the right one.

Ian


