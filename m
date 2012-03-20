Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030390Ab2CTAYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 20:24:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57034 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134Ab2CTAYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 20:24:41 -0400
MIME-Version: 1.0
In-Reply-To: <CACBanvpzOdC4ns-pg1f92ptxrCJ2O=_oJhpKFD4NOB0hyF_+aA@mail.gmail.com>
References: <20120318034412.GA22531@thunk.org>
	<Pine.LNX.4.44L0.1203181611020.23082-100000@netrider.rowland.org>
	<CACBanvpzOdC4ns-pg1f92ptxrCJ2O=_oJhpKFD4NOB0hyF_+aA@mail.gmail.com>
Date: Mon, 19 Mar 2012 17:24:41 -0700
Message-ID: <CAKwO_5EgwVn+d1LGoms+6+u_76cBG0NLqF8tmeo1u=32AKGqVA@mail.gmail.com>
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
From: Paul Taysom <taysom@google.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Ted Ts'o" <tytso@mit.edu>,
        Theodore Tso <tytso@google.com>, Greg KH <greg@kroah.com>,
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

On Sun, Mar 18, 2012 at 3:25 PM, Mandeep Singh Baines <msb@chromium.org> wrote:
> On Sun, Mar 18, 2012 at 1:23 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> On Sat, 17 Mar 2012, Ted Ts'o wrote:
>>
>>> I can't help thinking that the fact that we're constantly playing
>>> whack-a-mole trying to fix various random crashes when devices
>>> disappear that perhaps we should consider if there's a better way to
>>> do things.
>>
>> Indeed, as Jens's patch mentions, proper reference counting for the BDI
>> stuff hasn't been implemented yet.  Obviously it will require somebody
>> who really does know the code (i.e., not me).
>>
>> For example, when Paul's patch assigns &default_backing_dev_info, is
>> the assignment synchronized by any sort of lock?  I can't tell -- but
>> if it isn't then the possibility of a race will still exist.
>>
>
> I think its safe without a lock (assuming the assignment is atomic) but it
> wouldn't hurt to add an i_lock. That would also give you a barrier which
> is needed to propagate the assignment to other CPUs.
>
> This is not a perfect fix but its pretty safe and is nice in that it works
> independent of filesystem or bus-type.
>
> Regards,
> Mandeep
>
>>> The fact that at the file system layer I have **no** idea that a
>>> device has disappeared, and just blindly going on trying to write to a
>>> device which is gone just seems a little crazy to me...  why shouldn't
>>> block layer inform the upper layers about something as fundamental as,
>>> "the device is gone and is never coming back"?
>>
>> Playing devil's advocate...  What would you do differently if you did
>> know the device was gone?  All I/O operations will fail regardless, and
>> presumably with an error code like -ENODEV.  Pretty much all you could
>> do would be to fail them a little earlier.
>>
>>> > I suspect Paul's patch is the right thing to do.  It might even make
>>> > the ext4 fix unnecessary, although I don't understand the details well
>>> > enough to verify it.  Maybe Paul can check -- the commit I'm referring
>>> > to is 7c2e70879fc0949b4220ee61b7c4553f6976a94d (ext4: add ext4-specific
>>> > kludge to avoid an oops after the disk disappears).
>>>
>>> I have no idea either, because it's not obvious to me what data
>>> structures can be relied upon, and what can't, and when things are
>>> supposed to get freed on sudden device disconnects.  The fact that
>>> none of us are sure is part of what makes me think that the current
>>> scheme is, perhaps, non-optimal...
>>
>> That's why someone like Jens or Al needs to take a close look at this
>> (hint, hint).
>>
>> Alan Stern
>>

I have rerun my tests without my change on the 3.2.7 kernel and I was
not able to get it to crash. I even put some code in to do the early
detection so I didn't have to wait for another thread to stumble
across the corruption. The way I test is with several flash drivers
with ext2, ext3, ext4, FAT, and HPFS file systems and just repeatedly
plug and unplug them. When a flash drive is plugged in with a file
system, it is automatically mounted.

Paul Taysom
