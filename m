Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab1HXKTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 06:19:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737Ab1HXKT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 06:19:29 -0400
Date: Wed, 24 Aug 2011 12:19:27 +0200
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] oom: skip frozen tasks
Message-ID: <20110824101927.GB3505@tiehlicka.suse.cz>
References: <20110823073101.6426.77745.stgit@zurg>
 <alpine.DEB.2.00.1108231313520.21637@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108231313520.21637@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23-08-11 13:18:14, David Rientjes wrote:
> On Tue, 23 Aug 2011, Konstantin Khlebnikov wrote:
> 
> > All frozen tasks are unkillable, and if one of them has TIF_MEMDIE
> > we must kill something else to avoid deadlock. After this patch
> > select_bad_process() will skip frozen task before checking TIF_MEMDIE.
> > 
> 
> The caveat is that if the task in the refrigerator is not OOM_DISABLE and 
> there are no other eligible tasks (system wide, in the cpuset, or in the 
> memcg) to kill, then the machine will panic as a result of this when, in 
> the past, we would simply issue the SIGKILL and keep looping in the page 
> allocator until it is thawed.

mem_cgroup_out_of_memory doesn't panic if nothing has been selected. We
will loop in the charge&reclaim path until somebody frees some memory.

> So you may actually be trading a stall waiting for this thread to thaw for 
> what would now be a panic, and that's not clearly better to me.

When we are in the global OOM condition then you are right, we have a
higher chance to panic. I still find the patch an improvement because
encountering a frozen task and looping over it without any progress
(even though there are other tasks that could be killed) is more
probable than having no killable task at all.
On non-NUMA machines there is even not a big chance that somebody would
be able to thaw a task as the system is already on knees.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
