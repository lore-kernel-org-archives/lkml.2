Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab0DUUwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:52:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab0DUUwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:52:23 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [patch,rfc v2] ext3/4: enhance fsync performance when using cfq
References: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com>
	<20100407214631.GL3206@redhat.com> <20100408110442.GK10103@kernel.dk>
	<20100408140515.GB10879@redhat.com> <20100408140944.GQ10103@kernel.dk>
	<z2u170fa0d21004211342ncaf04f90h2cd7ebe832dcc46a@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 21 Apr 2010 16:52:11 -0400
In-Reply-To: <z2u170fa0d21004211342ncaf04f90h2cd7ebe832dcc46a@mail.gmail.com>
	(Mike Snitzer's message of "Wed, 21 Apr 2010 16:42:38 -0400")
Message-ID: <x49ochc1qbo.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer <snitzer@redhat.com> writes:

> On Thu, Apr 8, 2010 at 10:09 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
>> On Thu, Apr 08 2010, Vivek Goyal wrote:
>>> On Thu, Apr 08, 2010 at 01:04:42PM +0200, Jens Axboe wrote:
>>> > On Wed, Apr 07 2010, Vivek Goyal wrote:
>>> > > On Wed, Apr 07, 2010 at 05:18:12PM -0400, Jeff Moyer wrote:
>>> > > > Hi again,
>>> > > >
>>> > > > So, here's another stab at fixing this.  This patch is very much an RFC,
>>> > > > so do not pull it into anything bound for Linus.  ;-)  For those new to
>>> > > > this topic, here is the original posting:  http://lkml.org/lkml/2010/4/1/344
>>> > > >
>>> > > > The basic problem is that, when running iozone on smallish files (up to
>>> > > > 8MB in size) and including fsync in the timings, deadline outperforms
>>> > > > CFQ by a factor of about 5 for 64KB files, and by about 10% for 8MB
>>> > > > files.  From examining the blktrace data, it appears that iozone will
>>> > > > issue an fsync() call, and will have to wait until it's CFQ timeslice
>>> > > > has expired before the journal thread can run to actually commit data to
>>> > > > disk.
>>> > > >
>>> > > > The approach below puts an explicit call into the filesystem-specific
>>> > > > fsync code to yield the disk so that the jbd[2] process has a chance to
>>> > > > issue I/O.  This bring performance of CFQ in line with deadline.
>>> > > >
>>> > > > There is one outstanding issue with the patch that Vivek pointed out.
>>> > > > Basically, this could starve out the sync-noidle workload if there is a
>>> > > > lot of fsync-ing going on.  I'll address that in a follow-on patch.  For
>>> > > > now, I wanted to get the idea out there for others to comment on.
>>> > > >
>>> > > > Thanks a ton to Vivek for spotting the problem with the initial
>>> > > > approach, and for his continued review.
>>> > > >
> ...
>>> > > So we got to take care of two issues now.
>>> > >
>>> > > - Make it work with dm/md devices also. Somehow shall have to propogate
>>> > >   this yield semantic down the stack.
>>> >
>>> > The way that Jeff set it up, it's completely parallel to eg congestion
>>> > or unplugging. So that should be easily doable.
>>> >
>>>
>>> Ok, so various dm targets now need to define "yield_fn" and propogate the
>>> yield call to all the component devices.
>>
>> Exactly.
>
> To do so doesn't DM (and MD) need a blk_queue_yield() setter to
> establish its own yield_fn?  The established dm_yield_fn would call
> blk_yield() for all real devices in a given DM target.  Something like
> how blk_queue_merge_bvec() or blk_queue_make_request() allow DM to
> provide functional extensions.
>
> I'm not seeing such a yield_fn hook for stacking drivers to use. And
> as is, jbd and jbd2 just call blk_yield() directly and there is no way
> for the block layer to call into DM.
>
> What am I missing?

Nothing, it is I who am missing something (extra code).  When I send out
the next version, I'll add the setter function and ensure that
queue->yield_fn is called from blk_yield.  Hopefully that's not viewed
as upside down.  We'll see.

Thanks for the review, Mike!

-Jeff
