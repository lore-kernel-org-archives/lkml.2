Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab1JNWqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 18:46:45 -0400
Received: from smtp-out.google.com ([74.125.121.67]:16840 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab1JNWqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 18:46:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=uc2oozCs71JzVIrA9fNvzriRaBtnUV5oNZRmVPtnLKTy5AP45uCTMQ+GoSNAURUUO
	PDREHB9iLXq+t8zXiO0Vg==
Date: Fri, 14 Oct 2011 15:46:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Satoru Moriya <satoru.moriya@hds.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9CB4F747AC@USINDEVS02.corp.hds.com>
Message-ID: <alpine.DEB.2.00.1110141536520.21305@chino.kir.corp.google.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com> <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com> <20111010153723.6397924f.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com> <20111011125419.2702b5dc.akpm@linux-foundation.org> <65795E11DBF1E645A09CEC7EAEE94B9CB516CBFE@USINDEVS02.corp.hds.com> <20111011135445.f580749b.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516D055@USINDEVS02.corp.hds.com> <alpine.DEB.2.00.1110121537380.16286@chino.kir.corp.google.com> <65795E11DBF1E645A09CEC7EAEE94B9CB516D0EA@USINDEVS02.corp.hds.com> <alpine.DEB.2.00.1110121654120.30123@chino.kir.corp.google.com>
 <20111013143501.a59efa5c.kamezawa.hiroyu@jp.fujitsu.com>,<alpine.DEB.2.00.1110131351270.24853@chino.kir.corp.google.com> <65795E11DBF1E645A09CEC7EAEE94B9CB4F747AC@USINDEVS02.corp.hds.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Satoru Moriya wrote:

> > Satoru was specifically talking about the VM using free memory for 
> > pagecache,
> 
> Yes, because we can't stop increasing pagecache and it 
> occupies RAM where some people want to keep free for bursty
> memory requirement. Usually it works fine but sometimes like
> my test case doesn't work well.
> 
> > so doing echo echo 1 > /proc/sys/vm/drop_caches can mitigate 
> > that almost immediately.  
> 
> I know it and some admins use that kind of tuning. But is it
> proper way? Should we exec the script like above periodically?
> I believe that we should use it for debug only.
> 

Agreed, this was in response to the suggestion for adding a mem_shrink() 
syscall, which would require the same periodic calls or knowledge of the 
application prior to the bursty memory allocations.  I bring up 
drop_caches just to illustrate that it is effectively the same thing for 
the entire address space when pressured by pagecache.  So I don't think 
that syscall would actually help for your scenario.

> > If there were a change to increase the space significantly between the 
> > high and min watermark when min_free_kbytes changes, that would fix the 
> > problem. 
> 
> Right. But min_free_kbytes changes both thresholds, foregroud reclaim
> and background reclaim. I'd like to configure them separately like
> dirty_bytes and dirty_background_bytes for flexibility.
> 

The point I'm trying to make is that if kswapd can be made aware that it 
was kicked by a rt_task() in the page allocator, the same criteria we use 
for ALLOC_HARDER today, or a rt_task() subsequently enters the page 
allocator slowpath while kswapd is running, then not only can we increase 
the scheduling priority of kswapd but it is also possible to reclaim above 
the high watermark for an extra bonus.  I believe we can find a sane 
middle ground that requires no userspace tunable where a _single_ realtime 
application cannot allocate memory faster than kswapd with very high 
priority and reclaiming above the high watermark, whether that's a factor 
of 1.25 or not.

> > The problem is two-fold: that comes at a penalty for systems 
> > or workloads that don't need to reclaim the additional memory, and it's 
> > not clear how much space should exist between those watermarks.
> 
> The required size depends on a system architacture such as kernel,
> applications, storage etc. and so admin who care the whole system
> should configure it based on tests by his own risk.
> 

Doing that comes at a penalty for other workloads that are running on the 
same system, which is the problem with a global tunable that doesn't 
discriminate on an allocator's priority (the min -> high watermarks for 
reclaim do well except for rt-threads, as evidenced by this thread).
