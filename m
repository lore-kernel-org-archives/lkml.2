Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab2CRWZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 18:25:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60241 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab2CRWZo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 18:25:44 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1203181611020.23082-100000@netrider.rowland.org>
References: <20120318034412.GA22531@thunk.org>
	<Pine.LNX.4.44L0.1203181611020.23082-100000@netrider.rowland.org>
Date: Sun, 18 Mar 2012 15:25:43 -0700
X-Google-Sender-Auth: Eb0y42Sngb6prfkHCt-4C__Y98w
Message-ID: <CACBanvpzOdC4ns-pg1f92ptxrCJ2O=_oJhpKFD4NOB0hyF_+aA@mail.gmail.com>
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
From: Mandeep Singh Baines <msb@chromium.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Ted Ts'o" <tytso@mit.edu>, Theodore Tso <tytso@google.com>,
        Greg KH <greg@kroah.com>, Paul Taysom <taysom@google.com>,
        Paul Taysom <taysom@chromium.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@google.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 1:23 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 17 Mar 2012, Ted Ts'o wrote:
>
>> I can't help thinking that the fact that we're constantly playing
>> whack-a-mole trying to fix various random crashes when devices
>> disappear that perhaps we should consider if there's a better way to
>> do things.
>
> Indeed, as Jens's patch mentions, proper reference counting for the BDI
> stuff hasn't been implemented yet.  Obviously it will require somebody
> who really does know the code (i.e., not me).
>
> For example, when Paul's patch assigns &default_backing_dev_info, is
> the assignment synchronized by any sort of lock?  I can't tell -- but
> if it isn't then the possibility of a race will still exist.
>

I think its safe without a lock (assuming the assignment is atomic) but it
wouldn't hurt to add an i_lock. That would also give you a barrier which
is needed to propagate the assignment to other CPUs.

This is not a perfect fix but its pretty safe and is nice in that it works
independent of filesystem or bus-type.

Regards,
Mandeep

>> The fact that at the file system layer I have **no** idea that a
>> device has disappeared, and just blindly going on trying to write to a
>> device which is gone just seems a little crazy to me...  why shouldn't
>> block layer inform the upper layers about something as fundamental as,
>> "the device is gone and is never coming back"?
>
> Playing devil's advocate...  What would you do differently if you did
> know the device was gone?  All I/O operations will fail regardless, and
> presumably with an error code like -ENODEV.  Pretty much all you could
> do would be to fail them a little earlier.
>
>> > I suspect Paul's patch is the right thing to do.  It might even make
>> > the ext4 fix unnecessary, although I don't understand the details well
>> > enough to verify it.  Maybe Paul can check -- the commit I'm referring
>> > to is 7c2e70879fc0949b4220ee61b7c4553f6976a94d (ext4: add ext4-specific
>> > kludge to avoid an oops after the disk disappears).
>>
>> I have no idea either, because it's not obvious to me what data
>> structures can be relied upon, and what can't, and when things are
>> supposed to get freed on sudden device disconnects.  The fact that
>> none of us are sure is part of what makes me think that the current
>> scheme is, perhaps, non-optimal...
>
> That's why someone like Jens or Al needs to take a close look at this
> (hint, hint).
>
> Alan Stern
>
