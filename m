Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab1JLT55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:57:57 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:22425 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753283Ab1JLT54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:57:56 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: EyK6vsEVM1mKoW4S3ws7wPtO5ZumDVqJ92XD_xDUIyV._Tm
 Twu9a1BlCIKBxh3H7gXbMXENiLWAxF92YiLzqq1AO6u5reI2NeE7Mr7atCQX
 ztEeV2fTuCNRo9riMNydD4VdORQDzGv7vxT2Jl9GHOH.zyS2AgZFS3YMeKU0
 byhSBR.0m3enYgWS5ywnPxU7fz3bSwQ8lNB9eh64u03l8T5FN1hDih4dM64Q
 _ynAvvq6DB9GV_p_CD7bUvrg8cxURnF7HmWjEvVMDz6TbB0wp3gC1EcDGTRS
 UNMXQKv7G.oGD.RXEZFye7iqNKqQri0.UFjPWC0wup2Lc9CO1B39.ToMGEVM
 NHLa5HpLnopbdvaAaL7m1Kj2cB5lsCs0ydTWGv9f9yCOd1vsT69OXGNV66WJ
 ppnf0Cj05c5Raj3k6HeqX1MI-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 12 Oct 2011 14:57:53 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Reduce vm_stat cacheline contention in
 __vm_enough_memory
In-Reply-To: <20111012120118.e948f40a.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1110121452220.31218@router.home>
References: <20111012160202.GA18666@sgi.com> <20111012120118.e948f40a.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011, Andrew Morton wrote:

> > Note that this patch is simply to illustrate the gains that can be made here.
> > What I'm looking for is some guidance on an acceptable way to accomplish the
> > task of reducing contention in this area, either by caching these values in a
> > way similar to the attached patch, or by some other mechanism if this is
> > unacceptable.
>
> Yes, the global vm_stat[] array is a problem - I'm surprised it's hung
> around for this long.  Altering the sysctl_overcommit_memory mode will
> hide the problem, but that's no good.

The global vm_stat array is keeping the state for the zone. It would be
even more expensive to calculate this at every point where we need such
data.

> I think we've discussed switching vm_stat[] to a contention-avoiding
> counter scheme.  Simply using <percpu_counter.h> would be the simplest
> approach.  They'll introduce inaccuracies but hopefully any problems
> from that will be minor for the global page counters.

We already have a contention avoiding scheme for counter updates in
vmstat.c. The problem here is that vm_stat is frequently read. Updates
from other cpus that fold counter updates in a deferred way into the
global statistics cause cacheline eviction. The updates occur too frequent
in this load.

> otoh, I think we've been round this loop before and I don't recall why
> nothing happened.

The update behavior can be tuned using /proc/sys/vm/stat_interval.
Increase the interval to reduce the folding into the global counter (set
maybe to 10?). This will reduce contention. The other approach is to
increase the allowed delta per zone if frequent updates occur via the
overflow checks in vmstat.c. See calculate_*_threshold there.

Note that the deltas are current reduced for memory pressure situations
(after recent patches by Mel). This will cause a significant increase in
vm_stat cacheline contention compared to earlier kernels.


