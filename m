Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab2BWPCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 10:02:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197Ab2BWPCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 10:02:48 -0500
Date: Thu, 23 Feb 2012 10:02:39 -0500
From: Josef Bacik <josef@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Josef Bacik <josef@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: add sysctl to enable slab memory dump
Message-ID: <20120223150238.GA15427@dhcp231-144.rdu.redhat.com>
References: <20120222115320.GA3107@x61.redhat.com>
 <alpine.DEB.2.00.1202221640420.14213@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202221640420.14213@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 04:44:58PM -0800, David Rientjes wrote:
> On Wed, 22 Feb 2012, Rafael Aquini wrote:
> 
> > Adds a new sysctl, 'oom_dump_slabs', that enables the kernel to produce a
> > dump of all eligible system slab caches when performing an OOM-killing.
> > Information includes per cache active objects, total objects, object size,
> > cache name and cache size.
> > 
> > The eligibility for being reported is given by an auxiliary sysctl,
> > 'oom_dump_slabs_ratio', which express (in percentage) the memory committed
> > ratio between a particular cache size and the total slab size.
> > 
> > This, alongside with all other data dumped in OOM events, is very helpful
> > information in diagnosing why there was an OOM condition specially when
> > kernel code is under investigation.
> > 
> 
> I don't like this because it duplicates what is given by /proc/slabinfo 
> that can easily be read at the time of oom and is unnecessary to dump to 
> the kernel log.  We display the meminfo (which includes the amount of 
> slab, just not broken down by cache) because it's absolutely necessary to 
> understand why the oom was triggered.  The tasklist dump is allowed 
> because it's difficult to attain all that information easily and to 
> determine which threads are eligible in the oom context (global, memcg, 
> cpuset, mempolicy) so they matter to the oom condition.  The per-cache 
> slabinfo fits neither of that criteria and just duplicates code in the 
> slab allocators that is attainable elsewhere.
> 

I requested this specifically because I was oom'ing the box so hard that I
couldn't read /proc/slabinfo at the time of OOM and therefore had no idea what I
was leaking.  Telling me how much slab was in use was no help, I needed to know
which of the like 6 objects I was doing horrible things with was screwing me,
and without this patch I would have no way of knowing.

> I think this also gives another usecase for a possible /dev/mem_notify in 
> the future: userspace could easily poll on an eventfd and wait for an oom 
> to occur and then cat /proc/slabinfo to attain all this.  In other words, 
> if we had this functionality (which I think we undoubtedly will in the 
> future), this patch would be obsoleted.

Sure, if the OOM killer doesn't kill the poller, or kill NetworkManager since
I'm remote logged into the box, or any of the other various important things
that would be required for me to get this info.  Thanks,

Josef
