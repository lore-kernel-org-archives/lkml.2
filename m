Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138Ab2D0Liy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 07:38:54 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:52853 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab2D0Liw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 07:38:52 -0400
Date: Fri, 27 Apr 2012 13:38:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, devel@openvz.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 17/23] kmem controller charge/uncharge infrastructure
Message-ID: <20120427113841.GB3514@somewhere.redhat.com>
References: <1334959051-18203-1-git-send-email-glommer@parallels.com>
 <1335138820-26590-6-git-send-email-glommer@parallels.com>
 <alpine.DEB.2.00.1204231522320.13535@chino.kir.corp.google.com>
 <20120424142232.GC8626@somewhere>
 <alpine.DEB.2.00.1204241319360.753@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204241319360.753@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 01:21:43PM -0700, David Rientjes wrote:
> On Tue, 24 Apr 2012, Frederic Weisbecker wrote:
> 
> > > This seems horribly inconsistent with memcg charging of user memory since 
> > > it charges to p->mm->owner and you're charging to p.  So a thread attached 
> > > to a memcg can charge user memory to one memcg while charging slab to 
> > > another memcg?
> > 
> > Charging to the thread rather than the process seem to me the right behaviour:
> > you can have two threads of a same process attached to different cgroups.
> > 
> > Perhaps it is the user memory memcg that needs to be fixed?
> > 
> 
> No, because memory is represented by mm_struct, not task_struct, so you 
> must charge to p->mm->owner to allow for moving threads amongst memcgs 
> later for memory.move_charge_at_immigrate.  You shouldn't be able to 
> charge two different memcgs for memory represented by a single mm.

The idea I had was more that only the memcg of the thread that does the allocation
is charged. But the problem is that this allocation can be later deallocated
from another thread. So probably charging the owner is indeed the only sane
way to go with user memory.
