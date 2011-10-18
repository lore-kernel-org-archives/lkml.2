Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab1JROgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:36:18 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:43885 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932140Ab1JROgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:36:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: d8wqhpoVM1kj0N0JvSZFibNzT.lonj1cj9a.rbbilB5XLq7
 H.5HVbL2N4sSVlsMj4v1gQeUWXqaFEypQovyFv.5JhHKRMgnuDOqX1tjwJdh
 _vECexMNmJiVAmkAsa57NDRlRUacClF9br2gdrCN3DbqE48_xXQjc4iGrpbi
 TBwLBdFkqRD35u_X4gMCsZ8hWBI_JAFH2PgPoKSulPE7YepYgIHe9f37JUH2
 .fgP_.ZYug.zek3nUXhWavVWogNrIMmmNxwqFv2.UNKiQjPC_hNYs9Zo6qE7
 X.hmJNzMzQT1njAE1OJSU5ZhUxwWfCuO1j4AD3i0gJgVrdPv4amaMLOVHSCk
 hcqACnl8adV8zZM148rOIhbk79gsdtHQi8Mp3bP9imbF9Ex0cCGTvdUIJDha
 HxToYk2wzO4vLkVxLUAMNXWE-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 18 Oct 2011 09:36:14 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Dimitri Sivanich <sivanich@sgi.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Reduce vm_stat cacheline contention in
 __vm_enough_memory
In-Reply-To: <20111018134835.GA16222@sgi.com>
Message-ID: <alpine.DEB.2.00.1110180933470.687@router.home>
References: <20111013135032.7c2c54cd.akpm@linux-foundation.org> <alpine.DEB.2.00.1110131602020.26553@router.home> <20111013142434.4d05cbdc.akpm@linux-foundation.org> <20111014122506.GB26737@sgi.com> <20111014135055.GA28592@sgi.com> <alpine.DEB.2.00.1110140856420.6411@router.home>
 <20111014141921.GC28592@sgi.com> <alpine.DEB.2.00.1110140932530.6411@router.home> <alpine.DEB.2.00.1110140958550.6411@router.home> <20111014161603.GA30561@sgi.com> <20111018134835.GA16222@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Dimitri Sivanich wrote:

> After further testing, substantial increases in ZVC delta along with cache alignment
> of the vm_stat array bring the tmpfs writeback throughput numbers to about where
> they are with vm.overcommit_memory==OVERCOMMIT_NEVER.  I still need to determine how
> high the ZVC delta needs to be to achieve this performance, but it is greater than 125.

Sounds like this is the way to go then.

> Would it make sense to have the ZVC delta be tuneable (via /proc/sys/vm?), keeping the
> same default behavior as what we currently have?

I think so.

> If the thresholds get set higher, it could be that some values that don't normally have
> as big a delta may not get updated frequently enough.  Should we maybe update all values
> everytime a threshold is hit, as the patch below was intending?

Mel can probably chime in on the accuracy needed for reclaim etc. We
already have an automatic reduction of the delta if the vm gets into
problems.

> Note that having each counter in a separate cacheline does not have much, if any,
> effect.

It may have a good effect if you group the counters according to their
uses into different cachelines. Counters that are typically updates
together need to be close to each other. Also you could modify my patch to
only update counters in the same cacheline. I think doing all counters
caused the problems with that patch because we now touch multiple
cachelines and increase the cache footprint of critical vm functions.

