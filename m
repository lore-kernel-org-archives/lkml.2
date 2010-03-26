Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0CZGC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 02:02:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:41573 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934Ab0CZGCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 02:02:24 -0400
Date: Fri, 26 Mar 2010 17:02:14 +1100
From: Neil Brown <neilb@suse.de>
To: Tejun Heo <teheo@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] refcounting improvements in sysfs.
Message-ID: <20100326170214.517a17cc@notabene.brown>
In-Reply-To: <4BAC3CE0.2010408@suse.de>
References: <20100324031829.2136.66489.stgit@notabene.brown>
	<4BAC3CE0.2010408@suse.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010 13:49:36 +0900
Tejun Heo <teheo@suse.de> wrote:

> Hello,
> 
> On 03/24/2010 12:20 PM, NeilBrown wrote:
> > This series tidies up the refcount of sysfs_dirents in sysfs,
> > using kref where appropriate and a new karef for s_active.
> > This achieves significant code simplification, especially the first
> > patch.
> > 
> > This is in part inspired by http://lwn.net/Articles/336224/ :-)
> 
> Nice article.  In general, yeap, I agree it would be nice to have a
> working reference count abstraction.  However, kref along with kobject
> is a good example of obscurity by abstraction anti pattern.  :-)

I'm not at all sure that opinion would be universal....

refcounting is something that it is quite easy to get wrong.  There are
several slightly different models for refcounting and if you don't have a
clear understanding of the different use cases it is easy to get confused
about exactly what model is being used and so use a refcount wrongly.
kref certainly doesn't cover all models for refcounting but it does cover one
fairly common one very well and I think that it's use bring clarity rather
than obscurity.
Of course if it is used for a refcount which should really follow a different
model then that can cause confusion...

> 
> kobject API incorrectly suggests that it deals with the last put
> problem.  There still are large number of code paths which do the
> following,
> 
>   if (!(kob = kobject_get(kobj)))
> 	return;

kobject_get *always* returns exactly the argument that was passed to it.
(kref_get doesn't have a return value.)

I don't see how the code above has any bearing on the last-put problem, which
I think kref and thus kobject do handle exactly correctly.

> 
> I believe (or at least hope) the actual problem cases are mostly fixed
> now but there still are a lot of misconceptions around how stuff built
> on kref/kobject is synchronized and they sometimes lead to race
> conditions buried deep under several layers of abstractions and it
> becomes very hard to see those race conditions when they are buried
> deep.

I agree that there probably misconceptions about how kref works and they are
probably based on a lack of appreciation of the subtle differences in
flavours of refcounts.  Hence my desire to create and document different
k*ref types which clarify the different use cases.

> 
> If you want to kill refcounts w/ bias based off switch, please put it
> inside an abstraction which at least synchronizes itself properly.
> Open coding w/ bias at least warns you that there is some complex
> stuff going on and you need to trade carefully.  Putting the switch on
> a separate flag - people often forget how bits in a flag field are
> synchronized - and the rest of refcount in a nice looking kref bundle
> is very likely to lead to subtle race conditions which are *very*
> difficult to notice.

The only other use of a BIAS that I am aware of is in struct super_block, and
Al Viro recently removed that in his bleeding edge tree (two days before I
sent him a patch to do the same thing:-)

It is dangerous to build too much into an abstraction else you will find that
no-one uses it as it is too specific.

The s_count and s_active in struct super_block are very similar to s_count
and s_active in struct sysfs_dirent, however they are also quite different.
super_block uses a non-atomic s_count (because a spinlock is always held
anyway) and has a separate way of preventing new s_active references (s_root
becomes NULL).  The only real similarity is that they both have an 'active'
refcount that *can* become zero and still be visible, which is different to a
kref but still a model worth encapsulating (I think) in karef.

BTW I'd be perfectly happy if the first patch was taken and subsequent ones
not.  I think they are a good idea, but I'm happy to forgo them (for now:-).

NeilBrown
