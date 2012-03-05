Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab2CEJoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 04:44:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373Ab2CEJoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 04:44:15 -0500
Date: Mon, 5 Mar 2012 09:44:11 +0000
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miao Xie <miaox@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: mm: Remove memory barrier damage from the page
 allocator
Message-ID: <20120305094411.GD3481@suse.de>
References: <20120302112358.GA3481@suse.de>
 <alpine.DEB.2.00.1203021018130.15125@router.home>
 <20120302174349.GB3481@suse.de>
 <1330723529.11248.237.camel@twins>
 <alpine.DEB.2.00.1203021540040.18377@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203021540040.18377@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 03:47:17PM -0800, David Rientjes wrote:
> On Fri, 2 Mar 2012, Peter Zijlstra wrote:
> 
> > Also, for the write side it doesn't really matter, changing mems_allowed
> > should be rare and is an 'expensive' operation anyway.
> > 
> 
> It's very expensive even without memory barriers since the page allocator 
> wraps itself in {get,put}_mems_allowed() until a page or NULL is returned 
> and an update to current's set of allowed mems can stall indefinitely 
> trying to change the nodemask during this time. 

Hmm, this sounds problematic. Are you seeing a problem with the behaviour
with the patch applied or the existing behaviour?

If you are talking about the patch, I am missing something. The retry
only takes place if there is a parallel update of the nodemask and the
page allocation fails. There would need to be continual updates of the
nodemask that led to false allocation failures for it to stall indefinitely.

On the updating of the cpumask side, there is no longer the "yield and retry"
logic so it also should not stall indefinitely trying to change the nodemask.
The write_seqcount_begin() does not wait for the reader side to complete
so it should also not be stalling for long periods of time.

Did I miss something?

-- 
Mel Gorman
SUSE Labs
