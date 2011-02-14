Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab1BNXPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:15:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab1BNXPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:15:19 -0500
Date: Tue, 15 Feb 2011 10:15:06 +1100
From: NeilBrown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Milan Broz <mbroz@redhat.com>, Tao Ma <tm@tao.ma>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        device-mapper development <dm-devel@redhat.com>
Subject: Re: [PATCH][RFC] dm: Do not open log and cow device read-write for
 read-only mappings
Message-ID: <20110215101506.43d41ca8@notabene.brown>
In-Reply-To: <20110214154430.GR18742@htj.dyndns.org>
References: <4D573BBB.6090200@redhat.com>
	<1297594735-5593-1-git-send-email-tm@tao.ma>
	<4D57E67E.1030707@redhat.com>
	<4D57F357.6060708@tao.ma>
	<4D580A8B.5050508@redhat.com>
	<20110214103026.GA18742@htj.dyndns.org>
	<4D591664.6090203@redhat.com>
	<4D592AD1.6020500@redhat.com>
	<20110214140940.GM18742@htj.dyndns.org>
	<4D593AD8.7070901@redhat.com>
	<20110214154430.GR18742@htj.dyndns.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 16:44:30 +0100 Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Mon, Feb 14, 2011 at 03:23:20PM +0100, Milan Broz wrote:
> > >> I am not sure if this is complete fix... note that:
> > >> - what happens during mirror resync and read-only log?
> > >> - for COW, it there situation we need to update header in read-oly mode? (invalidated snap?)
> > > 
> > > But if the underlying device is marked ro, dm shouldn't update it at
> > > all.  The device should be opened ro and ro policy should be enforced.
> > 
> > Sure. So we need to check these situations I described.
> 
> Yeap, it seems dm folks are gonna take care of dm part.
> 
> > Btw the same pattern is in MD code in lock_rdev() ...
> 
> Indeed, cc'ing Neil.  Hi, the whole thread can be read from the
> following URL.
> 
>   http://thread.gmane.org/gmane.linux.kernel/1099399/focus=1099735
> 
> blkdev_get() now rejects rw open of devices which are marked
> read-only.  I think the right thing to do would be opening the member
> devices ro if the array is assembled for ro access (similar to Milan's
> patch for dm).  How does that sound?
> 
> Thanks.
> 

Sounds sensible ... though it is not all that easy to assemble an
array as 'read-only'....  it is possible though.

When the array is switched to read-write, do I have to call blkdev_get again
asking for rw access, then close the old blkdev, or can I 'upgrade'?

If a device has multiple opens: some read-only and some read-write, can I
find out when the last read-write close is gone?  That would be really useful,
especially if a filesystem down-graded its open to read-only when it is
remounted read-only..

[[And if filesystems could be convinced to open the device read-only when the
  fs is mounted read-only (and just do journal replay to internal data
  structures) that would be really awesome!!]]

NeilBrown

