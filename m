Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab2AISpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 13:45:14 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:58429 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752806Ab2AISpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 13:45:12 -0500
Date: Mon, 9 Jan 2012 10:45:01 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [GIT PULL] cgroup changes for v3.3-rc1
Message-ID: <20120109184501.GC7421@google.com>
References: <20120109183951.GB7421@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109183951.GB7421@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 10:39:51AM -0800, Tejun Heo wrote:
> Hello, Linus.
> 
> Please pull from the following branch to receive cgroup changes.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.3

Oops, forgot writing about conflicts.  There will be the following
conflict in kernel/cgroup.c.

	/*
	 * step 2: make sure css_sets exist for all threads to be migrated.
	 * we use find_css_set, which allocates a new one if necessary.
	 */
	INIT_LIST_HEAD(&newcg_list);
	for (i = 0; i < group_size; i++) {
<<<<<<< HEAD
		tc = flex_array_get(group, i);
		oldcg = tc->task->cgroups;

		/* if we don't already have it in the list get a new one */
		if (!css_set_check_fetched(cgrp, tc->task, oldcg,
					   &newcg_list)) {
=======
		tsk = flex_array_get_ptr(group, i);
		/* nothing to do if this task is already in the cgroup */
		oldcgrp = task_cgroup_from_root(tsk, root);
		if (cgrp == oldcgrp)
			continue;
		/* get old css_set pointer */
		task_lock(tsk);
		oldcg = tsk->cgroups;
		get_css_set(oldcg);
		task_unlock(tsk);
		/* see if the new one for us is already in the list? */
		if (css_set_check_fetched(cgrp, tsk, oldcg, &newcg_list)) {
			/* was already there, nothing to do. */
			put_css_set(oldcg);
		} else {
			/* we don't already have it. get new one. */
>>>>>>> a0e86bd4252519321b0d102dc4ed90557aa7bee9
			retval = css_set_prefetch(cgrp, oldcg, &newcg_list);
			if (retval)
				goto out_list_teardown;
		}
	}

This is caused by e0197aae59 "cgroups: fix a css_set not found bug in
cgroup_attach_proc" in mainline fixing a bug in code removed in
for-3.3 branch and taking the part from for-3.3 is the correct
resolution.  Just in case, the following is my test merge branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git test-merge

Thanks.

-- 
tejun
