Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab2CHS0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:26:31 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:52597 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006Ab2CHS03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:26:29 -0500
Date: Thu, 8 Mar 2012 10:26:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        =?utf-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] cgroup: fix race between fork and cgroup freezing
Message-ID: <20120308182622.GC25508@google.com>
References: <4F587199.6050404@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F587199.6050404@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li, Frederic.

On Thu, Mar 08, 2012 at 04:45:13PM +0800, Li Zefan wrote:
> +static void freezer_post_fork(struct cgroup_subsys *ss,
> +			      struct task_struct *task)
> +{
> +	struct freezer *freezer;
> +
> +	cgroup_lock();
> +
> +	freezer = task_freezer(task);
> +	if (!freezer->css.cgroup->parent)
> +		goto out;
> +
> +	spin_lock_irq(&freezer->lock);
> +	if (freezer->state != CGROUP_THAWED)
> +		freeze_task(task);
> +	spin_unlock_irq(&freezer->lock);
> +out:
> +	cgroup_unlock();
> +}

Urgh... this is requiring policy implementations to synchronize with
problem caused by cgroup core optimization and it's so very subtle.
IMHO, this definitely should be contained in cgroup core and in a very
confined form even inside cgroup core.

Any other ideas?

Thanks.

-- 
tejun
