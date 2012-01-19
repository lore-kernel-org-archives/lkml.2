Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab2ASNa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 08:30:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38096 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab2ASNaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 08:30:22 -0500
Message-ID: <1326979818.2249.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] memcg: restore ss->id_lock to spinlock, using RCU for
 next
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 19 Jan 2012 14:30:18 +0100
In-Reply-To: <CAOS58YO585NYMLtmJv3f9vVdadFqoWF+Y5vZ6Va=2qHELuePJA@mail.gmail.com>
References: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils>
	 <1326958401.1113.22.camel@edumazet-laptop>
	 <CAOS58YO585NYMLtmJv3f9vVdadFqoWF+Y5vZ6Va=2qHELuePJA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 19 janvier 2012 à 04:28 -0800, Tejun Heo a écrit :
> Hello,
> 
> On Wed, Jan 18, 2012 at 11:33 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Interesting, but should be a patch on its own.
> 
> Yeap, agreed.
> 
> > Maybe other idr users can benefit from your idea as well, if patch is
> > labeled  "idr: allow idr_get_next() from rcu_read_lock" or something...
> >
> > I suggest introducing idr_get_next_rcu() helper to make the check about
> > rcu cleaner.
> >
> > idr_get_next_rcu(...)
> > {
> >        WARN_ON_ONCE(!rcu_read_lock_held());
> >        return idr_get_next(...);
> > }
> 
> Hmmm... I don't know. Does having a separate set of interface help
> much?  It's easy to avoid/miss the test by using the other one.  If we
> really worry about it, maybe indicating which locking is to be used
> during init is better? We can remember the lockdep map and trigger
> WARN_ON_ONCE() if neither the lock or RCU read lock is held.


There is a rcu_dereference_raw(ptr) in idr_get_next()

This could be changed to rcu_dereference_check(ptr, condition) to get
lockdep support for free :)

[ condition would be the appropriate
lockdep_is_held(&the_lock_protecting_my_idr) or 'I use the rcu variant'
and I hold rcu_read_lock ]

This would need to add a 'condition' parameter to idr_gen_next(), but we
have very few users in kernel at this moment.



