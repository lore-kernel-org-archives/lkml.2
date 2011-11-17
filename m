Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1KQCPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 21:15:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64957 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab1KQCPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 21:15:48 -0500
Date: Thu, 17 Nov 2011 10:15:38 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -rt] memcg: use migrate_disable()/migrate_enable( ) in
 memcg_check_events()
Message-ID: <20111117021538.GB9281@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <alpine.LFD.2.02.1111150050590.4902@ionos>
 <20111115084059.GA23250@zhy>
 <20111116091653.GA8692@zhy>
 <1321452758.4181.18.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1321452758.4181.18.camel@frodo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 09:12:38AM -0500, Steven Rostedt wrote:
> On Wed, 2011-11-16 at 17:16 +0800, Yong Zhang wrote:
> > Looking at commit 4799401f [memcg: Fix race condition in
> > memcg_check_events() with this_cpu usage], we just want
> > to disable migration. So use the right API in -rt. This
> > will cure below warning.
> > 
> 
> >  mm/memcontrol.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 6aff93c..afa1954 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -722,7 +722,7 @@ static void __mem_cgroup_target_update(struct mem_cgroup *memcg, int target)
> >   */
> >  static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
> >  {
> > -	preempt_disable();
> > +	migrate_disable();
> 
> No this won't work. Not even for -rt. If we disable migration but not
> preemption, then two tasks can take this path. And the checks in
> __memcg_event_check() will be corrupted because nothing is protecting
> the updates from two tasks going into the same path.

I assumed that we only care about migration, but obviously I'm wrong.

> 
> Perhaps a local_lock would work.

Yeah, will try tglx's patch later.

Thanks,
Yong
