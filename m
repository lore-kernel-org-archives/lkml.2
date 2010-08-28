Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab0H1AgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 20:36:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab0H1AgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 20:36:00 -0400
Date: Fri, 27 Aug 2010 20:35:32 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        dm-devel@redhat.com
Subject: Re: [PATCH 2/4] dm: implement REQ_FLUSH/FUA support
Message-ID: <20100828003532.GA26796@redhat.com>
References: <1282929060-23663-1-git-send-email-tj@kernel.org>
 <1282929060-23663-3-git-send-email-tj@kernel.org>
 <20100827202403.GD23680@redhat.com>
 <4C784A1C.8030602@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C784A1C.8030602@kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27 2010 at  7:28pm -0400,
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 08/27/2010 10:24 PM, Mike Snitzer wrote:
> >> * As __blk_rq_prep_clone() copies REQ_FUA, just advertising FUA
> >>   support is enough to pass through REQ_FUA to targets.
> > 
> > You're doing blk_queue_flush(md->queue, REQ_FLUSH | REQ_FUA); in 2
> > places:
> > 1) generic dm_init_md_queue -- used for bio-based and request-based
> > 2) request-based specific dm_init_request_based_queue.
> 
> Well, there are two places creating queues.

Actually only alloc_dev() allocates the queue.  It'll then initialize it
for bio-based use via dm_init_md_queue() -- this initialization is
subset of that done for a request-based DM device's queue.  The
remaining queue initialization for rq-based is done in
dm_init_request_based_queue -- with the call to
blk_init_allocated_queue().

So the request-based queue is initialized in two stages.

dm_init_md_queue() is common to both both bio-based and request-based.
So we probably only need the one blk_queue_flush in dm_init_md_queue().

> > But how can we blindly assume/advertise REQ_FUA?
> >
> > Should we be taking more care to check each block device that DM
> > consumes to see if FUA is supported and only then advertise REQ_FUA?
> > DM already does this for discard support (see:
> > dm_table_supports_discards).
> 
> Nope, REQ_FUA will be interpreted by queues lower in the stack.
> Drivers in the middle just need to pass them through.

I thought that was likely the case, thanks for clarifying.

> >> Lightly tested linear, stripe, raid1, snap and crypt targets.
> > 
> > I tested the bio-based code with the LVM2 test suite and all tests
> > passed.
> > 
> >> Please proceed with caution as I'm not familiar with the code base.
> > 
> > As I shared in an earlier (private) mail, I'm unfortunately having
> > problems with request-based DM (when all patches in this series are
> > applied).  I'll be working on that more.
> 
> Heh... I probably should set up a simple dm-mpath and test it.  I'll
> do it this weekend.

OK, like I mentioned earlier in one of these threads; its easy enough to
use multipath with a single scsi-debug device.  That way you can also
create a discard capable multipath device without physical hardware,
e.g.:

# modprobe scsi_debug dev_size_mb=100 unmap_max_desc=16 unmap_granularity=2048 sector_size=4096
<edit multipath.conf to not blacklist all devices, also enable
 'user_friendly_names yes' in defaults section>
# /etc/init.d/multipathd restart
# multipath -ll

>From here you can just format the mpath device with ext4 or whatever.

But if you want to use LVM ontop of the multipath device you'll need to
allow LVM to treat DM devices as physical volumes, see FAQ #3 here:
http://christophe.varoqui.free.fr/faq.html

It also helps to tweak your 'preferred_names' and 'filter' in lvm.conf,
e.g.:
preferred_names = [ "^/dev/mpath/", "^/dev/mapper/mpath", "^/dev/[hs]d" ]
filter = [ "a|/dev/mapper/mpatha|", "a|/dev/vd.*|", "a|/dev/sdd|", "a|/dev/sde|", "r|.*|" ]

The 'lvmdiskscan' command should show the mpath device.

Now you can use that test script I provided in my earlier mail.

Mike
