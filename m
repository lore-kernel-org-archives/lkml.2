Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0C2FLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 01:11:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:49423 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab0C2FLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 01:11:07 -0400
Date: Mon, 29 Mar 2010 16:10:54 +1100
From: Neil Brown <neilb@suse.de>
To: Tejun Heo <teheo@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] refcounting improvements in sysfs.
Message-ID: <20100329161054.2dfcdfa8@notabene.brown>
In-Reply-To: <4BAC5513.8060608@suse.de>
References: <20100324031829.2136.66489.stgit@notabene.brown>
	<4BAC3CE0.2010408@suse.de>
	<20100326170214.517a17cc@notabene.brown>
	<4BAC5513.8060608@suse.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010 15:32:51 +0900
Tejun Heo <teheo@suse.de> wrote:

> Hello, Neil.
> 
> On 03/26/2010 03:02 PM, Neil Brown wrote:
> >> Nice article.  In general, yeap, I agree it would be nice to have a
> >> working reference count abstraction.  However, kref along with kobject
> >> is a good example of obscurity by abstraction anti pattern.  :-)
> > 
> > I'm not at all sure that opinion would be universal....
> > 
> > refcounting is something that it is quite easy to get wrong.  There are
> > several slightly different models for refcounting and if you don't have a
> > clear understanding of the different use cases it is easy to get confused
> > about exactly what model is being used and so use a refcount wrongly.
> > kref certainly doesn't cover all models for refcounting but it does cover one
> > fairly common one very well and I think that it's use bring clarity rather
> > than obscurity.
> > Of course if it is used for a refcount which should really follow a different
> > model then that can cause confusion...
> 
> I don't know.  After spending some time with k* and device model, I
> grew a pretty strong dislike for abstractions without clear functional
> necessities.  kref being much simpler than kobject, the abuse is much
> less severe but there have been kref misuses (in kobject and SCSI
> midlayer) which could have been avoided or at least easily located if
> they simply had used atomic_t instead of dreaming up some mystical
> properties of kref.

Hi Tejun,

this strikes me as really valuable experience that it would be great to
share.   While I generally like kref and see value in at least some of
kobject I don't for a moment suppose they are perfect.  Fixing them requires
a good understanding of the problems they cause.  If you have that knowledge,
it would be a great resource for anyone wanting to 'fix' kobject.
Are you interested in writing anything (more) up at all???


> 
> >> kobject API incorrectly suggests that it deals with the last put
> >> problem.  There still are large number of code paths which do the
> >> following,
> >>
> >>   if (!(kob = kobject_get(kobj)))
> >> 	return;
> > 
> > kobject_get *always* returns exactly the argument that was passed to it.
> > (kref_get doesn't have a return value.)
> > 
> > I don't see how the code above has any bearing on the last-put
> > problem, which I think kref and thus kobject do handle exactly
> > correctly.
> 
> Oh, I should have been more explicit.  It's not directly related to
> kref but just something that always comes to my mind when thinking
> about k* abstractions.  The above bogus condition checks used to be
> used quite widely.  The programmer for some reason believed the last
> kobject_put() somehow will magically make future kobject_get()s return
> NULL, which of course doesn't make any sense but hey the
> implementation is buried kilometers deep, the API and other usages
> seem to suggest that and it's easy to imagine something up when you're
> tired.

This would argue that having a return value from kobject_get violates Rusty's
law that interfaces should be hard to misuse.
We could probably change that - it is only used 19 times in the current
kernel.
It probably doesn't help that Documentation/kobject.txt includes the text:

    A successful call to kobject_get() will increment the kobject's reference
    counter and return the pointer to the kobject.

which seems to suggest that an unsuccessful call is possible.


> 
> As an another example, please take a look at the kref API.
> 
>   int kref_put(struct kref *kref, void (*release) (struct kref *kref));
> 
> The function takes @release callback but under which context is it
> called?  If you look at the source code, it's called in-line which
> isn't clear from the API at all (why the hell take a callback if
> you're gonna call it in-line?) and there have been *several* subtle
> bugs which could have been avoided or at least would have been caught
> much easier if it were not for that meaningless separate release
> callback.  It's just too easy to forget about the executing context
> when people write and review stuff over function boundaries.
> 
>  void put_something(something)
>  {
> 	 if (kref_put(&something->kref))
> 		 do something which might dead lock;
>  }
> 
> is way easier to avoid bugs and review than
> 
>  void really_kill_something(struct kref *kref)
>  {
> 	 struct my_something *something = container_of(...);
> 
> 	 do something which might dead lock;
>  }
> 
>  void put_something(something)
>  {
> 	 kref_put(&someting->kref);
>  }
> 
> This is *way* worse than atomic_t not better and the confusion is
> caused exactly by superflous abstraction which leads the users of the
> API to imagine some non-existing function of the abstraction and
> hinders the flow of review.

I'm not immediately convinced by this, though maybe I haven't seen enough
examples yet.

The deadlocks that I have come across would not have been any more obvious in
either of the above - they were caused because sysfs_remove deadlocks when
called from inside a sysfs attribute action...

Also, while this re-write is possible for kref uses it isn't really possible
in kobject as the 'final_put' function must be included in the ktype (though
maybe you don't like that either).

What would be really helpful here is a survey of what sorts of things are
actually done in final_put functions so would could create some guidelines
about how to write the release functions.

Thanks,
NeilBrown


> 
> >> I believe (or at least hope) the actual problem cases are mostly fixed
> >> now but there still are a lot of misconceptions around how stuff built
> >> on kref/kobject is synchronized and they sometimes lead to race
> >> conditions buried deep under several layers of abstractions and it
> >> becomes very hard to see those race conditions when they are buried
> >> deep.
> > 
> > I agree that there probably misconceptions about how kref works and they are
> > probably based on a lack of appreciation of the subtle differences in
> > flavours of refcounts.  Hence my desire to create and document different
> > k*ref types which clarify the different use cases.
> 
> Oh, I'm not objecting to cleaning up how reference counts are done
> per-se but *PLEASE* refrain from introducing abstractions for
> abstraction's sake.  The k* stuff, device model and sysfs already
> walked down that road and got burned badly.
> 
> > BTW I'd be perfectly happy if the first patch was taken and
> > subsequent ones not.  I think they are a good idea, but I'm happy to
> > forgo them (for now:-).
> 
> If it can be done in a way that it doesn't substitute pure logical
> complexity with one which involves memory ordering issues, which is
> almost always way worse, I have no objection at all.
> 
> Thanks.
> 

