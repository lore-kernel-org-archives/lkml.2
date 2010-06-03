Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab0FCG3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:29:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:31603 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880Ab0FCG3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:29:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=mbGFT0GVuQFXZNeIsmU00dRRooGIFOql6bRKjDRyKE7w2xgipD5Bxec497sXtdoFa
	MhEuHlit5VRG97wK/rYuQ==
Date: Wed, 2 Jun 2010 23:29:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] oom: remove PF_EXITING check completely
In-Reply-To: <20100603120814.7242.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006022326190.22441@chino.kir.corp.google.com>
References: <20100602155455.GB9622@redhat.com> <alpine.DEB.2.00.1006021359430.32666@chino.kir.corp.google.com> <20100603120814.7242.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010, KOSAKI Motohiro wrote:

> > On Wed, 2 Jun 2010, Oleg Nesterov wrote:
> > 
> > > > Today, I've thought to make some bandaid patches for this issue. but
> > > > yes, I've reached the same conclusion.
> > > >
> > > > If we think multithread and core dump situation, all fixes are just
> > > > bandaid. We can't remove deadlock chance completely.
> > > >
> > > > The deadlock is certenaly worst result, then, minor PF_EXITING optimization
> > > > doesn't have so much worth.
> > > 
> > > Agreed! I was always wondering if it really helps in practice.
> > > 
> > 
> > Nack, this certainly does help in practice, it prevents needlessly killing 
> > additional tasks when one is exiting and may free memory.  It's much 
> > better to defer killing something temporarily if an eligible task (i.e. 
> > one that has a high probability of memory allocations on current's nodes 
> > or contributing to its memcg) is exiting.
> > 
> > We depend on this check specifically for our use of cpusets, so please 
> > don't remove it.
> 
> Your claim violate our development process. Oleg pointed this check
> doesn't only work well, but also can makes deadlock. So, We certinally
> need anything fix. then, I'll remove this check completely at 2.6.35
> timeframe.
> 

Show me your deadlock.  I want to see it.  In practice.

We've been using this check specifically for three years and it prevents 
needlessly killing additional tasks when one is already exiting and will 
free its memory.  That's a crucial aspect of using cpusets that run out of 
memory constantly.

Unless you actually have real world experience with using the oom killer 
to affect a memory containment strategy, I don't buy into your overly 
exaggerated claims that these are all bugfixes and these races that you 
have no practical evidence to support actually even matter but speculate 
based on pure code inspection are important.
