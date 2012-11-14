Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab2KNLFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:05:54 -0500
Received: from mx2.parallels.com ([64.131.90.16]:45201 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab2KNLFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:05:52 -0500
Message-ID: <50A37B0A.7010608@parallels.com>
Date: Wed, 14 Nov 2012 15:05:46 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <lizefan@huawei.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mhocko@suse.cz>
Subject: Re: [PATCH 05/17] cgroup: cgroup->dentry isn't a RCU pointer
References: <1352775704-9023-1-git-send-email-tj@kernel.org> <1352775704-9023-6-git-send-email-tj@kernel.org>
In-Reply-To: <1352775704-9023-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 07:01 AM, Tejun Heo wrote:
> cgroup->dentry is marked and used as a RCU pointer; however, it isn't
> one - the final dentry put doesn't go through call_rcu().  cgroup and
> dentry share the same RCU freeing rule via synchronize_rcu() in
> cgroup_diput() (kfree_rcu() used on cgrp is unnecessary).  If cgrp is
> accessible under RCU read lock, so is its dentry and dereferencing
> cgrp->dentry doesn't need any further RCU protection or annotation.
> 
> While not being accurate, before the previous patch, the RCU accessors
> served a purpose as memory barriers - cgroup->dentry used to be
> assigned after the cgroup was made visible to cgroup_path(), so the
> assignment and dereferencing in cgroup_path() needed the memory
> barrier pair.  Now that list_add_tail_rcu() happens after
> cgroup->dentry is assigned, this no longer is necessary.
> 
> Remove the now unnecessary and misleading RCU annotations from
> cgroup->dentry.  To make up for the removal of rcu_dereference_check()
> in cgroup_path(), add an explicit rcu_lockdep_assert(), which asserts
> the dereference rule of @cgrp, not cgrp->dentry.
> 

Will memcontrol.c need similar amendments?

The code that lives in -mm and includes kmemcg includes the following
excerpt:

        rcu_read_lock();
        dentry = rcu_dereference(memcg->css.cgroup->dentry);
        rcu_read_unlock();


