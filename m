Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab2CRUXe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 16:23:34 -0400
Received: from netrider.rowland.org ([192.131.102.5]:49686 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756483Ab2CRUXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 16:23:33 -0400
Date: Sun, 18 Mar 2012 16:23:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Ted Ts'o" <tytso@mit.edu>
cc: Theodore Tso <tytso@google.com>, Greg KH <greg@kroah.com>,
        Paul Taysom <taysom@google.com>, Paul Taysom <taysom@chromium.org>,
        Mandeep Baines <msb@chromium.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@google.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <stable@kernel.org>
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
In-Reply-To: <20120318034412.GA22531@thunk.org>
Message-ID: <Pine.LNX.4.44L0.1203181611020.23082-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Mar 2012, Ted Ts'o wrote:

> I can't help thinking that the fact that we're constantly playing
> whack-a-mole trying to fix various random crashes when devices
> disappear that perhaps we should consider if there's a better way to
> do things.

Indeed, as Jens's patch mentions, proper reference counting for the BDI 
stuff hasn't been implemented yet.  Obviously it will require somebody 
who really does know the code (i.e., not me).

For example, when Paul's patch assigns &default_backing_dev_info, is 
the assignment synchronized by any sort of lock?  I can't tell -- but 
if it isn't then the possibility of a race will still exist.

> The fact that at the file system layer I have **no** idea that a
> device has disappeared, and just blindly going on trying to write to a
> device which is gone just seems a little crazy to me...  why shouldn't
> block layer inform the upper layers about something as fundamental as,
> "the device is gone and is never coming back"?

Playing devil's advocate...  What would you do differently if you did
know the device was gone?  All I/O operations will fail regardless, and
presumably with an error code like -ENODEV.  Pretty much all you could
do would be to fail them a little earlier.

> > I suspect Paul's patch is the right thing to do.  It might even make
> > the ext4 fix unnecessary, although I don't understand the details well
> > enough to verify it.  Maybe Paul can check -- the commit I'm referring
> > to is 7c2e70879fc0949b4220ee61b7c4553f6976a94d (ext4: add ext4-specific
> > kludge to avoid an oops after the disk disappears).
> 
> I have no idea either, because it's not obvious to me what data
> structures can be relied upon, and what can't, and when things are
> supposed to get freed on sudden device disconnects.  The fact that
> none of us are sure is part of what makes me think that the current
> scheme is, perhaps, non-optimal...

That's why someone like Jens or Al needs to take a close look at this
(hint, hint).

Alan Stern

