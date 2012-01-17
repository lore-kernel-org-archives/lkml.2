Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab2AQR5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:57:32 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61885 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab2AQR5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:57:31 -0500
Date: Tue, 17 Jan 2012 21:57:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children entry
 v6
Message-ID: <20120117175725.GJ16213@moon>
References: <20120116153231.GF2998@moon>
 <20120116161114.GA17727@redhat.com>
 <20120116162021.GH2998@moon>
 <20120117174049.GA19268@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117174049.GA19268@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 06:40:49PM +0100, Oleg Nesterov wrote:
...
> > >
> > > But this is not enough. exit_ptrace() can do list_move() without
> > > changing ->real_parent.
> > >
> > > I'll try to think. At first glance we can rely on EXIT_DEAD, but
> > > I'd like to avoid this, I think EXIT_DEAD should die.
> >
> > Ouch! Thanks for catching this Oleg. I'll try to come with something
> > to show as well.
> 
> Do you see another approach? I don't, so I'd suggest to check
> "task->exit_state != EXIT_DEAD" instead of !list_empty().
> 

Well, I thought what if I can find another way without EXIT_DEAD
but seems there is no luck.

> Just in case, we can also check "start->exit_state == 0" instead
> of "task->real_parent == start" with the same effect, up to you.
> 

real_parent == start somehow more informative for me so if you allow
(and noone against) I would leave the current form.

> It would be nice to add the comment explaining these checks...
> 

Yeah, I'll add ones. Sure.

> And I forgot to mention, the comment below
> 
> 	> +			/*
> 	> +			 * We might miss some freshly created children
> 	> +			 * here, but it was never promised to be
> 	> +			 * accurate.
> 	> +			 */
> 	> +			if (list_is_last(&task->sibling, &start->children))
> 	> +				goto out;
> 
> looks misleading. Contrary to the slow path, we can't miss the
> freshly forked child here, copy_process() does list_add_tail().
> 

Ah, crap, indeed!

> But the slow path obviously can skip much more than needed and
> miss children (freshly forked or not), probably it would be better
> to move the comment down and remove the "freshly created" part.
> 
> What do you think?
> 
> 

Yeah, thanks a lot, Oleg. I'll update it an post for review (I hope
to finish it tonight ;)

	Cyrill
