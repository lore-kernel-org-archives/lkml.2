Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab1I1OwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:52:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58900 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754479Ab1I1OwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:52:24 -0400
Date: Wed, 28 Sep 2011 10:52:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <axboe@kernel.dk>, Rocko Requin <rockorequin@hotmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block fixes for 3.1-rc
In-Reply-To: <4E826D3B.7080805@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.1109281042250.2089-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011, Jens Axboe wrote:

> On 2011-09-27 17:52, Linus Torvalds wrote:
> > On Wed, Sep 21, 2011 at 5:19 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> Final round of patches for 3.1.
> > 
> > Apparently better not.
> > 
> > The "block layer oopses on USB device removal" is still there, it seems.
> > 
> > I can even find a patch from it from Alan Stern:
> > 
> >    https://lkml.org/lkml/2011/9/18/63
> > 
> > and the reason I found that was that my wife's machine just saw what
> > looks very much like that bug in elv_put_request().
> > 
> > The call chain on that particular machine was:
> > 
> >  - __blk_put_request
> >   blk_put_request
> >   scsi_execute
> >   scsi_execute_req
> >   sd_check_events
> >   disk_events_workfn
> >   process_one_work
> > 
> > in one of the kthread helpers. It sounds like something either
> > generates disk events after the unplug event (despite a "safely
> > remove" thing), or doesn't properly wait for the disk events to have
> > flushed before the elevator is cleared.
> > 
> > The "things go oops at USB removal" reports have been with us for a
> > *loong* time now. Can we please get this fixed already, and have
> > somebody really look at it?
> > 
> > And if you can't figure out why it happens, at least apply Alan's
> > patch (or ack it).
> 
> The whole thing is a bit of a mess, it was introduced by changes meant
> to clean it up, which didn't get to the root of the problem (and
> seemingly only made it worse). We need the queue clearly referenced and
> released, not just pointed to. That would be the more invasive and real
> fix. I will apply Alan's fix for a happier 3.1.

You guys should be asking the person who first reported the most recent 
version of this bug and is able to reproduce it easily.

Rocko has already tested Hannes's patch in

	http://marc.info/?l=linux-scsi&m=131669751909474&w=2

successfully.  The only difference between it and James's patch in

	http://marc.info/?l=linux-kernel&m=131300594629839

is the assignment to q->queue_lock, which doesn't appear to be
essential in the SCSI case.  (Furthermore, Hannes's patch makes an
unnecessary test before doing the assignment, which is inelegant.)

Alan Stern

