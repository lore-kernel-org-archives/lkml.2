Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2HNJDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 05:03:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213Ab2HNJDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 05:03:51 -0400
Date: Tue, 14 Aug 2012 11:03:30 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 3/6] floppy: avoid leaking extra reference to queue on
 do_floppy_init error handling
Message-ID: <20120814090330.GC2423@redhat.com>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
 <1344881787-6422-4-git-send-email-herton.krzesinski@canonical.com>
 <1344914439.824.178.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344914439.824.178.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 04:20:39AM +0100, Ben Hutchings wrote:
> On Mon, 2012-08-13 at 15:16 -0300, Herton Ronaldo Krzesinski wrote:
> > After commit 3f9a5aa ("floppy: Cleanup disk->queue before caling
> > put_disk() if add_disk() was never called"), if something fails in the
> > add_disk loop, we unconditionally set disks[dr]->queue to NULL. But
> > that's wrong, since we may have succesfully done an add_disk on some of
> > the drives previously in the loop, and in this case we would end up with
> > an extra reference to the disks[dr]->queue.
> > 
> > Add a new global array to mark "registered" disks, and use that to check
> > if we did an add_disk on one of the disks already. Using an array to
> > track added disks also will help to simplify/cleanup code later, as
> > suggested by Vivek Goyal.
> [...]
> 
> It's totally ridiculous that a driver should have to do this.  Any
> registered disk should have the GENHD_FL_UP flag set... so why can't
> genhd check it?  It doesn't look like floppy is the only driver affected
> by this problem, either.  So I suggest the following general fix
> (untested):
> 
> ---
> Subject: genhd: Make put_disk() safe for disks that have not been registered
> 
> Since commit 9f53d2f ('block: fix __blkdev_get and add_disk race
> condition'), add_disk() adds a reference to disk->queue,

I do not see this? Commit 9f53d2fe insert disk_alloc_events() to add_disk(),
but disk_alloc_events() function does not get any reference to disk->queue,
I missed something?

Stanislaw
