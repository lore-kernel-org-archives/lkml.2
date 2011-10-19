Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab1JSBQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 21:16:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26828 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab1JSBQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 21:16:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=PtjNmtHR21oPXsweh97Jl2pSJfW9bFq2+D2WLh3fReMptUYwdI5CxE6E9ERxjCONJ
	qM/r6Owc7kG6XLH9tei9g==
Date: Tue, 18 Oct 2011 18:16:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Reduce vm_stat cacheline contention in
 __vm_enough_memory
In-Reply-To: <m2mxcyz4f7.fsf@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1110181806570.12850@chino.kir.corp.google.com>
References: <20111013135032.7c2c54cd.akpm@linux-foundation.org> <alpine.DEB.2.00.1110131602020.26553@router.home> <20111013142434.4d05cbdc.akpm@linux-foundation.org> <20111014122506.GB26737@sgi.com> <20111014135055.GA28592@sgi.com> <alpine.DEB.2.00.1110140856420.6411@router.home>
 <20111014141921.GC28592@sgi.com> <alpine.DEB.2.00.1110140932530.6411@router.home> <alpine.DEB.2.00.1110140958550.6411@router.home> <20111014161603.GA30561@sgi.com> <20111018134835.GA16222@sgi.com> <m2mxcyz4f7.fsf@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Andi Kleen wrote:

> > Would it make sense to have the ZVC delta be tuneable (via /proc/sys/vm?), keeping the
> > same default behavior as what we currently have?
> 
> Tunable is bad. We don't really want a "hundreds of lines magic shell script to
> make large systems perform". Please find a way to auto tune.
> 

Agreed, and I think even if we had a tunable that it would result in 
potentially erradic VM performance because some areas depend on "fairly 
accurate" ZVCs and it wouldn't be clear that you're trading other unknown 
VM issues that will affect your workload because you've increased the 
deltas.  Let's try to avoid having to ask "what is your ZVC delta tunable 
set at?" when someone reports a bug about reclaim stopping preemptively.

That said, perhaps we need higher deltas by default and then hints in key 
areas in the form of sync_stats_if_delta_above(x) calls that would do 
zone_page_state_add() only when that kind of precision is actually needed.  
For public interfaces, that would be very easy to audit to see what the 
level of precision is when parsing the data.
