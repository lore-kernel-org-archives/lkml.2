Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab1GLPY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 11:24:56 -0400
Received: from netrider.rowland.org ([192.131.102.5]:52072 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751725Ab1GLPYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 11:24:55 -0400
Date: Tue, 12 Jul 2011 11:24:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Vivek Goyal <vgoyal@redhat.com>
cc: Mike Snitzer <snitzer@redhat.com>, Roland Dreier <roland@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        <linux-scsi@vger.kernel.org>, Steffen Maier <maier@linux.vnet.ibm.com>,
        "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>,
        Tarak Reddy <tarak.reddy@in.ibm.com>,
        "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Tejun Heo <tj@kernel.org>, <jaxboe@fusionio.com>
Subject: Re: block: Check that queue is alive in blk_insert_cloned_request()
In-Reply-To: <20110712014633.GA30965@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1107121120130.31381-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, Vivek Goyal wrote:

> > > There's still the issue that Stefan Richter pointed out: The test for a 
> > > dead queue must be made _after_ acquiring the queue lock, not _before_.
> > 
> > Yes, quite important.
> > 
> > Jens, can you tweak the patch or should Roland send a v2?
> 
> I do not think that we should do queue dead check after taking a spinlock.
> The reason being that there are life time issues of two objects.
> 
> - Validity of request queue pointer
> - Validity of q->spin_lock pointer
> 
> If the dm has taken the reference to the request queue in the beginning
> then it can be sure request queue pointer is valid. But spin_lock might
> be coming from driver and might be in one of driver allocated structures.
> So it might happen that driver has called blk_cleanup_queue() and freed
> up structures which contained the spin lock.

Surely this is a bug in the design of the block layer?

> So if queue is not dead, we know that q->spin_lock is valid. I think
> only race present here is that whole operation is not atomic. First
> we check for queue not dead flag and then go on to acquire request
> queue lock. So this leaves a small window for race. I think I have
> seen other code written in such manner (__generic_make_request()). So
> it proably reasonably safe to do here too.

"Probably reasonably safe" = "unsafe".  The fact that it will usually
work out okay means that when it does fail, it will be very difficult
to track down.

It needs to be fixed _now_, when people are aware of the issue.  Not 
five years from now, when everybody has forgotten about it.

Alan Stern

