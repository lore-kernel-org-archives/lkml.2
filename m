Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644Ab0FJRIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 13:08:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:41657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab0FJRIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 13:08:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,399,1272870000"; 
   d="scan'208";a="525717145"
Subject: Re: [PATCH v2 1/2] tmpfs: Quick token library to allow scalable
 retrieval of tokens from token jar
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>
In-Reply-To: <20100609153654.0061e9c8.akpm@linux-foundation.org>
References: <1274902371.31973.9392.camel@mudge.jf.intel.com>
	 <20100601145126.f46572d1.akpm@linux-foundation.org>
	 <87ocftyfnh.fsf@basil.nowhere.org>
	 <20100609153654.0061e9c8.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 10:06:14 -0700
Message-ID: <1276189574.2385.32.camel@mudge.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 15:36 -0700, Andrew Morton wrote:

> > 
> > You need some synchronization, otherwise the accounting
> > would not be exact and you could overflow. Yes you could
> > open code it, but having it in a library is nicer.
> 
> The code doesn't have synchronisation!  qtoken_return() can modify the
> per-cpu "cache" in parallel with qtoken_avail()'s walk across the
> per-cpu "caches", yielding an inaccurate result.
> 
> This is all the same as percpu_add() executing in parallel with
> percpu_counter_sum() or percpu_counter_sum_positive().
> 
> If we cannot tolerate that inaccuracy then these patches are no good
> and we need a rethink.
> 
> If we _can_ tolerate that inaccuracy then percpu_counters can be used
> here.  And doing that is preferable to reinventing percpu_counters
> badly.
> 
> I'm just not seeing it.


The first version of the patch does a qtoken_reap_cache to reap the
tokens into pool before doing an accounting of the tokens and the token
count will be precise.  It was not done in the second version of the
patch due to objection that it may be  costly, and also the tokens count
will be fluctuating anyway.  However, qtoken_avail is not called very
often (usually caller will use qtoken_get to access the tokens and it
will not need a total accounting of the tokens). We can do it the
previous way and there will be no inaccuracies. 

Tim



