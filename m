Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab2CQOVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 10:21:50 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50534 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753375Ab2CQOVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 10:21:44 -0400
Date: Sat, 17 Mar 2012 10:21:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Theodore Tso <tytso@google.com>
cc: Greg KH <greg@kroah.com>, Paul Taysom <taysom@google.com>,
        Paul Taysom <taysom@chromium.org>, Mandeep Baines <msb@chromium.org>,
        Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@google.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <stable@kernel.org>
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
In-Reply-To: <CAGagf4eMPjP4ARWc7eBUeCjL=1FLshd33vafySwD1KBMFfB6QA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1203171010510.31791-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012, Theodore Tso wrote:

> I thought another fix at the USB layer also went in that attempted to
> fix this problem for 3.2, and so with two separate band-aid patches, I
> think we had thought the problem had been addressed.

I can't recall any USB fix like that.  The only thing I remember is 
your change to ext4 (leaving the problem still present in ext3).

> The real problem is that all of the patches which I've seen to date
> are band-aids, in that we aren't properly sending a "device as
> disappeared" notification to the file system layer, but instead we are
> trying to keep enough of the pointers valid (while also freeing other
> data structures), such that the file system can blindly write into a
> partially dismantled block device, and hopefully not oops.

That's not a band-aid approach; it's the way reference counting is 
_intended_ to work.  The whole idea of refcounting is that instead of 
synchronizing every single operation, you keep data structures around 
so long as anyone might be using them.

> Some have argued that my suggested approach of having an explicit
> super_ops revoke() function, which tells the file system that the
> block device is gone, etc., isn't necessary because this can be solved
> in userspace somehow.  Personally I think that's nuts, since we'll
> continue to play whack-a-mole, but I haven't had time to work up
> patches addressing this --- since this is really only a problem for
> naive users who pull USB sticks without unmounting them first (and so
> it never happens to me :-), and I've got a lot of other fish to
> try.....

I suspect Paul's patch is the right thing to do.  It might even make
the ext4 fix unnecessary, although I don't understand the details well
enough to verify it.  Maybe Paul can check -- the commit I'm referring
to is 7c2e70879fc0949b4220ee61b7c4553f6976a94d (ext4: add ext4-specific
kludge to avoid an oops after the disk disappears).

Alan Stern

