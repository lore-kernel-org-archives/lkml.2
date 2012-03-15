Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031302Ab2COASc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:18:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36775 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760898Ab2COAS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:18:29 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F6134E1.5090601@jp.fujitsu.com>
Date: Thu, 15 Mar 2012 09:16:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, gthelen@google.com,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC REPOST] cgroup: removing css reference drain wait during
 cgroup removal
References: <20120312213155.GE23255@google.com> <20120312213343.GF23255@google.com> <20120313151148.f8004a00.kamezawa.hiroyu@jp.fujitsu.com> <20120313163914.GD7349@google.com> <20120314092828.3321731c.kamezawa.hiroyu@jp.fujitsu.com> <4F6068F4.4090909@parallels.com>
In-Reply-To: <4F6068F4.4090909@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/14 18:46), Glauber Costa wrote:

> On 03/14/2012 04:28 AM, KAMEZAWA Hiroyuki wrote:
>> IIUC, in general, even in the processes are in a tree, in major case
>> of servers, their workloads are independent.
>> I think FLAT mode is the dafault. 'heararchical' is a crazy thing which
>> cannot be managed.
> 
> Better pay attention to the current overall cgroups discussions being 
> held by Tejun then. ([RFD] cgroup: about multiple hierarchies)
> 
> The topic of whether of adapting all cgroups to be hierarchical by 
> deafult is a recurring one.
> 
> I personally think that it is not unachievable to make res_counters 
> cheaper, therefore making this less of a problem.
> 


I thought of this a little yesterday. Current my idea is applying following
rule for res_counter.

1. All res_counter is hierarchical. But behavior should be optimized.

2. If parent res_counter has UNLIMITED limit, 'usage' will not be propagated
   to its parent at _charge_.

3. If a res_counter has UNLIMITED limit, at reading usage, it must visit
   all children and returns a sum of them.

Then,
	/cgroup/
		memory/                       (unlimited)
			libivirt/             (unlimited)
				 qeumu/       (unlimited)
				        guest/(limited)

All dir can show hierarchical usage and the guest will not have
any lock contention at runtime.


By this
 1. no runtime overhead if the parent has unlimited limit.
 2. All res_counter can show aggregate resource usage of children.

To do this
 1. res_coutner should have children list by itself.

Implementation problem
 - What should happens when a user set new limit to a res_counter which have
   childrens ? Shouldn't we allow it ? Or take all locks of children and
   update in atomic ?
 - memory.use_hierarchy should be obsolete ?

Other problem I'm not sure at all
 - blkcg doesn't support hierarchy at all.

Hmm. 

Thanks,
-Kame








