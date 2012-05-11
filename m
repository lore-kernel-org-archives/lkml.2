Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276Ab2EKOmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:42:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49496 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2EKOmo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:42:44 -0400
Message-ID: <1336747350.1017.22.camel@twins>
Subject: Re: [PATCH 10/17] netvm: Allow skb allocation to use PFMEMALLOC
 reserves
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, michaelc@cs.wisc.edu,
        emunson@mgebm.net
Date: Fri, 11 May 2012 16:42:30 +0200
In-Reply-To: <20120511143218.GS11435@suse.de>
References: <1336657510-24378-1-git-send-email-mgorman@suse.de>
	 <1336657510-24378-11-git-send-email-mgorman@suse.de>
	 <20120511.005740.210437168371869566.davem@davemloft.net>
	 <20120511143218.GS11435@suse.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 15:32 +0100, Mel Gorman wrote:
> > > +extern atomic_t memalloc_socks;
> > > +static inline int sk_memalloc_socks(void)
> > > +{
> > > +   return atomic_read(&memalloc_socks);
> > > +}
> > 
> > Please change this to be a static branch.
> > 
> 
> Will do. I renamed memalloc_socks to sk_memalloc_socks, made it a int as
> atomics are unnecessary and I check it directly in a branch instead of a
> static inline. It should be relatively easy for the branch predictor. 

David means you to use include/linux/jump_label.h.

static struct static_key sk_memalloc_socks = STATIC_KEY_INIT_FALSE;

and have your function read:

static inline bool sk_memalloc_socks(void)
{
	return static_key_false(&sk_memalloc_socks);
}

which can be modified using:

  static_key_slow_inc(&sk_memalloc_socks);

or

  static_key_slow_dec(&sk_memalloc_socks);

This magic goo turns the branch into self-modifying code such that the
branch is an unconditional jump at runtime.

  
