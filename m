Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab1KGMLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:11:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56930 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1KGMLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:11:36 -0500
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, robert.richter@amd.com, mingo@elte.hu,
        ming.m.lin@intel.com, ak@linux.intel.com
Date: Mon, 07 Nov 2011 13:10:33 +0100
In-Reply-To: <20111107110149.GA5177@quad>
References: <20111107110149.GA5177@quad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320667833.18053.24.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 12:01 +0100, Stephane Eranian wrote:
> +                       /*
> +                        * scan all possible counters for this event
> +                        * but use the one with the smallest counter weight,
> +                        * i.e., give a chance to other less constrained events
> +                        */
>                         for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
>  
> +                               if (test_bit(j, used_mask))
> +                                       continue;
> +
> +                               if (wcnt[j] < min_wcnt) {
> +                                       min_wcnt = wcnt[j];
> +                                       wcnt_idx = j;
> +                               }
> +                       } 

The problem with this is that it will typically hit the worst case for
Intel fixed-purpose events since the fixed purpose counters have the
highest counter index and their constraint masks are the heaviest in the
system ensuring we hit the max loop count on the top loop.

Then again, with Robert's approach we have to mark all fixed purpose
thingies as redo and we might hit some weird cases there as well, can't
seem to get me brain straight on that case though.


