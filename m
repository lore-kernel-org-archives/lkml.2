Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1HZPzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 11:55:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34102 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab1HZPzC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 11:55:02 -0400
MIME-Version: 1.0
In-Reply-To: <20110826023818.GC3457@count0.beaverton.ibm.com>
References: <1314312192-26885-1-git-send-email-tj@kernel.org>
 <1314312192-26885-4-git-send-email-tj@kernel.org> <20110826023818.GC3457@count0.beaverton.ibm.com>
From: Paul Menage <paul@paulmenage.org>
Date: Fri, 26 Aug 2011 08:54:42 -0700
X-Google-Sender-Auth: uz9cYEU4ZLgXUHLJfnWDz0DB0KA
Message-ID: <CALdu-PB==1C9NyrbAEqR932DOVLbdtv7Ri9_cUCMiz_PwmvL3g@mail.gmail.com>
Subject: Re: [PATCH 3/6] cgroup: introduce cgroup_taskset and use it in
 subsys->can_attach(), cancel_attach() and attach()
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 7:38 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
> On Fri, Aug 26, 2011 at 12:43:09AM +0200, Tejun Heo wrote:
>> Currently, there's no way to pass multiple tasks to cgroup_subsys
>> methods necessitating the need for separate per-process and per-task
>> methods.  This patch introduces cgroup_taskset which can be used to
>> pass multiple tasks and their associated cgroups to cgroup_subsys
>> methods.
>
> This will be the third iterator-ish pattern in the cgroup code.
> It's not your fault but it does seem a bit much to have:

I agree with this sentiment in principle (in fact it was one of the
first things that I thought when I saw this patch) but I think that
merging them is a non-trivial process, and so shouldn't hold up the
introduction of this patch set.

Changing the cgroup_scanner interface to be control-loop rather than
callback (for the processed tasks, at least - testing tasks will have
to be a callback still, I think) shouldn't be too hard.

The important differences between the iterators then are how they
generate a stable set of tasks. If we made the basic callback
operations be:

start - do any prep work
fill - return some tasks to process, or none if the iterator is exhausted
end - undo any prep work

then the user API functions would look something like:

iter_start(iter *i) {
  i->start();
  i->avail_task_count = i->avail_task_pos = 0;
}

struct task_and_cgroup *iter_next(iter *i) {
  if (i->avail_task_pos >= i->avail_task_count) {
    i->avail_task_pos = 0;
    i->fill(&i->avail_tasks, &i->avail_task_count);
    if (!i->avail_tasks)
      return NULL;
    }
  }
  return i->avail_tasks + i->avail_task_pos++;
}

iter_end(iter *i) {
  i->end();
}

then for the three iteration abstractions:

- cgroup_iter_start/next/end:

creation API: taskset_from_cgroup(cgroup *cg)

start - takes the lock
fill - returns the next task in the cgroup, or NULL if exhausted
end - releases the lock

- cgroup_taskset

creation API: taskset_from_array(task_and_cgroup *tg, int count)

start - no-op
fill - returns a pointer to the array used to set up the taskset
end - no-op

- cgroup_scanner

creation API: atomic_taskset_from_array(cgroup, test_fn, optional_heap);

start - allocate an array for storing the heap used to build the next
batch of tasks (if not provided by creator)
fill - takes css_set lock and makes a pass over the cgroup to find the
lowest (by start-time) set of unprocessed tasks that match the test_fn
predicate, releases css_set_lock
end - frees the array (if not provided by the creator)

I think the progression of patches would be:

- convert the current user of cgroup_scanner to a control-loop API
rather than a callback API (for process_task) just to verify that this
fits in the existing model

- convert the initial implementation of cgroup_taskset to use the new
internal start/fill/end API

- convert the other two iterators (in separate patches) to use the new
internal and external APIs.

Paul
