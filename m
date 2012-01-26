Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab2AZVFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:05:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab2AZVFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:05:02 -0500
Date: Thu, 26 Jan 2012 16:04:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Phillip Susi <psusi@ubuntu.com>
Cc: Maxim Patlasov <maxim.patlasov@gmail.com>, joe@perches.com,
        kzak@redhat.com, linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
Message-ID: <20120126210456.GC11297@redhat.com>
References: <CA+X1aCQRpJ_NwJBSBp+vDN37p+oipJNz=6T5LdJdqzxTiSWWWA@mail.gmail.com>
 <4EFD012D.7040602@cfl.rr.com>
 <20120126190114.GG1891@redhat.com>
 <4F21B91E.90106@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F21B91E.90106@ubuntu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 03:35:42PM -0500, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 1/26/2012 2:01 PM, Vivek Goyal wrote:
> > I thought update will always happen with mutex lock held. That's
> > what sequence counter expects so that two updaters don't race. Just
> > that while updating under mutex lock, we still need to use sequence
> > counter mecahinsm to update values so that any readers out there
> > not holding mutex don't get confused.
> 
> Yes, but holding the mutex while writing does no good for the reader.
>  When the writer doesn't use the seqcounter, then the reader that is
> using it is not actually protected.

Ok, so you are worried about updates to nr_sects by other code. Makes
sense.

[..]
> > Are you still pursuing this pathset? Sounds like a useful
> > functionality to have.
> 
> Yes, but I hadn't yet heard back about my question about this being a
> broader issue that is already a bug in the kernel because things like
> loop and md already change nr_sects ( on the whole disk partition )
> without any protection.

Interesting. I do see that set_capacity() changes the nr_sects without
any protection. Sounds like it is racy on 32bit machines with 64bit
sector_t.

> 
> Maybe what we need is a read/write lock on struct genhd, then all
> readers need to acquire the read lock, which should only slow them
> down if they collide with a writer.

But taking lock will mean atomic operation irrespective of the fact
whether lock is taken by somebody else or not. I am assuming it will
still turn out to be expensive.

> 
> Another idea that I had but have not yet checked to see if it is
> actually feasible is to copy the struct genhd, change the size of the
> copy, and replace the existing one since updating the pointer will be
> atomic.

You will run into issues if somebody has a pointer stored to genhd.

I think simpler thing would be to stick with sequence counter approach
which keeps read side lockless. We can fix other writers of nr_sects
over a period of time. If nobody has complained so far, that means
we don't run into issues frequently and it is not a huge concern.

Thanks
Vivek
