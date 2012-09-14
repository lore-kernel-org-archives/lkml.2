Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab2INV5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:57:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57757 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab2INV5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:57:07 -0400
Date: Fri, 14 Sep 2012 14:57:01 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
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
Message-ID: <20120914215701.GW17747@google.com>
References: <20120913205827.GO7677@google.com>
 <20120914142539.GC6221@redhat.com>
 <1347634409.7172.58.camel@twins>
 <20120914151447.GD6221@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914151447.GD6221@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek, Peter.

On Fri, Sep 14, 2012 at 11:14:47AM -0400, Vivek Goyal wrote:
> We don't have to start with 0%. We can keep a pool with dynamic % and
> launch all the virtual machines from that single pool. So nobody starts
> with 0%. If we require certain % for a machine, only then we look at
> peers and see if we have bandwidth free and create cgroup and move virtual
> machine there, otherwise we deny resources. 
> 
> So I think it is doable just that it is painful and tricky and I think
> lot of it will be in user space.

I think the system-wide % thing is rather distracting for the
discussion at hand (and I don't think being able to specify X% of the
whole system when you're three level down the resource hierarchy makes
sense anyway).  Let's focus on tasks vs. groups.

> > >  So
> > > an easier way is to stick to the model of relative weights/share and
> > > let user specify relative importance of a virtual machine and actual
> > > quota or % will vary dynamically depending on other tasks/components
> > > in the system.
> > > 
> > > Thoughts? 
> > 
> > cpu does the relative weight, so 'users' will have to deal with it
> > anyway regardless of blk, its effectively free of learning curve for all
> > subsequent controllers.
> 
> I am inclined to keep it simple in kernel and just follow cpu model of
> relative weights and treating tasks and gropu at same level in the
> hierarchy. It makes behavior consistent across the controllers and I
> think it might just work for majority of cases.

I think we need to stick to one model for all controllers; otherwise,
it gets confusing and unified hierarchy can't work.  That said, I'm
not too happy about how cpu is handling it now.

* As I wrote before, the configuration esacpes cgroup proper and the
  mapping from per-task value to group weight is essentially
  arbitrary and may not exist depending on the resource type.

* The proportion of each group fluctuates as tasks fork and exit in
  the parent group, which is confusing.

* cpu deals with tasks but blkcg deals with iocontexts and memcg,
  which currently doesn't implement proportional control, deals with
  address spaces (processes).  The proportions wouldn't even fluctuate
  the same way across different controllers.

So, I really don't think the current model used by cpu is a good one
and we rather should treat the tasks as a group competing with the
rest of child groups.  Whether we can change that at this point, I
don't know.  Peter, what do you think?

Thanks.

-- 
tejun
