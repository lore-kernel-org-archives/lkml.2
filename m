Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab0HIQGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 12:06:13 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57065 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0HIQGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 12:06:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=DCqpQ0eXG/WvqcKinSFPQowxcEwrduwv1SVWwzdeF9FD7/WcMwAg/hwcmS7+ogaDs/
         QNpuSk1Xa2eJyY4KeY7H3W+DUO3LGP4avncVFoWM/bHl2qQa0asWZN2b3esoysx2d0qz
         g+rA565JD1OBE/YwJcNDSYP1RxbYCDpKTJVsA=
MIME-Version: 1.0
In-Reply-To: <20100806202228.GA6153@suse.de>
References: <20100805213528.GA13794@kroah.com>
	<20100806204552.7cb80fd0@lxorguk.ukuu.org.uk>
	<AANLkTimGoG97dtp_hmHBJwwo1stzZxLoKs4_jr+eQ=gJ@mail.gmail.com>
	<201008062158.46013.arnd@arndb.de>
	<20100806202228.GA6153@suse.de>
Date: Mon, 9 Aug 2010 17:06:03 +0100
X-Google-Sender-Auth: 564U6-B9eiVltQe7MT9NDaGhvNw
Message-ID: <AANLkTinaQz22DAzrcvYREWAe9AFv8enC88Gu_9o_Ghg-@mail.gmail.com>
Subject: Re: [GIT PATCH] TTY patches for 2.6.36
From: Andy Whitcroft <apw@canonical.com>
To: Greg KH <gregkh@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 9:22 PM, Greg KH <gregkh@suse.de> wrote:
> On Fri, Aug 06, 2010 at 09:58:45PM +0200, Arnd Bergmann wrote:
>> On Friday 06 August 2010 21:38:36 Linus Torvalds wrote:
>> > I also don't want the BKL to show up in grep, even if the config
>> > option for it were to be impossible to enable. If we've gotten far
>> > enough that we can get rid of the BKL in the tty layer, we really
>> > should get rid of it. Not leave it in some zombie limbo state.
>>
>> Ok, I've sent the replacement patch that does this, and I'm much
>> happier with the outcome.
>>
>> If you apply this version, the only stronghold left for the BKL
>> will be fs/lockd, everything else that's left is either simple
>> to fix or highly obscure.
>
> Ok, I got that one now, and am building the tree to test here before
> sending to Linus.

I have been looking at the proposed change to the TTY locking here.
The conversion of the BKL into a real non-preemptable lock for the TTY
layer has had an interesting semantic change on racing open/closes on
the same TTY.  Prior to the changes we would:

 - grab the BLK and tty_mutex
 - mark the device TTY_CLOSING
 - drop the tty_mutex
 - call device shutdown
 - prevent the device from being found
 - drop the BKL

The use of the BLK to cover the device shutdown has an interesting
effect.  Where the shutdown processing is simple the lock is
maintained and the whole processing is atomic with respect to racing
opens and closes, such that an open would never see TTY_CLOSING.  For
any shutdown processing which resulted in a sleep then the BKL would
be implicitly dropped and reaquired allowing any racing opens to
continue and triggering an open failure errno=EIO, something POSIX at
least hints at as reasonable.  As shutdown can include hardware
interactions this seems like appropriate behaviour, and cirtinly the
git log documents this as expected and desirable semantics.

With the new locking the BTM is held in place of the BKL, which
effectivly means throughout open and close processing, which
effectively means _all_ TTY open/closes are serialised throughout
regardless of the length of the shutdown processing.  The EIO appears
to be no longer returnable.

Is this change in semantics expected?  If not, it is likely something
which could be addressed separately after merging, as long as we are
aware.

-apw
