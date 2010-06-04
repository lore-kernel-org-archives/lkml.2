Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab0FDO7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 10:59:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55567 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755911Ab0FDO7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 10:59:19 -0400
Date: Fri, 4 Jun 2010 10:59:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
In-Reply-To: <1275650416.3403.5.camel@maxim-laptop>
Message-ID: <Pine.LNX.4.44L0.1006041052570.1794-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010, Maxim Levitsky wrote:

> On Thu, 2010-03-04 at 14:53 +0100, Pavel Machek wrote: 
> > Hi!
> > 
> > > > journalling assumptions broken: commit block is there, but previous
> > > > blocks are not intact. Data loss.
> > > > 
> > > > ...and that was the first I could think about. Lets not do
> > > >  this. Barriers were invented for a reason.
> > > 
> > > Very well.  Then we still need a solution to the original problem:  
> > > Devices sometimes need to be unregistered during resume, but
> > > del_gendisk() blocks on the writeback thread, which is frozen until
> > > after the resume finishes.  How do you suggest this be fixed?
> > 
> > Avoid unregistering device during resume. Instead, return errors until
> > resume is done and you can call del_gendisk? 
> 
> This won't help ether. The same driver needs to unregister perfectly
> working device on suspend, because the user might replace the card
> during suspend and fool the os.
> There is a setting, CONFIG_MMC_UNSAFE_RESUME and I use it, but it isn't
> default.

People have generally agreed that the best answer is to have 
del_gendisk always thaw the writeback thread.

> Anyway to revive that old thread, how about introducing new
> del_gendisk_no_sync?
> 
> A less safe version of del_gendisk, but which won't sync the filesystem.
> Since driver knows that card is gone, there is no point of syncing it.
> 
> (the sync is done by invalidate_partition, so some flag should be
> propagated to it).

That might work for mmc, but it wouldn't help other drivers subject to
the same problem.

Besides, it's subject to races.  What if the card _isn't_ gone, but for 
some other reason the driver wants to unregister the device at a time 
when the writeback thread is frozen?

Alan Stern

