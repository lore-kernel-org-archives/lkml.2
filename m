Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2INPQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 11:16:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab2INPQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 11:16:52 -0400
Date: Fri, 14 Sep 2012 11:14:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@suse.cz>,
        Glauber Costa <glommer@parallels.com>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120914151447.GD6221@redhat.com>
References: <20120913205827.GO7677@google.com>
 <20120914142539.GC6221@redhat.com>
 <1347634409.7172.58.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347634409.7172.58.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 04:53:29PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-09-14 at 10:25 -0400, Vivek Goyal wrote:
> > So while % model is more intutive to users, it is hard to implement.
> 
> I don't agree with that. The fixed quota thing is counter-intuitive and
> hard to use. It begets you questions like: why, if everything is idle
> except my task, am I not getting the full throughput.

Actually by fixed quota I meant minimum fixed %. So if other groups are
idle, this group still gets to use 100% bandwidth. When resources are
highly contended, this group gets its minimum fixed %.

> 
> It also makes adding entities harder because you're constrained to 100%.
> This means you have to start each new cgroup with 0% because any !0
> value will eventually get you over 100%, it also means you have to do
> some form of admission control to make sure you never get over that
> 100%.
> 
> Starting with 0% is not convenient for people.. they think this is the
> wrong default, even though as argued above, it is the only possible
> value.

We don't have to start with 0%. We can keep a pool with dynamic % and
launch all the virtual machines from that single pool. So nobody starts
with 0%. If we require certain % for a machine, only then we look at
peers and see if we have bandwidth free and create cgroup and move virtual
machine there, otherwise we deny resources. 

So I think it is doable just that it is painful and tricky and I think
lot of it will be in user space.

> 
> >  So
> > an easier way is to stick to the model of relative weights/share and
> > let user specify relative importance of a virtual machine and actual
> > quota or % will vary dynamically depending on other tasks/components
> > in the system.
> > 
> > Thoughts? 
> 
> cpu does the relative weight, so 'users' will have to deal with it
> anyway regardless of blk, its effectively free of learning curve for all
> subsequent controllers.

I am inclined to keep it simple in kernel and just follow cpu model of
relative weights and treating tasks and gropu at same level in the
hierarchy. It makes behavior consistent across the controllers and I
think it might just work for majority of cases.

Those who really need to implement % model, they will have to do heavy
lifting in user space. I am skeptical that will take off but kernel
does not prohibit from somebody creating a group, moving all tasks
there and making sure tasks and groups are not at same level hence
% becomes more predictable. Just that, that's not the default from
kernel.

So yes, doing it cpu controller way in block controller should be
reasonable.

Thanks
Vivek
