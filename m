Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab2IZXd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 19:33:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57551 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab2IZXdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 19:33:40 -0400
Date: Wed, 26 Sep 2012 16:33:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Message-ID: <20120926233334.GD10453@mtj.dyndns.org>
References: <20120926195648.GA20342@google.com>
 <50635F46.7000700@parallels.com>
 <20120926201629.GB20342@google.com>
 <50637298.2090904@parallels.com>
 <20120926221046.GA10453@mtj.dyndns.org>
 <506381B2.2060806@parallels.com>
 <20120926224235.GB10453@mtj.dyndns.org>
 <50638793.7060806@parallels.com>
 <20120926230807.GC10453@mtj.dyndns.org>
 <50638DBB.4000002@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50638DBB.4000002@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 27, 2012 at 03:20:27AM +0400, Glauber Costa wrote:
> > One of the things wrong with that is that it exposes the limitation of
> > the current implementation as interface to userland, which is never a
> > good idea.  In addition, how is userland supposed to know which
> > workload is shared kmem heavy or not?  Details like that are not even
> > inherent to workloads.  It's highly dependent on kernel implementation
> > which may change any day.  If we hit workloads like that the right
> > thing to do is improving kmemcg so that such problems don't occur, not
> > exposing another switch.
> 
> Sorry, there is nothing implementation dependent in here. One of the
> biggest consumers of all this, are dentries. Dentries are related to
> the paths you touch. If you touch files in a self-contained directory,
> where you don't expect anyone else to touch, this can safely be
> considered local. If you touch files all around, this can safely be
> considered not local. Where is the implementation dependent part?

For things like dentries and inodes and if that really matters, we
should be able to account for the usage better, no?  And frankly I'm
not even sold on that usecase.  Unless there's a way to detect and
inform about these, userland isn't gonna know that they're doing
something which consumes a lot of shared memory even that activity is
filesystem walking.  You're still asking userland to tune something
depending on parameters not easily visible from userland.  It's a lose
lose situation.

> >> Even after the limit is set, it is set only by workloads that want kmem
> >> to be tracked. If you want to track it during the whole lifetime of the
> >> cgroup, you switch it before you put tasks to it. What is so crazy about it?
> > 
> > The fact that the numbers don't really mean what they apparently
> > should mean.
> > 
> 
> This is vague. The usage file in the cgroup means how much kernel memory
> was used by that cgroup. If it really bothers you that this may not be
> set through the whole group's lifetime, it is also easily solvable.

Yes, easily by having a global switch which can be manipulated when
there's no children.  It really seems like a no brainer to me.

> > So, this seems properly crazy to me at the similar level of
> > use_hierarchy fiasco.  I'm gonna NACK on this.
> 
> As I said: all use cases I particularly care about are covered by a
> global switch.
> 
> I am laying down my views because I really believe they make more sense.
> But at some point, of course, I'll shut up if I believe I am a lone voice.
> 
> I believe it should still be good to hear from mhocko and kame, but from
> your point of view, would all the rest, plus the introduction of a
> global switch make it acceptable to you?

The only thing I'm whining about is per-node switch + silently
ignoring past accounting, so if those two are solved, I think I'm
pretty happy with the rest.

Thanks.

-- 
tejun
