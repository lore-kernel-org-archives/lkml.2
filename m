Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab0EKNPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 09:15:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740Ab0EKNP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 09:15:29 -0400
Date: Tue, 11 May 2010 09:15:02 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for
 request-based device
Message-ID: <20100511131502.GA25211@redhat.com>
References: <1273532139-23043-1-git-send-email-snitzer@redhat.com>
 <1273532139-23043-2-git-send-email-snitzer@redhat.com>
 <4BE8DBB0.5060701@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE8DBB0.5060701@ct.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11 2010 at 12:23am -0400,
Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> Hi Mike,
> 
> On 05/11/2010 07:55 AM +0900, Mike Snitzer wrote:
> > Revert back to only allocating a minimalist request_queue structure
> > initially (needed for both bio and request-based DM).  Initialization of
> > a full request_queue (request_fn, elevator, etc) is deferred until it is
> > known that the DM device is request-based.
> 
> Thank you for working on this.
> However, I still disagree with this patch as we discussed on this thread:
> http://marc.info/?t=124990138700003&r=1&w=2
> (Exporting a part of queue's features may cause some maintenance costs
>  in future.)

Thanks for the reference.  I completely forgot about that thread (even
though I responded to Nikanth's patches in detail! :)

It is clear we need to resolve the current full request_queue
initialization that occurs even for bio-based DM devices.

I believe the 2 patches I posted accomplish this in a stright-forward
way.  We can always improve on it (by looking at what you proposed
below) but we need a minimlaist fix that doesn't depend on userspace
LVM2 changes right now.

Interestingly, having to revisit this issue (forgetting that this line
of work was already explored) I came up with roughly the same type of
change to the block layer as Nikanth's 1/2 patch.  The difference being
my blk_init_allocated_queue is more minimalist because the block code
has evolved to allow this change to be more natural.

Similarly, my proposed DM changes are also quite natural.  By using
dm_table_set_type() as the hook to initialize the request-based DM
device's elevator we perform allocations during table load.

Having just looked at Nikanth's proposed DM patch 2/2 again it shows
that blk_init_allocated_queue(), which allocates memory, was being
called during resume (dm_swap_table).  Allocations are not allowed
during resume.

> As I mentioned on the last email of the thread above (see below),
> specifying device type at the device creation time by userspace tools
> should make dm code very simple.  So that may be a better approach.
> 
> > By the way, another approach to optimizing the memory usage would be
> > to determine whether the dm device is bio-based or request-based
> > at the device creation time, instead of the table binding time.
> > We want the delayed allocation, since kernel can't decide the device
> > type until the first table is bound because of the auto-detection
> > mechanism.  The auto-detection is good for keeping compatibility with
> > existing user-space tools.  But once user-space tools are changed to
> > specify device type at the device creation time, we can eventually
> > remove the auto-detection.
> > Then, kernel can decide device type in alloc_dev(), so
> > the initialization code in kernel will become very simple.
> 
> Thanks,
> Kiyoshi Ueda
