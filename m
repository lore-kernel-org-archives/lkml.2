Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab1LVFsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 00:48:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62955 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab1LVFsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 00:48:37 -0500
Message-ID: <4EF2C536.7070408@cn.fujitsu.com>
Date: Thu, 22 Dec 2011 13:50:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mandeep Singh Baines <msb@chromium.org>
CC: Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 4/4] cgroup: remove extra calls to find_existing_css_set
References: <1324527518-24461-1-git-send-email-msb@chromium.org> <1324527518-24461-4-git-send-email-msb@chromium.org>
In-Reply-To: <1324527518-24461-4-git-send-email-msb@chromium.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-22 13:47:52,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-22 13:47:54,
	Serialize complete at 2011-12-22 13:47:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -2091,6 +2010,10 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  	 * rcu or tasklist locked. instead, build an array of all threads in the
>  	 * group - group_rwsem prevents new threads from appearing, and if
>  	 * threads exit, this will just be an over-estimate.
> +	 *
> +	 * While creating the list, also make sure css_sets exist for all
> +	 * threads to be migrated. we use find_css_set, which allocates a new
> +	 * one if necessary.
>  	 */
>  	group_size = get_nr_threads(leader);
>  	/* flex_array supports very large thread-groups better than kmalloc. */
> @@ -2137,6 +2060,12 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  		/* nothing to do if this task is already in the cgroup */
>  		if (ent.cgrp == cgrp)
>  			continue;
> +		ent.cg = find_css_set(tsk->cgroups, cgrp);

unfortunately This won't work, because we are holding tasklist_lock.

> +		if (!ent.cg) {
> +			retval = -ENOMEM;
> +			group_size = i;
> +			goto out_list_teardown;
> +		}
>  		retval = flex_array_put(group, i, &ent, GFP_ATOMIC);
>  		BUG_ON(retval != 0);
>  		i++;
