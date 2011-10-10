Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1JJWh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 18:37:29 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61148 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab1JJWh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 18:37:27 -0400
Date: Mon, 10 Oct 2011 15:37:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, lwoodman@redhat.com,
        Seiji Aguchi <saguchi@redhat.com>, hughd@google.com,
        hannes@cmpxchg.org
Subject: Re: [PATCH -v2 -mm] add extra free kbytes tunable
Message-Id: <20111010153723.6397924f.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com>
	<20110901100650.6d884589.rdunlap@xenotime.net>
	<20110901152650.7a63cb8b@annuminas.surriel.com>
	<alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Oct 2011 20:08:19 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Thu, 1 Sep 2011, Rik van Riel wrote:
> 
> > Add a userspace visible knob to tell the VM to keep an extra amount
> > of memory free, by increasing the gap between each zone's min and
> > low watermarks.
> > 
> > This is useful for realtime applications that call system
> > calls and have a bound on the number of allocations that happen
> > in any short time period.  In this application, extra_free_kbytes
> > would be left at an amount equal to or larger than than the
> > maximum number of allocations that happen in any burst.
> > 
> > It may also be useful to reduce the memory use of virtual
> > machines (temporarily?), in a way that does not cause memory
> > fragmentation like ballooning does.
> > 
> 
> I know this was merged into -mm, but I still have to disagree with it 
> because I think it adds yet another userspace knob that will never be 
> obsoleted, will be misinterepted, and is tied very closely to the 
> implementation of page reclaim, both synchronous and asynchronous.

Yup.  We should strenuously avoid merging it, for these reasons.

>  I also 
> think that it will cause regressions on other cpu intensive workloads 
> that don't require this extra freed memory because it works as a global 
> heuristic and is not tied to any specific application.
> 
> I think it would be far better to reclaim beyond above the high watermark 
> if the types of workloads that need this tunable can be somehow detected 
> (the worst case scenario is being a prctl() that does synchronous reclaim 
> above the watermark so admins can identify these workloads), or be able to 
> mark allocations within the kernel as potentially coming in large bursts 
> where allocation is problematic.

The page allocator already tries harder if the caller has
rt_task(current).  Why is this inadequate?  Can we extend this idea
further to fix whatever-the-problem-is?

Does there exist anything like a test case which demonstrates the need
for this feature?

