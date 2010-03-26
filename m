Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab0CZFcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 01:32:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab0CZFcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 01:32:45 -0400
Date: Fri, 26 Mar 2010 16:32:36 +1100
From: Neil Brown <neilb@suse.de>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sysfs: simplify handling for s_active refcount
Message-ID: <20100326163236.1ffb2c2b@notabene.brown>
In-Reply-To: <m139znogl0.fsf@fess.ebiederm.org>
References: <20100324031829.2136.66489.stgit@notabene.brown>
	<20100324032008.2136.52640.stgit@notabene.brown>
	<m139znogl0.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010 21:24:43 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> NeilBrown <neilb@suse.de> writes:
> 
> > s_active counts the number of active references to a 'sysfs_direct'.
> > When we wish to deactivate a sysfs_direct, we subtract a large
> > number for the refcount so it will always appear negative.  When
> > it is negative, new references will not be taken.
> > After that subtraction, we wait for all the active references to
> > drain away.
> >
> > The subtraction of the large number contains exactly the same
> > information as the setting of the flag SYSFS_FLAG_REMOVED.
> > (We know this as we already assert that SYSFS_FLAG_REMOVED is set
> > before adding the large-negative-bias).
> > So doing both is pointless.
> >
> > By starting s_active with a value of 1, not 0 (as is typical of
> > reference counts) and using atomic_inc_not_zero, we can significantly
> > simplify the code while keeping exactly the same functionality.
> 
> Overall your logic appears correct but in detail this patch scares me.
> 
> sd->s_flags is protected by the sysfs_mutex, and you aren't
> taking it when you read it.  So in general I don't see the new check
> if (sd->s_flags & SYSFS_FLAG_REMOVED) == 0 providing any guarantee of
> progress whatsoever with user space applications repeated reading from
> a sysfs file when that sysfs file is being removed.  They could easily
> have the sd->s_flags value cached and never see the new value, given a
> crazy enough cache architecture.

As you say, this is only a liveness issue.  The atomic_inc_not_zero
guarantees that we don't take a new reference after the last one is gone.
The test on SYSFS_FLAG_REMOVED is only there to ensure that the count does
eventually get to zero.
There could only be a problem here if the change to s_flags was not
propagated to all CPUs in some reasonably small time.

I'm not expert on these things but it was my understanding that interesting
cache architectures could arbitrarily re-order accesses, but does not delay
them indefinitely.
Inserting barriers could possibly make this more predictable, but that would
just delay certain loads/stores until a known state was reached - it would
not make the data visible at another CPU any faster (or would it?).

So unless there is no cache-coherency protocol at all, I think that
SYSFS_FLAG_REMOVED will be seen promptly and that s_active will drop to zero
and quickly as it does today.

> 
> So as attractive as this patch is I don't think it is correct.
>

I'm pleased you find it attractive - I certainly think the
"atomic_inc_not_zero" is much more readable than the code it replaces.
Hopefully if there are really problems (maybe I've fundamentally
misunderstood caches) they can be easily resolved (a couple of memory
barriers at worst?).

Thanks for the review,
NeilBrown
