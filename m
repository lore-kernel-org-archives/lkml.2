Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213Ab2J2OE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:04:28 -0400
Received: from mx2.parallels.com ([64.131.90.16]:36977 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab2J2OE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:04:26 -0400
Message-ID: <508E8CDE.1090702@parallels.com>
Date: Mon, 29 Oct 2012 18:04:14 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH v3 4/6] cgroups: forbid pre_destroy callback to fail
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz> <1351251453-6140-5-git-send-email-mhocko@suse.cz>
In-Reply-To: <1351251453-6140-5-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 03:37 PM, Michal Hocko wrote:
> Now that mem_cgroup_pre_destroy callback doesn't fail (other than a race
> with a task attach resp. child group appears) finally we can safely move
> on and forbit all the callbacks to fail.
> The last missing piece is moving cgroup_call_pre_destroy after
> cgroup_clear_css_refs so that css_tryget fails so no new charges for the
> memcg can happen.
> We cannot, however, move cgroup_call_pre_destroy right after because we
> cannot call mem_cgroup_pre_destroy with the cgroup_lock held (see
> 3fa59dfb cgroup: fix potential deadlock in pre_destroy) so we have to
> move it after the lock is released.
> 

If we don't have the cgroup lock held, how safe is the following
statement in mem_cgroup_reparent_charges():

if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
	return -EBUSY;

?

IIUC, although this is not generally safe, but it would be safe here
because at this point we are expected to had already set the removed bit
in the css. If this is the case, however, this condition is impossible
and becomes useless - in which case you may want to remove it from Patch1.

