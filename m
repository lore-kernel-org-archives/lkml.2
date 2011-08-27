Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab1H0Nkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 09:40:46 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:49347 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1H0Nkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 09:40:45 -0400
Date: Sat, 27 Aug 2011 15:40:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Menage <paul@paulmenage.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Tim Hockin <thockin@hockin.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFD] Task counter: cgroup core feature or cgroup subsystem?
 (was Re: [PATCH 0/8 v3] cgroups: Task counter subsystem)
Message-ID: <20110827134038.GH3298@somewhere>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <20110801161900.1fe24b76.akpm@linux-foundation.org>
 <CAAAKZwupGmw_+EaApZFAqVcXWBF885Gsjx6tUWUdMuebXrt_Mg@mail.gmail.com>
 <CAPXgP11aUfdkq-SdaHc8=tfjA4W7DYXjSXG-asoZMi6hK4iOPQ@mail.gmail.com>
 <20110818143319.GC10441@somewhere>
 <CALdu-PA3+u-v1fj-DQuC-zyJ4Ud0Xi0sq0zcB0DLNcR_TMT6XQ@mail.gmail.com>
 <20110824175431.GA26417@somewhere.redhat.com>
 <CALdu-PAiRgjFaERETAZVH=+Ky-0ekjBWn6aDK5Hzam1AQ7sC4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALdu-PAiRgjFaERETAZVH=+Ky-0ekjBWn6aDK5Hzam1AQ7sC4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 08:16:32AM -0700, Paul Menage wrote:
> On Wed, Aug 24, 2011 at 10:54 AM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
> >
> > It seems your patch doesn't handle the ->fork() and ->exit() calls.
> > We probably need a quick access to states of multi-subsystems from
> > the task, some lists available from task->cgroups, I don't know yet.
> >
> 
> That state is available, but currently only while holding cgroup_mutex
> - at least, that's what task_cgroup_from_root() requires.
> 
> It might be the case that we could achieve the same effect by just
> locking the task, so the pre-condition for task_cgroup_from_root()
> would be either that cgroup_mutex is held or the task lock is held.
> 
> We could extend the signature of cgroup_subsys.fork to include a
> reference to the cgroup; for the singly-bindable subsystems this would
> be trivially available via task->cgroups; for the multi-bindable
> subsystems then for each hierarchy that the subsystem is mounted on
> we'd call task_cgroup_from_root() to get the cgroup for that
> hierarchy. So multi-bindable subsystems with fork/exit callbacks would
> get called once for each mounted instance of the subsystem.
> 
> This would still make the task counter subsystem a bit painful - it
> would read_lock a global rwlock (css_set_lock) on every fork/exit in
> order to find the cgroup to charge/uncharge. I'm not sure how painful
> that would be on a big system. If that were a noticeable performance
> problem, we could have a variable-length extension on the end of
> css_set that contains a list of hierarchy_index/cgroup pairs for any
> hierarchies that had multi-bindable subsystems (or maybe for all
> hierarchies, for simplicity). This would make creating a css_set a
> little bit more complicated, but overall shouldn't be too painful, and
> would make the problem of finding a cgroup for a given hierarchy
> trivial.

Oh you're right. My first idea was to reference multi-bindable
subsystem states in cgroup_subsys_state, like it's done currently
for singletons subsystems. But this indeed require cgroup_mutex
or task_lock. And only the last one look sensible in fork/exit path.
And if that becomes a scalability problem we can still have a
dedicated lock for cgroup attach/detach on tasks.

Whatever we do, we need that lock. So we can pick your
solution that references cgroups that belong to multi-bindable
subsystems for a given task in css_set, or we can have tsk->cgroups->subsys[]
a variable size array that references 1 * singletons and N * multi
bindable subsystems, N beeing the number of hierarchies that use
a given subsystem.

What do you think?
