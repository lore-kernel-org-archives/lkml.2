Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2DACAo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 22:00:44 -0400
Received: from szxga01-in.huawei.com ([58.251.152.64]:34698 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2DACAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 22:00:42 -0400
Date: Sun, 01 Apr 2012 10:00:26 +0800
From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 2/2] cgroup: make css->refcnt clearing on cgroup removal
 optional
In-reply-to: <20120330223606.GK28934@google.com>
X-Originating-IP: [10.166.88.150]
To: Tejun Heo <tj@kernel.org>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Vivek Goyal <vgoyal@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Message-id: <4F77B6BA.4070207@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312
 Thunderbird/11.0
X-CFilter-Loop: Reflected
References: <20120330223423.GJ28934@google.com>
 <20120330223606.GK28934@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:

> Currently, cgroup removal tries to drain all css references.  If there
> are active css references, the removal logic waits and retries
> ->pre_detroy() until either all refs drop to zero or removal is
> cancelled.
> 


I don't like this either.

> This semantics is unusual and adds non-trivial complexity to cgroup
> core and IMHO is fundamentally misguided in that it couples internal
> implementation details (references to internal data structure) with
> externally visible operation (rmdir).  To userland, this is a behavior
> peculiarity which is unnecessary and difficult to expect (css refs is
> otherwise invisible from userland), and, to policy implementations,
> this is an unnecessary restriction (e.g. blkcg wants to hold css refs
> for caching purposes but can't as that becomes visible as rmdir hang).
> 
> Unfortunately, memcg currently depends on ->pre_destroy() retrials and
> cgroup removal vetoing and can't be immmediately switched to the new
> behavior.  This patch introduces the new behavior of not waiting for
> css refs to drain and maintains the old behavior for subsystems which
> have __DEPRECATED_clear_css_refs set.
> 
> Once, memcg is updated, we can drop the code paths for the old
> behavior as proposed in the following patch.  Note that the following
> patch is incorrect in that dput work item is in cgroup and may lose
> some of dputs when multiples css's are released back-to-back, and
> __css_put() triggers check_for_release() when refcnt reaches 0 instead
> of 1; however, it shows what part can be removed.
> 
>   http://thread.gmane.org/gmane.linux.kernel.containers/22559/focus=75251
> 
> Note that, in not-too-distant future, cgroup core will start emitting
> warning messages for subsys which require the old behavior, so please
> get moving.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>


Both patches look good.

Acked-by: Li Zefan <lizefan@huawei.com>

and I'd like to see code shrink with memcg updates ASAP.

> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

