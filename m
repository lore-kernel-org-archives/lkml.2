Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab2EONHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:07:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab2EONHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:07:53 -0400
Date: Tue, 15 May 2012 14:07:48 +0100
From: Mel Gorman <mgorman@suse.de>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 05/17] mm: allow PF_MEMALLOC from softirq context
Message-ID: <20120515130748.GI29102@suse.de>
References: <1336657510-24378-1-git-send-email-mgorman@suse.de>
 <1336657510-24378-6-git-send-email-mgorman@suse.de>
 <20120511.003951.1470088131186301605.davem@davemloft.net>
 <20120514100229.GA29102@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120514100229.GA29102@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 11:02:29AM +0100, Mel Gorman wrote:
> Softirqs can run on multiple CPUs sure but the same task should not be
> 	executing the same softirq code. Interrupts are disabled and the
> 	executing process cannot sleep in softirq context so the task flags
> 	cannot "leak" nor can they be concurrently modified.
> 

This comment about hardirq is obviously wrong as __do_softirq() enables
interrupts and can be preempted by a hardirq. I've updated the changelog
now to include the following;

Softirqs can run on multiple CPUs sure but the same task should not be
        executing the same softirq code. Neither should the softirq
        handler be preempted by any other softirq handler so the flags
        should not leak to an unrelated softirq.

Softirqs re-enable hardware interrupts in __do_softirq() so can be
        preempted by hardware interrupts so PF_MEMALLOC is inherited
        by the hard IRQ. However, this is similar to a process in
        reclaim being preempted by a hardirq. While PF_MEMALLOC is
        set, gfp_to_alloc_flags() distinguishes between hard and
        soft irqs and avoids giving a hardirq the ALLOC_NO_WATERMARKS
        flag.

If the softirq is deferred to ksoftirq then its flags may be used
        instead of a normal tasks but as the softirq cannot be preempted,
        the PF_MEMALLOC flag does not leak to other code by accident.

-- 
Mel Gorman
SUSE Labs
