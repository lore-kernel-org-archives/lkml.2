Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965647Ab2CBXrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 18:47:21 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44665 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965577Ab2CBXrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 18:47:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rientjes@google.com designates 10.68.130.1 as permitted sender) smtp.mail=rientjes@google.com; dkim=pass header.i=rientjes@google.com
Date: Fri, 2 Mar 2012 15:47:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Mel Gorman <mgorman@suse.de>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miao Xie <miaox@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: mm: Remove memory barrier damage from the page
 allocator
In-Reply-To: <1330723529.11248.237.camel@twins>
Message-ID: <alpine.DEB.2.00.1203021540040.18377@chino.kir.corp.google.com>
References: <20120302112358.GA3481@suse.de> <alpine.DEB.2.00.1203021018130.15125@router.home> <20120302174349.GB3481@suse.de> <1330723529.11248.237.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2012, Peter Zijlstra wrote:

> Also, for the write side it doesn't really matter, changing mems_allowed
> should be rare and is an 'expensive' operation anyway.
> 

It's very expensive even without memory barriers since the page allocator 
wraps itself in {get,put}_mems_allowed() until a page or NULL is returned 
and an update to current's set of allowed mems can stall indefinitely 
trying to change the nodemask during this time.  The thread changing 
cpuset.mems is holding cgroup_mutex the entire time which locks out 
changes, including adding additional nodes to current's set of allowed 
mems.  If direct reclaim takes a long time or an oom killed task fails to 
exit quickly (or the allocation is __GFP_NOFAIL and we just spin 
indefinitely holding get_mems_allowed()), then it's not uncommon to see a 
write to cpuset.mems taking minutes while holding the mutex, if it ever 
actually returns at all.
