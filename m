Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2CRDo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 23:44:29 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39008 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab2CRDoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 23:44:24 -0400
Date: Sat, 17 Mar 2012 23:44:12 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Theodore Tso <tytso@google.com>, Greg KH <greg@kroah.com>,
        Paul Taysom <taysom@google.com>, Paul Taysom <taysom@chromium.org>,
        Mandeep Baines <msb@chromium.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@google.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
Message-ID: <20120318034412.GA22531@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Alan Stern <stern@rowland.harvard.edu>,
	Theodore Tso <tytso@google.com>, Greg KH <greg@kroah.com>,
	Paul Taysom <taysom@google.com>, Paul Taysom <taysom@chromium.org>,
	Mandeep Baines <msb@chromium.org>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@google.com>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, stable@kernel.org
References: <CAGagf4eMPjP4ARWc7eBUeCjL=1FLshd33vafySwD1KBMFfB6QA@mail.gmail.com>
 <Pine.LNX.4.44L0.1203171010510.31791-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1203171010510.31791-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2012 at 10:21:43AM -0400, Alan Stern wrote:
> On Fri, 16 Mar 2012, Theodore Tso wrote:
> 
> > I thought another fix at the USB layer also went in that attempted to
> > fix this problem for 3.2, and so with two separate band-aid patches, I
> > think we had thought the problem had been addressed.
> 
> I can't recall any USB fix like that.  The only thing I remember is 
> your change to ext4 (leaving the problem still present in ext3).

I could have sworn there was another patch that was tried to fix this
at another layer, because I distinctly remember thinking, oh well,
maybe I didn't need to merge my patch, when I saw another patch go by
that tried to fix it somewhere else.

I can't find it though, so maybe my memory is playing tricks on me....

> > The real problem is that all of the patches which I've seen to date
> > are band-aids, in that we aren't properly sending a "device as
> > disappeared" notification to the file system layer, but instead we are
> > trying to keep enough of the pointers valid (while also freeing other
> > data structures), such that the file system can blindly write into a
> > partially dismantled block device, and hopefully not oops.
> 
> That's not a band-aid approach; it's the way reference counting is 
> _intended_ to work.  The whole idea of refcounting is that instead of 
> synchronizing every single operation, you keep data structures around 
> so long as anyone might be using them.

Yeah, maybe.  It's just that when I went looking in the git logs
trying to find the other patch which I was sure had gone by on LKML, I
can across this:

commit 95f28604a65b1c40b6c6cd95e58439cd7ded3add
Author: Jens Axboe <jaxboe@fusionio.com>
Date:   Thu Mar 17 11:13:12 2011 +0100

    fs: assign sb->s_bdi to default_backing_dev_info if the bdi is going away
    
    We don't have proper reference counting for this yet, so we run into
    cases where the device is pulled and we OOPS on flushing the fs data.
    This happens even though the dirty inodes have already been
    migrated to the default_backing_dev_info.
    
    Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
    Tested-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
    Cc: stable@kernel.org
    Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

I can't help thinking that the fact that we're constantly playing
whack-a-mole trying to fix various random crashes when devices
disappear that perhaps we should consider if there's a better way to
do things.

The fact that at the file system layer I have **no** idea that a
device has disappeared, and just blindly going on trying to write to a
device which is gone just seems a little crazy to me...  why shouldn't
block layer inform the upper layers about something as fundamental as,
"the device is gone and is never coming back"?

> I suspect Paul's patch is the right thing to do.  It might even make
> the ext4 fix unnecessary, although I don't understand the details well
> enough to verify it.  Maybe Paul can check -- the commit I'm referring
> to is 7c2e70879fc0949b4220ee61b7c4553f6976a94d (ext4: add ext4-specific
> kludge to avoid an oops after the disk disappears).

I have no idea either, because it's not obvious to me what data
structures can be relied upon, and what can't, and when things are
supposed to get freed on sudden device disconnects.  The fact that
none of us are sure is part of what makes me think that the current
scheme is, perhaps, non-optimal...

Regards,

						- Ted
