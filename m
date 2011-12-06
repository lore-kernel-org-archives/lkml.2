Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1LFVGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:06:12 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63594 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab1LFVGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:06:11 -0500
Date: Tue, 6 Dec 2011 13:06:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Alex,Shi" <alex.shi@intel.com>
cc: Christoph Lameter <cl@linux.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] slub: set a criteria for slub node partial adding
In-Reply-To: <1323076965.16790.670.camel@debian>
Message-ID: <alpine.DEB.2.00.1112061259210.28251@chino.kir.corp.google.com>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com> <alpine.DEB.2.00.1112020842280.10975@router.home> <1323076965.16790.670.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011, Alex,Shi wrote:

> Previous testing depends on 3.2-rc1, that show hackbench performance has
> no clear change, and netperf get some benefit. But seems after
> irqsafe_cpu_cmpxchg patch, the result has some change. I am collecting
> these results. 
> 

netperf will also degrade with this change on some machines, there's no 
clear heuristic that can be used to benefit all workloads when deciding 
where to add a partial slab into the list.  Cache hotness is great but 
your patch doesn't address situations where frees happen to a partial slab 
such that they may be entirely free (or at least below your 1:4 inuse to 
nr_objs threshold) at the time you want to deactivate the cpu slab.

I had a patchset that iterated the partial list and found the "most free" 
partial slab (and terminated prematurely if a threshold had been reached, 
much like yours) and selected that one, and it helped netperf 2-3% in my 
testing.  So I disagree with determining where to add a partial slab to 
the list at the time of free because it doesn't infer its state at the 
time of cpu slab deactivation.
