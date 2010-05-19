Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab0ESOjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:39:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab0ESOjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:39:13 -0400
Date: Wed, 19 May 2010 10:39:00 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for
 request-based device
Message-ID: <20100519143900.GC24618@redhat.com>
References: <4BEA659F.9050206@ct.jp.nec.com>
 <20100513035750.GA25523@redhat.com>
 <4BED049C.5040409@ct.jp.nec.com>
 <20100514140852.GA10373@redhat.com>
 <4BF10BF1.3040108@ct.jp.nec.com>
 <20100517172737.GA24591@redhat.com>
 <4BF25091.3000507@ct.jp.nec.com>
 <20100518134639.GA27582@redhat.com>
 <4BF37DD5.9050409@ct.jp.nec.com>
 <AANLkTinndXq8DkMBOUf5z8R_8lWRoRbDuOZ1LEmWeI21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinndXq8DkMBOUf5z8R_8lWRoRbDuOZ1LEmWeI21@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19 2010 at  8:01am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, May 19, 2010 at 1:57 AM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> > Hi Mike,
> >
> > On 05/18/2010 10:46 PM +0900, Mike Snitzer wrote:
> >> I'll post v5 of the overall patch which will revert the mapped_device
> >> 'queue_lock' serialization that I proposed in v4.  v5 will contain
> >> the following patch to localize all table load related queue
> >> manipulation to the _hash_lock protected critical section in
> >> table_load().  So it sets the queue up _after_ the table's type is
> >> established with dm_table_set_type().
> >
> > dm_table_setup_md_queue() may allocate memory with blocking mode.
> > Blocking allocation inside exclusive _hash_lock can cause deadlock;
> > e.g. when it has to wait for other dm devices to resume to free some
> > memory.
> 
> We make no guarantees that other DM devices will resume before a table
> load -- so calling dm_table_setup_md_queue() within the exclusive
> _hash_lock is no different than other DM devices being suspended while
> a request-based DM device performs its first table_load().
> 
> My thinking was this should not be a problem as it is only valid to
> call dm_table_setup_md_queue() before the newly created request-based
> DM device has been resumed.
> 
> AFAIK we don't have any explicit constraints on memory allocations
> during table load (e.g. table loads shouldn't depend on other devices'
> writeback) -- but any GFP_KERNEL allocation could recurse
> (elevator_alloc() currently uses GFP_KERNEL with kmalloc_node)...
> 
> I'll have to review the DM code further to see if all memory
> allocations during table_load() are done via mempools.  I'll also
> bring this up on this week's LVM call.

We discussed this and I understand the scope of the problem now.

Just reiterating what you covered when you first pointed this issue out:

It could be that a table load gets blocked (waiting on a memory
allocation).  The table load can take as long as it needs.  But we can't
have it block holding the exclusive _hash_lock while blocking.  Having
_hash_lock prevents further DM ioctls.  The table load's allocation may
be blocking waiting for writeback to a DM device that will be resumed by
another thread.

Thanks again for pointing this out; I'll work to arrive at an
alternative locking scheme.  Likely introduce a lock local to the
multiple_device (effectively the 'queue_lock' I had before).  But
difference is I'd take that lock before taking _hash_lock.

I hope to have v6 available at some point today but it may be delayed by
a day.

> > Also, your patch changes the queue configuration even when a table is
> > already active and used.  (e.g. Loading bio-based table to a mapped_device
> > which is already active/used as request-based sets q->requst_fn in NULL.)
> > That could cause some critical problems.
> 
> Yes, that is possible and I can add additional checks to prevent this.
> But this speaks to a more general problem with the existing DM code.
> 
> dm_swap_table() has the negative check to prevent such table loads, e.g.:
> /* cannot change the device type, once a table is bound */
> 
> This check should come during table_load, as part of
> dm_table_set_type(), rather than during table resume.

I'll look to address this issue in v6 too.

Regards,
Mike
