Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab1HZPQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 11:16:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37334 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1HZPQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 11:16:52 -0400
MIME-Version: 1.0
In-Reply-To: <20110824175431.GA26417@somewhere.redhat.com>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <20110801161900.1fe24b76.akpm@linux-foundation.org> <CAAAKZwupGmw_+EaApZFAqVcXWBF885Gsjx6tUWUdMuebXrt_Mg@mail.gmail.com>
 <CAPXgP11aUfdkq-SdaHc8=tfjA4W7DYXjSXG-asoZMi6hK4iOPQ@mail.gmail.com>
 <20110818143319.GC10441@somewhere> <CALdu-PA3+u-v1fj-DQuC-zyJ4Ud0Xi0sq0zcB0DLNcR_TMT6XQ@mail.gmail.com>
 <20110824175431.GA26417@somewhere.redhat.com>
From: Paul Menage <paul@paulmenage.org>
Date: Fri, 26 Aug 2011 08:16:32 -0700
X-Google-Sender-Auth: qzhfcHqqeppazo-4LB7Gm_vx_po
Message-ID: <CALdu-PAiRgjFaERETAZVH=+Ky-0ekjBWn6aDK5Hzam1AQ7sC4Q@mail.gmail.com>
Subject: Re: [RFD] Task counter: cgroup core feature or cgroup subsystem? (was
 Re: [PATCH 0/8 v3] cgroups: Task counter subsystem)
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Tim Hockin <thockin@hockin.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 10:54 AM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
>
> It seems your patch doesn't handle the ->fork() and ->exit() calls.
> We probably need a quick access to states of multi-subsystems from
> the task, some lists available from task->cgroups, I don't know yet.
>

That state is available, but currently only while holding cgroup_mutex
- at least, that's what task_cgroup_from_root() requires.

It might be the case that we could achieve the same effect by just
locking the task, so the pre-condition for task_cgroup_from_root()
would be either that cgroup_mutex is held or the task lock is held.

We could extend the signature of cgroup_subsys.fork to include a
reference to the cgroup; for the singly-bindable subsystems this would
be trivially available via task->cgroups; for the multi-bindable
subsystems then for each hierarchy that the subsystem is mounted on
we'd call task_cgroup_from_root() to get the cgroup for that
hierarchy. So multi-bindable subsystems with fork/exit callbacks would
get called once for each mounted instance of the subsystem.

This would still make the task counter subsystem a bit painful - it
would read_lock a global rwlock (css_set_lock) on every fork/exit in
order to find the cgroup to charge/uncharge. I'm not sure how painful
that would be on a big system. If that were a noticeable performance
problem, we could have a variable-length extension on the end of
css_set that contains a list of hierarchy_index/cgroup pairs for any
hierarchies that had multi-bindable subsystems (or maybe for all
hierarchies, for simplicity). This would make creating a css_set a
little bit more complicated, but overall shouldn't be too painful, and
would make the problem of finding a cgroup for a given hierarchy
trivial.

Paul
