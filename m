Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab2IQP14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:27:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086Ab2IQP1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:27:54 -0400
Date: Mon, 17 Sep 2012 11:27:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Graf <tgraf@suug.ch>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120917152704.GC5094@redhat.com>
References: <20120913205827.GO7677@google.com>
 <20120914142539.GC6221@redhat.com>
 <1347634409.7172.58.camel@twins>
 <20120914151447.GD6221@redhat.com>
 <20120914215701.GW17747@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914215701.GW17747@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 02:57:01PM -0700, Tejun Heo wrote:

[..]
> > > cpu does the relative weight, so 'users' will have to deal with it
> > > anyway regardless of blk, its effectively free of learning curve for all
> > > subsequent controllers.
> > 
> > I am inclined to keep it simple in kernel and just follow cpu model of
> > relative weights and treating tasks and gropu at same level in the
> > hierarchy. It makes behavior consistent across the controllers and I
> > think it might just work for majority of cases.
> 
> I think we need to stick to one model for all controllers; otherwise,
> it gets confusing and unified hierarchy can't work.  That said, I'm
> not too happy about how cpu is handling it now.
> 
> * As I wrote before, the configuration esacpes cgroup proper and the
>   mapping from per-task value to group weight is essentially
>   arbitrary and may not exist depending on the resource type.

If need be, one can create task priority type for those resources too. Or
one could even think of being able to directly specify weigths (same
thing as groups) for tasks. That should be doable if people think if that
kind of interface helps.

> 
> * The proportion of each group fluctuates as tasks fork and exit in
>   the parent group, which is confusing.

Agreed with that. But some people are just happy with varying
percentage and don't care about fixed percentage. In fact current
deployments of systemd and libvirt don't care about fixed percentage.
They are just happy providing relative priority to things and making
sure some kind of basic isolation.

> 
> * cpu deals with tasks but blkcg deals with iocontexts and memcg,
>   which currently doesn't implement proportional control, deals with
>   address spaces (processes).  The proportions wouldn't even fluctuate
>   the same way across different controllers.
> 
> So, I really don't think the current model used by cpu is a good one
> and we rather should treat the tasks as a group competing with the
> rest of child groups.  Whether we can change that at this point, I
> don't know.  Peter, what do you think?

I am not convinced that by default kernel should enforce that all the
tasks of a group are accounted to a hidden group. People have use
cases where they are happy with currently offered semantics. I think
auto scheduler group is another example where system is well protected
from workloads like "make -j64". Even in the case of hidden group it
will be protected but %share of that group will be much higher. (Up
to 50%).

So IMHO, if users really care about tasks and groups not competing
at same level, users should create hiearchy that way and kernel should
not enforce that.

Thanks
Vivek
