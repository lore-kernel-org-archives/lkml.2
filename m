Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab2D0Ukn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:40:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53415 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab2D0Ukm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:40:42 -0400
Date: Fri, 27 Apr 2012 13:40:35 -0700
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Han Ying <yinghan@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyuki@gmail.com
Subject: Re: [RFC][PATCH 8/9 v2] cgroup: avoid creating new cgroup under a
 cgroup being destroyed
Message-ID: <20120427204035.GN26595@google.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
 <4F9A36DE.30301@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9A36DE.30301@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 03:04:14PM +0900, KAMEZAWA Hiroyuki wrote:
> When ->pre_destroy() is called, it should be guaranteed that
> new child cgroup is not created under a cgroup, where pre_destroy()
> is running. If not, ->pre_destroy() must check children and
> return -EBUSY, which causes warning.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Hmm... I'm getting confused more.  Why do we need these cgroup changes
at all?  cgroup still has cgrp->count check and
cgroup_clear_css_refs() after pre_destroy() calls.  The order of
changes should be,

* Make memcg pre_destroy() not fail; however, pre_destroy() should
  still be ready to be retried.  That's the defined interface.

* cgroup core updated to drop pre_destroy() retrying and guarantee
  that pre_destroy() invocation will happen only once.

* memcg and other cgroups can update their pre_destroy() if the "won't
  be retried" part can simplify their implementations.

So, there's no reason to be updating cgroup pre_destroy() semantics at
this point and these updates actually break cgroup API as it currently
stands.  The only change necessary is memcg's pre_destroy() not
returning zero.

Thanks.

-- 
tejun
