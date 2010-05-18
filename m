Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab0ERUG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:06:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53878 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758126Ab0ERUGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:06:55 -0400
Date: Tue, 18 May 2010 16:06:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Nigel Cunningham <ncunningham@crca.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Matt Reimer <mattjreimer@gmail.com>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
In-Reply-To: <201005182143.28004.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1005181558480.1795-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, Rafael J. Wysocki wrote:

> > > So, I think we should merge the patch and if someone finds the root cause
> > > at one point in future, then we can just use the *right* approach instead of
> > > the present one.
> > >
> > > The problem is real and people in the field are affected by it, so if you don't
> > > have a working alternative patch, please just let go.
> > 
> > I'm not denying that the problem is real. What I am concerned about is 
> > finding a real solution, not just putting a sticky plaster over the 
> > wound. It seems to me to be much wiser to deal with the issue properly 
> > now instead of doing extra work later to diagnose what might be a harder 
> > to reproduce symptom of the same problem. I'd happily put the time in 
> > now myself, but I simply don't have the time this week.
> > 
> > Would it be possible to apply the patch, adding some sort of new tag 
> > that can be used to say "This needs further attention", perhaps 
> > including an enduring reference to this conversation.

Isn't there a problem involving filesystems with userspace components 
(fuse and such)?

You can't sync these filesystems after userspace is frozen.  And if you 
sync everything first, there's a possibility that some more pages will 
get marked dirty before all the threads are frozen.

The only safe course seems to be to freeze the writeback thread.  But 
Nigel is right; there is a race here.  What happens if del_gendisk is 
called just as the freezer is starting up?  Clearly, del_gendisk needs 
to mark the writeback thread as unfreezable in addition to thawing it.  
And there has to be some synchronization -- a spinlock for example.

Alan Stern

