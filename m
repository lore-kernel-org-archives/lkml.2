Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab2AOSbw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 13:31:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49611 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2AOSbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 13:31:51 -0500
Date: Sun, 15 Jan 2012 22:31:45 +0400
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
 v5
Message-ID: <20120115183145.GH3186@moon>
References: <20111228121407.GL27266@moon>
 <20120115180721.GA23810@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120115180721.GA23810@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 07:07:21PM +0100, Oleg Nesterov wrote:
> On 12/28, Cyrill Gorcunov wrote:
> >
> > When we do checkpoint of a task we need to know the list of children
> > the task has but there is no easy way to make a reverse parent->children
> > chain from an arbitrary <pid> (while a parent pid is provided in "PPid"
> > field of /proc/<pid>/status).
> 
> Looks correct at first glance... But I'll try to recheck. I guess you need
> to resend anyway, I bet nobody can recall this patch ;)
> 

Sure ;)

> However I do not understand the ptrace_may_access() check at all.
> 
...

> Well, this is cosmetic, but imho
> 
> 			if (list_is_last(...))
> 				goto out;
> 
> 			task = list_first_entry(...);
> 			...
> 
> looks better.
> 

ok

> 
> > +	list_for_each_entry(task, &start->children, sibling) {
> > +		if (pos-- == 0) {
> > +			if (ptrace_may_access(task, PTRACE_MODE_READ)) {
> > +				pid = get_pid(task_pid(task));
> > +				goto out;
> > +			} else {
> > +				/* Maybe we success with the next children */
> > +				pos++;
> 
> Again. I simply can't understand what ptrace_may_access() actually
> means. Why do we use the possible child, not parent?
> 
> IOW. I have no idea if we really need any security check at all.
> You can find the children pids without this patch anyway via.
> grep PPid /proc/*/status.
> 

OK, I see. I am actually not sure which behaviour should be there.
What should we do if say we have a task with a number of children,
which changed permissions of own and some of children. Look what I mean.

We have say tid A, which has children B C D, and when we read
/proc/pid/task/tid/children we should see "B C D" here. But
what if say A started with roots rights, then changed own permission
so everyone could read this /proc/pid/task/<A>/children, but
left C with root permissions only. So should we list C here?
Or such scenario is impossible at all?

> But if you want ptrace_may_access/whatever, you should check
> ptrace_may_access(start), no?
> 

	Cyrill
