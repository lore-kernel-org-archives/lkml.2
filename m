Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0FDRwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 13:52:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49331 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751328Ab0FDRwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 13:52:38 -0400
Date: Fri, 4 Jun 2010 13:52:35 -0400 (EDT)
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
In-Reply-To: <1275664778.4596.1.camel@maxim-laptop>
Message-ID: <Pine.LNX.4.44L0.1006041351280.1794-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010, Maxim Levitsky wrote:

> On Fri, 2010-06-04 at 10:59 -0400, Alan Stern wrote: 
> > On Fri, 4 Jun 2010, Maxim Levitsky wrote:
> > 
> > > On Thu, 2010-03-04 at 14:53 +0100, Pavel Machek wrote: 
> > > > Hi!
> > > > 
> > > > > > journalling assumptions broken: commit block is there, but previous
> > > > > > blocks are not intact. Data loss.
> > > > > > 
> > > > > > ...and that was the first I could think about. Lets not do
> > > > > >  this. Barriers were invented for a reason.
> > > > > 
> > > > > Very well.  Then we still need a solution to the original problem:  
> > > > > Devices sometimes need to be unregistered during resume, but
> > > > > del_gendisk() blocks on the writeback thread, which is frozen until
> > > > > after the resume finishes.  How do you suggest this be fixed?
> > > > 
> > > > Avoid unregistering device during resume. Instead, return errors until
> > > > resume is done and you can call del_gendisk? 
> > > 
> > > This won't help ether. The same driver needs to unregister perfectly
> > > working device on suspend, because the user might replace the card
> > > during suspend and fool the os.
> > > There is a setting, CONFIG_MMC_UNSAFE_RESUME and I use it, but it isn't
> > > default.
> > 
> > People have generally agreed that the best answer is to have 
> > del_gendisk always thaw the writeback thread.
> Now the question is how to do that? :-)

Here's a start:

	http://marc.info/?l=linux-kernel&m=127378922620074&w=2

It's not quite right, because it needs to make the writeback thread
unfreezable before thawing it.

Alan Stern

