Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1LIPtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:49:36 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53116 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab1LIPtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:49:35 -0500
Date: Fri, 9 Dec 2011 19:49:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111209154930.GT21678@moon>
References: <20111206181026.GO29781@moon>
 <20111207185343.GA3209@redhat.com>
 <20111207190340.GP21678@moon>
 <20111208163535.GA25023@redhat.com>
 <20111208212853.GO21678@moon>
 <20111208135430.00730308.akpm@linux-foundation.org>
 <20111209153009.GA20865@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111209153009.GA20865@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 04:30:09PM +0100, Oleg Nesterov wrote:
...
> >
> > It is a potential problem, from the lock-hold point of view and
> > also it can cause large scheduling latencies.  What's involved in
> > making ->children an rcu-protected list?
> 
> At first glance, this doesn't look trivial... forget_original_parent()
> abuses ->sibling.
> 

But wait, forget_original_parent may move task out of the original
list and put it in dead_children list, right? Then release_task
may call delayed_put_task_struct under as call_rcu which should
wait until we finish reading in our rcu section, isn't it?

Even if we get inconsistent picture of children (ie we get pid
of shildren which just getting dead) I think it's fine.

> But yes, it is not really nice to hold tasklist_lock here. May be
> we can change this code so that every iteration records the reported
> task_struct and then tries to continue. This means we should verify
> that ->real_parent is still the same under tasklist, but at least
> this way we do not hold it throughout.
> 

And if real_parent is changed, I should simply skip such task and
continue, right?

> > If so, I guess the feature could/should be configurable.  Probably with
> > a CONFIG_PROC_CHILDREN which is selected by CONFIG_CHECKPOINT_RESTORE.
> > Which is all getting a bit over the top, but I suppose we must do it.
> 
> Heh. This is the rare case when I personally like the new feature ;)
> I mean, it looks "obviously useful" to me. If nothing else, it can
> help to debug the problems. Probably the tools like pstree can use it.
> 

Well, I'm personally fine with either approach. We could make it
CONFIG_CHECKPOINT_RESTORE dependant and make CONFIG_CHECKPOINT_RESTORE
being Y on default, then if someone not needed this facility he simply
turn it off, no?

> Personally I'd even prefer /proc/pid/children/ directory (like
> /proc/pid/task), but I guess this needs much more complications.
> 

I fear so. Oleg, if it possible I would like to bring in as minimum
code as I can ;)

	Cyrill
