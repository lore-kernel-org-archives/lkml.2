Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572Ab2KBKDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:03:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59695 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab2KBKDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:03:19 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50939A50.9060704@jp.fujitsu.com>
Date: Fri, 02 Nov 2012 19:02:56 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] cgroup: kill CSS_REMOVED
References: <1351712650-23709-1-git-send-email-tj@kernel.org> <1351712650-23709-3-git-send-email-tj@kernel.org>
In-Reply-To: <1351712650-23709-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/01 4:44), Tejun Heo wrote:
> CSS_REMOVED is one of the several contortions which were necessary to
> support css reference draining on cgroup removal.  All css->refcnts
> which need draining should be deactivated and verified to equal zero
> atomically w.r.t. css_tryget().  If any one isn't zero, all refcnts
> needed to be re-activated and css_tryget() shouldn't fail in the
> process.
> 
> This was achieved by letting css_tryget() busy-loop until either the
> refcnt is reactivated (failed removal attempt) or CSS_REMOVED is set
> (committing to removal).
> 
> Now that css refcnt draining is no longer used, there's no need for
> atomic rollback mechanism.  css_tryget() simply can look at the
> reference count and fail if it's deactivated - it's never getting
> re-activated.
> 
> This patch removes CSS_REMOVED and updates __css_tryget() to fail if
> the refcnt is deactivated.  As deactivation and removal are a single
> step now, they no longer need to be protected against css_tryget()
> happening from irq context.  Remove local_irq_disable/enable() from
> cgroup_rmdir().
> 
> Note that this removes css_is_removed() whose only user is VM_BUG_ON()
> in memcontrol.c.  We can replace it with a check on the refcnt but
> given that the only use case is a debug assert, I think it's better to
> simply unexport it.
> 
> v2: Comment updated and explanation on local_irq_disable/enable()
>      added per Michal Hocko.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thank you.
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



